//
//  InfoPageView.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 17.05.2022.
//

import SwiftUI

struct InfoPageView: View {
    
//    @Binding var appData: AppData
    @EnvironmentObject var userData: UserDataView
    @EnvironmentObject var contacts: ContactsDataView
    @EnvironmentObject var history: HistoryDataView
    @EnvironmentObject private var model: ChatScreenModel
    
    var body: some View {
        VStack{
            Text("id: " + userData.data.id)
            Text("jwt: " + userData.data.jwt)
            Text("number: " + userData.data.number)
            Text("loggedIn: " + String(userData.data.loggedIn))
            Text("uuid: " + userData.data.uuid)
            Text("isNewUser: " + String(userData.data.isNewUser))
            resetButton
        }
    }
    
    var resetButton: some View{
        VStack{
            Button {
                Task {
                    ResetButton()
                }
            } label: {
                Text("Reset data")
    //                .buttonStyleLogin(fontSize: 15, color: Color.secondary)
            }
            Button {
                Task {
                    ResetButton2()
                }
            } label: {
                Text("Reset contacts")
    //                .buttonStyleLogin(fontSize: 15, color: Color.secondary)
            }
            Button {
                Task {
                    ResetButton3()
                }
            } label: {
                Text("Reset history")
    //                .buttonStyleLogin(fontSize: 15, color: Color.secondary)
            }
            Button {
                Task {
                    ResetButton4()
                }
            } label: {
                Text("Reset chats")
    //                .buttonStyleLogin(fontSize: 15, color: Color.secondary)
            }
        }
    }
    
    func ResetButton(){
        userData.reset()
//        contacts.reset()
    }
    func ResetButton2(){
//        userData.data.reset()
        contacts.reset()
    }
    
    func ResetButton3(){
//        userData.data.reset()
        history.reset()
    }
    func ResetButton4(){
//        userData.data.reset()
        model.reset()
    }
}

struct tmp{
    var id: String
}

struct InfoPageView_Previews: PreviewProvider {
    static var previews: some View {
        InfoPageView()
    }
}
