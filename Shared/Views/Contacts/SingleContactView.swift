//
//  SingleContactView.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 26.05.2022.
//

import SwiftUI

struct SingleContactView: View {
    
    //    @State var contact: FetchedContact
    @EnvironmentObject var contacts: ContactsDataView
    @EnvironmentObject var history: HistoryDataView
    @State var hasScrolled: Bool = false
    @AppStorage("big") var big: Bool = IsBig()
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    
    var body: some View {
        ScrollView{
            GeometryElement(hasScrolled: $hasScrolled, big: big, hasBack: false)
            VStack(spacing: 10) {
                BigLetter(letter: String(contacts.selectedContact?.filterindex.prefix(1) ?? ""), frame: 130, font: 96, color: Color.accentColor)
                Text((contacts.selectedContact?.firstName ?? "") + " " + (contacts.selectedContact?.lastName ?? ""))
                    .font(Font.custom("SFProDisplay-Regular", size: 25))
                HStack{
                    Text("Select a number to search handshakes:")
                        .font(Font.custom("SFProDisplay-Regular", size: 20, relativeTo: .body))
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                    Spacer()
                }
                Divider()
                
                ForEach (contacts.selectedContact?.telephone ?? []){ number in
                    Button{Task {
//                        do{
                            //                                    Send code
//                            let validatedPhoneNumber = try self.phoneNumberKit.parse(self.phoneNumber)
//                            let number = self.phoneNumberKit.format(validatedPhoneNumber, toType: .international)
                            withAnimation(){
//                                selectedHistory = history.Add(number: number)
                                history.Add(number: number.phone)
                                
        //                        sleep(1)
        //                        print(history.datta)
        //                        print(history.selectedHistory)
        //                        selectedTab = .singleSearch
        //                        history.save()
                            }
//                        }
//                        catch {
//                            alert = MyAlert(error: true, title: "", text: "Please enter a valid phone number", button: "Ok")
//                        }
                    }
                    }
                label: {
                    HStack{
                        
                        NumberRow(number: number)
                            .listRowBackground(Color.clear)
//                        Spacer()
                    }
                }
                    
                    //                .padding()
                    
                }
                
                ForEach (contacts.selectedContact?.guid ?? [], id: \.self){ number in
                    
                    
                    HStack{
                        Text(number)
                    }
                    
                }
                
            }
            //                                    .listStyle(PlainListStyle())
        }
        .overlay(
            NavigationBar(title: "Contact", hasScrolled: $hasScrolled, search: .constant(false), showSearch: .constant(false), back: .contacts)
        )
        .onAppear{
            if ((contacts.selectedContact == nil) && (selectedTab == .singleContact)){
                selectedTab = .contacts
            }

        }
    }
}

//struct SingleContactView_Previews: PreviewProvider {
//    static var previews: some View {
//        SingleContactView()
//    }
//}
