
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
                                            ForEach(b?.filter({$0.marker != "new_chat_meta"}) ?? [], id: \.self) { message in
                                                ChatMessageRow(message: message, isUser: message.is_sender ?? false, partner: a[0].firstName)
                                                    .id(message.message_id)
                                                //                                .onAppear{
                                                //                                    print(message)
                                                //                                }
                                                //                            }
                                            }
                                        }
                                        .onChange(of: model.chats.allChats[model.openChat!]?.count) { _ in // 3
                                            scrollToLastMessage(proxy: proxy)
                                            print(message)
                                        }
                                        .onAppear{
                                            scrollToLastMessage(proxy: proxy)
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
            if ((model.openChat == nil) && (selectedTab == .singleChat)){
                selectedTab = .chats
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



