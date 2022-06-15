//
//  SectionLetter.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 28.05.2022.
//

import SwiftUI

struct SectionLetter: View{
    @State var text: String
    
    var body: some View{
        VStack(spacing: 5){
            HStack{
                Text(text)
                    .padding(.leading, 13)
//                    .padding(5)
//                    .font(Font.custom("Inter-Bold", size: 16))
                    .font(Font.system(size: 16, weight: .bold, design: .default))
                    .foregroundColor(Color.theme.contactsHeadLetter)
                Spacer()
            }
//            .background(.red)
            Divider()
//                .background(.green)
        }
//        .background(Color.theme.input)
//        .cornerRadius(60)
        .padding(10)
    }
}
