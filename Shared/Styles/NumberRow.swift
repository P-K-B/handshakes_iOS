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
        VStack(alignment: .leading){
            Text ("\(number.title)")
                .font(Font.system(size: 16, weight: .semibold, design: .default))
                .foregroundColor(Color.theme.contactsHeadLetter)
                .padding(.leading, 5)
            Divider()
            Text ("\(number.phone)")
                .font(Font.system(size: 20, weight: .medium, design: .default))
//                .underline()
                .padding(.leading, 5)
            
            Divider()
            Text ("\(number.guid)")
                .font(Font.system(size: 20, weight: .medium, design: .default))
//                .underline()
                .padding(.leading, 5)
        }
    }
}

//struct NumberRow_Previews: PreviewProvider {
//    static var previews: some View {
//        NumberRow()
//    }
//}
