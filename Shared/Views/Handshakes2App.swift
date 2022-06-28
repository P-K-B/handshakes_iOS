//
//  Handshakes2App.swift
//  Shared
//
//  Created by Kirill Burchenko on 17.05.2022.
//

import SwiftUI
import PhoneNumberKit
import Combine
import Lottie

@main
struct Handshakes2App: App {
    
    //    let persistenceController = PersistenceController.shared
    
    //    @State var appData: AppData = AppData()
    @State var alert = MyAlert()
    @State var logged: Bool = false
    @StateObject var userData: UserDataView = UserDataView()
    @StateObject var contactsData: ContactsDataView = ContactsDataView()
    @StateObject private var model = ChatScreenModel()
    @StateObject var historyData: HistoryDataView = HistoryDataView()

    let phoneNumberKit = PhoneNumberKit()
    @State private var phoneField: PhoneNumberTextFieldView?
    @State var hideContacts: Bool = true
    //        @State private var phoneNumber = String()
    //        @State private var validNumber: Bool = false
    //        @State private var validationError = false
    //    @State private var errorDesc = Text("")
    //        @StateObject var contacts: ContactsData = ContactsData()
    
    @AppStorage("jwt") var jwt: String = ""
    @AppStorage("fresh") var fresh: Bool = true
    
    @State var isAnimating = false
//        var foreverAnimation: Animation {
//            Animation.linear(duration: 1.0)
//                .repeatForever(autoreverses: false)
//        }


    
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
//                        if (contactsData.data.showedHide == false){
//                            HideContacts(close: $hideContacts)
//                                .environmentObject(contactsData)
////                                .onAppear{
////                                    print(contactsData)
////                                }
//                        }
//                        else{
                            ContentView(alert: $alert)
                                .environmentObject(userData)
                                .environmentObject(contactsData)
                                .environmentObject(model)
                                .environmentObject(historyData)
    //                            .transition(.scale)
//                        }
                    }
                    else{
                        LoginHi(alert: $alert)
                            .environmentObject(userData)
                            .environmentObject(contactsData)
                            .environmentObject(model)
                            .environmentObject(historyData)
                            
                            
                    }
                }
                else{
                    appLoading
                        .transition(.scale)
                }
            }
            .onAppear{
//                if (fresh == true){
//                    contactsData.Delete()
//                    fresh = false
//                }

    
//                    self.hideContacts = !contactsData.data.showedHide
//                print("Show Hide", contactsData.data.showedHide, self.hideContacts)
//                if (hideContacts != true){
//                    contactsData.Load(upload: false)
//                }
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
//                                                                        sleep(3)
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
                                    alert = MyAlert(error: true, title: "", text: "Error connectiong to server", button: "Ok", oneButton: true)
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
//                    contactsData.Load(upload: false)
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
                if ((alert.oneButton) && (!alert.deleteChat)){
                    return Alert(
                        title: Text(alert.title),
                        message: Text(alert.text),
                        dismissButton: .default(Text(alert.button))
                    )
                }
                else if ((alert.oneButton) && (alert.deleteChat)){
                    return Alert (
                        title: Text(alert.title),
                        message: Text(alert.text),
                        dismissButton: .default(Text(alert.button),
                                                action: {
//                                                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                                                })
//                        secondaryButton: .default(Text(alert.button2))
                    )
                }
                    
                else if (!alert.oneButton){
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
                else{
                    return Alert(
                        title: Text(alert.title),
                        message: Text(alert.text),
                        dismissButton: .default(Text(alert.button))
                    )
                }
            }
        }
        
    }
    
    
    
    var appLoading: some View{
        
        VStack{
            LottieView()
            Text ("Loading...")
//            ProgressView()
            
            
//            Image("LogoAnimated")
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

struct LottieView: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        @Environment(\.colorScheme) var colorScheme: ColorScheme
        let view = UIView(frame: .zero)
        let animationView = AnimationView()

        let img = (colorScheme == .dark) ? "handshakes_logo_dark" : "handshakes_loading"
           
        print("Color scheme: ", colorScheme, " and img = ", img)
        let animation = Animation.named(img)
                animationView.animation = animation
                animationView.contentMode = .scaleAspectFit
                animationView.loopMode = LottieLoopMode.loop
                animationView.play()

                animationView.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(animationView)
                NSLayoutConstraint.activate([
                    animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
                    animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
                ])

                return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
    }
}
