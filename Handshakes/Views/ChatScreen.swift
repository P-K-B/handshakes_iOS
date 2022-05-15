//
//  ChatScreen.swift
//  Handshakes
//
//  Created by Kirill Burchenko on 29.04.2022.
//

import SwiftUI
import Foundation
import Combine

struct ChatView: View {
    @StateObject private var userInfo = UserInfo() // 1
    
        var body: some View {
        NavigationView {
            SettingsScreen()
        }
        .environmentObject(userInfo) // 2
        .navigationViewStyle(StackNavigationViewStyle())// 3
    }
}

struct ChatScreen: View {
    @StateObject private var model = ChatScreenModel()
    @EnvironmentObject private var userInfo: UserInfo

    @State private var message = ""

    var body: some View {
        VStack {
            // Chat history.
            ScrollView {
                ScrollViewReader { proxy in
                    LazyVStack(spacing: 8) {
                        ForEach(model.messages) { message in
                            // This one right here 👇, officer.
                            ChatMessageRow(message: message, isUser: message.userID == userInfo.userID)
                                .id(message.id)
                        }
                    }
                    .onChange(of: model.messages.count) { _ in // 3
                        scrollToLastMessage(proxy: proxy)
                    }
                }
            }

            // Message field.
            HStack {
                TextField("Message", text: $message, onEditingChanged: { _ in }, onCommit: onCommit)
                    // .modifiers here
                Button(action: onCommit) {
                    // Image etc
                }
                .padding()
                .disabled(message.isEmpty) // 4
            }
            .padding()
        }
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }
    
    private func onAppear() {
        model.connect(username: userInfo.username, userID: userInfo.userID)
    }
    
    private func onDisappear() {
            model.disconnect()
        }
    
    private func onCommit() {
        if !message.isEmpty {
            model.send(text: message)
            message = ""
        }
    }
    
    private func scrollToLastMessage(proxy: ScrollViewProxy) {
        if let lastMessage = model.messages.last { // 4
            withAnimation(.easeOut(duration: 0.4)) {
                proxy.scrollTo(lastMessage.id, anchor: .bottom) // 5
            }
        }
    }
    
}

struct ChatScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChatScreen()
    }
}


final class ChatScreenModel: ObservableObject {
    private var username: String?
    private var userID: UUID?
    @Published private(set) var messages: [ReceivingChatMessage] = []
    private var webSocketTask: URLSessionWebSocketTask? // 1
    // MARK: - Connection
    func connect(username: String, userID: UUID) {
        self.username = username
        self.userID = userID
        let url = URL(string: "ws://127.0.0.1:8080/chat?jwt=123")! // 3
        webSocketTask = URLSession.shared.webSocketTask(with: url) // 4
        webSocketTask?.receive(completionHandler: onReceive) // 5
        webSocketTask?.resume() // 6
    }
    
    func disconnect() { // 7
        webSocketTask?.cancel(with: .normalClosure, reason: nil) // 8
    }

    private func onReceive(incoming: Result<URLSessionWebSocketTask.Message, Error>) {
        webSocketTask?.receive(completionHandler: onReceive) // 1
        if case .success(let message) = incoming { // 2
            onMessage(message: message)
        }
        else if case .failure(let error) = incoming { // 3
            print("Error", error)
        }
    }

    private func onMessage(message: URLSessionWebSocketTask.Message) { // 4
        if case .string(let text) = message { // 5
            guard let data = text.data(using: .utf8),
                    let chatMessage = try? JSONDecoder().decode(ReceivingChatMessage.self, from: data)
            else {
                return
            }

            DispatchQueue.main.async { // 6
                self.messages.append(chatMessage)
            }
        }
    }
    
    deinit { // 9
        disconnect()
    }
    
    func send(text: String) {
        guard let username = username, let userID = userID else {
            return
        }
        
        let message = SubmittedChatMessage(message: text, user: username, userID: userID) // 1
        guard let json = try? JSONEncoder().encode(message), // 2
            let jsonString = String(data: json, encoding: .utf8)
        else {
            return
        }
        
        webSocketTask?.send(.string(jsonString)) { error in // 3
            if let error = error {
                print("Error sending message", error) // 4
            }
        }
    }
}


struct SubmittedChatMessage: Encodable {
    let message: String
    let user: String // <- We
    let userID: UUID // <- are
}

struct ReceivingChatMessage: Decodable, Identifiable {
    let date: Date
    let id: UUID
    let message: String
    let user: String // <- new
    let userID: UUID // <- here
}

class UserInfo: ObservableObject {
    let userID = UUID()
    @Published var username = ""
}

struct SettingsScreen: View {
    @EnvironmentObject private var userInfo: UserInfo // 1
    
    private var isUsernameValid: Bool {
        !userInfo.username.trimmingCharacters(in: .whitespaces).isEmpty // 2
    }
    
    var body: some View {
        Form {
            Section(header: Text("Username")) {
                TextField("E.g. John Applesheed", text: $userInfo.username) // 3
                NavigationLink("Continue", destination: ChatScreen()) // 4
                    .disabled(!isUsernameValid)
            }
        }
        .navigationTitle("Settings")
    }
}


struct ChatMessageRow: View {
    static private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    let message: ReceivingChatMessage
    let isUser: Bool
    
    var body: some View {
        HStack {
            if isUser {
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(message.user)
                        .fontWeight(.bold)
                        .font(.system(size: 12))
                    
                    Text(Self.dateFormatter.string(from: message.date))
                        .font(.system(size: 10))
                        .opacity(0.7)
                }
                
                Text(message.message)
            }
            .foregroundColor(isUser ? .white : .black)
            .padding(10)
            .background(isUser ? Color.blue : Color(white: 0.95))
            .cornerRadius(5)
            
            if !isUser {
                Spacer()
            }
        }
    }
}
