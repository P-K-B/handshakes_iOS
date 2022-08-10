//
//  MyFonts.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 10.08.2022.
//

import SwiftUI

struct MyFont {
    let size: CGFloat
    let bold: Bool
}

struct MyFonts{
    let body = MyFont(size: 18, bold: false)
    let bodyBold = MyFont(size: 18, bold: true)
    let Title = MyFont(size: 26, bold: false)
    let SubTitle = MyFont(size: 23, bold: false)
}

struct MyFontStyle: ViewModifier {
    let font: MyFont
    let color: Color
    func body(content: Content) -> some View {
        content
            .foregroundColor(color)
            .font(Font.custom(font.bold ? "SFProDisplay-Bold" : "SFProDisplay-Regular", size: font.size))
    }
}

extension View {
    func myFont(font: MyFont, color: Color) -> some View {
        modifier(MyFontStyle(font: font, color: color))
    }
}
