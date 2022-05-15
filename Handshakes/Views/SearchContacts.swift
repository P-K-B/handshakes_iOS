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
    @Binding var windowManager: WindowManager
    @EnvironmentObject private var contactsManager: ContactsDataView
    
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
            ForEach(contactsManager.contacts
                        .filter { searchText.isEmpty || $0.shortSearch.localizedStandardContains(searchText)}
            )
            { contact in
                ZStack{
                    Button(action:{
                        withAnimation{
                            withAnimation(){
                                close = false
                            }
                            windowManager.contactDetailsIndex = contact.id
                            windowManager.isContactDetails = true
                        }
                    }){
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
            Text("Other results")
        }
        
    }
}

struct SearchContacts_Previews: PreviewProvider {
    static var previews: some View {
        SearchContacts(close: .constant(true), windowManager: .constant(WindowManager()))
    }
}



