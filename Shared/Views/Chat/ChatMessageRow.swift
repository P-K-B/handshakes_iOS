//
//  ChatMessageRow.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 31.05.2022.
//

import SwiftUI

struct ChatMessageRow: View {
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        //        formatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        formatter.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation() ?? "GMT") //Set timezone that you want
        formatter.locale = NSLocale.current
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    let message: ReceivingChatMessage
    @EnvironmentObject private var model: ChatScreenModel
    let isUser: Bool
    let partner: String
    @State private var messageWidth: CGFloat = 0
    
    //    let dateFormatter = DateFormatter()
    
    var body: some View {
        if (model.openChat != nil){
            let b = model.chats.allChats[model.openChat!]
            HStack {
                if isUser {
                    Spacer()
                }
                VStack(spacing: 0){
//                    GeometryReader { geometry in
//                        Text(b?.first(where: {$0.message_id == message.message_id})?.body ?? "")
//                            .frame(minWidth: 94, alignment: .leading)
//                            .myFont(font: MyFonts().Body, type: .display, color: Color.black, weight: .regular)
////                            .background(GeometryReader {
////                                Color.clear.preference(key: MessageWidthPreferenceKey.self,
////                                                       value: $0.frame(in: .local).size.width)
////                            })
//                            .frame(width: geometry.size.width, height: <#T##CGFloat?#>, alignment: <#T##Alignment#>)
//                    }
//                                            Text("\(messageWidth)")
                    VStack(alignment: .leading, spacing: 6) {
                        let a = dateFormatter.string(from: Date(timeIntervalSince1970: Double(message.sent_on ?? 0)))
                        HStack{
                            Text(b?.first(where: {$0.message_id == message.message_id})?.body ?? "")
//                            Text("")
                                .frame(minWidth: 94, alignment: .leading)
                                .myFont(font: MyFonts().Body, type: .display, color: isUser ? Color.white : Color.black, weight: .regular)
                                .background(GeometryReader {
                                    Color.clear.preference(key: MessageWidthPreferenceKey.self,
                                                           value: $0.frame(in: .local).size.width)
                                })
                        if (messageWidth <= 230){
                            HStack{
                            Text(a)
//                                .font(Font.system(size: 12, weight: .regular, design: .default))
                                .myFont(font: MyFonts().Footnote, type: .display, color: isUser ? Color.white : Color.black, weight: .regular)
                                if ((b?.first(where: {$0.message_id == message.message_id})?.is_sender ?? false) == true){
                                    if (b?.first(where: {$0.message_id == message.message_id})?.read != nil){
                                        if (b?.first(where: {$0.message_id == message.message_id})?.read == true){
                                            Text("Read")
        //                                        .font(Font.system(size: 12, weight: .regular, design: .default))
                                                .myFont(font: MyFonts().Footnote, type: .display, color: isUser ? Color.white : Color.black, weight: .regular)
                                        }
                                    }
                                }
                            }
                                .offset(y: 10)
                        }
                        }
                        if (messageWidth > 230){
                            HStack(alignment: .bottom){
//                                VStack(){
//                                    Spacer()
                            Text(a)
//                                .font(Font.system(size: 12, weight: .regular, design: .default))
                                .myFont(font: MyFonts().Footnote, type: .display, color: isUser ? Color.white : Color.black, weight: .regular)
                                if ((b?.first(where: {$0.message_id == message.message_id})?.is_sender ?? false) == true){
                                    if (b?.first(where: {$0.message_id == message.message_id})?.read != nil){
                                        if (b?.first(where: {$0.message_id == message.message_id})?.read == true){
                                            Text("Read")
        //                                        .font(Font.system(size: 12, weight: .regular, design: .default))
                                                .myFont(font: MyFonts().Footnote, type: .display, color: isUser ? Color.white : Color.black, weight: .regular)
                                        }
                                    }
                                }
//                                    .frame(minWidth: 94, alignment: .bottom)
//                                    .background(.green)
//                                }
                        }
//                            .background(.red)
                        .frame(minWidth: messageWidth, alignment: .trailing)
                    
//                            .frame(height:100)
                        
                        .onAppear{
                            print(messageWidth)
                        }
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 5)
                    .padding(.bottom, messageWidth > 230 ? 5 : 15)
                    .onPreferenceChange(MessageWidthPreferenceKey.self) { pref in
                        self.messageWidth = pref
                    }
                    .frame(alignment: isUser ? .trailing : .leading)
                    
                    .foregroundColor(isUser ? .white : .black)
                    .background(isUser ? Color.blue : Color.theme.contactsHeadLetter.opacity(0.30))
                    //            .padding(10)
                    .cornerRadius(10)
//                    HStack{
//                        if ((b?.first(where: {$0.message_id == message.message_id})?.is_sender ?? false) == true){
//                            if (b?.first(where: {$0.message_id == message.message_id})?.read != nil){
//                                if (b?.first(where: {$0.message_id == message.message_id})?.read == true){
//                                    Text("Read")
////                                        .font(Font.system(size: 12, weight: .regular, design: .default))
//                                        .myFont(font: MyFonts().Footnote, type: .display, color: Color.black, weight: .regular)
//                                }
//                            }
//                        }
//                    }
//                    .frame(minWidth: messageWidth, alignment: .trailing)
                }
                .padding(10)
                
                if !isUser {
                    Spacer()
                }
            }
        }
    }
    
    struct MessageWidthPreferenceKey : PreferenceKey {
        static var defaultValue: CGFloat { 0 }
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value = value + nextValue()
        }
    }
}

struct ChatMessageRow_Previews: PreviewProvider {
    static let debug: DebugData = DebugData()
    
    static let historyData: HistoryDataView = debug.historyData
    static let contactsData: ContactsDataView = debug.contactsData
    static let model: ChatScreenModel = debug.model
    static let userData: UserDataView = debug.userData
    static var previews: some View {
        ChatMessageRow(message: model.chats.allChats["9A8897C50C3811EDBD9E0242AC120002"]![1], isUser: true, partner: "")
            .environmentObject(historyData)
            .environmentObject(contactsData)
            .environmentObject(model)
            .environmentObject(userData)
    }
}
