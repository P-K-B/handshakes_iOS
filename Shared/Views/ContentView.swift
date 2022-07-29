//
//  ContentView.swift
//  Shared
//
//  Created by Kirill Burchenko on 17.05.2022.
//

import SwiftUI

//struct ContentView: View {
//        @Binding var alert: MyAlert
//
//    var body: some View {
//        ScrollView {
//            ScrollViewReader { proxy in
//                LazyVStack {
//                    ForEach(0..<50000, id: \.self) { i in
//                        Button("Jump to \(i+500)") {
//                            proxy.scrollTo(i+500, anchor: .top)
//                        }
//                        Text("Example \(i)")
//                            .id(i)
//                    }
//                }
//            }
//        }
//    }
//}

struct ContentView: View {
    
    //    @EnvironmentObject var userData: UserDataView
    //    @EnvironmentObject var contactsData: ContactsDataView
    //    @StateObject var contactsData: ContactsDataView = ContactsDataView()
    @Binding var alert: MyAlert
    
    @AppStorage("big") var big: Bool = IsBig()
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    @AppStorage("profile") var profile: Bool = false
    @AppStorage("fresh") var fresh: Bool = true
    @AppStorage("hideContacts") var hideContacts: Bool = false
    @AppStorage("showHideAlertLoacl") var showHideAlertLoacl: Bool = false
    //    @State var showHide: Bool = false
    //    @State var showHideAlert: Bool = false
    //    @EnvironmentObject private var model: ChatScreenModel
    //    @EnvironmentObject var historyData: HistoryDataView
    
    @State var visible: Int = 0
    @State var test: Bool = true
    @State var selector: Bool = false
    
    @EnvironmentObject var historyData: HistoryDataView
    @EnvironmentObject var contactsData: ContactsDataView
    @EnvironmentObject var model: ChatScreenModel
    @EnvironmentObject var userData: UserDataView
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        
        //        NavigationView{
        //            VStack{
        //                ZStack{
        VStack {
            switch selectedTab {
            case .contacts:
                ContactsView(alert: $alert, visible: $visible)
                    .environmentObject(historyData)
                    .environmentObject(contactsData)
                    .environmentObject(model)
                    .environmentObject(userData)
                    .onAppear{
                        print("Data")
                        print(historyData.datta)
                        print(contactsData.data)
                        print(userData.data)
                        //                                    print(contactsData.selectedContact)
                    }
                
                
                //                        case .singleContact:
                //                            ContactsView(alert: $alert, visible: $visible)
                //                                .environmentObject(contactsData)
                //                                .environmentObject(historyData)
                
            case .search:
                SearchList(alert: $alert)
                    .environmentObject(historyData)
                    .environmentObject(contactsData)
                    .environmentObject(model)
                    .environmentObject(userData)
                
                //                        case .singleSearch:
                //                            SingleSearchView()
                //                                .environmentObject(historyData)
                //                                .environmentObject(contactsData)
                //                                .environmentObject(model)
                
            case .chats:
                AllChats(alert: $alert)
                    .environmentObject(historyData)
                    .environmentObject(contactsData)
                    .environmentObject(model)
                    .environmentObject(userData)
                
            case .hide:
                HideContacts(root: true)
                ////                               SearchList(alert: $alert)
                
                                    .environmentObject(historyData)
                                    .environmentObject(contactsData)
                                    .environmentObject(model)
                                    .environmentObject(userData)
                
                //                        case .singleChat:
                //
                //                            ChatScreen(alert: $alert)
                //                                .environmentObject(model)
                //                                .environmentObject(contactsData)
                //
                //                        case .profile:
                //                            Settings()
                //                                .environmentObject(userData)
                //                                .environmentObject(contactsData)
                //                                .environmentObject(historyData)
                //                                .environmentObject(model)
            }
            
            //                    }
            
            
            //                }
            //            }
            //            .navigationBarHidden(true)
            //            .navigationBarBackButtonHidden(true)
//            VStack{
//                NavigationLink(destination:
//                                HideContacts()
////                               SearchList(alert: $alert)
//
//                    .environmentObject(historyData)
//                    .environmentObject(contactsData)
//                    .environmentObject(model)
//                    .environmentObject(userData)
//                    .navigationBarHidden(true)
//                    .navigationBarBackButtonHidden(true), isActive: $selector
//                ){
//                    EmptyView()
//                        .navigationBarHidden(true)
//                        .navigationBarBackButtonHidden(true)
//                }
//            }
        }
        
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear{
            selector = false
            contactsData.SetJwt( jwt: userData.data.jwt)
            historyData.SetJwt( jwt: userData.data.jwt)
            model.SetJwt( jwt: userData.data.jwt)
            
            if (hideContacts == false){
                contactsData.Load(upload: false)
            }
            else{
                contactsData.Load(upload: true)
            }
            onAppear()
            //            print("hideContacts:")
            //            print(hideContacts)
            if (hideContacts == false){

                selectedTab = .hide
               
            }
            if ((selectedTab == .hide) && (hideContacts == true)){
                selectedTab = .search
            }
        }
        .onDisappear(perform: onDisappear)
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
    }
    
    private func onAppear() {
        model.connect()
    }
    
    private func onDisappear() {
        model.disconnect()
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
