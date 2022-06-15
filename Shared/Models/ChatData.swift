//
//  ChatData.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 31.05.2022.
//

import Foundation
import SwiftUI
import Combine

final class ChatScreenModel: ObservableObject {
    @Published var toGuid: String = ""
    @Published var openChat: String?
//    @Published private(set) var messages: [ReceivingChatMessage] = []
    @Published var chats: Chats = Chats()
//    private var webSocketTask: URLSessionWebSocketTask? // 1
    
//    @AppStorage("jwt") var jwt: String = ""
    
    private let chatsDataService = ChatScreenService()
    
    private var cansellables = Set<AnyCancellable>()

    init(){
        addDataSubscriber()
    }
    
    func addDataSubscriber(){
        chatsDataService.$toGuid
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    print (error.localizedDescription)
                }
            } receiveValue: { returnedData in
                self.toGuid=returnedData
            }
            .store(in: &cansellables)
        
        chatsDataService.$openChat
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    print (error.localizedDescription)
                }
            } receiveValue: { returnedData in
                self.openChat=returnedData
            }
            .store(in: &cansellables)
        
        
        
        chatsDataService.$chats
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    print (error.localizedDescription)
                }
            } receiveValue: { returnedData in
                self.chats=returnedData
            }
            .store(in: &cansellables)
        
        
    }
    
    // MARK: - Connection
    func connect() {
        chatsDataService.connect()
    }
    
    func disconnect() { // 7
        chatsDataService.disconnect()
    }
    
    func addChat(a: String, to: String){
        chatsDataService.addChat(a: a, to: to)
    }
    
    deinit { // 9
        disconnect()
    }
    
    func send(text: String, searchGuid: String, toGuid: String, meta: Meta?) {
        chatsDataService.send(text: text, searchGuid: searchGuid, toGuid: toGuid, meta: meta, read: nil, id: -1)
    }
    
    func readMessage(searchGuid: String, id: Int){
        chatsDataService.readMessage(searchGuid: searchGuid, id: id)
    }
    
    func reset(){
        chatsDataService.reset()
    }
    
    func SetJwt(jwt: String){
        chatsDataService.SetJwt(jwt: jwt)
    }
    func OpenChat(chat: String){
        chatsDataService.OpenChat(chat: chat)
    }
    func DeleteChat(chat:String){
        chatsDataService.DeleteChat(chat: chat)
    }
}

struct ChatsSave: Encodable,Decodable{
//    var messages: [ReceivingChatMessage] = []
    var chats: Chats = Chats()
}

final class ChatScreenService  {
    @Published var toGuid: String = ""
    @Published var openChat: String = ""
    @Published private(set) var chats: Chats = Chats()
    private var webSocketTask: URLSessionWebSocketTask? // 1
    
    @Published var jwt: String = ""
    
    func SetJwt(jwt: String){
        self.jwt = jwt
    }
    
    init(){
        if let data = UserDefaults.standard.data(forKey: "ChatsData") {
            if let decoded = try? JSONDecoder().decode(ChatsSave.self, from: data) {
                print("ChatsData loaded")
//                self.messages = decoded.messages
                self.chats = decoded.chats
                return
            }
        }
    }
    
    func  readMessage(searchGuid: String, id: Int){
        if (self.chats.allChats[searchGuid]?.first(where: {$0.message_id == id})?.read == false){
            self.send(text: "", searchGuid: searchGuid, toGuid: "", meta: nil, read: true, id: id)
//            let a = self.chats.allChats[searchGuid]?.firstIndex(where: {$0.message_id == id}) ?? nil
//            if (a != nil){
//                self.chats.allChats[searchGuid]?[a ?? 0].read = true
//            }
        }
        
    }
    
    func OpenChat(chat:String){
        self.openChat = chat
    }
    
    func DeleteChat(chat:String){
        self.chats.allChats.removeValue(forKey: chat)
        self.OpenChat(chat: "")
        self.save()
    }
    
    func reset(){
//        self.messages = []
        self.chats = Chats()
        self.toGuid = ""
        self.openChat = ""
        self.save()
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(ChatsSave(chats: self.chats)) {
            UserDefaults.standard.set(encoded, forKey: "ChatsData")
        }
        print("ChatsData saved!")
    }
    
