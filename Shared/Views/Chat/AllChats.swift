//
//  AllChats.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 31.05.2022.
//

import SwiftUI

struct AllChats: View{
    @EnvironmentObject var historyData: HistoryDataView
    @EnvironmentObject var contactsData: ContactsDataView
    @EnvironmentObject var model: ChatScreenModel
    @EnvironmentObject var userData: UserDataView
    @State var search: Bool = false
    @State var selectedChat: String? = ""
    @State var selectedChatMsgID: UInt64? = 0
    //    @State var searchGuid: String?
    //    @State var toGuid: String = ""
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    @AppStorage("big") var big: Bool = IsBig()
    @State var hasScrolled: Bool = false
    @Binding var alert: MyAlert
    
    
    var body: some View {
        //        ZStack{
        /// Почему тут нужен NavigationView? Без него какая то проблема с сокетом...
            //        VStack{
            ZStack{
                Color.theme.background
                    .ignoresSafeArea()
                //                VStack{
                GeometryReader { geometry in
                    ScrollView() {
                        let a = model.chats.allChats
                            .sorted(by: {$0.value.last?.sent_on ?? 0 > $1.value.last?.sent_on ?? 0})
                        let b = a.filter({$0.value.contains(where: {$0.marker == "new_message"})})
                        if (b.count > 0){
                            Divider()
                            ForEach(a, id: \.key) { chatKey, val in
                                let chat = model.chats.allChats[chatKey]
                                
                                NavigationLink(destination:
                                                ChatScreen(alert: $alert)
                                    .environmentObject(historyData)
                                    .environmentObject(contactsData)
                                    .environmentObject(model)
                                    .environmentObject(userData)
                                )
                                {
                                    ChatItem(chat: chat)
                                }
                                .navigationViewStyle(.stack)
                                .foregroundColor(Color.black)
                                .simultaneousGesture(TapGesture().onEnded{
                                    model.OpenChat(chat: chatKey)
                                })
                                
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
                        
                    }
                    
                    .overlay(
                        NavigationBar(title: "Messages", search: .constant(false), showSearch: false, showProfile: true, hasBack: false, alert: $alert)
                            .environmentObject(historyData)
                            .environmentObject(contactsData)
                            .environmentObject(model)
                            .environmentObject(userData)
                        
                    )
                }
            }
            .safeAreaInset(edge: .top, content: {
                Color.clear.frame(height: big ? 45: 75)
            })
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: big ? 55: 70)
            }
            .popover(isPresented: $search) {
                SearchChats(close: $search, selectedChat:$selectedChat, selectedChatMsgID: $selectedChatMsgID)
                    .onAppear{
                        
                    }
            }
//            .overlay{
//                TabBar()
//                    .zIndex(1)
//                    .transition(.move(edge: .bottom))
//            }
            .navigationBarHidden(true)
        }
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
    var lastMessage: ReceivingChatMessage? = nil
    
    init(chat: [ReceivingChatMessage]?) {
        self.chat = chat
        self.lastMessage = chat?.last
    }
    
    func GetChatTitle() -> (String, String) {
        let metaMsg = self.chat?.first(where: {$0.marker == "new_chat_meta"})
        if (metaMsg?.is_sender == true){
            let a = contacts.data.contacts.filter({$0.telephone.contains(where: {$0.phone == metaMsg?.meta?.res})})
            return ((a.count > 0 ? a[0].firstName : "Unknown person"), (metaMsg?.meta?.number ?? "No number"))
        }
        else{
            let a = contacts.data.contacts.filter({$0.telephone.contains(where: {$0.phone == metaMsg?.meta?.asking_number})})
            return
            ((a.count > 0 ? a[0].firstName : "Unknown person"), (metaMsg?.meta?.number ?? "No number"))
        }
    }
    var body: some View {
        if ((self.chat?.filter({$0.marker == "new_message"}))?.count ?? 0 > 0) {
            VStack {
                VStack{
                    VStack(spacing: 5){
                        let s = GetChatTitle()
                        HStack{
                            Text(s.0)
        //                        .font(Font.system(size: 22, weight: .semibold, design: .default))
                                .myFont(font: MyFonts().Title2, type: .display, color: Color.black, weight: .bold)
        //                        .myFont(font: MyFonts().SubTitle, color: .black)
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                            Spacer()
                            if (lastMessage != nil) {
                                let a = dateFormatter.string(from: Date(timeIntervalSince1970: Double(lastMessage?.sent_on ?? 0)))
                                Text(a)
        //                            .font(Font.system(size: 16, weight: .regular, design: .default))
                                    .myFont(font: MyFonts().Subhead, type: .display, color: Color.black, weight: .regular)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        HStack{
                            Image(systemName: "number.circle")
                                .resizable()
                                .frame(width: 18, height: 18, alignment: .center)
                                .foregroundColor(Color.theme.accent)
                            Text(s.1)
        //                        .font(Font.system(size: 18, weight: .regular, design: .default))
                                .myFont(font: MyFonts().Subhead, type: .display, color: Color.black, weight: .regular)
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
        //                            .font(Font.system(size: 18, weight: .regular, design: .default))
                                    .myFont(font: MyFonts().Body, type: .display, color: Color.black, weight: .regular)
                            }
                            Spacer()
                            let unread = chat?.filter({$0.read != true})
                            let b = unread?.count ?? 0
                            if (lastMessage?.is_sender != true){
                                
                                if (lastMessage?.read == false){
                                    if (b != 0){
                                        Text("\(b)")
                                            .foregroundColor(.white)
                                            .frame(width: 15, height: 15, alignment: .center)
                                            .background(Color.theme.accent)
                                            .cornerRadius(10)
                                            
                                    }
        //                            Circle()
        //                                .fill(Color.theme.accent)
        //                                .frame(width: 10, height: 10, alignment: .center)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 13.0)
                }
            
            Divider()
        }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: 80,
                alignment: .topLeading
            )
        }
            
    }
    
}



struct AllChats_Previews: PreviewProvider {
    static let debug: DebugData = DebugData()
    
    static let historyData: HistoryDataView = debug.historyData
    static let contactsData: ContactsDataView = debug.contactsData
    static let model: ChatScreenModel = debug.model
    static let userData: UserDataView = debug.userData
    static var previews: some View {
        AllChats(alert: .constant(MyAlert()))
            .environmentObject(historyData)
            .environmentObject(contactsData)
            .environmentObject(model)
            .environmentObject(userData)
    }
}
