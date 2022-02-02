//
//  ContactDetails.swift
//  Handshakes
//
//  Created by Kirill Burchenko on 29.11.2021.
//

import SwiftUI
import UIKit
import PhoneNumberKit

struct ContactDetail: View {
    
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("big") var big: Bool = false
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    
    var contact: FetchedContact
    
    @State var hasScrolled = false
    @Binding var historyData: HistoryData
    @Binding var windowManager: WindowManager
    @State var phoneNumber = String()
    @State private var validationError = false
    @State private var errorDesc = Text("")
    @State private var phoneField: PhoneNumberTextFieldView?
    @State private var validNumber: Bool = true
    @State private var code: String = ""
    let phoneNumberKit = PhoneNumberKit()
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
                NavigationBar(title: "Contact", hasScrolled: $hasScrolled, search: .constant(false), showSearch: .constant(false), back: $windowManager.isContactDetails)
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
                GeometryElement(hasScrolled: $hasScrolled, big: big, hasBack: hasBack)
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
                            windowManager.isContactDetails = false
                        }
                    }){
                        Text("Back")
                    }
                    Divider()
                    //                List(contact.telephone) { number in
                    ScrollView{
                        ForEach (contact.telephone){ number in
                            
                            Button{Task {
                                do{
                                    //                                    Send code
                                    let validatedPhoneNumber = try self.phoneNumberKit.parse(number.phone)
                                    print(validatedPhoneNumber)
                                    let number = self.phoneNumberKit.format(validatedPhoneNumber, toType: .international)
                                    withAnimation(){
                                        self.validNumber = true
                                        historyData.history.insert(SearchHistory(number:number), at: 0)
                                        historyData.save()
                                        windowManager.searchingNumberIndex=0
                                        windowManager.isSearchingNumber=true
                                        selectedTab = .search
                                        
                                        //                            }
                                    }
                                    
                                    let row = historyData.history[0]
                                    try API().GetPath(row: row){ (reses) in
                //                        print(reses)
                                        historyData.history[historyData.history.firstIndex(of: row)!] = reses
                                        historyData.save()
                                    }
//                                    try await API1234().Load(row: row) { (reses) in
//                                        historyData.history[historyData.history.firstIndex(of: row)!] = reses
//                                        historyData.save()
//                                    }
                                }
                                catch {
                                    self.validationError = true
                                    self.errorDesc = Text("Please enter a valid phone number")
                                }
                            }
                                
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
        .alert(isPresented: self.$validationError) {
            Alert(title: Text(""), message: self.errorDesc, dismissButton: .default(Text("OK")))
        }
    }
}

struct ContactDetail_Previews: PreviewProvider {
    static var previews: some View {
        ContactDetail(contact: ContactsDataView().contacts[0], historyData: .constant(HistoryData()), windowManager: .constant(WindowManager()))
    }
}

struct NumberRow: View {
    var number: Number
    
    var body: some View {
        HStack{
            Text ("\(number.title): \(number.phone)")
                .font(Font.custom("SFProDisplay-Regular", size: 20))
        }
    }
}

struct NumberRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NumberRow(number: ContactsDataView().contacts[0].telephone[0])
            //            ContactRow(contact: contacts[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