    func connect() {
        #if DEBUG
            let baseUrl="wss://develop.freekiller.net"
        #else
            let baseUrl="wss://hand.freekiller.net"
        #endif
        let url = URL(string: baseUrl + "/ws?token=\(jwt)")! // 3
        webSocketTask = URLSession.shared.webSocketTask(with: url) // 4
        webSocketTask?.receive(completionHandler: onReceive) // 5
        webSocketTask?.resume() // 6
    }
    
    func disconnect() { // 7
        webSocketTask?.cancel(with: .normalClosure, reason: nil) // 8
    }
    
    func addChat(a: String, to: String){
        if (self.chats.allChats[a] == nil){
            self.chats.allChats[a] = []
        }
//        if (self.chats.chatsData[a] == nil){
//            self.chats.chatsData[a] = ChatData(to: to)
//        }
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
            var newChatMessage: ReceivingChatMessage = ReceivingChatMessage(message_id: -1, from: "", to: "", sent_on: 0, read_on: 0, search_chain: "", marker: "", body: "", is_sender: false)
            guard let data = text.data(using: .utf8),
                  let chatMessage = try? JSONDecoder().decode(ReceivingChatMessage.self, from: data)
            else {
                print ("Can't parse message")
                return
            }
            
            DispatchQueue.main.async { // 6
                newChatMessage = chatMessage
                newChatMessage.read = false
                    if (newChatMessage.message_id != -1){
                    var to = ""
                    if (chatMessage.is_sender == true){
                        to = newChatMessage.to
                    }
                    else{
                        to = newChatMessage.from
                    }
                    if (newChatMessage.marker == "new_chat_meta"){
                        guard let data_meta = newChatMessage.body.data(using: .utf8),
                              let meta = try? JSONDecoder().decode(Meta.self, from: data_meta)
                        else {
                            print ("Can't parse message")
                            return
                        }
                        newChatMessage.meta = meta
                    }
                        if (newChatMessage.marker == "message_has_been_read"){
                            let a = self.chats.allChats[newChatMessage.search_chain]?.firstIndex(where: {$0.message_id == newChatMessage.message_id}) ?? nil
                            if (a != nil){
                                print(self.chats.allChats[newChatMessage.search_chain]?[a ?? 0])
                                self.chats.allChats[newChatMessage.search_chain]?[a ?? 0].read = true
                            }
                        }
                        else{
                            self.addChat(a: newChatMessage.search_chain, to: to)
                            self.chats.allChats[newChatMessage.search_chain]?.append(newChatMessage)
                            self.save()
                            print(self.chats)
                        }
                }
            }
        }
    }
    
    deinit { // 9
        disconnect()
    }
    
    func send(text: String, searchGuid: String, toGuid: String, meta: Meta?, read: Bool?, id: Int?) {
        
//        let meta: Meta = Meta(number: "+1", asking_number: "+2")
        
        guard let json = try? JSONEncoder().encode(meta), // 2
              let jsonMeta = String(data: json, encoding: .utf8)
        else {
            return
        }
        var message = SubmittedChatMessage(marker: "new_message", search_chain: searchGuid, body: text, to: toGuid, message_id: 0) // 1
        if (meta != nil){
            message = SubmittedChatMessage(marker: "new_chat_meta", search_chain: searchGuid, body: jsonMeta, to: toGuid, message_id: 0) // 1
        }
        if (read != nil){
            if (read == true){
                message = SubmittedChatMessage(marker: "message_has_been_read", search_chain: searchGuid, body: "", to: "", message_id: id ?? 0)
            }
        }
        guard let json = try? JSONEncoder().encode(message), // 2
              let jsonString = String(data: json, encoding: .utf8)
        else {
            return
        }
        print(jsonString)
//        print(webSocketTask?.state)
        webSocketTask?.send(.string(jsonString)) { error in // 3
            if let error = error {
                print("Error sending message", error) // 4
            }
        }
    }
    
}

