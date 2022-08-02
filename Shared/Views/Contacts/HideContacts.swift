//
//  HideContacts.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 23.06.2022.
//

import SwiftUI

struct HideContacts: View {
    @State var searchText: String = ""
    //    @Binding var close: Bool
    //    @EnvironmentObject var contacts: ContactsDataView
    //    @Binding var selectedContact: String?
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    @State var hasScrolled: Bool = false
    @AppStorage("big") var big: Bool = IsBig()
    @State var hide: [String] = []
    @State var alert: MyAlert = MyAlert()
    //    @Binding var showHide: Bool
    //    @Binding var showHideAlert: Bool
//    @State var showHideAlertLoacl: Bool = false
    @AppStorage("showHideAlertLoacl") var showHideAlertLoacl: Bool = false
    @State var chansError: Bool = false
    @AppStorage("hideContacts") var hideContacts: Bool = false
    
    @EnvironmentObject var historyData: HistoryDataView
    @EnvironmentObject var contactsData: ContactsDataView
    @EnvironmentObject var model: ChatScreenModel
    @EnvironmentObject var userData: UserDataView
    
    @State var root: Bool
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    
    var body: some View {
        
        ZStack{
            
            VStack{
                ZStack {
                    VStack (alignment: .leading){
                        HStack{
                            //                            Text("\(showHideAlert ? "true" : "false")")
                            Button(action:{
                                withAnimation(){
                                    //                            selectedTab = back ?? .search
                                    if (hideContacts == false){
                                        contactsData.Upload(initial: true)
                                    }
                                    hideContacts = true
                                    if (root == true){
                                        selectedTab = .search
                                    }
                                    else{
                                        presentationMode.wrappedValue.dismiss()
                                    }

                                }
                            }){
                                HStack(spacing: 10){
                                    Image(systemName: "chevron.left")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 15)
                                        .foregroundColor(Color.accentColor) //Apply color for arrow only
                                    Text("Hide contacts")
                                        .animatableFont(size: 36, weight: .bold)
                                        .foregroundColor(.black)
                                }
                            }
                            
                            Spacer()
                            Button(action: {
                                //                                if (contacts.data.hide != hide){
                                //                                    contacts.ShowedHideTrue(){ res in
                                
                                //                                        close = false
                                //                                showHide = false
                                do{
                                    contactsData.updateHide(id: hide, upload: false, force: false){res in
                                        print("Hide result:")
                                        print(res)
                                        if (res == false){
                                            chansError = true
                                        }
                                        else{
                                            if (hideContacts == false){
                                                contactsData.Upload(initial: false)
                                            }
                                            hideContacts = true
                                            if (root == true){
                                                selectedTab = .search
                                            }
                                            else{
                                                presentationMode.wrappedValue.dismiss()
                                            }
                                            
                                        }
                                    }
                                }
                                
                                //                                    }
                                //                                    contacts.ShowedHideTrue()
                                //                                }
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
//                    .offset(y: hasScrolled ? -4 : 0)
                    
                    //            }
                }
                .frame(height: 74)
                
                ScrollViewReader { proxy in
                    SearchBarMy(searchText: $searchText)
                    ScrollView() {
                        LazyVStack (pinnedViews: .sectionHeaders){
                            ContactsSearchList
                        }
                    }
                }
            }
            

            .contentShape(Rectangle())
            
            .onTapGesture {
                self.endEditing()
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            //
        }
//        .background(.red)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .frame(maxHeight:.infinity)
        .onAppear{
            print(contactsData.data.updated)
            //            if (contacts.data.updated == false){
            //                contacts.Load(upload: false)
            //                print(contacts.data.contacts)
            //            }
            self.hide = contactsData.data.hide
            //            self.showHideAlertLoacl = self.showHideAlert
            if (hideContacts == false){
//                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
//                    showHideAlertLoacl = true
//                        }
                
                
            }
        }
        
        
//        .onDisappear{
//            if (hideContacts == false){
//                contactsData.Upload()
//                hideContacts = true
//            }
//        }
//        .alert(isPresented: $alert.error) {
//            if ((alert.oneButton) && (!alert.deleteChat)){
//                return Alert(
//                    title: Text(alert.title),
//                    message: Text(alert.text),
//                    dismissButton: .default(Text(alert.button))
//                )
//            }
//            else if ((alert.oneButton) && (alert.deleteChat)){
//                return Alert (
//                    title: Text(alert.title),
//                    message: Text(alert.text),
//                    dismissButton: .default(Text(alert.button),
//                                            action: {
//                                                //                                                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
//                                            })
//                    //                        secondaryButton: .default(Text(alert.button2))
//                )
//            }
//
//            else if (!alert.oneButton){
//                return Alert (
//                    title: Text(alert.title),
//                    message: Text(alert.text),
//                    primaryButton: .default(Text(alert.button),
//                                            action: {
//                                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
//                                            }),
//                    secondaryButton: .default(Text(alert.button2))
//                )
//            }
//            else{
//                return Alert(
//                    title: Text(alert.title),
//                    message: Text(alert.text),
//                    dismissButton: .default(Text(alert.button))
//                )
//            }
//        }
        
        
        .alert(isPresented: $chansError){
            return Alert (
                title: Text("Hide contacts"),
                message: Text("Some of the selected contacts are used in search chanis. If you hide them thouse chais will stop working."),
                primaryButton: .default(Text("Hide"),
                                        action: {
                                            do{
                                                contactsData.updateHide(id: hide, upload: false, force: true){res in
                                                    print("Hide result:")
                                                    print(res)
                                                    if (res == false){
                                                        chansError = true
                                                    }
                                                    else{
                                                        if (hideContacts == false){
                                                            contactsData.Upload(initial: false)
                                                        }
                                                        presentationMode.wrappedValue.dismiss()
                                                    }
                                                }
                                            }
                                        }),
                secondaryButton: .default(Text("Cancel"))
            )
        }
        
    }
    
    var ContactsSearchList: some View{
        LazyVStack{
            Text("\(contactsData.data.contacts.count)")
            //            Text("\(contacts.data.showedHide ? "true" : "false")")
            //
            //            if (contacts.data.contacts != nil){
            ForEach(contactsData.data.contacts
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
                                ContactRow(contact: contact, order: contactsData.order)
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
        //        }
        
    }
}

struct HideContacts_Previews: PreviewProvider {
    static let debug: DebugData = DebugData()
    
    static let historyData: HistoryDataView = debug.historyData
    static let contactsData: ContactsDataView = debug.contactsData
    static let model: ChatScreenModel = debug.model
    static let userData: UserDataView = debug.userData
    static var previews: some View {
        HideContacts(root: false)
            .environmentObject(historyData)
            .environmentObject(contactsData)
            .environmentObject(model)
            .environmentObject(userData)
    }
}
