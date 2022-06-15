//
//  AppData.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 17.05.2022.
//

import Foundation
import SwiftUI


struct AppData {
//    @StateObject var user: UserDataView = UserDataView()
//    var api: API = API()
//    var alert: MyAlert = MyAlert()
//    @ObservedObject var contacts: ContactsData = ContactsData()
    var loaded: Bool = false
}

struct MyAlert{
    var error: Bool = false
    var title: String = ""
    var text: String = ""
    var button: String = ""
    var button2: String = ""
    var oneButton: Bool = true
    var deleteChat: Bool = false
}
