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
    

    
    var body: some View {
        //        lazyV
        NavigationView{
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
        .overlay{
            TabBar()
                .zIndex(1)
                .transition(.move(edge: .bottom))
        }
//        .onDisappear{
//            nav = false
//        }

//            .onAppear{
//                print(contactsData.data)
//                print("Debug!")
//                print(DebugData().contactsData.data)
//                print("Debug!")
//            }
            .safeAreaInset(edge: .top, content: {
                                        Color.clear.frame(height: big ? 45: 75)
                                    })
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)

        }
//        .navigationBarHidden(true)
//        .navigationBarBackButtonHidden(true)
    }
    
    var hardV: some View{
        ZStack{
            //            if (windowManager.isContactDetails == false){
            ZStack{
//                Color.theme.background
//                    .ignoresSafeArea()
                
                

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
                                        //                        contacts = ContactsData()
                                    }
                                }){
                                    Text ("Fetch contacts")
                                }
                                }
                                .frame(width: geometry.size.width)      // Make the scroll view full-width
                                            .frame(minHeight: geometry.size.height)
                            }
                            else{
                            //                            debugTime
//                            GeometryElement(hasScrolled: $hasScrolled, big: big, hasBack: false)
//                            Text("\(contacts.data.contacts.count)")
//                            Text("\(contacts.data.letters.count)")
                            
                            if (contactsData.data.loaded){
                                if (!contactsData.data.updated){
                                    Text ("Updating")
                                        .onDisappear{
                                            print("2")
                                        }
                                }
    //                            else{
                                    //                                ForEach(contacts.data.contacts){ contact in
                                    //                                    HStack() {
                                LazyVStack{
                                    ContactsList
    //                                ForEach(contacts.data.contacts)
    //                                { contact in
    //                                ContactRow(contact: contact, order: contacts.order)
    //                                        .id(contact.index)
    //                                }
                                    
                                }
                                .onAppear {
                                    print("Visible!" ,visible)
    //                                if (contacts.data.contacts.count > 0){
    //                                    print("scrol to last",contacts.data.contacts[contacts.data.contacts.count - 2].index)
    //                                proxy.scrollTo(contacts.data.contacts[contacts.data.contacts.count - 2].index)
    //                                }
    //                                else{
                                    proxy.scrollTo(visible, anchor: .bottom)
    //                                }
                                                }
    //                                        }
    //                            }
                                //                                    }
                                //                                }
                            }
                            else{
                                Text("Loading")
                            }
                        }
                        }
                        }
    //                    .overlay(
    //                        NavigationBar(title: "Contacts", hasScrolled: $hasScrolled, search: $search, showSearch: true, showProfile: true)
    //
    //                    )
                    }
                }
                    
