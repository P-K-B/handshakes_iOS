//
//  ContentView.swift
//  Shared
//
//  Created by Kirill Burchenko on 17.05.2022.
//

import SwiftUI
import SnapToScroll

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
    
    @EnvironmentObject var userData: UserDataView
    @EnvironmentObject var contactsData: ContactsDataView
    //    @StateObject var contactsData: ContactsDataView = ContactsDataView()
    @Binding var alert: MyAlert
    
    @AppStorage("big") var big: Bool = IsBig()
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    @AppStorage("profile") var profile: Bool = false
    @AppStorage("fresh") var fresh: Bool = true
    @AppStorage("hideContacts") var hideContacts: Bool = false
    @State var showHide: Bool = false
    @State var showHideAlert: Bool = false
    @EnvironmentObject private var model: ChatScreenModel
    @EnvironmentObject var historyData: HistoryDataView

    @State var visible: Int = 0
    @State var test: Bool = true
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        
        //        VStack{
        //            ScrollView{
        //                ZStack{
        //                    GeometryReader{reader -> AnyView in
        //                        let lyAxis=reader.frame(in: .global).minY
        //                        let lxAxis=reader.frame(in: .global).minX
        //
        //
        //                        print(lyAxis)
        //                        print(lxAxis)
        //
        //                        //                                    Path { path in
        //                        //
        //                        //
        //                        //                                        path.move(
        //                        //                                            to: CGPoint(
        //                        //                                                x: 1,
        //                        //                                                y: 1
        //                        //                                            )
        //                        //                                        )
        //                        //
        //                        //                                        path.addLine(
        //                        //                                            to: CGPoint(
        //                        //                                                x: 2,
        //                        //                                                y: 2
        //                        //                                            )
        //                        //                                        )
        //                        //                                        path.addLine(
        //                        //                                            to: CGPoint(
        //                        //                                                x: 3,
        //                        //                                                y: 3
        //                        //                                            )
        //                        //                                        )
        //                        //
        //                        //                                        path.closeSubpath()
        //                        //                                    }
        //
        //                        return AnyView(
        //                            ZStack{
        //                                Arrow(index: 1, total: 5)
        //                                Arrow(index: 2, total: 5)
        //                                Arrow(index: 3, total: 5)
        //                                Arrow(index: 4, total: 5)
        //                                Arrow(index: 5, total: 5)
        //                                //                                       Color.red.frame(width: 50)
        //
        //                            }
        ////                                .background(.blue)
        //                        )
        //                    }
        //                    Scl(letter: "I", frame: 50, font: 20, color: .green, text: "I")
        ////                        .background(.orange)
        //                    //                                .frame(height: 0)
        //
        //                }
        //                .frame(width: 70)
        ////                .background(.red)
        //            }
        //            .padding(.top, 200)
        //        }
        
        
        ZStack{
            ZStack {
                VStack{
                    
                switch selectedTab {
                case .contacts:
                    ContactsView(alert: $alert, visible: $visible)
                        .environmentObject(contactsData)
                        .safeAreaInset(edge: .top, content: {
                            Color.clear.frame(height: big ? 45: 75)
                        })
                        .safeAreaInset(edge: .bottom) {
                            Color.clear.frame(height: big ? 55: 70)
                        }
                case .singleContact:
                    SingleContactView()
                        .environmentObject(contactsData)
                        .environmentObject(historyData)
                    //                                .safeAreaInset(edge: .top, content: {
                    //                                    Color.clear.frame(height: big ? 45: 75)
                    //                                })
//                        .safeAreaInset(edge: .bottom) {
//                            Color.clear.frame(height: big ? 55: 70)
//                        }
                case .search:
                    SearchList(alert: $alert)
                        .environmentObject(historyData)
                        .safeAreaInset(edge: .top, content: {
                            Color.clear.frame(height: big ? 45: 75)
                        })
                    //                                .safeAreaInset(edge: .bottom) {
                    //                                    Color.clear.frame(height: big ? 55: 70)
                    //                                }
                case .singleSearch:
                    SingleSearchView()
                        .environmentObject(historyData)
                        .environmentObject(contactsData)
                        .environmentObject(model)
                        .safeAreaInset(edge: .top, content: {
                            Color.clear.frame(height: big ? 45: 75)
                        })
//                        .safeAreaInset(edge: .bottom) {
//                            Color.clear.frame(height: big ? 55: 70)
//                        }
                    //                    EmptyView()
                    //                    SingleContactView()
                    //                        .environmentObject(contactsData)
                case .chats:
                    //                            VStack{
                    
//                    AllChats(big: big)
//                        .environmentObject(model)
//                        .environmentObject(contactsData)
//                        .safeAreaInset(edge: .top, content: {
//                            Color.clear.frame(height: big ? 45: 75)
//                        })
//                        .safeAreaInset(edge: .bottom) {
//                            Color.clear.frame(height: big ? 55: 70)
//                        }
                    InfoPageView()
                                    .environmentObject(userData)
                                    .environmentObject(contactsData)
                                    .environmentObject(historyData)
                                    .environmentObject(model)
                    
                    //                            }
                case .singleChat:
                    
                    ChatScreen(alert: $alert)
                        .environmentObject(model)
                        .environmentObject(contactsData)
//                        .safeAreaInset(edge: .top, content: {
//                            Color.clear.frame(height: big ? 45: 75)
//                        })
                case .profile:
                    Settings(showHide: $showHide, showHideAlert: $showHideAlert)
                    .environmentObject(userData)
                    .environmentObject(contactsData)
                    .environmentObject(historyData)
                    .environmentObject(model)
                }
                }
                
            }
            //            ScrollView{
            //                Example3ContentView()
            //                Example3ContentView()
            //                Example3ContentView()
            //                Example3ContentView()
            //                Example3ContentView()
            //                Example3ContentView()
            //                Example3ContentView()
            //                Example3ContentView()
            //            }
            
            
//            Button(action:{withAnimation{self.test.toggle()}}){
//                Text("Hide")
//            }
            if ((selectedTab == .contacts) || (selectedTab == .search) || (selectedTab == .chats)){
                TabBar()
                    .zIndex(1)
 
                    .transition(.move(edge: .bottom))
            }
        }
        .onAppear{
            contactsData.SetJwt( jwt: userData.data.jwt)
            historyData.SetJwt( jwt: userData.data.jwt)
            model.SetJwt( jwt: userData.data.jwt)
            //                if (fresh == true){
            //                    contactsData.Delete()
            //                    fresh = false
            //                }
            if (hideContacts == false){
            contactsData.Load(upload: false)
            }
            else{
                contactsData.Load(upload: true)
            }
            //                    contactsData.Upload()
            //
            //                    }
            
            onAppear()
            if (hideContacts == false){
                showHide = true
                showHideAlert = true
                selectedTab = .profile
            }
            
            
            //            print(String(data: try! JSONEncoder().encode(userData), encoding: String.Encoding.utf8))
            //            print(contactsData.data)
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
//        .popover(isPresented: $profile) {
//            InfoPageView()
//                .environmentObject(userData)
//                .environmentObject(contactsData)
//                .environmentObject(historyData)
//                .environmentObject(model)
//        }
//        .popover(isPresented: $showHide) {
//            HideContacts(close: $showHide, showHideAlert: $showHideAlert)
//                .environmentObject(contactsData)
//        }
    }
    
    private func onAppear() {
        model.connect()
    }
    
    private func onDisappear() {
        model.disconnect()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(alert: .constant(MyAlert()))
    }
}


