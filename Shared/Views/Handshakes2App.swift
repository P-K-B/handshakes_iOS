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
import UserNotifications


@main
struct Handshakes2App: App {
    
    /// Main app data
    ///
    /// Alert object
    @State var alert = MyAlert()
    /// Data about user
    @StateObject var userData: UserDataView = UserDataView(d: false)
    /// Data about user's contacts
    @StateObject var contactsData: ContactsDataView = ContactsDataView(d: false)
    /// Chat data
    @StateObject private var model = ChatScreenModel(d: false)
    /// Search history data
    @StateObject var historyData: HistoryDataView = HistoryDataView(d: false)
    /// User's jwt token
    @AppStorage("jwt") var jwt: String = ""
    /// Flag of app open. It is used to update contacts data on app open
    @AppStorage("reopen") var reopen: Bool = false
    
    @AppStorage("ans_token") var ans_token: String = ""
    @AppStorage("ans_token_change") var ans_token_change: Bool = false
    @AppStorage("ans_token_done") var ans_token_done: Bool = false
    @AppStorage("showHowFlag") var showHowFlag: Bool = false
    
    @State var showHow: Bool = false

    
    /// View data
    ///
    /// Phone number parser object
    let phoneNumberKit = PhoneNumberKit()
    /// Phone number parserv field
    @State private var phoneField: PhoneNumberTextFieldView?
    /// Flag to open ContentView
    @AppStorage("ContentMode") var contentMode: Bool = false
    /// Flaf to open LoginHi view
    @AppStorage("LoginMode") var loginMode: Bool = false
    /// Loading animation object
    @State var lot = LottieView()
    /// Loading screen text
    @State var lotText: String = "Loading..."
    @Environment(\.scenePhase) var scenePhase
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init(){
        contentMode = false
        loginMode = false
        reopen = true
        jwt = "nil"
        ans_token_change = false
        ans_token_done = false
//        showHowFlag = false
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(named: "AccentColor")
    }
    