//                }
            }
        }
        .popover(isPresented: $search) {
//            HideContacts(showHideAlert: .constant(false))
            SearchContacts(close: $search, selectedContact: $selectedContact)
                .environmentObject(historyData)
                .environmentObject(contactsData)
                .environmentObject(model)
                .environmentObject(userData)
                .onDisappear{
                    print("Closed")
                    
                    selector = selectedContact
                }
//                .onAppear{
//                    print(contacts.data)
//                    print(contacts.contactsDataService.data)
//                }
        }
    }
    
    var ContactsList: some View{
        

        
//        LazyVStack(){
            ForEach(contactsData.data.letters, id:\.self) { letter in
                
                    let a = contactsData.data.contacts
                        .filter({ (contact) -> Bool in (contact.filterindex.prefix(1).uppercased() == letter)})
                    if (a.filter({!contactsData.data.hide.contains($0.id)}).count > 0){
                        Section(header: SectionLetter(text:letter)) {
                    ForEach(a
                    )
//                    ForEach(contacts.data.contacts
//                        .filter({ (contact) -> Bool in (contact.filterindex.prefix(1).uppercased() == letter)})
//                    )
                    { contact in
                        if (!contactsData.data.hide.contains(contact.id)){
                            VStack{
                                //                            Button (action:{
                                //                                withAnimation{
                                //                                    windowManager.contactDetailsIndex = contact.id
                                //                                    windowManager.isContactDetails = true
                                //                                }
                                //                            }) {
                                HStack {
                                    //                                    Text(contact.lastName.isEmpty ? "" : contact.lastName + " ")
                                    //                                        .font(Font.custom("SFProDisplay-Bold", size: 20))
                                    //                                    +
                                    //                                    Text(contact.firstName)
                                    //                                        .font(Font.custom("SFProDisplay-Regular", size: 20))
                                    
                                    //                                NavigationLink("", destination: SingleContactView(), tag: contact.id, selection: $selectedContact)
                                    
                                    NavigationLink(destination:
                                                    SingleContactView2(selectedContact: contact, alert: $alert)
//                                                   SingleContactView2()
                                        .environmentObject(historyData)
                                        .environmentObject(contactsData)
                                        .environmentObject(model)
                                        .environmentObject(userData), tag: contact.id, selection: $selector
                                    ) {
                                        EmptyView()
//                                        HStack{
//                                        ContactRow(contact: contact, order: contactsData.order)
//                                        Spacer()
////
//                                    }
                                    }
                                    .navigationViewStyle(.stack)
                                    .foregroundColor(Color.black)
                                    
                                    Button(action: {
                                       
                                        selector = contact.id
                                    }, label: {
                                        HStack{
                                            ContactRow(contact: contact, order: contactsData.order)
                                            Spacer()
    //                                        Image(systemName: "chevron.right")
    //                                            .resizable()
    //                                            .aspectRatio(contentMode: .fit)
    //                                            .frame(width: 7)
    //                                            .foregroundColor(Color.accentColor) //Apply color for arrow only
    //                                            .padding(.trailing, 5)
                                        }
                                    })
                                    .onAppear {
    //                                                                    print(">> added \(contact.index)")
                                                                        current.append(contact.index)
    //                                    print(current.sorted(by: {$0 < $1}))
                                        visible = (current.sorted(by: {$0 < $1}).last ?? 0) - 2
                                                                    }
                                                                    .onDisappear {
                                                                        current.removeAll { $0 == contact.index }
    //                                                                    print("<< removed \(contact.index)")
                                                                    }
                                    .foregroundColor(.black)
                                    .padding(.leading, 13)
                                    
                                    
                                    
                                }
                                Divider()
                                
                                //                            }
                                //                            .foregroundColor(.primary)
                                
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 3)
                            .id(contact.index)
                        }
                    }
                    }
                }
                
            }
//            Text(String(contacts.data.contacts.count))
//        }
    }
    
//    var lazyV: some View{
//        NavigationView{
//            VStack{
//                if (!contacts.checkAccess()){
//                    Button(action:{
//                        if (!contacts.checkAccess()){
//                            alert = MyAlert(error: true, title: "Contacts access required.", text: "Go to Settings?", button: "Settings", button2: "Cancel", oneButton: false)
//                        }
//                        else{
//                            //                        contacts = ContactsData()
//                        }
//                    }){
//                        Text ("Fetch contacts")
//                    }
//                }
//                else{
//                    ScrollView() {
//                        debugTime
//                        LazyVStack(){
//                            if (contacts.data.loaded){
//                                if (!contacts.data.updated){
//                                    Text ("Updating")
//                                }
//                                ForEach(contacts.data.contacts){ contact in
//                                    HStack() {
//                                        //                                        NavigationLink(String(String(contact.lastName.isEmpty ? "" : contact.lastName + " ") + contact.firstName), destination: SingleContactView(contact: contact))
//                                        Button(action: {
//                                            contacts.selectedContact = contact
//                                            selectedTab = .singleContact
//                                        }, label: {
//                                            HStack{
//                                                ContactRow(contact: contact, order: contacts.order)
//                                                Spacer()
//                                                Image(systemName: "chevron.right")
//                                                    .resizable()
//                                                    .aspectRatio(contentMode: .fit)
//                                                    .frame(width: 7)
//                                                    .foregroundColor(Color.accentColor) //Apply color for arrow only
//                                                    .padding(.trailing, 5)
//                                            }
//                                        })
//                                        .foregroundColor(.black)
//                                    }
//                                }
//                            }
//                            else{
//                                Text("Loading")
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
    
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
