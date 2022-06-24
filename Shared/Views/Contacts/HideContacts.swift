//
//  HideContacts.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 23.06.2022.
//

import SwiftUI

struct HideContacts: View {
    @State var searchText: String = ""
    @Binding var close: Bool
    @EnvironmentObject var contacts: ContactsDataView
    @Binding var selectedContact: String?
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    @State var hasScrolled: Bool = false
    @AppStorage("big") var big: Bool = IsBig()
    @State var hide: [String] = []
    @State var alert: MyAlert = MyAlert()

    
    
    var body: some View {
        
        ZStack{
            
            VStack{
                ZStack {
                    VStack (alignment: .leading){
                        HStack{
                        Text("Search")
//                                .font(Font.system(size: 36, weight: .bold, design: .default))
                            .animatableFont(size: hasScrolled ? 22 : 36, weight: .bold)
                            Spacer()
                            Button(action: {
                                if (contacts.data.hide != hide){
                                    contacts.updateHide(id: hide)
                                }
                                close = false
                            }, label: {
                                Text("Save")
                                    .font(Font.system(size: 18, weight: .regular, design: .default))
//                                    .padding()
                            })
                            .padding()
                        }
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
                            ContactsSearchList
                        }
                    }
                }
            }
            .onTapGesture {
                self.endEditing()
            }
            //
        }
        .onAppear{
            self.hide = contacts.data.hide
        }
        .alert(isPresented: $alert.error) {
            if ((alert.oneButton) && (!alert.deleteChat)){
                return Alert(
                    title: Text(alert.title),
                    message: Text(alert.text),
                    dismissButton: .default(Text(alert.button))
                )
            }
            else if ((alert.oneButton) && (alert.deleteChat)){
                return Alert (
                    title: Text(alert.title),
                    message: Text(alert.text),
                    dismissButton: .default(Text(alert.button),
                                            action: {
//                                                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                                            })
//                        secondaryButton: .default(Text(alert.button2))
                )
            }
                
            else if (!alert.oneButton){
                return Alert (
                    title: Text(alert.title),
                    message: Text(alert.text),
                    primaryButton: .default(Text(alert.button),
                                            action: {
                                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                                            }),
                    secondaryButton: .default(Text(alert.button2))
                )
            }
            else{
                return Alert(
                    title: Text(alert.title),
                    message: Text(alert.text),
                    dismissButton: .default(Text(alert.button))
                )
            }
        }
        
    }
    
    var ContactsSearchList: some View{
        LazyVStack{
            //
            ForEach(contacts.data.contacts
                .filter { searchText.isEmpty || $0.longSearch.localizedStandardContains(searchText)}
                    
            )
            { contact in
                VStack{
                    HStack {
                        Button(action: {
                            if (hide.contains(contact.id)){
                                hide.remove(at: hide.firstIndex(where: {$0 == contact.id}) ?? 0)
//                                contacts.removeHide(id: contact.id)
                            }
                            else{
                                if (hide.count < 5){
                                hide.append(contact.id)
//                                    contacts.addHide(id: contact.id)
                                }
                                else{
                                    alert = MyAlert(error: true, title: "", text: "Maximum number of hidden contacts achieved", button: "Ok", oneButton: true)
//                                                alert = MyAlert(error: true, title: "", text: "Please enter a valid phone number", button: "Ok", oneButton: true)
                                }
                            }
                        }, label: {
                            HStack{
                                ContactRow(contact: contact, order: contacts.order)
                                Spacer()
                                Image(systemName: hide.contains(contact.id) ? "checkmark.square" : "square")
                                    .foregroundColor(hide.contains(contact.id) ? Color.theme.accent : Color.secondary)
//                                    .onTapGesture {
//
//                                    }
                                    .font(Font.custom("SFProDisplay-Regular", size: 20))
                                
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
        
    }
}

//struct HideContacts_Previews: PreviewProvider {
//    static var previews: some View {
//        HideContacts()
//    }
//}
