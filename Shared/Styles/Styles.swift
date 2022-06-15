//
//  Styles.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 17.05.2022.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct SuperTextField: View {
    
    var placeholder: Text
    @Binding var all: Alignment
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: all) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
    
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

func wphone() -> Int {
    if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            //            print("iPhone 5 or 5S or 5C")
            return 1
            
        case 1334:
            //            print("iPhone 6/6S/7/8")
            return 2
            
        case 1920, 2208:
            //            print("iPhone 6+/6S+/7+/8+")
            return 3
            
        case 2436:
            //            print("iPhone X/XS/11 Pro")
            return 4
            
        case 2688:
            //            print("iPhone XS Max/11 Pro Max")
            return 5
            
        case 1792:
            //            print("iPhone XR/ 11 ")
            return 6
            
        default:
            //            print("Unknown")
            return 7
        }
    }
    return 0
}

func IsBig() -> Bool{
    if (wphone() > 3){
        return true
    }
    else{
        return false
    }
}


struct AnimatableFontModifier: AnimatableModifier {
    var size: Double
    var weight: Font.Weight = .regular
    var design: Font.Design = .default
    
    var animatableData: Double {
        get { size }
        set { size = newValue }
    }
    
    func body(content: Content) -> some View {
        content
//            .font(.system(size: size, weight: weight, design: design))
//            .font(Font.custom("SFProDisplay-Bold", size: size))
            .font(Font.system(size: size, weight: .bold, design: .default))
    }
}

extension View {
    func animatableFont(size: Double, weight: Font.Weight = .regular, design: Font.Design = .default) -> some View {
        self.modifier(AnimatableFontModifier(size: size, weight: weight, design: design))
    }
}


struct StrokeStyle: ViewModifier {
    var cornerRadius: CGFloat
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(
                    .linearGradient(
                        colors: [
                            .white.opacity(colorScheme == .dark ? 0.6 : 0.3),
                            .black.opacity(colorScheme == .dark ? 0.3 : 0.1)
                        ], startPoint: .top, endPoint: .bottom
                    )
                )
                .blendMode(.overlay)
        )
    }
}

extension View {
    func strokeStyle(cornerRadius: CGFloat = 30) -> some View {
        modifier(StrokeStyle(cornerRadius: cornerRadius))
    }
}


extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}