//UserData(id: "196", jwt: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMTk2In0.5va4GSF251o7ZanaZ6kI22N19gHsY_h9PWarCEMvcY4", number: "+1 888-555-1212", loggedIn: true, uuid: "36F3D851-D39D-4E5A-A1E9-12DF55DACB37", isNewUser: false, loaded: true)


struct Example3ContentView: View {
    
    var body: some View {
        
        VStack {
            
            Text("Getting Started")
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .leading], 32)
            
            HStackSnap(alignment: .center(32)) {
                
                ForEach(GettingStartedModel.exampleModels) { viewModel in
                    
                    GettingStartedView(
                        selectedIndex: $selectedGettingStartedIndex,
                        viewModel: viewModel)
                    .snapAlignmentHelper(id: viewModel.id)
                    .background(.pink)
                }
            } eventHandler: { event in
                
                handleSnapToScrollEvent(event: event)
            }
            .frame(height: 200)
            .padding(.top, 4)
            .background(.blue)
        }
        .padding([.top, .bottom], 64)
        //        .background(LinearGradient(
        //            colors: [Color("Cream"), Color("LightPink")],
        //            startPoint: .top,
        //            endPoint: .bottom))
    }
    
    func handleSnapToScrollEvent(event: SnapToScrollEvent) {
        switch event {
        case let .didLayout(layoutInfo: layoutInfo):
            
            print("\(layoutInfo.keys.count) items layed out")
            
        case let .swipe(index: index):
            
            print("swiped to index: \(index)")
            selectedGettingStartedIndex = index
        }
    }
    
    // MARK: Private
    
    @State private var selectedGettingStartedIndex: Int = 0
}

