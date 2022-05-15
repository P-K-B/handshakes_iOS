//
//  Loading.swift
//  Handshakes
//
//  Created by Kirill Burchenko on 20.02.2022.
//

import SwiftUI

struct Loading: View {
    @State private var isRotated = false
    var animation: Animation {
        Animation.linear
            .repeatForever(autoreverses: false)
            .speed(0.3)
    }
    
    var body: some View {
        ZStack{
            VStack{
//                Button("Rotate") {
//                        self.isRotated.toggle()
//                    }
            Image("NewIcon")
                .resizable()
            
            
            //                .aspectRatio(contentMode: .fit)
                .scaledToFit()
                .frame(maxWidth: 150, maxHeight: 150)
                .rotationEffect(Angle.degrees(isRotated ? 360 : 0))
                .animation(animation)
                .onAppear{
                    self.isRotated = true
                    
                }
            
            }
        }
    }
}

struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        Loading()
    }
}
