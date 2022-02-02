//
//  ContentView.swift
//  Handshakes
//
//  Created by Kirill Burchenko on 26.11.2021.
//

import Foundation
import SwiftUI
import Contacts

func wphone() -> Int {
    if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            //            print("iPhone 5 or 5S or 5C")
            return 1
            
        case 1334:
            //            print("iPhone 6/6S/7/8")
            return 2
            
        case 1920, 2208:
            //            print("iPhone 6+/6S+/7+/8+")
            return 3
            
        case 2436:
            //            print("iPhone X/XS/11 Pro")
            return 4
            
        case 2688:
            //            print("iPhone XS Max/11 Pro Max")
            return 5
            
        case 1792:
            //            print("iPhone XR/ 11 ")
            return 6
            
        default:
            //            print("Unknown")
            return 7
        }
    }
    return 0
}

func IsBig() -> Bool{
    if (wphone() > 3){
        return true
    }
    else{
        return false
    }
}

struct ContentView: View {
    
    @AppStorage("jwt") var jwt: String = ""
    @AppStorage("number") var number: String = ""
    
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    
    @AppStorage("loggedIn") var loggedIn: Bool = false
    
    @AppStorage("big") var big: Bool = IsBig()
    
    //    @State var test: TestData = TestData()
    
    @State var historyData: HistoryData = HistoryData()
    
    @State var windowManager: WindowManager = WindowManager()
    
    //    @State var contactsManager: ContactsDataView = ContactsDataView()
    @StateObject var contactsManager = ContactsDataView()
    
    
    var body: some View {
                ZStack {
                    switch selectedTab {
                    case .contacts:
                        ContactView(big: (wphone() > 3) ? true : false, historyData: $historyData, windowManager: $windowManager)
                            .environmentObject(contactsManager)
                    case .search:
                        History(historyData: $historyData, big: (wphone() > 3) ? true : false, windowManager: $windowManager)
                            .environmentObject(contactsManager)
                        
                    case .settings:
                        SettingsView()
                            .environmentObject(contactsManager)
                        //                        Test()
                    }
                    TabBar(big:(wphone() > 3) ? true : false)
                }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
