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
    
    @AppStorage("jwt") var jwt: String = ""
    @AppStorage("number") var number: String = ""
    @AppStorage("loggedIn") var loggedIn: Bool = false
    
    init() {
        if (jwt != ""){
            loggedIn = true
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if (loggedIn){
            ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
            else{
                Login()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .onAppear{
                        print(jwt)
                    }
            }
//            Test()
        }
    }
}
