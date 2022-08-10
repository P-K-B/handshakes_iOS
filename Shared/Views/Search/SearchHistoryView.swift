//
//  SearchHistory.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 29.05.2022.
//

import SwiftUI
import PhoneNumberKit

struct SearchList: View, KeyboardReadable {
    
    //    App data
    @Binding var alert: MyAlert
    @EnvironmentObject var historyData: HistoryDataView
    @EnvironmentObject var contactsData: ContactsDataView
    @EnvironmentObject var model: ChatScreenModel
    @EnvironmentObject var userData: UserDataView
    
    //    view data
    @State var hasScrolled: Bool = false
    @AppStorage("big") var big: Bool = IsBig()
    @State var selectedHistory: UUID?
    //    @State var search: Bool = false
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    
    
    let phoneNumberKit = PhoneNumberKit()
    @State private var phoneField: PhoneNumberTextFieldView?
    @State private var phoneNumber = String()
    @State private var validNumber: Bool = false
    @State var welcomeText: String = "Enter phone number to search:"
    @State private var isKeyboardVisible = false
    @State var selector: Bool = false
    @State var number: String = ""
    
    @AppStorage("hideContacts") var hideContacts: Bool = false
    
    @State var rowSelector: UUID?
    
    //    @AppStorage("hideContacts") var hideContacts: Bool = false
    
    
    
    var body: some View {
            VStack{
                hardV
            }
            .onTapGesture {
                self.endEditing()
            }
            .safeAreaInset(edge: .top, content: {
                Color.clear.frame(height: big ? 45: 75)
            })
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: isKeyboardVisible ? 0 : (big ? 55: 70))
            }
            .onAppear{
            }
//            .overlay{
//                TabBar()
//                    .zIndex(1)
//                    .transition(.move(edge: .bottom))
//            }
            .navigationBarHidden(true)
    }
    
    
    
    var numberField: some View{
        self.phoneField
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
            .keyboardType(.phonePad)
            .padding(.horizontal, 15)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding()
    }
    
    var inputRow: some View{
        VStack{
            Text(welcomeText)
                .font(Font.custom("SFProDisplay-Regular", size: 20))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            numberField
                .onReceive(keyboardPublisher) { newIsKeyboardVisible in
                    print("Is keyboard visible? ", newIsKeyboardVisible)
                    isKeyboardVisible = newIsKeyboardVisible
                }
            
            
            NavigationLink(destination: SingleSearchView2(alert: $alert)
                .environmentObject(historyData)
                .environmentObject(contactsData)
                .environmentObject(model)
                .environmentObject(userData)
                           , isActive: $selector
            )
            {
                EmptyView()
            }
            .navigationViewStyle(.stack)
            .foregroundColor(Color.black)
            .simultaneousGesture(TapGesture().onEnded{
            })
            
            
            Button{Task {
                do{
                    let validatedPhoneNumber = try self.phoneNumberKit.parse(self.phoneNumber)
                    number = self.phoneNumberKit.format(validatedPhoneNumber, toType: .international)
                    historyData.Add(number: number)
                    selector = true
                }
                catch {
                    alert = MyAlert(error: true, title: "", text: "Please enter a valid phone number", button: "Ok", oneButton: true)
                }
            }
            }
        label: {
            Text("Search")
                .frame(minWidth: 70)
                .padding(.vertical, 10)
                .padding(.horizontal, 30)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(100)
        }
        .padding()
        }
        .onAppear{
            self.phoneField = PhoneNumberTextFieldView(phoneNumber: $phoneNumber, isEdeted: $validNumber, maxDigits: 16)
        }
    }
    
    var hardV: some View{
        ZStack{
            ZStack{
                Color.theme.background
                    .ignoresSafeArea()
                VStack(spacing: 0){
                    inputRow
                    Divider()
                    GeometryReader { geometry in
                        
                        ScrollView() {
                            if (historyData.datta.count > 0){
                                if (historyData.updated){
                                    HistoryRows
                                        .padding(.top, 10)
                                }
                                else{
                                    Text("Loading")
                                }
                            }
                            
                            
                            else{
                                VStack{
                                    Text("Search history is empty")
                                        .font(Font.system(size: 16, weight: .light, design: .default))
                                }
                                .frame(width: geometry.size.width)      // Make the scroll view full-width
                                .frame(minHeight: geometry.size.height)
                                
                            }
                        }
                    }
                }
                .overlay(
                    NavigationBar(title: "Search", search: .constant(false), showSearch: false, showProfile: true, hasBack: false)
                        .environmentObject(historyData)
                        .environmentObject(contactsData)
                        .environmentObject(model)
                        .environmentObject(userData)
                    
                )
            }
        }
    }
    
    var HistoryRows: some View{
        LazyVStack(){
            
            ForEach(historyData.datta) { search in
                ZStack{
                    HStack {
                        NavigationLink(destination: SingleSearchView2(alert: $alert)
                            .environmentObject(historyData)
                            .environmentObject(contactsData)
                            .environmentObject(model)
                            .environmentObject(userData),
                                       tag: search.id, selection: $rowSelector
                        ) {                                      HStack{
                           EmptyView()
                        }
                        }
                        .foregroundColor(Color.black)
//                        .simultaneousGesture(TapGesture().onEnded{
//                            historyData.selectedHistory = search.id
//                        })
                        
                        Button(action:{
                            historyData.selectedHistory = search.id
                            rowSelector = search.id
                        }){
                            HistoryRow(history: search)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.accentColor) //Apply color for arrow only
                                .padding(.trailing, 5)
                        }
                    }
                    .padding(.horizontal, 15)
                    
                }
            }
        }
    }
}

struct SearchList_Previews: PreviewProvider {
    
    static let debug: DebugData = DebugData()
    
    static let historyData: HistoryDataView = debug.historyData
    static let contactsData: ContactsDataView = debug.contactsData
    static let model: ChatScreenModel = debug.model
    static let userData: UserDataView = debug.userData
    
    static var previews: some View {
        Group {
            SearchList(alert: .constant(MyAlert()))
                .environmentObject(historyData)
                .environmentObject(contactsData)
                .environmentObject(model)
                .environmentObject(userData)
            
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
            SearchList(alert: .constant(MyAlert()))
                .environmentObject(DebugData().historyData)
                .environmentObject(DebugData().contactsData)
                .environmentObject(DebugData().userData)
                .environmentObject(DebugData().model)
            
                .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
        }
    }
}
