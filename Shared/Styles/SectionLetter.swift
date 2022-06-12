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
        HStack{
            BigLetter(letter: text, frame: 25, font: 15, color: Color.theme.accent)
                .padding(.leading, 10)
                .padding(5)
                .font(Font.custom("SFProDisplay-Bold", size: 15))
            Spacer()
        }
        .background(Color.theme.input)
        .cornerRadius(60)
        .padding(3)
    }
}
