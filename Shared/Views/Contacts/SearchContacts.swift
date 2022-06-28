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
    @State var hasScrolled: Bool = false
    @AppStorage("big") var big: Bool = IsBig()


    
    var body: some View {
        
        ZStack{

            VStack{
                ZStack {
//                    Color.clear
//                        .background(.ultraThinMaterial)
//                    //                .blur(radius: 5)
//                        .mask(
//                            LinearGradient(gradient: Gradient(stops: [
//                                Gradient.Stop(color: Color(white: 0, opacity: 1),
//                                              location: 0.8),
//                                Gradient.Stop(color: Color(white: 0, opacity: 0),
//                                              location: 1),
//                            ]), startPoint: .top, endPoint: .bottom)
//                        )
//                        .opacity(hasScrolled ? 1 : 0)
                    
                    VStack (alignment: .leading){

                            Text("Search")
                                .animatableFont(size: hasScrolled ? 22 : 36, weight: .bold)
                        
                        //                    .frame(maxWidth: .infinity, alignment: .leading)
                        //                    .padding(.leading, 20)
                        //                    .padding(.top, 30)
                        //                    .offset(y: hasScrolled ? -4 : 0)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    .padding(.top, 30)
                    .offset(y: hasScrolled ? -4 : 0)

        //            }
                }
                .frame(height: hasScrolled ? 50 : 74)
//                .frame(maxHeight: .infinity, alignment: .top)
//                .ignoresSafeArea()
                ScrollViewReader { proxy in
                
//                    .onChange(of: searchText, perform: {print(searchText)})
//                    .padding(.top, 5)
                
//                    let binding = Binding<String>(get: {
//                                self.searchText
//                            }, set: {
//                                self.searchText = $0
//                                // do whatever you want here
//                                print("Scrol")
//                                if (contacts.data.contacts.filter { searchText.isEmpty || $0.longSearch.localizedStandardContains(searchText)}.count > 0){
//                                proxy.scrollTo((contacts.data.contacts.filter { searchText.isEmpty || $0.longSearch.localizedStandardContains(searchText)}[0]).index, anchor: .top)
//                                }
//                            })
                    SearchBarMy(searchText: $searchText)
                ScrollView() {
//                    GeometryElement(hasScrolled: $hasScrolled, big: big, hasBack: false)
                    LazyVStack (pinnedViews: .sectionHeaders){
                        Text("\(contacts.data.contacts.count)")
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
//            .safeAreaInset(edge: .top, content: {
//                Color.clear.frame(height: big ? 45: 75)
//            })
//            .overlay(
//                NavigationBar(title: "Search", hasScrolled: $hasScrolled, search: .constant(false), showSearch: .constant(false))
//
//            )
        }

    }
    
    var ContactsSearchList: some View{
        LazyVStack{
//            Text("\(searchText)")
//            Text("Top name matches")
//            ForEach(contacts.data.contacts
//                        .filter { searchText.isEmpty || $0.shortSearch.localizedStandardContains(searchText)}
//            )
//            { contact in
//                VStack{
//                    //                            Button (action:{
//                    //                                withAnimation{
//                    //                                    windowManager.contactDetailsIndex = contact.id
//                    //                                    windowManager.isContactDetails = true
//                    //                                }
//                    //                            }) {
//                    HStack {
//                        //                                    Text(contact.lastName.isEmpty ? "" : contact.lastName + " ")
//                        //                                        .font(Font.custom("SFProDisplay-Bold", size: 20))
//                        //                                    +
//                        //                                    Text(contact.firstName)
//                        //                                        .font(Font.custom("SFProDisplay-Regular", size: 20))
//
//                        //                                NavigationLink("", destination: SingleContactView(), tag: contact.id, selection: $selectedContact)
//                        Button(action: {
//                            withAnimation(){
//                                contacts.selectedContact = contact
//                                selectedTab = .singleContact
//                            }
//                        }, label: {
//                            HStack{
//                                ContactRow(contact: contact, order: contacts.order)
//                                Spacer()
////                                        Image(systemName: "chevron.right")
////                                            .resizable()
////                                            .aspectRatio(contentMode: .fit)
////                                            .frame(width: 7)
////                                            .foregroundColor(Color.accentColor) //Apply color for arrow only
////                                            .padding(.trailing, 5)
//                            }
//                        })
//                        .foregroundColor(.black)
//                        .padding(.leading, 13)
//
//
//
//                    }
//                    Divider()
//
//                    //                            }
//                    //                            .foregroundColor(.primary)
//
//                }
//                .padding(.horizontal, 10)
//                .padding(.vertical, 3)
//            }
//            if (searchText != ""){
//                Text("Other results")
                            ForEach(contacts.data.contacts
                                        .filter { searchText.isEmpty || $0.longSearch.localizedStandardContains(searchText)}

                )
                { contact in
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
                            Button(action: {
                                withAnimation(){
                                    contacts.selectedContact = contact
                                    selectedTab = .singleContact
                                }
                            }, label: {
                                HStack{
                                    ContactRow(contact: contact, order: contacts.order)
                                    Spacer()
//                                        Image(systemName: "chevron.right")
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fit)
//                                            .frame(width: 7)
//                                            .foregroundColor(Color.accentColor) //Apply color for arrow only
//                                            .padding(.trailing, 5)
                                }
                            })
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
//        }
        
    }
}