struct GettingStartedModel: Identifiable {
    
    static let exampleModels: [GettingStartedModel] = [
        .init(
            id: 0,
            systemImage: "camera.aperture",
            title: "",
            body: ""),
        .init(
            id: 1,
            systemImage: "camera.filters",
            title: "Filter it Up",
            body: "Add filters - from detailed colorization to film effects."),
        .init(
            id: 2,
            systemImage: "paperplane",
            title: "Send It",
            body: "Share your photos with your contacts. Or the entire world."),
        .init(
            id: 3,
            systemImage: "sparkles",
            title: "Be Awesome",
            body: "You're clearly already doing this. Just wanted to remind you. 😉 You're clearly already doing this. Just wanted to remind you. 😉 You're clearly already doing this. Just wanted to remind you. 😉 You're clearly already doing this. Just wanted to remind you. 😉 You're clearly already doing this. Just wanted to remind you. 😉"),
    ]
    
    let id: Int
    let systemImage: String
    let title: String
    let body: String
}

struct GettingStartedView: View {
    
    @Binding var selectedIndex: Int
    
    let viewModel: GettingStartedModel
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Image(systemName: viewModel.systemImage)
                .foregroundColor(isSelected ? .pink : .gray)
                .font(.system(size: 32))
                .padding(.bottom, 2)
            
            Text(viewModel.title)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 1)
                .opacity(0.8)
            
            Text(viewModel.body)
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .opacity(0.8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .opacity(isSelected ? 1 : 0.8)
    }
    
    var isSelected: Bool {
        
        return selectedIndex == viewModel.id
    }
}

