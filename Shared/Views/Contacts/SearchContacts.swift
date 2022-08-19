//
//  SearchContacts.swift
//  Handshakes
//
//  Created by Kirill Burchenko on 04.12.2021.
//

import SwiftUI


struct SearchContacts: View {
    
    @Binding var alert: MyAlert
    @State var searchText: String = ""
    @Binding var close: Bool
    @Binding var selectedContact: String?
    @Binding var searchSelectedContact: FetchedContact?
    @Binding var selected: Bool
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    @State var hasScrolled: Bool = false
    @AppStorage("big") var big: Bool = IsBig()
    
    @EnvironmentObject var historyData: HistoryDataView
    @EnvironmentObject var contactsData: ContactsDataView
    @EnvironmentObject var model: ChatScreenModel
    @EnvironmentObject var userData: UserDataView
    
    
    
    var body: some View {
        
        ZStack{
            
            VStack{
                ZStack {
                    
                    VStack (alignment: .leading, spacing: 0){
                        
                        Text("Search")
                            .animatableFont(size: hasScrolled ? 22 : 36, weight: .bold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    .padding(.top, 30)
                    .offset(y: hasScrolled ? -4 : 0)
                    
                    //            }
                }
                .frame(height: hasScrolled ? 50 : 74)
                
                ScrollViewReader { proxy in
                    
                    SearchBarMy(searchText: $searchText)
                    ScrollView() {

                        if (!contactsData.checkAccess()){
                            VStack(spacing: 0){
                                Button(action:{
                                    if (!contactsData.checkAccess()){
                                        alert = MyAlert(active: true, alert: Alert(title: Text("Contacts access required"), message: Text("Go to Settings?"), primaryButton: .default(Text("Settings")) {
                                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                                        },
                                        secondaryButton: .cancel()))
                                    }
                                    else{
                                    }
                                }){
                                    Text ("Fetch contacts")
                                        .myFont(font: MyFonts().Body, type: .display, color: Color.black, weight: .regular)
                                }
                            }
//                            .frame(width: geometry.size.width)      // Make the scroll view full-width
//                            .frame(minHeight: geometry.size.height)
                        }
                        else{
                            
                            if (contactsData.data.loaded){
                                if (!contactsData.data.updated){
                                    Text ("Updating")
                                        .myFont(font: MyFonts().Body, type: .display, color: Color.black, weight: .regular)
                                }
                                LazyVStack(spacing: 0){
//                                    ContactsList
                                    Text("Random text")
                                        .frame(width: 0, height: 0)
                                    ContactsSearchList
                                    
                                }
                            }
                            else{
                                Text("Loading")
                                    .myFont(font: MyFonts().Body, type: .display, color: Color.black, weight: .regular)
                            }
                        }
                        
//                            ContactsSearchList
//                        }
                    }
                    //                    .padding(.top, 5)
                }
            }
            .contentShape(Rectangle())
            
            .onTapGesture {
                self.endEditing()
            }
        }
        .onAppear{
            selected = false
        }
        
    }
    
    var ContactsSearchList: some View{
        LazyVStack(spacing: 0){
            ForEach(contactsData.data.contacts
                .filter { searchText.isEmpty || $0.longSearch.localizedStandardContains(searchText)}
            )
            { contact in
                VStack(spacing: 0){
                    
                    HStack {
                        
                        Button(action: {
                            withAnimation(){
                                selectedContact = contact.id
                                searchSelectedContact = contact
                                selected = true
                                close = false
                            }
                        }, label: {
                            HStack{
                                ContactRow(contact: contact, order: contactsData.order)
                                Spacer()
                                
                            }
                        })
                        .foregroundColor(.black)
                        .padding(.leading, 13)
                        .padding(.vertical, 10)
                        
                        
                        
                    }
                    Divider()
                    
                    
                }
                .padding(.horizontal, 10)
//                .padding(.vertical, 3)
                .id(contact.index)
            }
        }
        //        }
        
    }
}
