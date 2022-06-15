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
    @EnvironmentObject var contacts: ContactsDataView
    
    //    view data
    @State var hasScrolled: Bool = false
    @AppStorage("big") var big: Bool = IsBig()
    @State var selectedContact: String? = ""
    @State var search: Bool = false
    @AppStorage("selectedTab") var selectedTab: Tab = .search

    
    var body: some View {
        //        lazyV
        hardV
    }
    
    var hardV: some View{
        ZStack{
            //            if (windowManager.isContactDetails == false){
            ZStack{
                Color.theme.background
                    .ignoresSafeArea()
                if (!contacts.checkAccess()){
                    Button(action:{
                        if (!contacts.checkAccess()){
                            alert = MyAlert(error: true, title: "Contacts access required.", text: "Go to Settings?", button: "Settings", button2: "Cancel", oneButton: false)
                        }
                        else{
                            //                        contacts = ContactsData()
                        }
                    }){
                        Text ("Fetch contacts")
                    }
                }
                else{
                    ScrollView() {
                        //                            debugTime
                        GeometryElement(hasScrolled: $hasScrolled, big: big, hasBack: false)
                        
                        if (contacts.data.loaded){
                            if (!contacts.data.updated){
                                Text ("Updating")
                                    .onDisappear{
                                        print("2")
                                    }
                            }
//                            else{
                                //                                ForEach(contacts.data.contacts){ contact in
                                //                                    HStack() {
                                ContactsList
                                .onAppear{
                                    print("1")
                                }
//                            }
                            //                                    }
                            //                                }
                        }
                        else{
                            Text("Loading")
                        }
                    }
                    .overlay(
                        NavigationBar(title: "Contacts", hasScrolled: $hasScrolled, search: $search, showSearch: .constant(true))
                           
                    )
                }
            }
        }
        .popover(isPresented: $search) {
            SearchContacts(close: $search, selectedContact: $selectedContact)
                .onAppear{
                    print(contacts.data)
                    print(contacts.contactsDataService.data)
                }
        }
    }
    
    var ContactsList: some View{
        LazyVStack(){
            ForEach(contacts.data.letters, id: \.self) { letter in
                Section(header: SectionLetter(text:letter)) {
                    ForEach(contacts.data.contacts
                        .filter({ (contact) -> Bool in (contact.filterindex.prefix(1).uppercased() == letter)})
                    )
                    { contact in
                        ZStack{
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
                                Button(action: {
                                    withAnimation(){
                                        contacts.selectedContact = contact
                                        selectedTab = .singleContact
                                    }
                                }, label: {
                                    HStack{
                                        ContactRow(contact: contact, order: contacts.order)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 7)
                                            .foregroundColor(Color.accentColor) //Apply color for arrow only
                                            .padding(.trailing, 5)
                                    }
                                })
                                .foregroundColor(.black)
                                
                            }
                            .padding(.horizontal, 15)
                            //                            }
                            //                            .foregroundColor(.primary)
                            
                        }
                    }
                }
                
            }
            Text(String(contacts.data.contacts.count))
        }
    }
    
    var lazyV: some View{
        NavigationView{
            VStack{
                if (!contacts.checkAccess()){
                    Button(action:{
                        if (!contacts.checkAccess()){
                            alert = MyAlert(error: true, title: "Contacts access required.", text: "Go to Settings?", button: "Settings", button2: "Cancel", oneButton: false)
                        }
                        else{
                            //                        contacts = ContactsData()
                        }
                    }){
                        Text ("Fetch contacts")
                    }
                }
                else{
                    ScrollView() {
                        debugTime
                        LazyVStack(){
                            if (contacts.data.loaded){
                                if (!contacts.data.updated){
                                    Text ("Updating")
                                }
                                ForEach(contacts.data.contacts){ contact in
                                    HStack() {
                                        //                                        NavigationLink(String(String(contact.lastName.isEmpty ? "" : contact.lastName + " ") + contact.firstName), destination: SingleContactView(contact: contact))
                                        Button(action: {
                                            contacts.selectedContact = contact
                                            selectedTab = .singleContact
                                        }, label: {
                                            HStack{
                                                ContactRow(contact: contact, order: contacts.order)
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 7)
                                                    .foregroundColor(Color.accentColor) //Apply color for arrow only
                                                    .padding(.trailing, 5)
                                            }
                                        })
                                        .foregroundColor(.black)
                                    }
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
    
    var debugTime: some View{
        VStack{
            VStack{
                Text("\(contacts.jwt)")
                Text("Loaded:" + String(contacts.data.time11.timeIntervalSinceReferenceDate - contacts.data.time.timeIntervalSinceReferenceDate))
                Text("New/Delete:" + String(contacts.data.time2.timeIntervalSinceReferenceDate - contacts.data.time.timeIntervalSinceReferenceDate))
                Text("Deleted:" + String(contacts.data.time3.timeIntervalSinceReferenceDate - contacts.data.time2.timeIntervalSinceReferenceDate))
                Text("Uploaded:" + String(contacts.data.time4.timeIntervalSinceReferenceDate - contacts.data.time3.timeIntervalSinceReferenceDate))
                Text("Guid:" + String(contacts.data.time5.timeIntervalSinceReferenceDate - contacts.data.time4.timeIntervalSinceReferenceDate))
                Text("Delete:" + String(contacts.data.time6.timeIntervalSinceReferenceDate - contacts.data.time5.timeIntervalSinceReferenceDate))
            }
            Text("New:" + String(contacts.data.time7.timeIntervalSinceReferenceDate - contacts.data.time6.timeIntervalSinceReferenceDate))
            Text("Updated:" + String(contacts.data.time10.timeIntervalSinceReferenceDate - contacts.data.time7.timeIntervalSinceReferenceDate))
            Text("Total:" + String(contacts.data.time10.timeIntervalSinceReferenceDate - contacts.data.time11.timeIntervalSinceReferenceDate))
            Text("Count: \(contacts.data.contacts.count)")
        }
    }
}

//struct ContactsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContactsView(appData: .constant(AppData()))
//    }
//}


extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
