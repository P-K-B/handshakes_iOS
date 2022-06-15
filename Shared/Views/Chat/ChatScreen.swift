
//
//  ChatScreen.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 31.05.2022.
//

import SwiftUI
import Combine
import Foundation

struct ChatScreen: View {
    @Binding var alert: MyAlert

    @EnvironmentObject private var model: ChatScreenModel
    @EnvironmentObject var contacts: ContactsDataView
    //    @State var searchGuid: String
    //    @State var toGuid: String
    @AppStorage("big") var big: Bool = IsBig()
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    @State var hasScrolled: Bool = false
    
    @State private var message = ""
    
    var body: some View {
        ZStack{
            
            //            if (windowManager.isContactDetails == false){
            ZStack{
                Color.theme.background
                    .ignoresSafeArea()
                VStack{
//                    ScrollView() {
                        //                            debugTime
//                        GeometryElement(hasScrolled: $hasScrolled, big: big, hasBack: false)
                        
                        
                        VStack {
                            if (model.openChat != nil){
                                let b = model.chats.allChats[model.openChat!]
                                let a = b?.first(where: {$0.marker == "new_chat_meta"})?.is_sender == true ?
                                contacts.data.contacts.filter({$0.telephone.contains(where: {$0.phone == b?.first(where: {$0.marker == "new_chat_meta"})?.meta?.res})}) :
                                contacts.data.contacts.filter({$0.telephone.contains(where: {$0.phone == b?.first(where: {$0.marker == "new_chat_meta"})?.meta?.asking_number})})
//                                Text("search")
                                //            Text(model.openChat)
//                                Text("to")
                                //            Text(toGuid)
                                //            Text(String((model.chats.allChats[model.openChat]?.count) ?? 0))
                                // Chat history.
                                Text("Chat about " + (b?.first(where: {$0.marker == "new_chat_meta"})?.meta?.number ?? "No number"))
                                ScrollView {
                                    
                                        
                                    ScrollViewReader { proxy in
                                        LazyVStack(spacing: 8) {
                                            ForEach(b?.filter({($0.marker != "new_chat_meta") && ($0.marker != "destination_user_not_found")}) ?? [], id: \.self) { message in

                                                ChatMessageRow(message: message, isUser: message.is_sender ?? false, partner: a.count > 0 ? a[0].firstName : "Unknown person")
                                                    .environmentObject(model)
                                                    .id(message.message_id)
                                                    .onAppear{
                                                        if ((message.is_sender ?? false) == false){
                                                            model.readMessage(searchGuid: model.openChat ?? "", id: message.message_id)
                                                        }
                                                    }
                                                //                                .onAppear{
                                                //                                    print(message)
                                                //                                }
                                                //                            }
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
//                                            print (model.openChat)
                                            let c = model.chats.allChats[model.openChat!]?.first(where: {$0.marker == "destination_user_not_found"})
                                            if (c != nil){
                                                alert = MyAlert(error: true, title: "Message error", text: "Destination user is not yet registrated", button: "Close", oneButton: true, deleteChat: true)
                                                model.DeleteChat(chat: model.openChat!)
                                                selectedTab = .chats
                                            }
                                        }
                                    }
                                }
                                
                                // Message field.
                                
                            }
                        }
                        //                                    }
                        //                                }
//                    }
                    HStack {
                        TextField("Message", text: $message, onEditingChanged: { _ in }, onCommit: onCommit)
                        // .modifiers here
                        Button(action: onCommit) {
                            // Image etc
                            Image(systemName: "paperplane")
                        }
                        .padding()
                        .disabled(message.isEmpty) // 4
                    }
                    .padding()
                }
                .overlay(
                    NavigationBar(title: "Chat", hasScrolled: $hasScrolled, search: .constant(false), showSearch: .constant(false), back: .chats)
                )
            }
        }
        
        //        .safeAreaInset(edge: .top, content: {
        //            Color.clear.frame(height: big ? 45 : 75)
        //        })
        //        .safeAreaInset(edge: .bottom) {
        //            Color.clear.frame(height: big ? 55 : 70)
        //        }
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
                    //                        userData.data.loaded = false
                
                DispatchQueue.main.async {
                    print("HERE2233")
                    if (((model.openChat == nil) || (model.openChat == "")) && (selectedTab == .singleChat)){
                        selectedTab = .chats
                    }
                }
            }
        }
    }
    
    private func onCommit() {
        print("here!!")
        if !message.isEmpty {
            model.send(text: message, searchGuid: model.openChat!, toGuid: model.chats.allChats[model.openChat!]![0].is_sender ?? false ?  model.chats.allChats[model.openChat!]![0].to : model.chats.allChats[model.openChat!]![0].from, meta: nil)
            //            model.send(text: "112233", searchGuid: "A9F02EF1E19B11ECA0FE0242AC120003", toGuid: "A9730C39E19B11ECA0FE0242AC120003")
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
    
}



