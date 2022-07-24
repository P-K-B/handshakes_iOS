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
    @Binding var selectedContact: String?
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
                    
                    VStack (alignment: .leading){

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
                    LazyVStack (pinnedViews: .sectionHeaders){
                        Text("\(contactsData.data.contacts.count)")
                        ContactsSearchList
                    }
                }
//                    .padding(.top, 5)
                }
            }
            .contentShape(Rectangle())

            .onTapGesture {
                self.endEditing()
            }
        }

    }
    
    var ContactsSearchList: some View{
        LazyVStack{

            
                            ForEach(contactsData.data.contacts
                                        .filter { searchText.isEmpty || $0.longSearch.localizedStandardContains(searchText)}

                )
                { contact in
                    VStack{

                        HStack {
                            
                            
//                            NavigationLink(destination:
//                                            SingleContactView2(selectedContact: contact)
////                                                   SingleContactView2()
//                                .environmentObject(historyData)
//                                .environmentObject(contactsData)
//                                .environmentObject(model)
//                                .environmentObject(userData)
//                            ) {  HStack{
//                                ContactRow(contact: contact, order: contactsData.order)
//                                Spacer()
////
//                            }
//                            }
//                            .navigationViewStyle(.stack)
//                            .foregroundColor(Color.black)
//                            .simultaneousGesture(TapGesture().onEnded{
////                                    print("Hello world!")
//                                close=false
//                            })
                            
                           
                            Button(action: {
                                withAnimation(){
                                    selectedContact = contact.id
                                    close = false
//                                    contacts.selectedContact = contact
//                                    selectedTab = .singleContact
                                }
                            }, label: {
                                HStack{
                                    ContactRow(contact: contact, order: contactsData.order)
                                    Spacer()

                                }
                            })
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
//        }
        
    }
}
