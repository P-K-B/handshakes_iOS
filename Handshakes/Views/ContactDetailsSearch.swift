//
//  ContactDetails.swift
//  Handshakes
//
//  Created by Kirill Burchenko on 29.11.2021.
//

import SwiftUI

struct ContactDetailSearch: View {
    
    //    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage("big") var big: Bool = false
    
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    
    var contact: FetchedContact
    
    @State var hasScrolled = false
    
    @Binding var windowManager: WindowManager
    
    @State private var hasBack: Bool = true

    
    var body: some View {
        dt
            .safeAreaInset(edge: .top, content: {
                Color.clear.frame(height: big ? 45 : 75)
            })
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: big ? 55 : 70)
            }
            .overlay(
                NavigationBar(title: "Contact", hasScrolled: $hasScrolled, search: .constant(false), showSearch: .constant(false), back: $windowManager.isContactDetailsSearch)
            )
        
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear{
                print(contact)
            }
            .onBack(perform:{
                windowManager.isContactDetails = false

            })
    }
    
    var dt: some View{
        ZStack{
            Color.theme.background
                .ignoresSafeArea()
            ScrollView{
                GeometryReader{reader -> AnyView in
                    
                    let yAxis=reader.frame(in: .global).minY
                    if yAxis < (hasBack ? 88 : 77) && !hasScrolled{
                        DispatchQueue.main.async {
                            withAnimation(.easeInOut) {
                                hasScrolled = true
                            }
                        }
                    }
                    if yAxis > (hasBack ? 88 : 77) && hasScrolled{
                        DispatchQueue.main.async {
                            withAnimation(.easeInOut) {
                                hasScrolled = false
                            }
                        }
                    }
                    return AnyView(
                        Color.clear.frame(width: 0, height: 0))
                    
                }
                VStack(spacing: 10) {
                    BigLetter(letter: String(contact.filterindex.prefix(1)), frame: 130, font: 96, color: Color.accentColor)
                    Text(contact.firstName + " " + contact.lastName)
                        .font(Font.custom("SFProDisplay-Regular", size: 25))
                    HStack{
                        Text("Select a number to search handshakes:")
                            .font(Font.custom("SFProDisplay-Regular", size: 20, relativeTo: .body))
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                        Spacer()
                    }
                    Button(action:{
                        withAnimation(){
                            windowManager.isContactDetailsSearch = false
                        }
                    }){
                        Text("Back")
                    }
                    Divider()
                    //                List(contact.telephone) { number in
                    ScrollView{
                        ForEach (contact.telephone){ number in
                            
                            Button{Task {}
                                
                            }
                        label: {
                            HStack{
                                NumberRow(number: number)
                                    .listRowBackground(Color.clear)
                                Spacer()
                            }
                        }
                        .padding()
                            
                        }
                        
                        
                    }
                    //                                    .listStyle(PlainListStyle())
                }
            }
            //            Spacer(minLength: 1000)
        }
    }
}

struct ContactDetailSearch_Previews: PreviewProvider {
    static var previews: some View {
        ContactDetail(contact: ContactsDataView().contacts[0], historyData: .constant(HistoryData()), windowManager: .constant(WindowManager()))
    }
}
