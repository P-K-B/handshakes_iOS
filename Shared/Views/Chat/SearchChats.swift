//
//  SearchContacts.swift
//  Handshakes
//
//  Created by Kirill Burchenko on 04.12.2021.
//

import SwiftUI


struct SearchChats: View {
    @EnvironmentObject private var model: ChatScreenModel
    
    @State var searchText: String = ""
    @Binding var close: Bool
    @Binding var selectedChat: String?
    @Binding var selectedChatMsgID: UInt64?
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    @State var hasScrolled: Bool = false
    @AppStorage("big") var big: Bool = IsBig()

    @State var searchData:[ReceivingChatMessage] = []
    func prepareData() -> Void{
        for (_, chat) in model.chats.allChats {
            searchData.append(contentsOf: chat)
        }
    
    }
    var body: some View {
        ZStack{

            VStack{
                ZStack {
                    VStack (alignment: .leading){
                            Text("Search")
                                .animatableFont(size: hasScrolled ? 22 : 36, weight: .bold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    .padding(.top, 30)
                    .offset(y: hasScrolled ? -4 : 0)
                }
                .frame(height: hasScrolled ? 50 : 74)

                SearchBarMy(searchText: $searchText)
                ScrollView() {
//                    GeometryElement(hasScrolled: $hasScrolled, big: big, hasBack: false)
                    LazyVStack (pinnedViews: .sectionHeaders){
                        ChatsSearchList(searchData: searchData, searchedText: searchText)
                    }
//                    .padding(.top, 5)
                }
            }
            .onTapGesture {
                self.endEditing()
            }
//            .safeAreaInset(edge: .top, content: {
//                Color.clear.frame(height: big ? 45: 75)
//            })
//            .overlay(
//                NavigationBar(title: "Search", hasScrolled: $hasScrolled, search: .constant(false), showSearch: .constant(false))
//
//            )
        }.onAppear(perform: prepareData)

    }
    
    struct ChatsSearchList: View{
        var searchData: [ReceivingChatMessage]
        var searchedText: String
        var body: some View {
            HStack{
                ForEach(searchData.filter( {$0.body.contains(searchedText)}), id: \.message_id) { msg in
                    ChatSearchResult(chat: nil, msg: msg)
                }
            }
        }
    }
}

struct ChatSearchResult: View {
    var chat: [ReceivingChatMessage]?
    var msg: ReceivingChatMessage?
    var body: some View {
        VStack{
            HStack {
                Button(action: {
                    withAnimation(){
//                        contacts.selectedContact = contact
//                        selectedTab = .singleContact
                    }
                }, label: {
                    HStack{
                        Text(msg!.body)
//                                    ChatSearchResult(chat: chat, msg: msg)
                        Spacer()
                    }
                })
                .foregroundColor(.black)
                .padding(.leading, 13)
                
                
                
            }
            Divider()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 3)
    }
}
