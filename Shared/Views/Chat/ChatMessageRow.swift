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
                    VStack(alignment: .leading, spacing: 6) {
                        //                    VStack{
                        //                HStack {
                        //
                        //                    Text(b?.first(where: {$0.message_id == message.message_id})?.is_sender ?? false ? "You" : partner)
                        //                        .fontWeight(.bold)
                        //                        .font(.system(size: 12))
                        //                }
                        
                        Text(b?.first(where: {$0.message_id == message.message_id})?.body ?? "")
                            .frame(minWidth: 94, alignment: .leading)
                            .background(GeometryReader {
                                Color.clear.preference(key: MessageWidthPreferenceKey.self,
                                                       value: $0.frame(in: .local).size.width)
                            })
                        //                Text(message.body)
                        //                HStack{
                        //                    Spacer()
                        let a = dateFormatter.string(from: Date(timeIntervalSince1970: Double(message.sent_on ?? 0)))
                        HStack{
                            Text(a)
                                .font(Font.system(size: 12, weight: .regular, design: .default))
                                .frame(minWidth: 94, alignment: .trailing)
                        }
                        .frame(minWidth: messageWidth, alignment: .trailing)
                        //                }
                        
                        .onAppear{
                            print(messageWidth)
                        }
                        //                    }
                        
                    }
                    .padding(5)
                    .onPreferenceChange(MessageWidthPreferenceKey.self) { pref in
                        self.messageWidth = pref
                    }
                    .frame(minWidth: 100, alignment: isUser ? .trailing : .leading)
                    
                    .foregroundColor(isUser ? .white : .black)
                    .background(isUser ? Color.blue : Color.theme.contactsHeadLetter.opacity(0.30))
                    //            .padding(10)
                    .cornerRadius(10)
                    HStack{
                        if ((b?.first(where: {$0.message_id == message.message_id})?.is_sender ?? false) == true){
                            if (b?.first(where: {$0.message_id == message.message_id})?.read != nil){
                                if (b?.first(where: {$0.message_id == message.message_id})?.read == true){
                                    //                            Image(systemName: "checkmark.circle")
                                    //                                .foregroundColor(.gray)
                                    //                                .frame(width: 10, height: 10, alignment: .center)
                                    Text("Read")
                                        .font(Font.system(size: 12, weight: .regular, design: .default))
                                }
                                //                        else{
                                //                            Image(systemName: "checkmark.circle.fill")
                                //                                .foregroundColor(.green)
                                //                                .frame(width: 10, height: 10, alignment: .center)
                                //                        }
                            }
                        }
                    }
                    .frame(minWidth: messageWidth, alignment: .trailing)
                }
                .padding(10)
                
                if !isUser {
                    Spacer()
                }
            }
        }
        //        .onAppear{
        //
        //        }
    }
    
    struct MessageWidthPreferenceKey : PreferenceKey {
        static var defaultValue: CGFloat { 0 }
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value = value + nextValue()
        }
    }
}
