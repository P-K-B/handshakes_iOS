//
//  SearchContacts.swift
//  Handshakes
//
//  Created by Kirill Burchenko on 04.12.2021.
//

import SwiftUI


struct SearchContacts: View {
    
    @State var searchText: String = ""
    @Binding var close: Bool
    @EnvironmentObject var contacts: ContactsDataView
    @Binding var selectedContact: String?
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    
    var body: some View {
        ZStack{
            VStack{
                SearchBarMy(searchText: $searchText)
                ScrollView() {
                    
                    LazyVStack (pinnedViews: .sectionHeaders){
                        ContactsSearchList
                    }
                    .padding(.top, 20)
                }
            }
        }
    }
    
    var ContactsSearchList: some View{
        LazyVStack{
            Text("\(searchText)")
            Text("Top name matches")
            ForEach(contacts.data.contacts
                        .filter { searchText.isEmpty || $0.shortSearch.localizedStandardContains(searchText)}
            )
            { contact in
                ZStack{
//                    NavigationLink("", destination: SingleContactView(contact: contact), tag: contact.id, selection: $selectedContact)
                    Button(action: {
                        contacts.SelectContact(contact: contact)
                        selectedTab = .singleContact
                        close = false
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
            if (searchText != ""){
                Text("Other results")
                ForEach(contacts.data.contacts
                            .filter { searchText.isEmpty || ($0.longSearch.localizedStandardContains(searchText) && !$0.shortSearch.localizedStandardContains(searchText))}
                )
                { contact in
                    ZStack{
    //                    NavigationLink("", destination: SingleContactView(contact: contact), tag: contact.id, selection: $selectedContact)
                        Button(action: {
                            contacts.SelectContact(contact: contact)
                            selectedTab = .singleContact
                            close = false
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
        }
        
    }
}
