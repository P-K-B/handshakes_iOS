
//
//  ChatScreen.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 31.05.2022.
//

import SwiftUI
import Combine
import Foundation
import UIKit

struct ChatScreen: View, KeyboardReadable {
    @Binding var alert: MyAlert

    @EnvironmentObject private var model: ChatScreenModel
    @EnvironmentObject var contacts: ContactsDataView

    @AppStorage("big") var big: Bool = IsBig()
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    @State var hasScrolled: Bool = false
    @State private var isKeyboardVisible = false

    @State private var message = ""
    
    func GetChatTitle(b: [ReceivingChatMessage]) -> (String) {
        let metaMsg = b.first(where: {$0.marker == "new_chat_meta"})
        if (metaMsg?.is_sender == true){
            let a = contacts.data.contacts.filter({$0.telephone.contains(where: {$0.phone == metaMsg?.meta?.res})})
            let s = "You'r asking " +
            (a.count > 0 ? a[0].firstName : "Unknown person") +
            (" about ") +
            (metaMsg?.meta?.number ?? "No number")
            return s
        }
        else{
            let a = contacts.data.contacts.filter({$0.telephone.contains(where: {$0.phone == metaMsg?.meta?.asking_number})})
                        return
                            (a.count > 0 ? a[0].firstName : "Unknown person") +
                            (" is asking about ") +
                            (metaMsg?.meta?.number ?? "No number")
        }
    }
    
