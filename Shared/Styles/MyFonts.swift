//
//  MyFonts.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 10.08.2022.
//

import SwiftUI

struct MyFont {
    let size: CGFloat
}

struct MyFonts{
    let LargeTitle = MyFont(size: 34)
    let Title1 = MyFont(size: 28)
    let Title2 = MyFont(size: 22)
    let Title3 = MyFont(size: 20)
    let Headline = MyFont(size: 18)
    let Body = MyFont(size: 18)
    let Callout = MyFont(size: 16)
    let Subhead = MyFont(size: 15)
    let Footnote = MyFont(size: 13)
    let Caption1 = MyFont(size: 12)
    let Caption2 = MyFont(size: 11)
}

enum MyFontWeight{
    case regular, ultralight, thin, light, medium, semibold,  bold, heavy, black
}

//struct MyFontWeight{
//    let regular = "Regular"
//    let ultralight = "Ultralight"
//    let thin = "Thin"
//    let light = "Light"
//    let medium = "Medium"
//    let semibold = "Semibold"
//    let bold = "Bold"
//    let heavy = "Heavy"
//    let black = "Black"
//}

enum MyFontType{
    case display, rounded, text
}

//struct MyFontType{
//    let display = "Display"
//    let rounded = "Rounded"
//    let text = "Text"
//}

struct MyFontStyle: ViewModifier {
    let font: MyFont
    let color: Color?
    var fnt: String = "SFPro"
    
    init(font: MyFont, type:MyFontType?, color:Color?, weight:MyFontWeight?){
        self.font = font
        if (color != nil){
            self.color = color
        }
        else{
            self.color = Color.black
        }
        switch type{
        case .display:
            fnt += "Display-"
        case .rounded:
            fnt += "Rounded-"
        case .text:
            fnt += "Text-"
        case .none:
            fnt += "Display-"
        }
        switch weight{
        case .regular:
            fnt += "Regular"
        case .ultralight:
            fnt += "Ultralight"
        case .thin:
            fnt += "Thin"
        case .light:
            fnt += "Light"
        case .medium:
            fnt += "Medium"
        case .semibold:
            fnt += "Semibold"
        case .bold:
            fnt += "Bold"
        case .heavy:
            fnt += "Heavy"
        case .black:
            fnt += "Black"
        case .none:
            fnt += "Regular"
        }
//        if ((italic == true) && (type != .rounded)){
//            fnt += "Italic"
//        }
//        print(fnt)
    }
    func body(content: Content) -> some View {
        content
            .foregroundColor(color)
            .font(Font.custom(fnt, size: font.size))
    }
}

extension View {
    func myFont(font: MyFont,type: MyFontType, color: Color, weight: MyFontWeight) -> some View {
        modifier(MyFontStyle(font: font, type: type, color: color, weight: weight))
    }
}
