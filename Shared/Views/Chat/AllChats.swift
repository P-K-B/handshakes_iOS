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
                GeometryReader { geometry in
                    ScrollView() {
//                        VStack{
//                            ScrollView {
//                                LazyVStack(spacing: 8) {
                        
//                            .padding(.horizontal, 13.0)
                        let a = model.chats.allChats
                            .sorted(by: {$0.value.last?.sent_on ?? 0 > $1.value.last?.sent_on ?? 0})
//                        var b = Array(model.chats.allChats)
//                            b.sort(by: {$0.value.last?.sent_on ?? 0 > $1.value.last?.sent_on ?? 0})
                        
//                            .sorted(by: {$0.value.last?.sent_on ?? 0 > $1.value.last?.sent_on ?? 0})
                        if (a.count > 0){
                            GeometryElement(hasScrolled: $hasScrolled, big: big, hasBack: false)

                        Divider()
                        ForEach(a, id: \.key) { chatKey, val in
                            let chat = model.chats.allChats[chatKey]
                                        ChatItem(chat: chat, onClickAction: {withAnimation(){
                                                model.OpenChat(chat: chatKey)
                                                selectedTab = .singleChat
                                        }})
                                        .onAppear{
                                            
                                        }
                                    }
                        }
                        else{
                            VStack{
                            Text("No chats yet")
                                     .font(Font.system(size: 16, weight: .light, design: .default))
                            }
                            .frame(width: geometry.size.width)      // Make the scroll view full-width
                                        .frame(minHeight: geometry.size.height)
                        }
//                                }
//                            }
//                        }
                        
                        
                    }
//                }
                .overlay(
                    NavigationBar(title: "Messages", hasScrolled: $hasScrolled, search: $search, showSearch: false, showProfile: true)
                )
                }
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
    
    func GetChatTitle() -> (String, String) {
        let metaMsg = self.chat?.first(where: {$0.marker == "new_chat_meta"})
        if (metaMsg?.is_sender == true){
            let a = contacts.data.contacts.filter({$0.telephone.contains(where: {$0.phone == metaMsg?.meta?.res})})
//                                                        Text ("You'r asking ")
//            let s = "You'r asking " +
//            (a.count > 0 ? a[0].firstName : "Unknown person") +
//            (" about ") +
//            (metaMsg?.meta?.number ?? "No number")
            return ((a.count > 0 ? a[0].firstName : "Unknown person"), (metaMsg?.meta?.number ?? "No number"))
        }
        else{
            let a = contacts.data.contacts.filter({$0.telephone.contains(where: {$0.phone == metaMsg?.meta?.asking_number})})
            return
                ((a.count > 0 ? a[0].firstName : "Unknown person"), (metaMsg?.meta?.number ?? "No number"))
        }
    }
    var body: some View {
        VStack{
            VStack(spacing: 5){
                let s = GetChatTitle()
                HStack{
                    Text(s.0)
    //                    .font(.title2).bold()
                        .font(Font.system(size: 22, weight: .semibold, design: .default))
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    Spacer()
                    if (lastMessage != nil) {
                        let a = dateFormatter.string(from: Date(timeIntervalSince1970: Double(lastMessage?.sent_on ?? 0)))
                        Text(a)
    //                        .font(.caption)
                            .font(Font.system(size: 16, weight: .regular, design: .default))
                            .multilineTextAlignment(.leading)
    //                        .lineLimit(2)
                    }
                }
                HStack{
                    Image(systemName: "number.circle")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                        .foregroundColor(Color.theme.accent)
                    Text(s.1)
    //                    .font(.title2).bold()
                        .font(Font.system(size: 18, weight: .regular, design: .default))
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    Spacer()
                }
                HStack{
                
                    if (lastMessage != nil) {
                        Text(lastMessage!.body)
                            .truncationMode(.tail)
                            .foregroundColor(.gray)
                            .frame(maxHeight: 50)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                            .font(Font.system(size: 18, weight: .regular, design: .default))
                    }
                    Spacer()
                    if (lastMessage?.is_sender != true){
//                        if (lastMessage?.read == true){
////                            Image(systemName: "checkmark.circle")
////                                .foregroundColor(.gray)
////                                .frame(width: 10, height: 10, alignment: .center)
//                            Text("read")
//                                .font(Font.system(size: 18, weight: .regular, design: .default))
//                        }
////                        else{
////                            Image(systemName: "checkmark.circle.fill")
////                                .foregroundColor(.green)
////                                .frame(width: 10, height: 10, alignment: .center)
////                        }
//                    }
//                    else{
                        if (lastMessage?.read == false){
                            Circle()
                                .fill(Color.theme.accent)
                                .frame(width: 10, height: 10, alignment: .center)
//                            Image(systemName: "checkmark")
//                                .foregroundColor(.gray)
                        }
                    }
                    
//                    if (b?.first(where: {$0.message_id == message.message_id})?.read != nil){
//                        if (b?.first(where: {$0.message_id == message.message_id})?.read == false){
//                            Image(systemName: "checkmark")
//                                .foregroundColor(.gray)
//                        }
//                        else{
//                            Image(systemName: "checkmark")
//                                .foregroundColor(.green)
//                            Image(systemName: "checkmark")
//                                .foregroundColor(.green)
//                        }
//                    }
                    
                    
                }
            }
            .padding(.horizontal, 13.0)
            Divider()
        }
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


