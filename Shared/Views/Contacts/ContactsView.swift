//
//  ContactsView.swift
//  Handshakes2
//
//  Created by Kirill Burchenko on 18.05.2022.
//

import SwiftUI
import Foundation

struct ContactsView: View {
    
    //    App data
    @Binding var alert: MyAlert
    @EnvironmentObject var historyData: HistoryDataView
    @EnvironmentObject var contactsData: ContactsDataView
    @EnvironmentObject var model: ChatScreenModel
    @EnvironmentObject var userData: UserDataView
    
    //    view data
    //    @State var hasScrolled: Bool = false
    @AppStorage("big") var big: Bool = IsBig()
    @State var selectedContact: String? = ""
    @State var search: Bool = false
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    
    @State var stored: Int = 0
    @State var current: [Int] = []
    @Binding var visible: Int
    
    //    Nav
    @State var showSingleContact: Bool = false
    @State var prev: Bool = false
    
    @State var selector: String? = nil
    @State var searchSelector: Bool = false
    @State var searchSelectedContact: FetchedContact?
    @State var selected: Bool = false
    
    
    var body: some View {

        VStack{
            ZStack{
                hardV
                    .overlay(
                        NavigationBar(title: "Contacts", search: $search, showSearch: true, showProfile: true, hasBack: false)
                            .environmentObject(historyData)
                            .environmentObject(contactsData)
                            .environmentObject(model)
                            .environmentObject(userData)
                        
                    )
            }
        }
            .safeAreaInset(edge: .top, content: {
                Color.clear.frame(height: big ? 45: 75)
            })
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: big ? 55: 70)
            }
        
    }
    
    var hardV: some View{
        ZStack{
            ZStack{
                ZStack {
                    GeometryReader { geometry in
                        ScrollViewReader { proxy in
                            ScrollView() {
                                if ((!contactsData.checkAccess()) && (!self.prev)){
                                    VStack{
                                        Button(action:{
                                            if (!contactsData.checkAccess()){
                                                alert = MyAlert(error: true, title: "Contacts access required.", text: "Go to Settings?", button: "Settings", button2: "Cancel", oneButton: false)
                                            }
                                            else{
                                            }
                                        }){
                                            Text ("Fetch contacts")
                                        }
                                    }
                                    .frame(width: geometry.size.width)      // Make the scroll view full-width
                                    .frame(minHeight: geometry.size.height)
                                }
                                else{
                                    
                                    if (contactsData.data.loaded){
                                        if (!contactsData.data.updated){
                                            Text ("Updating")
                                                .onDisappear{
                                                    print("2")
                                                }
                                        }
                                        NavigationLink(destination:
                                                        SingleContactView2(selectedContact: searchSelectedContact ?? contactsData.data.contacts[0], alert: $alert)
                                            .environmentObject(historyData)
                                            .environmentObject(contactsData)
                                            .environmentObject(model)
                                            .environmentObject(userData),
                                                       isActive: $searchSelector
                                        ) {
                                            EmptyView()
                                        }
                                        LazyVStack{
                                            ContactsList
                                            
                                        }
                                        .onAppear {
                                            print("Visible!" ,visible)
                                            
                                            proxy.scrollTo(visible, anchor: .bottom)
                                        }
                                        
                                    }
                                    else{
                                        Text("Loading")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .popover(isPresented: $search) {
            SearchContacts(close: $search, selectedContact: $selectedContact, searchSelectedContact: $searchSelectedContact, selected: $selected)
                .environmentObject(historyData)
                .environmentObject(contactsData)
                .environmentObject(model)
                .environmentObject(userData)
                .onDisappear{
                    print("Closed")
                    if (selected){
                        searchSelector = true
                    }
//                    print(selectedContact)
//                    selector = selectedContact
//                    print(selector)
                }
        }
    }
    
    var ContactsList: some View{
        ForEach(contactsData.data.letters, id:\.self) { letter in
            let a = contactsData.data.contacts
                .filter({ (contact) -> Bool in (contact.filterindex.prefix(1).uppercased() == letter)})
            if (a.filter({!contactsData.data.hide.contains($0.id)}).count > 0){
                Section(header: SectionLetter(text:letter)) {
                    ForEach(a
                    )
                    { contact in
                        if (!contactsData.data.hide.contains(contact.id)){
                            VStack{
                                HStack {
                                    NavigationLink(destination:
                                                    SingleContactView2(selectedContact: contact, alert: $alert)
                                        .environmentObject(historyData)
                                        .environmentObject(contactsData)
                                        .environmentObject(model)
                                        .environmentObject(userData), tag: contact.id, selection: $selector
                                    ) {
                                        EmptyView()
                                    }
//                                    .navigationViewStyle(.stack)
                                    .foregroundColor(Color.black)
                                    Button(action: {
                                        
                                        selector = contact.id
                                    }, label: {
                                        HStack{
                                            ContactRow(contact: contact, order: contactsData.order)
                                            Spacer()
                                            
                                        }
                                    })
                                    .onAppear {
                                        current.append(contact.index)
                                        visible = (current.sorted(by: {$0 < $1}).last ?? 0) - 2
                                    }
                                    .onDisappear {
                                        current.removeAll { $0 == contact.index }
                                    }
                                    .foregroundColor(.black)
                                    .padding(.leading, 13)
                                }
                                Divider()
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 3)
                            .id(contact.index)
                        }
                    }
                }
            }
            
        }
    }
    
    
    var debugTime: some View{
        VStack{
            VStack{
                Text("\(contactsData.jwt)")
                Text("Loaded:" + String(contactsData.data.time11.timeIntervalSinceReferenceDate - contactsData.data.time.timeIntervalSinceReferenceDate))
                Text("New/Delete:" + String(contactsData.data.time2.timeIntervalSinceReferenceDate - contactsData.data.time.timeIntervalSinceReferenceDate))
                Text("Deleted:" + String(contactsData.data.time3.timeIntervalSinceReferenceDate - contactsData.data.time2.timeIntervalSinceReferenceDate))
                Text("Uploaded:" + String(contactsData.data.time4.timeIntervalSinceReferenceDate - contactsData.data.time3.timeIntervalSinceReferenceDate))
                Text("Guid:" + String(contactsData.data.time5.timeIntervalSinceReferenceDate - contactsData.data.time4.timeIntervalSinceReferenceDate))
                Text("Delete:" + String(contactsData.data.time6.timeIntervalSinceReferenceDate - contactsData.data.time5.timeIntervalSinceReferenceDate))
            }
            Text("New:" + String(contactsData.data.time7.timeIntervalSinceReferenceDate - contactsData.data.time6.timeIntervalSinceReferenceDate))
            Text("Updated:" + String(contactsData.data.time10.timeIntervalSinceReferenceDate - contactsData.data.time7.timeIntervalSinceReferenceDate))
            Text("Total:" + String(contactsData.data.time10.timeIntervalSinceReferenceDate - contactsData.data.time11.timeIntervalSinceReferenceDate))
            Text("Count: \(contactsData.data.contacts.count)")
        }
    }
}

struct ContactsView_Previews: PreviewProvider {
    
    static let debug: DebugData = DebugData()
    
    static let historyData: HistoryDataView = debug.historyData
    static let contactsData: ContactsDataView = debug.contactsData
    static let model: ChatScreenModel = debug.model
    static let userData: UserDataView = debug.userData
    
    static var previews: some View {
        Group{
            ContactsView(alert: .constant(MyAlert()), visible: .constant(0), prev: true)
                .environmentObject(historyData)
                .environmentObject(contactsData)
                .environmentObject(model)
                .environmentObject(userData)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
            ContactsView(alert: .constant(MyAlert()), visible: .constant(0), prev: true)
                .environmentObject(historyData)
                .environmentObject(contactsData)
                .environmentObject(model)
                .environmentObject(userData)
                .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
        }
    }
}


extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
