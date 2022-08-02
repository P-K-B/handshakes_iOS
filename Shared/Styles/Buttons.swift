//
//  Buttons.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 28.05.2022.
//

import SwiftUI

struct ButtonStyleLogin: ViewModifier {
    var fontSize: CGFloat
    var color: Color
    //    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .frame(minWidth: 70, maxHeight: 25)
            .padding(.vertical, 10)
            .padding(.horizontal, 30)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(100)
//            .font(Font.custom("SFProDisplay-Regular", size: fontSize))
            .font(.body)
    }
}

extension View {
    func buttonStyleLogin(fontSize: CGFloat = 30, color: Color = Color.accentColor) -> some View {
        modifier(ButtonStyleLogin(fontSize: fontSize, color: color))
    }
}