struct Arrow: View {
    @State var index: Int
    @State var total: Int
    @State var width: Double = 70
    @State var height: Double = 100
    var body: some View{
        if (total % 2 == 1){
            //            Odd
            if (index > (total+1)/2){
                //                Down
                Path { path in
                    let lwidth = self.width
                    let lheight = self.height * Double(index-((total+1)/2))
                    //                                    let
                    // 1
                    path.move(
                        to: CGPoint(
                            x: 0.5 * lwidth,
                            y: 0.5 * lheight
                        )
                    )
                    // 2
                    path.addLine(
                        to: CGPoint(
                            x: 0.5 * lwidth,
                            y: 0.9 * lheight)
                    )
                    path.addQuadCurve(to: CGPoint(
                        x: 0.6 * lwidth,
                        y: 1 * lheight), control: CGPoint(
                            x: 0.5 * lwidth,
                            y: 1 * lheight))
                    path.addLine(
                        to: CGPoint(
                            x: 1 * lwidth,
                            y: 1 * lheight)
                    )
                    
                    path.addLines([CGPoint(
                        x: 0.9 * lwidth,
                        y: 0.9 * lheight),
                                   CGPoint(
                                    x: 1 * lwidth,
                                    y: 1 * lheight),
                                   CGPoint(
                                    x: 0.9 * lwidth,
                                    y: 1.1 * lheight)])
                    
                }
                .stroke(Color.pink, lineWidth: 1)
                .onAppear(){print("here111")}
            }
            else if (index == (total+1)/2){
                //                Middle
                Path { path in
                    let lwidth = self.width
                    let lheight = self.height
                    //                                    let
                    // 1
                    path.move(
                        to: CGPoint(
                            x: 0.5 * lwidth,
                            y: 0.5 * lheight
                        )
                    )
                    // 2
                    path.addLine(
                        to: CGPoint(
                            x: 1 * lwidth,
                            y: 0.5 * lheight)
                    )
                    //                    arrow
                    path.addLines([CGPoint(
                        x: 0.9 * lwidth,
                        y: 0.4 * lheight),
                                   CGPoint(
                                    x: 1 * lwidth,
                                    y: 0.5 * lheight),
                                   CGPoint(
                                    x: 0.9 * lwidth,
                                    y: 0.6 * lheight)])
                    
                }
                .stroke(Color.pink, lineWidth: 1)
                
            }
            else if (index < (total+1)/2){
                //                Up
                Path { path in
                    let lwidth = self.width
                    let lheight = self.height * Double(((total+1)/2)-index)
                    //                                    let
                    // 1
                    path.move(
                        to: CGPoint(
                            x: 0.5 * lwidth,
                            y: 0.5 * lheight
                        )
                    )
                    // 2
                    path.addLine(
                        to: CGPoint(
                            x: 0.5 * lwidth,
                            y: 0.1 * lheight)
                    )
                    path.addQuadCurve(to: CGPoint(
                        x: 0.6 * lwidth,
                        y: 0 * lheight), control: CGPoint(
                            x: 0.5 * lwidth,
                            y: 0 * lheight))
                    path.addLine(
                        to: CGPoint(
                            x: 1 * lwidth,
                            y: 0 * lheight)
                    )
                    
                    path.addLines([CGPoint(
                        x: 0.9 * lwidth,
                        y: 0.1 * lheight),
                                   CGPoint(
                                    x: 1 * lwidth,
                                    y: 0 * lheight),
                                   CGPoint(
                                    x: 0.9 * lwidth,
                                    y: -0.1 * lheight)])
                    
                }
                .stroke(Color.pink, lineWidth: 1)
            }
        }
        else{
            //            Even
            if (index > total/2){
                //                Down
                VStack{}
                    .background(.pink)
                    .onAppear(){print("here")}
            }
            else{
                //                Up
                VStack{}
                    .onAppear(){print("here")}
            }
        }
    }
}


//Path { path in
//    let width: CGFloat = 70
//    let height: CGFloat = 100
//    //                                    let
//    // 1
//    path.move(
//        to: CGPoint(
//            x: 0.5 * width,
//            y: 0.5 * height
//        )
//    )
//    // 2
//    path.addLine(
//        to: CGPoint(
//            x: 0.5 * width,
//            y: 0.9 * height)
//    )
//    path.addQuadCurve(to: CGPoint(
//        x: 0.6 * width,
//        y: 1 * height), control: CGPoint(
//            x: 0.5 * width,
//            y: 1 * height))
//    path.addLine(
//        to: CGPoint(
//            x: 1 * width,
//            y: 1 * height)
//    )
//
//    path.addLines([CGPoint(
//        x: 0.9 * width,
//        y: 0.9 * height),
//                   CGPoint(
//                    x: 1 * width,
//                    y: 1 * height),
//                   CGPoint(
//                    x: 0.9 * width,
//                    y: 1.1 * height)])
//
//}
//.stroke(Color.pink, lineWidth: 1)
