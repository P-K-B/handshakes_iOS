//
//  Styles.swift
//  Handshakes
//
//  Created by Kirill Burchenko on 27.11.2021.
//

import SwiftUI

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

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

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


extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing))
            .mask(self)
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
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

enum MyError: Error {
    case runtimeError(String)
}


struct SearchBarMy: View{
    
    @Binding var searchText: String
    @State var showCancelButton: Bool = false
    
    var body: some View{
        HStack {
            HStack {
                //search bar magnifying glass image
                Image(systemName: "magnifyingglass").foregroundColor(.secondary)
                
                //search bar text field
                TextField("search", text: self.$searchText, onEditingChanged: { isEditing in
                    self.showCancelButton = true
                })
                
                // x Button
                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .opacity(self.searchText == "" ? 0 : 1)
                }
            }
            .padding(8)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            
            // Cancel Button
            if self.showCancelButton  {
                Button("Cancel") {
                    self.endEditing()
                    self.searchText = ""
                    self.showCancelButton = false
                }
            }
        }
        .padding([.leading, .trailing,.top])
    }
}

//extension UIApplication {
//    func endEditing(_ force: Bool) {
//        self.windows
//            .filter{$0.isKeyWindow}
//            .first?
//            .endEditing(force)
//        UIWindowScene.windows.first!.endEditing(force)
//    }
//}

extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}

extension String: Error {}


struct Delete: ViewModifier {
    
    let action: () -> Void
    
    @State var offset: CGSize = .zero
    @State var initialOffset: CGSize = .zero
    @State var contentWidth: CGFloat = 0.0
    @State var willDeleteIfReleased = false
    @State var showTrash = false
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    ZStack {
                        Rectangle()
                            .foregroundColor(.red)
                        Image(systemName: "trash")
                            .foregroundColor(.white)
                            .font(.title2.bold())
                            .layoutPriority(-1)
                            .opacity(showTrash ? 1 : 0)
                    }.frame(width: -offset.width)
                        .offset(x: geometry.size.width)
                        .onAppear {
                            contentWidth = geometry.size.width
                        }
                        .gesture(
                            TapGesture()
                                .onEnded {
                                    delete()
                                }
                        )
                }
            )
            .offset(x: offset.width, y: 0)
            .gesture (
                DragGesture()
                    .onChanged { gesture in
                        if gesture.translation.width + initialOffset.width <= 0 {
                            withAnimation(.interactiveSpring()){
                                self.offset.width = gesture.translation.width + initialOffset.width
                            }
                        }
                        if self.offset.width < -deletionDistance && !willDeleteIfReleased {
                            hapticFeedback()
                            willDeleteIfReleased.toggle()
                        } else if offset.width > -deletionDistance && willDeleteIfReleased {
                            hapticFeedback()
                            willDeleteIfReleased.toggle()
                        }
                        if (self.offset.width < -40){
                            showTrash = true
                        }
                        else{
                            showTrash = false
                        }
                    }
                    .onEnded { _ in
                        if offset.width < -deletionDistance {
                            delete()
                        } else if offset.width < -halfDeletionDistance {
                            offset.width = -tappableDeletionWidth
                            initialOffset.width = -tappableDeletionWidth
                        } else {
                            offset = .zero
                            initialOffset = .zero
                        }
                    }
            )
        //            .animation(.interactiveSpring())
    }
    
    private func delete() {
        offset.width = -contentWidth
        action()
    }
    
    private func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    //MARK: Constants
    
    let deletionDistance = CGFloat(200)
    let halfDeletionDistance = CGFloat(50)
    let tappableDeletionWidth = CGFloat(100)
    
    
}

extension View {
    
    func onDelete(perform action: @escaping () -> Void) -> some View {
        self.modifier(Delete(action: action))
    }
    func onBack(perform action: @escaping () -> Void) -> some View {
        self.modifier(Back(action: action))
    }
    
}

struct Back: ViewModifier {
    
    let action: () -> Void
    
    @State var offset: CGSize = .zero
    @State var initialOffset: CGSize = .zero
    @State var contentWidth: CGFloat = 0.0
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .frame(width: 0)
                }
            )
        //            .offset(x: offset.width, y: 0)
            .gesture (
                DragGesture()
                    .onChanged { gesture in
                        print (self.offset.width)
                        print (gesture.startLocation.x)
                        if (gesture.translation.width + initialOffset.width >= 0 && gesture.startLocation.x < 20) {
                            withAnimation(.interactiveSpring()){
                                self.offset.width = gesture.translation.width + initialOffset.width
                            }
                        }
                        if self.offset.width > 80 {
                            hapticFeedback()
                            //                        willDeleteIfReleased.toggle()
                        }
                        if (self.offset.width > 80){
                            //                        showTrash = true
                            action()
                        }
                    }
            )
        //            .animation(.interactiveSpring())
    }
    
    
    private func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    
}

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
