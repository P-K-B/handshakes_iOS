//
//  Settings.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 28.06.2022.
//

import SwiftUI

struct Settings: View {
    @EnvironmentObject var userData: UserDataView
    @EnvironmentObject var contacts: ContactsDataView
    @EnvironmentObject var history: HistoryDataView
    @EnvironmentObject private var model: ChatScreenModel
    
    @Binding var showHide: Bool
    @Binding var showHideAlert: Bool
    @AppStorage("selectedTab") var selectedTab: Tab = .search

    
    var body: some View {
        NavigationView{
        VStack{
            Text("id: " + userData.data.id)
            Text("jwt: " + userData.data.jwt)
            Text("number: " + userData.data.number)
            Text("loggedIn: " + String(userData.data.loggedIn))
            Text("uuid: " + userData.data.uuid)
            Text("isNewUser: " + String(userData.data.isNewUser))
            NavigationLink(destination: HideContacts(showHide: $showHide, showHideAlert: $showHideAlert).environmentObject(userData).environmentObject(contacts).environmentObject(model).environmentObject(history), isActive: $showHide) { EmptyView() }
            Button(action:{showHide = true}){
                Text("Hide contacts")
                    .buttonStyleLogin(fontSize: 20, color: Color.accentColor)
            }
            Button(action:{ResetButton()}){
                Text("Logout")
                    .buttonStyleLogin(fontSize: 20, color: Color.accentColor)
            }
            Button(action:{selectedTab = .search}){
                Text("Back")
                    .buttonStyleLogin(fontSize: 20, color: Color.accentColor)
            }
        }
    }
    }
    
    func ResetButton(){
        userData.reset()
//        contacts.reset()
    }
}

//struct Settings_Previews: PreviewProvider {
//    static var previews: some View {
//        Settings()
//            .environmentObject(DebugData().userData)
//            .environmentObject(DebugData().contactsData)
//            .environmentObject(DebugData().historyData)
//            .environmentObject(DebugData().model)
//    }
//}
