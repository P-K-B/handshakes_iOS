//
//  GeometryElement.swift
//  Handshakes
//
//  Created by Kirill Burchenko on 01.02.2022.
//

import SwiftUI

struct GeometryElement: View {
    
    @Binding var hasScrolled: Bool
    @State var big: Bool
    @State var hasBack: Bool
    
    var body: some View {
        VStack (){
            
            GeometryReader{reader -> AnyView in
                let yAxis=reader.frame(in: .global).minY
                //                                    print(yAxis)
                if yAxis < (hasBack ? 88 : 77) && !hasScrolled{
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut) {
                            hasScrolled = true
                        }
                    }
                }
                if yAxis > (hasBack ? 88 : 77) && hasScrolled{
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut) {
                            hasScrolled = false
                        }
                    }
                }
                return AnyView(
                    Color.clear.frame(width: 0, height: 0))
            }
            .frame(height: 0)
            
        }
        .padding(.top, 20)
    }
    
}