    var body: some Scene {
        WindowGroup {
            VStack{
                NavigationView{
                    VStack{
                        ///  App loading animation
                        appLoading
                            .transition(.scale)
                        /// Navigate to main ContentView
                        NavigationLink(destination: ContentView(alert: $alert)
                            .environmentObject(historyData)
                            .environmentObject(contactsData)
                            .environmentObject(model)
                            .environmentObject(userData)
                            .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
                                       , isActive: $contentMode){
                            EmptyView()
                        }
                        /// Navigate to LoginHi view
                        NavigationLink(destination: LoginHi(alert: $alert)
                            .environmentObject(historyData)
                            .environmentObject(contactsData)
                            .environmentObject(model)
                            .environmentObject(userData), isActive: $loginMode){
                                EmptyView()
                            }
                    }
                    .navigationBarHidden(true)
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .accentColor(ColorTheme().accent)
            }
            .preferredColorScheme(.light)
            .popover(isPresented: $showHow) {
                PDFView
            }
            .onAppear{
                alert = MyAlert(active: true, alert: Alert(title: Text("Disclaimer!"), message: Text("This is a beta build. It doesn't have notifications. Please check your chats this app from time to time. All bugs and suggestions can be submitted with TestFlight app."), dismissButton: .default(Text("Ok"), action: {if (showHowFlag == false){showHow = true}})))
                /// Set a flag to app is opened
//                reopen = true
//                contentMode = false
//                loginMode = false
                /// Login with app token
                DispatchQueue.global(qos: .userInitiated).async {
                    do{
                        let group = DispatchGroup()
                        group.enter()
                        /// Wait for user data to be loaded
                        DispatchQueue.global().async {
                            while userData.data.loaded != true {
                            }
                            group.leave()
                        }
                        group.wait()
                        
                        group.enter()
                        /// Wait for user data to be loaded
                        DispatchQueue.global().async {
                            while ans_token_done != true {
                            }
                            group.leave()
                        }
                        group.wait()
                        print("Got token")
                        userData.update(newData: UserUpdate(field: .loaded, bool: false))
                        /// Check that user has a valid phone
                        if (userData.data.number != "000"){
//                            sleep(4)
                            try self.phoneNumberKit.parse(userData.data.number)
                            do{
                                /// Try to sing in using app token
                                try userData.SignInUpCallAppToken()
                                { (reses) in
//                                                                    print(reses)
                                    /// If status code is "0" and "jwt" is not nill than Login was sucessful
                                    if ((reses.status_code == 0) && (reses.payload?.jwt != nil)){
                                        userData.update(newData: UserUpdate(field: .loggedIn, bool: true))
                                        userData.update(newData: UserUpdate(field: .jwt, string: reses.payload?.jwt?.jwt ?? ""))
                                        jwt = reses.payload?.jwt?.jwt ?? ""
                                        userData.update(newData: UserUpdate(field: .id, string: String(reses.payload?.jwt?.id ?? -1)))
                                        userData.save()
                                        
                                        do{
                                            /// Try to sing in using app token
                                            try userData.UploadToken(token: ans_token)
                                            { (reses2) in

                                            }
                                        }
                                        catch{
                                            
                                        }
                                        
                                        /// Finish loading animation and proside
                                        lot.test(){res in
                                            contentMode = true
                                            userData.update(newData: UserUpdate(field: .loaded, bool: true))
                                        }
                                    }
                                    /// Error connectiong to server
                                    else if (reses.status_code == -1){
                                        alert = MyAlert(active: true, alert: Alert(title: Text("Error"), message: Text("Error connectiong to server"), dismissButton: .default(Text("Ok"))))
                                    }
                                    /// App token is not valid and user has to Login again
                                    else{
                                        lot.test(){res in
                                            loginMode = true
                                            userData.update(newData: UserUpdate(field: .loaded, bool: true))
                                        }                                }
                                }
                            }
                        }
                        else{
                            lot.test(){res in
                                loginMode = true
                                userData.update(newData: UserUpdate(field: .loaded, bool: true))
                            }
                        }
                    }
                    /// Catch error if saved user number is not valid
                    catch {
                        //                        alert = MyAlert(active: true, alert: Alert(title: Text(""), message: Text("Error parsing your number"), dismissButton: .default(Text("Ok"))))
                        lot.test(){res in
                            loginMode = true
                            userData.update(newData: UserUpdate(field: .loaded, bool: true))
                        }
                    }
                }
            }
            /// Show alert
            .alert(isPresented: $alert.active) {
                return alert.alert ?? Alert(title: Text("Error showing alert"))
            }
            .onChange(of: scenePhase) { newPhase in
                                    if newPhase == .active {
                                        print("Active")
                                        if (reopen == false){
                                            onAppear()
                                        }
                                    } else if newPhase == .inactive {
                                        print("Inactive")
                                    } else if newPhase == .background {
                                        print("Background")
                                    }
                                }
        }
        
        
    }
    
    private func onAppear() {
        model.connect()
    }
    
    /// Loading view
    var appLoading: some View{
        VStack{
            /// Show loading animation
            lot
            /// Show loading text
            Text (lotText)
                .myFont(font: MyFonts().Body, type: .display, color: Color.black, weight: .regular)
        }
    }
    
    var PDFView:some View{
        VStack{
            HStack{
                Image(systemName: showHowFlag ? "checkmark.square" : "square")
                    .foregroundColor(showHowFlag ? Color.theme.accent : Color.secondary)
                    .onTapGesture {
                        showHowFlag.toggle()
                    }
    //                .font(Font.custom("SFProDisplay-Regular", size: 20))
                    .myFont(font: MyFonts().Body, type: .display, color: ColorTheme().accent, weight: .regular)
                    .padding(.leading, 5)
                Button(action:{
                    showHowFlag = true
                },
                       label: {
                    Text("Don't show again")
    //                    .font(Font.custom("SFProDisplay-Regular", size: 20))
//                        .underline()
                        .myFont(font: MyFonts().Body, type: .display, color: ColorTheme().accent, weight: .regular)
                        .foregroundColor(Color.theme.accent)
                }
                )
                .foregroundColor(Color.theme.accent)
            
//            .padding()
//            HStack{
                Button(action:{showHow = false}, label: {
                    HStack{
                        Spacer()
                        Image(systemName: "xmark.circle")
                            .padding()
                            .foregroundColor(ColorTheme().accent)
                    }
                })
            }
#if DEBUG
    let url=URL(string: "https://develop.freekiller.net/content/instruction.pdf")
#else
    let url=URL(string: "https://hand.freekiller.net/content/instruction.pdf")
#endif
            PDFKitView(url: url!)
        }
    }
}

struct LottieView: UIViewRepresentable {
    
    @Environment(\.colorScheme) var colorScheme
    
    let view = UIView(frame: .zero)
    let animationView = AnimationView()
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        
        let img = (self.colorScheme == .dark ? "handshakes_logo_dark" : "handshakes_loading")
        
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
    
    func test(completion: @escaping (Bool) -> ()){
        animationView.loopMode = LottieLoopMode.playOnce
        animationView.play()
        animationView.play(
            fromProgress: animationView.realtimeAnimationProgress,
            toProgress: 1,
            loopMode: .playOnce,
            
            completion: { completed in
                print("Done animation")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    completion(true)
                }
            }
        )
    }
}

struct V1: View {
    
    @State private var isShowingNextView: Bool = false
    //    @StateObject var c1: C1 = C1(d: false)
    //    @StateObject var historyData: HistoryDataView = HistoryDataView(d: false)
    //    @Environment(\.colorScheme) var colorScheme
    
