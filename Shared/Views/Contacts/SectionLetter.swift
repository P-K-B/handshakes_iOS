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
        VStack(spacing: 0){
            HStack{
                Text(text)
                    .padding(.leading, 13)
//                    .padding(5)
//                    .font(Font.custom("Inter-Bold", size: 16))
//                    .font(Font.system(size: 16, weight: .bold, design: .default))
                    .myFont(font: MyFonts().Callout, type: .display, color: Color.gray, weight: .bold)
                    .foregroundColor(Color.theme.contactsHeadLetter)
                    .padding(.bottom, 5)
                Spacer()
            }
//            .background(.red)
            Divider()
//                .background(.green)
        }
//        .background(Color.theme.input)
//        .cornerRadius(60)
        .padding(.horizontal, 10)
        .padding(.top, 10)
//        .background(.pink)
    }
}

struct SectionLetter_Previews: PreviewProvider {
    
    static var previews: some View {
        Group{
            SectionLetter(text: "This is a test")
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
        }
    }
}
