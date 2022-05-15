//
//  HandshakesApp.swift
//  Handshakes
//
//  Created by Kirill Burchenko on 26.11.2021.
//

import SwiftUI

@main
struct HandshakesApp: App {
    let persistenceController = PersistenceController.shared
    
    @State var user: UserData = UserData()
    
    @AppStorage("jwt") var jwt: String = ""
    @AppStorage("number") var number: String = ""
    @AppStorage("loggedIn") var loggedIn: Bool = false
    @State private var loading: Bool = false
    
    init() {
        //        if (jwt != ""){
        //        loggedIn = true
        //        }
        //        jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNiJ9.7IRFyjJbB5IXiyG0STQQNaMBczkBB81sCRcgnyG_wLQ"
        
//                self.user.jwt="12345"
//        print(user)
//        print("Here")
//        user.loggedIn=false
//        print(user)
//        self.user.save()
        
        
    }
    
    var body: some Scene {
        WindowGroup {
            VStack{
//                VStack{
//                    Text("id: " + user.id)
//                    Text("jwt: " + user.jwt)
//                    Text("number: " + user.number)
//                    Text("loggedIn: " + String(user.loggedIn))
//                    Text("uuid: " + user.uuid)
//                }
                if (self.user.loggedIn){
//                    InfoPageView(user: $user)
                    ContentView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                }
                else{
                    LoginView(user: $user)
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                }
            }
            .onAppear{
                do{
                    try API().SignInUpCallAppToken(phone: self.user.number, token: self.user.uuid)
                    { (reses) in
                        print(reses)
                        self.user.save()
                        if (reses.status_code == 0){
                            self.user.loggedIn = true
                            self.user.jwt=reses.payload?.jwt.jwt ?? ""
                            self.user.save()
                        }
                        else{
                            print(reses)
                        }
                    }
                }
                catch {
                    print("Error")
                }
            }
            //            ChatView()
            //            if (loading){
            //                Loading()
            ////                    .animation(.easeInOut, value: loading)
            ////                    .transition(.slide)
            //                    .onAppear {
            //                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            //                            withAnimation(){
            //                                self.loading = false
            //                            }
            //                        }
            //                    }
            //            }
            //            else{
            //                if (loggedIn){
            //                    ContentView()
            ////                        .animation(.easeInOut, value: loading)
            ////                        .transition(.slide)
            //                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
            //                }
            //                else{
            //                    Login()
            //                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
            //                        .onAppear{
            //                            print(jwt)
            //                        }
            //                }
            ////                Test()
            //            }
        }
    }
}
