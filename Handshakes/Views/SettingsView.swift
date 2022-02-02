//
//  SettingsView.swift
//  Handshakes
//
//  Created by Kirill Burchenko on 31.12.2021.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("loggedIn") var loggedIn: Bool = false
    @AppStorage("jwt") var jwt: String = ""
    @EnvironmentObject private var contactsManager: ContactsDataView

    var body: some View {
        Button(action:{
            loggedIn = false
            jwt = ""
//            contactsManager.contacts = []
        }){
            Text("Log out")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
