//
//  ContentView.swift
//  Shared
//
//  Created by Kirill Burchenko on 17.05.2022.
//

import SwiftUI
import SnapToScroll

struct ContentView: View {
    
    @EnvironmentObject var userData: UserDataView
    @StateObject var contactsData: ContactsDataView = ContactsDataView()
    @StateObject var historyData: HistoryDataView = HistoryDataView()
    @Binding var alert: MyAlert
    
    @AppStorage("big") var big: Bool = IsBig()
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    @StateObject private var model = ChatScreenModel()
    
    var body: some View {
        ZStack{
            ZStack {
                switch selectedTab {
                case .contacts:
                    ContactsView(alert: $alert)
                        .environmentObject(contactsData)
                case .singleContact:
                    SingleContactView()
                        .environmentObject(contactsData)
                        .environmentObject(historyData)
                case .search:
                    SearchList(alert: $alert)
                        .environmentObject(historyData)
                case .singleSearch:
                    SingleSearchView()
                        .environmentObject(historyData)
                        .environmentObject(contactsData)
                        .environmentObject(model)
//                    EmptyView()
//                    SingleContactView()
//                        .environmentObject(contactsData)
                case .chats:
//                    VStack{
//                    InfoPageView()
//                        .environmentObject(userData)
//                        .environmentObject(contactsData)
//                        .environmentObject(historyData)
//                        .environmentObject(model)
                    AllChats(big: big)
                                                .environmentObject(model)
                                                .environmentObject(contactsData)

//                    }
                case .singleChat:
//                    InfoPageView()
//                        .environmentObject(userData)
//                        .environmentObject(contactsData)
//                        .environmentObject(historyData)
                    ChatScreen()
                        .environmentObject(model)
                        .environmentObject(contactsData)
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
            
            .safeAreaInset(edge: .top, content: {
                Color.clear.frame(height: big ? 45: 75)
            })
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: big ? 55: 70)
            }
            
            TabBar()
        }
        .onAppear{
            contactsData.SetJwt( jwt: userData.data.jwt)
            historyData.SetJwt( jwt: userData.data.jwt)
            model.SetJwt( jwt: userData.data.jwt)
            onAppear()
            
//            print(String(data: try! JSONEncoder().encode(userData), encoding: String.Encoding.utf8))
//            print(contactsData.data)
        }
//        .onDisappear(perform: onDisappear)
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
