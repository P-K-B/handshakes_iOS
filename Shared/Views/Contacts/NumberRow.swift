//
//  NumberRow.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 26.05.2022.
//

import SwiftUI

struct NumberRow: View {
    var number: Number
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text ("\(number.title)")
//                .font(Font.system(size: 16, weight: .semibold, design: .default))
                .myFont(font: MyFonts().Callout, type: .display, color: Color.black, weight: .bold)
                .foregroundColor(Color.theme.contactsHeadLetter)
                .padding(.leading, 13)
                .padding(.bottom, 5)
            Divider()
            Text ("\(number.phone)")
//                .font(Font.system(size: 20, weight: .medium, design: .default))
                .myFont(font: MyFonts().Body, type: .display, color: Color.black, weight: .regular)
//                .underline()
                .padding(.leading, 13)
                .padding(.vertical, 10)
            Divider()
//            Text ("\(number.guid)")
//                .font(Font.system(size: 20, weight: .medium, design: .default))
////                .underline()
//                .padding(.leading, 5)
        }
    }
}

struct NumberRow_Previews: PreviewProvider {
    static var previews: some View {
        NumberRow(number: Number(id: 0, title: "Mobile", phone: "+1 888-555-5512", uuid: "1"))
    }
}
