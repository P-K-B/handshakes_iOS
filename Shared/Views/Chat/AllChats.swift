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
    @State var search: Bool = false
    @State var selectedChat: String? = ""
    @State var selectedChatMsgID: UInt64? = 0
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
                                    ForEach(Array(model.chats.allChats.keys), id: \.self) { chatKey in
                                        let chat = model.chats.allChats[chatKey]
                                        ChatItem(chat: chat, onClickAction: {withAnimation(){
                                                model.OpenChat(chat: chatKey)
                                                selectedTab = .singleChat
                                        }})
                                    }
//                                }
//                            }
//                        }
                        
                        
                    }
//                }
                .overlay(
                    NavigationBar(title: "Chats", hasScrolled: $hasScrolled, search: $search, showSearch: .constant(true))
                )
            }
            .popover(isPresented: $search) {
                SearchChats(close: $search, selectedChat:$selectedChat, selectedChatMsgID: $selectedChatMsgID)
                    .onAppear{
    //                    print(contacts.data)
    //                    print(contacts.contactsDataService.data)
                    }
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

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation() ?? "GMT") //Set timezone that you want
    formatter.locale = NSLocale.current
    formatter.dateFormat = "HH:mm"
    return formatter
}()

struct ChatItem: View {
    @EnvironmentObject var contacts: ContactsDataView
    
    var chat: [ReceivingChatMessage]?
    var onClickAction: ()->Void
    var lastMessage: ReceivingChatMessage? = nil
    
    init(chat: [ReceivingChatMessage]?, onClickAction: @escaping ()->Void) {
        self.chat = chat
        self.onClickAction = onClickAction
        self.lastMessage = chat?.last
    }
    
    func GetChatTitle() -> String {
        let metaMsg = self.chat?.first(where: {$0.marker == "new_chat_meta"})
        if (metaMsg?.is_sender == true){
            let a = contacts.data.contacts.filter({$0.telephone.contains(where: {$0.phone == metaMsg?.meta?.res})})
//                                                        Text ("You'r asking ")
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
        VStack{
            HStack{
                Text(GetChatTitle()).font(.title2).bold()
                if (lastMessage != nil) {
                    let a = dateFormatter.string(from: Date(timeIntervalSince1970: Double(lastMessage?.sent_on ?? 0)))
                    Text(a)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                }
            }
            
            if (lastMessage != nil) {
                Text(lastMessage!.body)
                    .truncationMode(.tail)
                    .foregroundColor(.gray)
                    .frame(maxHeight: 50)
            }
            Divider()
        }
        .padding(.horizontal, 13.0)
        .frame(
              minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              maxHeight: 80,
              alignment: .topLeading
        )
        .onTapGesture(perform: onClickAction)
    }

}


