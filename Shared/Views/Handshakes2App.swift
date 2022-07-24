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
    @StateObject var contactsData: ContactsDataView = ContactsDataView(d: false)
    @StateObject private var model = ChatScreenModel()
    @StateObject var historyData: HistoryDataView = HistoryDataView(d: false)
    
    //    @StateObject var UIState: UIStateModel = UIStateModel()
    
    let phoneNumberKit = PhoneNumberKit()
    @State private var phoneField: PhoneNumberTextFieldView?
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
    
    
    
    var body: some Scene {
        WindowGroup {
            VStack{
                NavigationView{
                    if (userData.data.loaded){
                                                if (userData.data.loggedIn){
                                                    ContentView(alert: $alert)
                                                        .environmentObject(historyData)
                                                        .environmentObject(contactsData)
                                                        .environmentObject(model)
                                                        .environmentObject(userData)
                                                }
                                                else{
                        
                                                    LoginHi(alert: $alert)
                                                        .environmentObject(historyData)
                                                        .environmentObject(contactsData)
                                                        .environmentObject(model)
                                                        .environmentObject(userData)
                        
                        
                                                }
                        
//                        V1()
                        //                            .environmentObject(UIState)
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
    
    @State private var isShowingNextView: Bool = false
    //    @StateObject var c1: C1 = C1(d: false)
    @StateObject var historyData: HistoryDataView = HistoryDataView(d: false)
    @Environment(\.colorScheme) var colorScheme
    
    @State var currentPage = 0
    @State var numberOfPages = 6
    
    var body: some View{
        VStack{
            VStack {
                //                                    Spacer()
                PageControlView(currentPage: $currentPage, numberOfPages: numberOfPages)
            }
            TabView(selection: $currentPage) {
                ScrollView{
                    Text("Item 1")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .frame(width: 200, height: 1000)
                        .background(.red)
                }.tag(0)
                ScrollView{
                    Text("Item 2")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .frame(width: 200, height: 200)
                        .background(.blue)
                }.tag(1)
                Text("First").tag(2)
                Text("Second").tag(3)
                Text("Third").tag(4)
                Text("Fourth").tag(5)
            }
            //        .frame(width: 200, height: 200)
            //                .tabViewStyle(.page)
            //                .indexViewStyle(.page(backgroundDisplayMode: .always))
            .tabViewStyle(.page(indexDisplayMode: .never))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
        
        //        GeometryReader { geometry in
        //
        //            ScrollViewReader { proxy in
        //
        //                ScrollView(.horizontal) {
        //                    VStack{
        //
        //                        HStack(spacing: 20) {
        //                            GeometryElement(x: $xScroll, y: $yScroll)
        //                            //                ForEach(0..<10) {
        //                            //                    VStack{
        //                            //                    ScrollView{
        //                            Text("Item 1")
        //                                .foregroundColor(.white)
        //                                .font(.largeTitle)
        //                                .frame(width: cardWidth, height: 300)
        //                                .background(.red)
        ////                                .offset(x: -xScroll)
        //                            //                    }
        //                            //                ScrollView{
        //                                            Text("Item 2")
        //                                                .foregroundColor(.white)
        //                                                .font(.largeTitle)
        //                                                .frame(width: cardWidth, height: 200)
        //                                                .background(.blue)
        ////                                                .offset(x: -xScroll*2)
        //                            //                }
        //                            //                ScrollView{
        //                            //                Text("Item 3")
        //                            //                    .foregroundColor(.white)
        //                            //                    .font(.largeTitle)
        //                            //                    .frame(width: 200, height: 800)
        //                            //                    .background(.red)
        //                            //                    }
        //                            //                    }
        //                        }
        //                    }
        //                    .background(.green)
        //                    .frame(width: geometry.size.width)      // Make the scroll view full-width
        //                    .frame(minHeight: geometry.size.height)
        ////                    .offset(x:)
        //                }
        //                .background(.pink)
        //            }
        //
        //        }
        //            .modifier(ScrollingHStackModifier(items: 3, itemWidth: 200, itemSpacing: 30))
        //        }
        
        
        
        //        NavigationView{
        //            VStack{
        //                Text("V1")
        //                Text(colorScheme == .dark ? "In dark mode" : "In light mode")
        //
        //
        //                NavigationLink(destination: V2(back: $isShowingNextView, root: $isShowingNextView).environmentObject(historyData), isActive: $isShowingNextView) { EmptyView() }
        //
        //                //            Button(action: {
        //                //
        //                //            }, label: {
        //                //                Text("back")
        //                //            })
        //
        //                Button(action: {
        //                    isShowingNextView = true
        //                }, label: {
        //                    Text("next")
        //                })
        //            }
        //        }
        //
        //        .navigationBarHidden(true)
        //        .navigationBarBackButtonHidden(true)
    }
    
}

struct V2: View {
    
    @Binding var back: Bool
    @Binding var root: Bool
    @State private var isShowingNextView: Bool = false
    @EnvironmentObject var historyData: HistoryDataView
    
    var body: some View{
        NavigationView{
            VStack{
                Text("V2")
                
                NavigationLink(destination: V3(back: $isShowingNextView, root: $root)) { Text("V2") }
                    .simultaneousGesture(TapGesture().onEnded{
                        //                                    print("Hello world!")
                        historyData.Add(number: "123")
                    })
                
                Button(action: {
                    back = false
                }, label: {
                    Text("back")
                })
                
                Button(action: {
                    historyData.Add(number: "123")
                    isShowingNextView = true
                }, label: {
                    Text("next")
                })
            }
        }
        .environmentObject(historyData)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
}

struct V3: View {
    
    @Binding var back: Bool
    @Binding var root: Bool
    @State private var isShowingNextView: Bool = false
    @EnvironmentObject var historyData: HistoryDataView
    
    var body: some View{
        NavigationView{
            VStack{
                Text("V3")
                //                Text(historyData)
                
                //                NavigationLink(destination: V2(back: $isShowingNextView), isActive: $isShowingNextView) { EmptyView() }
                
                Button(action: {
                    back = false
                }, label: {
                    Text("back")
                })
                
                Button(action: {
                    root = false
                }, label: {
                    Text("root")
                })
                Button(action: {
                    historyData.Add(number: "123")
                }, label: {
                    Text("update")
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
        uiView.backgroundStyle = .prominent
        uiView.currentPage = currentPage
        uiView.numberOfPages = numberOfPages
        return uiView
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
        uiView.numberOfPages = numberOfPages
    }
}
