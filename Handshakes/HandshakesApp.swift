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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
