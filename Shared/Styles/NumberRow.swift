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
        HStack{
            Text ("\(number.title): \(number.phone)")
                .font(Font.custom("SFProDisplay-Regular", size: 20))
        }
    }
}

//struct NumberRow_Previews: PreviewProvider {
//    static var previews: some View {
//        NumberRow()
//    }
//}
