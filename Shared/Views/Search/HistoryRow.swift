//
//  HistoryRow.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 29.05.2022.
//

import SwiftUI

struct HistoryRow: View {
    
    var history: SearchHistory
    
//    var body: some View {
//        VStack{
//            Text(history.number)
//                .font(Font.custom("SFProDisplay-Bold", size: 20))
//            Text("\(history.id)")
//                .font(Font.custom("SFProDisplay-Bold", size: 20))
//        }
//    }
    var body: some View {
        HStack() {
            Text(history.number)
            Spacer()
            if (history.searching == true){
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
            else{
                Image(systemName: history.res ? "checkmark.circle" : "xmark.circle")
            }
        }
        .font(Font.custom("SFProDisplay-Regular", size: 20))
//        .opacity(0.70)
        .foregroundColor(Color("GrayGary"))
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
    }
}

//struct HistoryRow_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryRow()
//    }
//}

