//
//  GeometryElement.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 28.05.2022.
//

import SwiftUI

struct GeometryElement: View {
    
//    @Binding var hasScrolled: Bool
//    @State var big: Bool
//    @State var hasBack: Bool

    @Binding var x: CGFloat
    @Binding var y: CGFloat
    var body: some View {
        VStack (){
            
            GeometryReader{reader -> AnyView in
                let yAxis=reader.frame(in: .global).minY
                let xAxis=reader.frame(in: .global).minX

                                                    print(xAxis,yAxis)
                DispatchQueue.main.async {
                                        
                                            x = xAxis
                    y = yAxis
                                        
                                    }
//                if yAxis < (hasBack ? 88 : 77) && !hasScrolled{
//                    DispatchQueue.main.async {
//                        withAnimation(.easeInOut) {
//                            hasScrolled = true
//                        }
//                    }
//                }
//                if yAxis > (hasBack ? 88 : 77) && hasScrolled{
//                    DispatchQueue.main.async {
//                        withAnimation(.easeInOut) {
//                            hasScrolled = false
//                        }
//                    }
//                }
                return AnyView(
                    Color.clear.frame(width: 0, height: 0))
            }
            .frame(height: 0)
            
        }
//        .padding(.top, 20)
    }
    
}
