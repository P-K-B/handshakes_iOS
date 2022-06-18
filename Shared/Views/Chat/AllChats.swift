//
//  AllChats.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 31.05.2022.
//

import SwiftUI

struct AllChats: View{
    @EnvironmentObject private var model: ChatScreenModel
    @EnvironmentObject var contacts: ContactsDataView
    //    @State var searchGuid: String?
    //    @State var toGuid: String = ""
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    @AppStorage("big") var big: Bool = IsBig()
    @State var hasScrolled: Bool = false
    
    var body: some View {
//        ZStack{
            ZStack{
                Color.theme.background
                    .ignoresSafeArea()
//                VStack{
                    ScrollView() {
                        GeometryElement(hasScrolled: $hasScrolled, big: big, hasBack: false)
//                        VStack{
//                            ScrollView {
//                                LazyVStack(spacing: 8) {
                                    ForEach(Array(model.chats.allChats.keys), id: \.self) { chat in
                                        HStack{
                                            Button(action: {
                                                withAnimation(){
                                                    model.OpenChat(chat: chat)
                                                    selectedTab = .singleChat
                                                }
                                            }, label: {
                                                HStack{
                                                    let b = model.chats.allChats[chat]
                                                    if (b?.first(where: {$0.marker == "new_chat_meta"})?.is_sender == true){
                                                        let a = contacts.data.contacts.filter({$0.telephone.contains(where: {$0.phone == b?.first(where: {$0.marker == "new_chat_meta"})?.meta?.res})})
//                                                        Text ("You'r asking ")
                                                        let s = "You'r asking " +
                                                        (a.count > 0 ? a[0].firstName : "Unknown person") +
                                                        (" about ") +
                                                        (b?.first(where: {$0.marker == "new_chat_meta"})?.meta?.number ?? "No number")
                                                        Text(s)
                                                    }
                                                    else{
                                                        let a = contacts.data.contacts.filter({$0.telephone.contains(where: {$0.phone == b?.first(where: {$0.marker == "new_chat_meta"})?.meta?.asking_number})})
                                                        Text(
                                                            (a.count > 0 ? a[0].firstName : "Unknown person") +
                                                            (" is asking about ") +
                                                            (b?.first(where: {$0.marker == "new_chat_meta"})?.meta?.number ?? "No number")
                                                        )
                                                    }
                                                }
                                            })
                                        }
                                    }
//                                }
//                            }
//                        }
                        
                        
                    }
//                }
                .overlay(
                    NavigationBar(title: "Messages", hasScrolled: $hasScrolled, search: .constant(false), showSearch: .constant(false))
                )
            }
//        }
    }
    
//    var Title: some View{
//
//    }
    
//    var Title1: some View{
//
//
//
//    }
//
//    var Title2: some View{
//
//
//    }
}



