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
    //    @AppStorage("fresh") var fresh: Bool = true
    
    @State var isAnimating = false
//    @Environment(\.colorScheme) var colorScheme
    //        var foreverAnimation: Animation {
    //            Animation.linear(duration: 1.0)
    //                .repeatForever(autoreverses: false)
    //        }
    
//    Navigation
    @State var contectView: Bool = false
    @State var loginHi: Bool = false
    
    
    
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
                NavigationView{
                    if (userData.data.loaded){
//                                            if (userData.data.loggedIn){
//                                                NavigationLink(destination: ContentView(alert: $alert)
//                                                    .environmentObject(userData)
//                                                    .environmentObject(contactsData)
//                                                    .environmentObject(model)
//                                                    .environmentObject(historyData),
//                                                               isActive: $contectView) { EmptyView() }
//
//
//    //                                            ContentView(alert: $alert)
//    //                                                .environmentObject(userData)
//    //                                                .environmentObject(contactsData)
//    //                                                .environmentObject(model)
//    //                                                .environmentObject(historyData)
//                                            }
//                                            else{
//                                                NavigationLink(destination: LoginHi(alert: $alert)
//                                                    .environmentObject(userData)
//                                                    .environmentObject(contactsData)
//                                                    .environmentObject(model)
//                                                    .environmentObject(historyData),
//                                                               isActive: $loginHi) { EmptyView() }
//
//    //                                            LoginHi(alert: $alert)
//    //                                                .environmentObject(userData)
//    //                                                .environmentObject(contactsData)
//    //                                                .environmentObject(model)
//    //                                                .environmentObject(historyData)
//
//
//                                            }
                        V1()
                    }
                    else{
                        appLoading
                            .transition(.scale)
                    }
                }
            }
            .onAppear{
                //                Login
                DispatchQueue.global(qos: .userInitiated).async {
                    print("Performing time consuming task in this background thread")
                    do{
                        let group = DispatchGroup()
                        group.enter()
                        
//                        Wait for user data to be loaded
                        DispatchQueue.global().async {
                            while userData.data.loaded != true {
                            }
                            group.leave()
                        }
                        
                        group.wait()
                        userData.update(newData: UserUpdate(field: .loaded, bool: false))
                        //                                                                        sleep(3)
//                        Check that user has a valid phone
                        try self.phoneNumberKit.parse(userData.data.number)
                        do{
//                            Try to sing in using app token
                            try userData.SignInUpCallAppToken()
                            { (reses) in
                                print(reses)
                                if ((reses.status_code == 0) && (reses.payload?.jwt != nil)){
                                    userData.update(newData: UserUpdate(field: .loggedIn, bool: true))
                                    userData.update(newData: UserUpdate(field: .jwt, string: reses.payload?.jwt?.jwt ?? ""))
                                    jwt = reses.payload?.jwt?.jwt ?? ""
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
                        }
                    }
                    catch {
                        userData.update(newData: UserUpdate(field: .loaded, bool: true))
                    }
                    DispatchQueue.main.async {
                        // Task consuming task has completed
                        // Update UI from this block of code
                        print("SignInUpCallAppToken. Time consuming task has completed. From here we are allowed to update user interface.")
                    }
                }
                
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
                                                })
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
        }
    }
}

struct LottieView: UIViewRepresentable {
    
    @Environment(\.colorScheme) var colorScheme
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        
        let view = UIView(frame: .zero)
        let animationView = AnimationView()
        
        let img = (self.colorScheme == .dark ? "handshakes_logo_dark" : "handshakes_loading")
        
        print("Color scheme: ", self.colorScheme, " and img = ", img)
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

struct V1: View {
    
//    @State private var isShowingNextView: Bool = false
    @StateObject var myNav: MyNavigation = MyNavigation()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View{
        NavigationView{
            VStack{
                Text("V1")
                Text(myNav.contentView == true ? "contentView" : "no contentView")
                
                
                NavigationLink(destination: V2().environmentObject(myNav), isActive: $myNav.contentView) { EmptyView() }
                
                //            Button(action: {
                //
                //            }, label: {
                //                Text("back")
                //            })
                
                Button(action: {
//                    isShowingNextView = true
                    myNav.SetTMPRoot(view: .root)
                    myNav.Forward(view: .contentView)
                }, label: {
                    Text("next")
                })
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
}

struct V2: View {
    
//    @Binding var back: Bool
//    @Binding var root: Bool
//    @State private var isShowingNextView: Bool = false
    @EnvironmentObject var myNav: MyNavigation
    
    var body: some View{
        NavigationView{
            VStack{
                Text("V2")
                
                NavigationLink(destination: V3().environmentObject(myNav), isActive: $myNav.loginHi) { EmptyView() }
                
                Button(action: {
//                    back = false
                    myNav.Back()
                }, label: {
                    Text("back")
                })
                
                Button(action: {
//                    isShowingNextView = true
                    myNav.Forward(view: .loginHi)
                }, label: {
                    Text("next")
                })
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
}

struct V3: View {
    
//    @Binding var back: Bool
//    @Binding var root: Bool
//    @State private var isShowingNextView: Bool = false
    @EnvironmentObject var myNav: MyNavigation
    
    var body: some View{
        NavigationView{
            VStack{
                Text("V3")
                
                //                NavigationLink(destination: V2(back: $isShowingNextView), isActive: $isShowingNextView) { EmptyView() }
                
                Button(action: {
//                    back = false
                    myNav.Back()
                }, label: {
                    Text("back")
                })
                
                Button(action: {
//                    root = false
                    myNav.ToTMPRoot()
                }, label: {
                    Text("root")
                })
                
                //                Button(action: {
                //                    isShowingNextView = true
                //                }, label: {
                //                    Text("next")
                //                })
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
}


class MyNavigation: ObservableObject{
    var root: Bool = false
    var contentView: Bool = false
    var loginHi: Bool = false
    
    var stack: [MyView] = []
    var view: MyView = .root
    var tmpRoot: MyView = .root
    
    func ToRoot(){
        Close()
        self.view = .root
        self.stack = [.root]
        Open()
    }
    
    func ToTMPRoot(){
        Close()
        while self.view != self.tmpRoot{
            self.view = self.stack.last ?? .root
            self.stack = self.stack.dropLast()
        }
        Open()
    }
    
    func SetTMPRoot(view: MyView){
        self.tmpRoot = view
    }
    
    func Forward(view: MyView){
        Close()
        self.stack.append(view)
        self.view = view
        Open()
    }
    
    func Back(){
        Close()
        self.view = self.stack.last ?? .root
        self.stack = self.stack.dropLast()
        Open()
    }
    
    func AllFalse(){
    }
    
    func Open(){
        switch self.view{
        case .root:
            self.root = true
        case .contentView:
            self.contentView = true
        case .loginHi:
            self.loginHi = true
        }
    }
    
    func Close(){
        switch self.stack.last{
        case .root:
            self.root = false
        case .contentView:
            self.contentView = false
        case .loginHi:
            self.loginHi = false
        case .none:
            return
        }
    }
}

enum MyView: String{
    case root
    case contentView
    case loginHi
}
