//
//  ChatMessageRow.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 31.05.2022.
//

import SwiftUI

struct ChatMessageRow: View {
    static private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    let message: ReceivingChatMessage
    let isUser: Bool
    let partner: String
    
    var body: some View {
        HStack {
            if isUser {
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(message.is_sender ?? false ? "You" : partner)
                        .fontWeight(.bold)
                        .font(.system(size: 12))
                }
                
                Text(message.body)
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
}
