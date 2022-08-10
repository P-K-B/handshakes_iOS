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
    
    @State var alert = MyAlert()
    @StateObject var userData: UserDataView = UserDataView(d: false)
    @StateObject var contactsData: ContactsDataView = ContactsDataView(d: false)
    @StateObject private var model = ChatScreenModel(d: false)
    @StateObject var historyData: HistoryDataView = HistoryDataView(d: false)
        
    let phoneNumberKit = PhoneNumberKit()
    @State private var phoneField: PhoneNumberTextFieldView?
    
    @AppStorage("jwt") var jwt: String = ""
    @AppStorage("reopen") var reopen: Bool = false

    @State var content: Bool = false
    @State var login: Bool = false
    
    @State var lot = LottieView()
    @State var lotText: String = "Loading..."
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            VStack{
                NavigationView{
                    VStack{
//                        if (userData.data.loaded){
//                                                    if (userData.data.loggedIn){
//                                                        ContentView(alert: $alert)
//                                                                                    .environmentObject(historyData)
//                                                                                    .environmentObject(contactsData)
//                                                                                    .environmentObject(model)
//                                                                                    .environmentObject(userData)
//                                                    }
//                                                        else{
//                                                            LoginHi(alert: $alert)
//                                                                                        .environmentObject(historyData)
//                                                                                        .environmentObject(contactsData)
//                                                                                        .environmentObject(model)
//                                                                                        .environmentObject(userData)
//                                                        }
//                                                    }
//                        else{
                                                        
                        appLoading
                            .transition(.scale)
//                        }
                        NavigationLink(destination: ContentView(alert: $alert)
                            .environmentObject(historyData)
                            .environmentObject(contactsData)
                            .environmentObject(model)
                            .environmentObject(userData)
                            .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
                                       , isActive: $content){
                                EmptyView()
                            }
                        NavigationLink(destination: LoginHi(alert: $alert)
                            .environmentObject(historyData)
                            .environmentObject(contactsData)
                            .environmentObject(model)
                            .environmentObject(userData), isActive: $login){
                                EmptyView()
                            }
                    }
                    .navigationBarHidden(true)
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
//            .onChange(of: scenePhase) { newPhase in
//                if newPhase == .active {
//                    print("Active")
//                    onAppear()
//                } else if newPhase == .inactive {
//                    print("Inactive")
//                } else if newPhase == .background {
//                    print("Background")
//                }
//            }
            .onAppear{
                reopen = true
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
                        
//                        sleep(3)
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
                                    lot.test(){res in
                                        content = true
                                        userData.update(newData: UserUpdate(field: .loaded, bool: true))
                                    }
                                }
                                else if (reses.status_code == -1){
                                    alert = MyAlert(error: true, title: "", text: "Error connectiong to server", button: "Ok", oneButton: true)
                                }
                                else{
                                    //                                    login = true
                                    lot.test(){res in
                                        login = true
                                        userData.update(newData: UserUpdate(field: .loaded, bool: true))
                                    }                                }
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
    
    private func onAppear() {
        model.connect()
    }
    
    var appLoading: some View{
        
        VStack{
            lot
            Text (lotText)
        }
    }
}

struct LottieView: UIViewRepresentable {
    
    @Environment(\.colorScheme) var colorScheme
    
    let view = UIView(frame: .zero)
    let animationView = AnimationView()
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        
        let img = (self.colorScheme == .dark ? "handshakes_logo_dark" : "handshakes_loading")
        
        //        print("Color scheme: ", self.colorScheme, " and img = ", img)
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
        animationView.play(
            fromProgress: animationView.currentProgress,
            toProgress: 1,
            loopMode: .playOnce,
            completion: { [self] completed in
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
