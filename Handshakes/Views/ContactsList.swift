//
//  ContactsList.swift
//  Handshakes
//
//  Created by Kirill Burchenko on 26.11.2021.
//

import SwiftUI

struct ContactView: View {
    
    @State var hasScrolled = false
    @State var big: Bool
    @State var search: Bool = false
    @Binding var historyData: HistoryData
    @Binding var windowManager: WindowManager
    @EnvironmentObject private var contactsManager: ContactsDataView
    @State private var err: Bool = false
    @State private var hasBack: Bool = false
    
    var body: some View {
        ZStack{
            if (windowManager.isContactDetails == false){
                ZStack{
                    Color.theme.background
                        .ignoresSafeArea()
                    if (contactsManager.updated && contactsManager.contacts.isEmpty){
                        Button(action:{
                            CList().requestAccess(){
                                (data, err) in
                                contactsManager.contacts = data
                                contactsManager.updated = true
                                self.err = err
                            }
                        }){
                            Text ("Fetch contacts")
                        }
                    }
                    else{
                        ScrollView() {
                            GeometryElement(hasScrolled: $hasScrolled, big: big, hasBack: hasBack)

                                if (!contactsManager.updated){
                                    VStack{
                                        Text("Updating contacts...")
                                        ProgressView()
                                    }
                                }
                                else{
                                    ContactsList
                                }

                        }
                        .safeAreaInset(edge: .top, content: {
                            Color.clear.frame(height: big ? 45: 75)
                        })
                        .safeAreaInset(edge: .bottom) {
                            Color.clear.frame(height: big ? 55: 70)
                        }
                        .overlay(
                            NavigationBar(title: "Contacts", hasScrolled: $hasScrolled, search: $search, showSearch: .constant(true), back: .constant(false))
                        )
                    }
                }
            }
            else{
                ContactDetail(contact: contactsManager.contacts[windowManager.contactDetailsIndex], historyData: $historyData, windowManager: $windowManager)
            }
        }
        .alert(isPresented: $err) {
            Alert (title: Text("Contacts access required."),
                   message: Text("Go to Settings?"),
                   primaryButton: .default(Text("Settings"), action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }),
                   secondaryButton: .default(Text("Cancel")))
        }
        .onAppear() {
        }
        .popover(isPresented: $search) {
            SearchContacts(close: $search, windowManager: $windowManager)
        }
        .onAppear{
            windowManager.isSearchingNumber = false
        }
    }
    
    var ContactsList: some View{
        LazyVStack(){
            ForEach(CAlpha(contacts: contactsManager.contacts).letters, id: \.self) { letter in
                Section(header: SectionLetter(text:letter)) {
                    ForEach(contactsManager.contacts
                                .filter({ (contact) -> Bool in (contact.filterindex.prefix(1).uppercased() == letter)})
                    )
                    { contact in
                        ZStack{
                            Button (action:{
                                withAnimation{
                                    windowManager.contactDetailsIndex = contactsManager.contacts.firstIndex(of: contact)!
                                    windowManager.isContactDetails = true
                                }
                            }) {
                                HStack {
                                    ContactRow(contact: contact)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 7)
                                        .foregroundColor(Color.accentColor) //Apply color for arrow only
                                        .padding(.trailing, 5)
                                }
                                .padding(.horizontal, 15)
                            }
                            .foregroundColor(.primary)
                            
                        }
                    }
                }
                
            }
            Text(String(contactsManager.contacts.count))
        }
    }
}


struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView(big: true, historyData: .constant(HistoryData()), windowManager: .constant(WindowManager()))
            .environmentObject(ContactsDataView())
    }
}







struct SectionLetter_Previews: PreviewProvider {
    static var previews: some View {
        SectionLetter(text: "T")
    }
}
