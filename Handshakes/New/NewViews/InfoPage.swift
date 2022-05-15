//
//  SwiftUIView.swift
//  Handshakes
//
//  Created by Kirill Burchenko on 03.05.2022.
//

import SwiftUI

struct InfoPageView: View {
    
    @Binding var user: UserData
    
    var body: some View {
        VStack{
            Text("id: " + user.id)
            Text("jwt: " + user.jwt)
            Text("number: " + user.number)
            Text("loggedIn: " + String(user.loggedIn))
            Text("uuid: " + user.uuid)
        }
    }
}

//struct InfoPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        InfoPageView()
//            .environmentObject(User())
//    }
//}