    @State var currentPage = 0
    @State var numberOfPages = 6
    
    var body: some View{
        //        NavigationView{
        VStack{
            Text("V1")
            
            NavigationLink(destination: V2(back: $isShowingNextView, root: $isShowingNextView)) { Text("V2") }
                .simultaneousGesture(TapGesture().onEnded{
                    //                                    print("Hello world!")
                    //                        historyData.Add(number: "123")
                })
            
            //                Button(action: {
            //                    back = false
            //                }, label: {
            //                    Text("back")
            //                })
            
            Button(action: {
                //                    historyData.Add(number: "123")
                isShowingNextView = true
            }, label: {
                Text("next")
            })
        }
        .navigationTitle("V1")
        //        }
        //        .environmentObject(historyData)
        //        .navigationBarHidden(true)
        //        .navigationBarBackButtonHidden(true)
    }
    
}

struct V2: View {
    
    @Binding var back: Bool
    @Binding var root: Bool
    @State private var isShowingNextView: Bool = false
    //    @EnvironmentObject var historyData: HistoryDataView
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    
    var body: some View{
        //        NavigationView{
        VStack{
            Text("V2")
            
            NavigationLink(destination: V3(back: $isShowingNextView, root: $root)) { Text("V3") }
                .simultaneousGesture(TapGesture().onEnded{
                    //                                    print("Hello world!")
                    //                        historyData.Add(number: "123")
                })
            
            Button(action: {
                //                    back = false
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("back")
            })
            ButtonBack()
            Button(action: {
                //                    historyData.Add(number: "123")
                isShowingNextView = true
            }, label: {
                Text("next")
            })
        }
        //            .navigationTitle("V2")
        //        }
        //        .environmentObject(historyData)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
}

struct V3: View {
    
    @Binding var back: Bool
    @Binding var root: Bool
    @State private var isShowingNextView: Bool = false
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View{
        //        NavigationView{
        VStack{
            Text("V3")
            //                Text(historyData)
            
            //                NavigationLink(destination: V2(back: $isShowingNextView), isActive: $isShowingNextView) { EmptyView() }
            
            Button(action: {
                //                    back = false
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("back")
            })
            ButtonBack()
            Button(action: {
                root = false
            }, label: {
                Text("root")
            })
            
            //                Button(action: {
            //                    isShowingNextView = true
            //                }, label: {
            //                    Text("next")
            //                })
        }
        .navigationTitle("V3")
        //        }
        //        .navigationBarHidden(true)
        //        .navigationBarBackButtonHidden(true)
    }
    
}

struct ButtonBack: View {
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View{
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("back button")
        })
    }
    
}

class C1: ObservableObject {
    
    @Published var text: String = ""
    
    private let DataService = C2()
    
    private var cansellables = Set<AnyCancellable>()
    
    init(d: Bool){
        addDataSubscriber(d: d)
    }
    
    func addDataSubscriber(d: Bool){
        if (d == false){
            DataService.$text
                .receive(on: DispatchQueue.main)
                .sink { (completion) in
                    switch completion{
                    case .finished:
                        break
                    case .failure(let error):
                        print (error.localizedDescription)
                    }
                } receiveValue: { returnedData in
                    self.text=returnedData
                }
                .store(in: &cansellables)
        }
    }
    
    func upd(){
        DataService.upd()
    }
}

class C2{
    @Published var text: String = "V3_1"
    
    func upd(){
        self.text = "V3_2"
    }
}


struct PageControlView: UIViewRepresentable {
    @Binding var currentPage: Int
    @State var numberOfPages: Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let uiView = UIPageControl()
        uiView.isUserInteractionEnabled = false
        uiView.backgroundStyle = .prominent
        uiView.currentPageIndicatorTintColor = UIColor(named: "AccentColor")
        uiView.currentPage = currentPage
        uiView.numberOfPages = numberOfPages
        return uiView
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
        uiView.numberOfPages = numberOfPages
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    @AppStorage("ans_token") var ans_token: String = ""
    @AppStorage("ans_token_change") var ans_token_change: Bool = false
    @AppStorage("ans_token_done") var ans_token_done: Bool = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current()
          .requestAuthorization(
            options: [.alert, .sound, .badge]) { granted, _ in
            print("Permission granted: \(granted)")
            guard granted else { return }
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                print("Notification settings: \(settings)")
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async {
                  application.registerForRemoteNotifications()
                }
              }
          }
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
          }
        print("got something, aka the \(aps)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("device token")
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        if (ans_token != token){
            ans_token = token
            ans_token_change = true
        }
        ans_token_done = true
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Device Token not found.")
        ans_token_done = true
    }
}


enum NotificationAction: String {
    case dimiss
    case reminder
}

enum NotificationCategory: String {
    case general
}