struct Chats: Decodable, Encodable{
    var allChats:[String: [ReceivingChatMessage]] = [:]
//    var chatsData:[String: ChatData] = [:]
}

struct ChatData: Decodable, Encodable {
    var to: String
}

struct SubmittedChatMessage: Encodable {
    let marker: String
    let search_chain: String
    let body: String
    let to: String
    let message_id: Int?
}

struct Meta: Decodable, Encodable, Hashable{
    let number: String
    let asking_number: String
    let res: String
//    let is_asking: Bool
}

struct ReceivingChatMessage: Decodable, Hashable, Encodable {
    let message_id: Int
    let from: String
    let to: String
    let sent_on: Int64?
    let read_on: Int64?
    let search_chain: String
    let marker: String
    let body: String
    let is_sender: Bool?
    var meta: Meta?
    var read: Bool?
}

class UserInfo: ObservableObject {
    let userID = UUID()
    @Published var username = ""
}

//
////
////  ChatScreen.swift
////  Handshakes2 (iOS)
////
////  Created by Kirill Burchenko on 31.05.2022.
////
//
//import SwiftUI
//import Combine
//import Foundation
//
//struct ChatScreen: View {
//
//    @EnvironmentObject private var model: ChatScreenModel
////    @State var searchGuid: String
////    @State var toGuid: String
//    @AppStorage("big") var big: Bool = IsBig()
//    @AppStorage("selectedTab") var selectedTab: Tab = .search
//
//    @State private var message = ""
//
//    var body: some View {
//        VStack {
//            if (model.openChat != nil){
//            Text("search")
////            Text(model.openChat)
//            Text("to")
////            Text(toGuid)
////            Text(String((model.chats.allChats[model.openChat]?.count) ?? 0))
//            // Chat history.
//            ScrollView {
//                Button(action: {
//                    model.send(text: "112233", searchGuid: "A9F02EF1E19B11ECA0FE0242AC120003", toGuid: "A9730C39E19B11ECA0FE0242AC120003")
//                }, label: {
//                    Text("Send!")
//                })
//                ScrollViewReader { proxy in
//                    LazyVStack(spacing: 8) {
//                        ForEach(model.chats.allChats[model.openChat!] ?? [], id: \.self) { message in
//                            ChatMessageRow(message: message, isUser: message.is_sender)
//                                .id(message.message_id)
//                                .onAppear{
//                                    print(message)
//                                }
//                            //                            }
//                        }
//                    }
//                    .onChange(of: model.chats.allChats[model.openChat!]?.count) { _ in // 3
//                        scrollToLastMessage(proxy: proxy)
//                        print(message)
//                    }
//                }
//            }
//
//            // Message field.
//            HStack {
//                TextField("Message", text: $message, onEditingChanged: { _ in }, onCommit: onCommit)
//                // .modifiers here
//                Button(action: onCommit) {
//                    // Image etc
//                }
//                .padding()
//                .disabled(message.isEmpty) // 4
//            }
//            .padding()
//            }
//        }
////        .safeAreaInset(edge: .top, content: {
////            Color.clear.frame(height: big ? 45 : 75)
////        })
////        .safeAreaInset(edge: .bottom) {
////            Color.clear.frame(height: big ? 55 : 70)
////        }
//        .onAppear{
//            if ((model.openChat == nil) && (selectedTab == .singleChat)){
//                selectedTab = .settings
//            }
//        }
//    }
//
//    private func onCommit() {
//        print("here!!")
//        if !message.isEmpty {
////            model.send(text: message, searchGuid: model.openChat!, toGuid: model.chats.allChats[model.openChat!]![0].to)
//            model.send(text: "112233", searchGuid: "A9F02EF1E19B11ECA0FE0242AC120003", toGuid: "A9730C39E19B11ECA0FE0242AC120003")
//            message = ""
//        }
//    }
//
//    private func scrollToLastMessage(proxy: ScrollViewProxy) {
//        if let lastMessage = model.messages.last { // 4
//            withAnimation(.easeOut(duration: 0.4)) {
//                proxy.scrollTo(lastMessage.message_id, anchor: .bottom) // 5
//            }
//        }
//    }
//
//}
//
