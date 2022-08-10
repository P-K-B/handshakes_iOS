//
//  ContentView.swift
//  Shared
//
//  Created by Kirill Burchenko on 17.05.2022.
//

import SwiftUI

struct ContentView: View {
    
    @Binding var alert: MyAlert
    
    @AppStorage("big") var big: Bool = IsBig()
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    @AppStorage("profile") var profile: Bool = false
    @AppStorage("fresh") var fresh: Bool = true
    @AppStorage("hideContacts") var hideContacts: Bool = false
    @AppStorage("showHideAlertLoacl") var showHideAlertLoacl: Bool = false
    @AppStorage("reopen") var reopen: Bool = false
    
    
    @State var visible: Int = 0
    //    @State var test: Bool = true
    //    @State var selector: Bool = false
    
    @EnvironmentObject var historyData: HistoryDataView
    @EnvironmentObject var contactsData: ContactsDataView
    @EnvironmentObject var model: ChatScreenModel
    @EnvironmentObject var userData: UserDataView
    
    @State var bar = TabBar()
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        VStack {
            switch selectedTab {
            case .contacts:
                ContactsView(alert: $alert, visible: $visible)
                    .environmentObject(historyData)
                    .environmentObject(contactsData)
                    .environmentObject(model)
                    .environmentObject(userData)
//                    .overlay{
//                        bar
//                            .zIndex(1)
//                            .transition(.move(edge: .bottom))
//                    }
                
            case .search:
                SearchList(alert: $alert)
                    .environmentObject(historyData)
                    .environmentObject(contactsData)
                    .environmentObject(model)
                    .environmentObject(userData)
//                    .overlay{
//                        bar
//                            .zIndex(1)
//                            .transition(.move(edge: .bottom))
//                    }
                
            case .chats:
                AllChats(alert: $alert)
                    .environmentObject(historyData)
                    .environmentObject(contactsData)
                    .environmentObject(model)
                    .environmentObject(userData)
//                    .overlay{
//                        bar
//                            .zIndex(1)
//                            .transition(.move(edge: .bottom))
//                    }
                
            case .hide:
                HideContacts(root: true)
                    .environmentObject(historyData)
                    .environmentObject(contactsData)
                    .environmentObject(model)
                    .environmentObject(userData)
            }
        }
        .overlay{
            bar
                .zIndex(1)
                .transition(.move(edge: .bottom))
        }
        .onAppear{
            //            selector = false
            if (reopen){
                contactsData.SetJwt( jwt: userData.data.jwt)
                historyData.SetJwt( jwt: userData.data.jwt)
                model.SetJwt( jwt: userData.data.jwt)
                
                if (hideContacts == false){
                    contactsData.Load(upload: false, initial: false)
                }
                else{
                    contactsData.Load(upload: true, initial: false)
                }
                if (hideContacts == false){
                    
                    selectedTab = .hide
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                        showHideAlertLoacl = true
                    }
                    
                }
                if ((selectedTab == .hide) && (hideContacts == true)){
                    selectedTab = .search
                }
    //            DispatchQueue.global(qos: .userInitiated).async {
    //                sleep(1)
    //
    //                DispatchQueue.main.async {
                        onAppear()
    //                }
    //            }
                reopen = false
            }
        }
        .onChange(of: scenePhase) { newPhase in
                        if newPhase == .active {
                            print("Active")
                            onAppear()
                        } else if newPhase == .inactive {
                            print("Inactive")
                        } else if newPhase == .background {
                            print("Background")
                        }
                    }
        .onDisappear(perform: onDisappear)
        .alert(isPresented: $showHideAlertLoacl) {
            
            return Alert (
                title: Text("Hide contacts"),
                message: Text("This app need to upload your contacts to be able to build search chanis. You can hide some contacts if you'd like.\nYou can always change this list in the setting"),
                dismissButton: .default(Text("Ok"),
                                        action: {
                                            //                        hideContacts = true
                                        })
            )
            
        }
        .navigationBarHidden(true)
    }
    
    private func onAppear() {
        model.connect()
    }
    
    private func onDisappear() {
//        model.disconnect()
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static let debug: DebugData = DebugData()
    
    static let historyData: HistoryDataView = debug.historyData
    static let contactsData: ContactsDataView = debug.contactsData
    static let model: ChatScreenModel = debug.model
    static let userData: UserDataView = debug.userData
    
    static var previews: some View {
        ContentView(alert: .constant(MyAlert()))
            .environmentObject(historyData)
            .environmentObject(contactsData)
            .environmentObject(model)
            .environmentObject(userData)
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
        
        ContentView(alert: .constant(MyAlert()))
            .environmentObject(DebugData().historyData)
            .environmentObject(DebugData().contactsData)
            .environmentObject(DebugData().userData)
            .environmentObject(DebugData().model)
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
    }
}
