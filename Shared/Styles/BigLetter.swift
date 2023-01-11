//
//  BigLetter.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 26.05.2022.
//

import Foundation
import SwiftUI

struct BigLetter: View {
    @State var letter: String
    @State var frame: CGFloat
    @State var font: CGFloat
    @State var color: Color
    
    var body: some View {
        Text(letter)
        
            .font(Font.custom("SFProDisplay-Bold", size: font))
            .frame(width: frame, height: frame, alignment: .center)
            .foregroundColor(.white)
            .background(color)
            .clipShape(Circle())
    }
}
