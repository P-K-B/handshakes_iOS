//
//  Tab.swift
//  Handshakes
//
//  Created by Kirill Burchenko on 27.11.2021.
//

import SwiftUI

struct TabItem: Identifiable {
    var id = UUID()
    var text: String
    var icon: String
    var tab: Tab
    var color: Color
}

var tabItems = [
//    TabItem(text: "Learn Now", icon: "house", tab: .home, color: .accentColor),
//    TabItem(text: "Explore", icon: "magnifyingglass", tab: .explore, color: .blue),
//    TabItem(text: "Notifications", icon: "bell", tab: .notifications, color: .accentColor),
//    TabItem(text: "Library", icon: "rectangle.stack", tab: .library, color: .accentColor)
    TabItem(text: "Contacts", icon: "person", tab: .contacts, color: .accentColor),
    TabItem(text: "Search", icon: "magnifyingglass", tab: .search, color: .blue),
    TabItem(text: "Settings", icon: "magnifyingglass", tab: .settings, color: .pink)
]

enum Tab: String {
    case contacts
    case search
    case settings
//    case notifications
//    case library
}

struct TabPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


struct WindowManager: Encodable, Decodable {
//    var isSearching: Bool
    var searchingNumberIndex: Int
    var isSearchingNumber: Bool
    
    var contactDetailsIndex: Int
    var isContactDetails: Bool
    var isContactDetailsSearch: Bool
    
    init() {
//        print(UserDefaults.standard.data(forKey: "WindowManager")!)
        if let data = UserDefaults.standard.data(forKey: "WindowManager") {
//            print(data)
            if let decoded = try? JSONDecoder().decode(WindowManager.self, from: data) {
//                print(decoded)
                self = decoded
                return
            }
        }
        self.searchingNumberIndex = -1
        self.isSearchingNumber = false
        
        self.contactDetailsIndex = -1
        self.isContactDetails = false
        self.isContactDetailsSearch = false
    }
    
    mutating func save() {
        //        text = "new text"
//        self.text = newText
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: "WindowManager")
        }
//        print(UserDefaults.standard.data(forKey: "TestData")!)
    }
}
