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
        formatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
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
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    
                    Text(b?.first(where: {$0.message_id == message.message_id})?.is_sender ?? false ? "You" : partner)
                        .fontWeight(.bold)
                        .font(.system(size: 12))
                }
                
                Text(b?.first(where: {$0.message_id == message.message_id})?.body ?? "")
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
                    if ((b?.first(where: {$0.message_id == message.message_id})?.is_sender ?? false) == true){
                    if (b?.first(where: {$0.message_id == message.message_id})?.read != nil){
                        if (b?.first(where: {$0.message_id == message.message_id})?.read == false){
                            Image(systemName: "checkmark")
                                .foregroundColor(.gray)
                        }
                        else{
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                        }
                    }
                    }
                }
                    .frame(minWidth: messageWidth, alignment: .trailing)
//                }
                
                .onAppear{
                    print(messageWidth)
                }
            }
            .onPreferenceChange(MessageWidthPreferenceKey.self) { pref in
                                self.messageWidth = pref
                            }
            .foregroundColor(isUser ? .white : .black)
            .padding(10)
            .background(isUser ? Color.blue : Color(white: 0.95))
            .cornerRadius(5)
            
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