    var body: some View {
        ZStack{
            ZStack{
                Color.theme.background
                    .ignoresSafeArea()
                VStack{
                    
                        VStack {
                            aprRow
                            if (model.openChat != nil){
                                let b = model.chats.allChats[model.openChat!]
                                let a = b?.first(where: {$0.marker == "new_chat_meta"})?.is_sender == true ?
                                contacts.data.contacts.filter({$0.telephone.contains(where: {$0.phone == b?.first(where: {$0.marker == "new_chat_meta"})?.meta?.res})}) :
                                contacts.data.contacts.filter({$0.telephone.contains(where: {$0.phone == b?.first(where: {$0.marker == "new_chat_meta"})?.meta?.asking_number})})

                                let s = GetChatTitle(b: b ?? [])
                                Text(s)
                                    .font(Font.system(size: 18, weight: .regular, design: .default))
                                    .padding(.top, 5)
                                ScrollView {
                                    
                                        
                                    ScrollViewReader { proxy in
                                        LazyVStack(spacing: 3) {
                                            ForEach(b?.filter({($0.marker != "new_chat_meta") && ($0.marker != "destination_user_not_found")}) ?? [], id: \.self) { message in

                                                ChatMessageRow(message: message, isUser: message.is_sender ?? false, partner: a.count > 0 ? a[0].firstName : "Unknown person")
                                                    .environmentObject(model)
                                                    .id(message.message_id)
                                                    .onAppear{
                                                        if ((message.is_sender ?? false) == false){
                                                            model.readMessage(searchGuid: model.chats.allChats[model.openChat!]!.first(where: {$0.meta != nil})?.meta?.chain ?? "", id: message.message_id, chatGuid: model.openChat ?? "", to: model.chats.allChats[model.openChat!]![0].is_sender ?? false ?  model.chats.allChats[model.openChat!]![0].to : model.chats.allChats[model.openChat!]![0].from)
                                                        }
                                                    }
                                            }
                                        }
                                        .onChange(of: b?.count) { _ in // 3
                                            scrollToLastMessage(proxy: proxy)
                                            print ("112233")
                                            print(b)
                                            print(model.openChat)
                                            let c = model.chats.allChats[model.openChat!]?.first(where: {$0.marker == "destination_user_not_found"})
                                            if (c != nil){
                                                alert = MyAlert(error: true, title: "Message error", text: "Destination user is not yet registrated", button: "Close", oneButton: true, deleteChat: true)
                                                model.DeleteChat(chat: model.openChat!)
                                                selectedTab = .chats
                                            }
                                        }
                                        .onAppear{
                                            scrollToLastMessage(proxy: proxy)
                                            let c = model.chats.allChats[model.openChat!]?.first(where: {$0.marker == "destination_user_not_found"})
                                            if (c != nil){
                                                alert = MyAlert(error: true, title: "Message error", text: "Destination user is not yet registrated", button: "Close", oneButton: true, deleteChat: true)
                                                model.DeleteChat(chat: model.openChat!)
                                                selectedTab = .chats
                                            }
                                        }
                                    }
                                }

                            }
                        }
                    HStack(spacing: 5) {
                        TextField("Message", text: $message, onEditingChanged: { _ in }, onCommit: onCommit)
                            .font(Font.system(size: 18, weight: .regular, design: .default))
                            .padding(5)
                            .addBorder(Color.theme.contactsHeadLetter.opacity(0.30), width: 1, cornerRadius: 10)
                            .foregroundColor(message.isEmpty ? Color.theme.contactsHeadLetter.opacity(0.30) : Color.black)
                            .onReceive(keyboardPublisher) { newIsKeyboardVisible in
                                            print("Is keyboard visible? ", newIsKeyboardVisible)
                                            isKeyboardVisible = newIsKeyboardVisible
                                        }
                        // .modifiers here
                        Button(action: onCommit) {
                            // Image etc
                            Image(systemName: "arrow.up.circle")
                                .resizable()
                                .frame(width: 30, height: 30, alignment: .center)
                                .foregroundColor(Color.theme.accent)
                        }
                        .disabled(message.isEmpty) // 4
                    }
                    .padding(.horizontal, 5)
                    .padding(.bottom, 5)
                }
                .overlay(
                    NavigationBar(title: "Chat", search: .constant(false), showSearch: false, showProfile: false, hasBack: true)
                )
            }
        }
        .myBackGesture()
        .safeAreaInset(edge: .top, content: {
                                    Color.clear.frame(height: big ? 45: 75)
                                })
        .onTapGesture {
            self.endEditing()
        }
        .onAppear{
            DispatchQueue.global(qos: .userInitiated).async {
                    let group = DispatchGroup()
                    group.enter()
                    
                    // avoid deadlocks by not using .main queue here
                    DispatchQueue.global().async {
                        if (model.openChat != nil){
                            while model.chats.allChats[model.openChat!]?.count == 0 {
                            }
                        }
                        group.leave()
                        print("Left")
                    }
                    
                    // wait ...
                    group.wait()
                DispatchQueue.main.async {
                    print("HERE2233")
                    if (((model.openChat == nil) || (model.openChat == ""))){
                        selectedTab = .chats
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func onCommit() {
        print("here!!")
//        model.connect()
        if !message.isEmpty {
            model.send(text: message, searchGuid: model.chats.allChats[model.openChat!]!.first(where: {$0.meta != nil})?.meta?.chain ?? "", toGuid: model.chats.allChats[model.openChat!]![0].is_sender ?? false ?  model.chats.allChats[model.openChat!]![0].to : model.chats.allChats[model.openChat!]![0].from, meta: nil)
            message = ""
        }
    }
    
    private func scrollToLastMessage(proxy: ScrollViewProxy) {
        if let lastMessage = model.chats.allChats[model.openChat!]?.last { // 4
            withAnimation(.easeOut(duration: 0.4)) {
                proxy.scrollTo(lastMessage.message_id, anchor: .bottom) // 5
            }
        }
    }
    
    var aprRow: some View{
        
        VStack(spacing: 40){
///// V0
//            HStack(alignment: .top, spacing: 0){
//                VStack{
//                    Image(systemName: "person.crop.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 20, height: 20, alignment: .center)
////                        .foregroundColor(.green)
//                    Text("You")
//                        .multilineTextAlignment(.center)
//                        .font(.caption)
//                }
//                .frame(width: UIScreen.screenWidth*1/8)
//                VStack{
//                    Image(systemName: "checkmark.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 20, height: 20, alignment: .center)
//                        .foregroundColor(.green)
//                    Text("Kirill Burchenko")
//                        .multilineTextAlignment(.center)
//                        .font(.caption)
//                }
//                .frame(width: UIScreen.screenWidth*2/8)
//                VStack{
//                    Image(systemName: "checkmark.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 20, height: 20, alignment: .center)
//                        .foregroundColor(.green)
////                    Text("Kirill Burchenko")
////                        .multilineTextAlignment(.center)
////                        .font(.caption)
//                }
//                .frame(width: UIScreen.screenWidth*1/8)
//                VStack{
//                    Image(systemName: "xmark.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 20, height: 20, alignment: .center)
//                        .foregroundColor(.red)
////                    Text("Kirill Burchenko")
////                        .multilineTextAlignment(.center)
////                        .font(.caption)
//                }
//                .frame(width: UIScreen.screenWidth*1/8)
//                VStack{
//                    Image(systemName: "questionmark.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 20, height: 20, alignment: .center)
////                    Text("Kirill Burchenko")
////                        .multilineTextAlignment(.center)
////                        .font(.caption)
//                }
//                .frame(width: UIScreen.screenWidth*1/8)
//                VStack{
//                    Image(systemName: "message.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 20, height: 20, alignment: .center)
//                        .foregroundColor(.green)
//                    Text("Chat approved")
//                        .multilineTextAlignment(.center)
//                        .font(.caption)
//                }
//                .frame(width: UIScreen.screenWidth*2/8)
//            }
//            Divider()
/////            V1
//            HStack(alignment: .top, spacing: 0){
//                VStack{
//                    Image(systemName: "person.crop.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 20, height: 20, alignment: .center)
////                        .foregroundColor(.green)
//                    Text("You")
//                        .multilineTextAlignment(.center)
//                        .font(.caption)
//                }
//                .frame(width: UIScreen.screenWidth*1/8)
//                VStack{
//                    Image(systemName: "checkmark.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 20, height: 20, alignment: .center)
//                        .foregroundColor(.green)
//                    Text("Kirill Burchenko")
//                        .multilineTextAlignment(.center)
//                        .font(.caption)
//                }
//                .frame(width: UIScreen.screenWidth*2/8)
//                VStack{
//                    Image(systemName: "checkmark.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 20, height: 20, alignment: .center)
//                        .foregroundColor(.green)
////                    Text("Kirill Burchenko")
////                        .multilineTextAlignment(.center)
////                        .font(.caption)
//                }
//                .frame(width: UIScreen.screenWidth*1/8)
//                VStack{
//                    Image(systemName: "xmark.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 20, height: 20, alignment: .center)
//                        .foregroundColor(.red)
////                    Text("Kirill Burchenko")
////                        .multilineTextAlignment(.center)
////                        .font(.caption)
//                }
//                .frame(width: UIScreen.screenWidth*1/8)
//                VStack{
//                    Image(systemName: "questionmark.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 20, height: 20, alignment: .center)
////                    Text("Kirill Burchenko")
////                        .multilineTextAlignment(.center)
////                        .font(.caption)
//                }
//                .frame(width: UIScreen.screenWidth*1/8)
//                VStack{
//                    Image(systemName: "message.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 20, height: 20, alignment: .center)
//                        .foregroundColor(.red)
//                    Text("Chat approved")
//                        .multilineTextAlignment(.center)
//                        .font(.caption)
//                }
//                .frame(width: UIScreen.screenWidth*2/8)
//            }
//            Divider()
/////            V2
//            HStack(alignment: .top, spacing: 0){
//                VStack{
//                    Image(systemName: "questionmark.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 20, height: 20, alignment: .center)
////                    Text("Kirill Burchenko")
////                        .multilineTextAlignment(.center)
////                        .font(.caption)
//                }
//                .frame(width: UIScreen.screenWidth*1/9)
//                VStack{
//                    Image(systemName: "checkmark.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 20, height: 20, alignment: .center)
//                        .foregroundColor(.green)
//                    Text("Maxim Fisher")
//                        .multilineTextAlignment(.center)
//                        .font(.caption)
//                }
//                .frame(width: UIScreen.screenWidth*2/9)
//                VStack{
//                    Image(systemName: "person.crop.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 20, height: 20, alignment: .center)
////                        .foregroundColor(.green)
//                    Text("You")
//                        .multilineTextAlignment(.center)
//                        .font(.caption)
//                }
//                .frame(width: UIScreen.screenWidth*1/9)
//                VStack{
//                    Image(systemName: "checkmark.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 20, height: 20, alignment: .center)
//                        .foregroundColor(.green)
//                    Text("Kirill Burchenko")
//                        .multilineTextAlignment(.center)
//                        .font(.caption)
//                }
//                .frame(width: UIScreen.screenWidth*2/9)
//                VStack{
//                    Image(systemName: "xmark.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 20, height: 20, alignment: .center)
//                        .foregroundColor(.red)
////                    Text("Kirill Burchenko")
////                        .multilineTextAlignment(.center)
////                        .font(.caption)
//                }
//                .frame(width: UIScreen.screenWidth*1/9)
//                VStack{
//                    Image(systemName: "message.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 20, height: 20, alignment: .center)
////                        .foregroundColor(.green)
//                    Text("Chat approved")
//                        .multilineTextAlignment(.center)
//                        .font(.caption)
//                }
//                .frame(width: UIScreen.screenWidth*2/9)
//            }
//            Divider()
/////            V3
//            HStack(alignment: .top, spacing: 0){
//                VStack{
//                    Image(systemName: "questionmark.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 20, height: 20, alignment: .center)
////                    Text("Kirill Burchenko")
////                        .multilineTextAlignment(.center)
////                        .font(.caption)
//                }
//                .frame(width: UIScreen.screenWidth*1/8)
//                VStack{
//                    Image(systemName: "checkmark.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 20, height: 20, alignment: .center)
//                        .foregroundColor(.green)
////                    Text("Maxim Fisher")
////                        .multilineTextAlignment(.center)
////                        .font(.caption)
//                }
//                .frame(width: UIScreen.screenWidth*1/8)
//                VStack{
//                    Image(systemName: "xmark.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 20, height: 20, alignment: .center)
//                        .foregroundColor(.red)
////                    Text("Kirill Burchenko")
////                        .multilineTextAlignment(.center)
////                        .font(.caption)
//                }
//                .frame(width: UIScreen.screenWidth*1/8)
//                VStack{
//                    Image(systemName: "checkmark.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 20, height: 20, alignment: .center)
//                        .foregroundColor(.green)
//                    Text("Maxim Fisher")
//                        .multilineTextAlignment(.center)
//                        .font(.caption)
//                }
//                .frame(width: UIScreen.screenWidth*2/8)
//                VStack{
//                    Image(systemName: "person.crop.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 20, height: 20, alignment: .center)
////                        .foregroundColor(.green)
//                    Text("You")
//                        .multilineTextAlignment(.center)
//                        .font(.caption)
//                }
//                .frame(width: UIScreen.screenWidth*1/8)
//                VStack{
//                    Image(systemName: "message.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 20, height: 20, alignment: .center)
////                        .foregroundColor(.green)
//                    Text("Chat approved")
//                        .multilineTextAlignment(.center)
//                        .font(.caption)
//                }
//                .frame(width: UIScreen.screenWidth*2/8)
//            }
        }
    }
    
}



protocol KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> { get }
}

extension KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },
            
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        )
        .eraseToAnyPublisher()
    }
}

struct ChatScreen_Previews: PreviewProvider {
    static let debug: DebugData = DebugData()
    
    static let historyData: HistoryDataView = debug.historyData
    static let contactsData: ContactsDataView = debug.contactsData
    static let model: ChatScreenModel = debug.model
    static let userData: UserDataView = debug.userData
    static var previews: some View {
        ChatScreen(alert: .constant(MyAlert()))
            .environmentObject(historyData)
            .environmentObject(contactsData)
            .environmentObject(model)
            .environmentObject(userData)
    }
}
