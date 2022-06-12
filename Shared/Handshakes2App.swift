//
//  Handshakes2App.swift
//  Shared
//
//  Created by Kirill Burchenko on 17.05.2022.
//

import SwiftUI
import PhoneNumberKit
import Combine

@main
struct Handshakes2App: App {
    
    //    let persistenceController = PersistenceController.shared
    
    //    @State var appData: AppData = AppData()
    @State var alert = MyAlert()
    @State var logged: Bool = false
    @StateObject var userData: UserDataView = UserDataView()
    let phoneNumberKit = PhoneNumberKit()
    @State private var phoneField: PhoneNumberTextFieldView?
    //        @State private var phoneNumber = String()
    //        @State private var validNumber: Bool = false
    //        @State private var validationError = false
    //    @State private var errorDesc = Text("")
    //        @StateObject var contacts: ContactsData = ContactsData()
    
    @AppStorage("jwt") var jwt: String = ""
    
    @State var isAnimating = false
        var foreverAnimation: Animation {
            Animation.linear(duration: 1.0)
                .repeatForever(autoreverses: false)
        }


    
    var body: some Scene {
        WindowGroup {
            
            //            VStack{
            //                Text(String(data.data.number))
            //                Button {
            //                    Task {
            ////                                                DataService().Plus()
            //                        data.Plus()
            //                    }
            //                } label: {
            //                    Text("Plus")
            //                    //                .buttonStyleLogin(fontSize: 15, color: Color.secondary)
            //                }
            //            }
            
            
            VStack{
                if (userData.data.loaded){
//                    if (logged){

                    if (userData.data.loggedIn){
                        ContentView(alert: $alert)
                            .environmentObject(userData)
//                            .transition(.scale)
                    }
                    else{
                        LoginView(alert: $alert)
                            .environmentObject(userData)
                            
                    }
                }
                else{
                    appLoading
                        .transition(.scale)
                }
            }
            .onAppear{
                //                        self.phoneField = PhoneNumberTextFieldView(phoneNumber: self.$phoneNumber, isEdeted: self.$validNumber)
                
//                Login
                DispatchQueue.global(qos: .userInitiated).async {
                    print("Performing time consuming task in this background thread")
                    do{
                        let group = DispatchGroup()
                        group.enter()
                        
                        // avoid deadlocks by not using .main queue here
                        DispatchQueue.global().async {
                            while userData.data.loaded != true {
                            }
                            group.leave()
                        }
                        
                        // wait ...
                        group.wait()
                        //                        userData.data.loaded = false
                        userData.update(newData: UserUpdate(field: .loaded, bool: false))
                        //                                                sleep(3)
                        print(userData.data.number)
                        try self.phoneNumberKit.parse(userData.data.number)
                        do{
                            try userData.SignInUpCallAppToken()
                            { (reses) in
                                print(reses)
                                if ((reses.status_code == 0) && (reses.payload?.jwt != nil)){
                                    //                                    userData.data.loggedIn = true
                                    userData.update(newData: UserUpdate(field: .loggedIn, bool: true))
                                    //                                    userData.data.jwt=reses.payload?.jwt?.jwt ?? ""
                                    userData.update(newData: UserUpdate(field: .jwt, string: reses.payload?.jwt?.jwt ?? ""))
                                    jwt = reses.payload?.jwt?.jwt ?? ""
//                                    contactsData.SetJwt(jwt: reses.payload?.jwt?.jwt ?? "")
                                    userData.update(newData: UserUpdate(field: .id, string: String(reses.payload?.jwt?.id ?? -1)))
                                    userData.save()
                                }
                                if (reses.status_code == -1){
                                    alert = MyAlert(error: true, title: "", text: "Error connectiong to server", button: "Ok")
                                }
                                    userData.update(newData: UserUpdate(field: .loaded, bool: true))
                            }
                        }
                        catch{
                            print("here1")
                        }
                    }
                    catch {
                        print("here2")
                        //                        userData.data.loaded = true
                        userData.update(newData: UserUpdate(field: .loaded, bool: true))
                    }
                    
                    DispatchQueue.main.async {
                        // Task consuming task has completed
                        // Update UI from this block of code
                        print("Time consuming task has completed. From here we are allowed to update user interface.")
                    }
                }

//                Contacts
//                DispatchQueue.global(qos: .userInitiated).async {
//                    print("Performing time consuming task in this background thread")
//                    
//                    let group = DispatchGroup()
//                    group.enter()
//                    
//                    // avoid deadlocks by not using .main queue here
//                    DispatchQueue.global().async {
//                        while contactsData.data.loaded != true {
//                        }
//                        group.leave()
//                    }
//                    
//                    // wait ...
//                    group.wait()
////                    print(contactsData.data)
//                    
//                    DispatchQueue.main.async {
//                        // Task consuming task has completed
//                        // Update UI from this block of code
//                        print("Time consuming task has completed. From here we are allowed to update user interface.")
//                    }
//                }
            }
            .alert(isPresented: $alert.error) {
                if (alert.oneButton){
                    return Alert(
                        title: Text(alert.title),
                        message: Text(alert.text),
                        dismissButton: .default(Text(alert.button))
                    )
                }
                else{
                    return Alert (
                        title: Text(alert.title),
                        message: Text(alert.text),
                        primaryButton: .default(Text(alert.button),
                                                action: {
                                                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                                                }),
                        secondaryButton: .default(Text(alert.button2))
                    )
                }
            }
        }
        
    }
    
    
    
    var appLoading: some View{
        
        VStack{
            Text ("Loading...")
//            ProgressView()
//            Image("Logo")
//            Image(systemName: "arrow.2.circlepath")
//                .rotationEffect(Angle(degrees: isAnimating ? 360.0 : 0.0))
////                .animation(isAnimating ? self.foreverAnimation : foreverAnimationNo)
//                .animation(self.foreverAnimation)
//                            .onAppear {
//                                isAnimating = true
//                        }
//                            .onDisappear{
//                                isAnimating = false
//                            }
        }
    }
}
