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
    @Binding var alert: MyAlert
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
    
    @State var prev: Bool = false
    
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    
    var body: some View {
        
        ZStack{
            
            VStack{
                ZStack {
                    VStack (alignment: .leading){
                        HStack{
                            Button(action:{
                                withAnimation(){
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
//                                        .animatableFont(size: 36, weight: .bold)
                                        .myFont(font: MyFonts().LargeTitle, type: .display, color: Color.black, weight: .bold)
                                        .foregroundColor(.black)
                                }
                            }
                            
                            Spacer()
                            Button(action: {
                                do{
                                    contactsData.updateHide(id: hide, upload: false, force: false){res in
                                        print("Hide result:")
                                        print(res)
                                        if (res == false){
//                                            chansError = true
                                            alert = MyAlert(active: true, alert: Alert(title: Text("Hide contacts"), message: Text("Some of the selected contacts are used in search chanis. If you hide them thouse chais will stop working."), primaryButton: .default(Text("Hide")) {
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
                                            },
                                            secondaryButton: .cancel()))
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

                            }, label: {
                                Text("Save")
//                                    .font(Font.system(size: 18, weight: .regular, design: .default))
                                    .myFont(font: MyFonts().Body, type: .display, color: ColorTheme().accent, weight: .regular)
                            })
//                            .padding()
                        }
//                        .padding(.top, 30)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
//                    .padding(.top, 20)
                }
//                .frame(height: 110)
//                .ignoresSafeArea()
                
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
                                else{
                                    LazyVStack(spacing: 0){
                                        Text("Random text")
                                            .frame(width: 0, height: 0)
    //                                    ContactsList
                                        ContactsSearchList
                                        
                                    }
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
        .myBackGesture()
        //        .background(.red)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .frame(maxHeight:.infinity)
        .onAppear{
            //            print(contactsData.data.updated)
            self.hide = contactsData.data.hide
            if (hideContacts == false){
                
                //                selectedTab = .hide
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    alert = MyAlert(active: true, alert: Alert(title: Text("Hide contacts!"), message: Text("This app need to upload your contacts to be able to build search chanis. You can hide some contacts if you'd like.\nYou can always change this list in the setting"), dismissButton: .default(Text("Ok").foregroundColor(Color.red))))
                }
                //                    hideContactsSelector = true
                //                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                //                        showHideAlertLoacl = true
                //                    }
                
            }
        }
        
//        .alert(isPresented: $chansError){
//            return Alert (
//                title: Text("Hide contacts"),
//                message: Text("Some of the selected contacts are used in search chanis. If you hide them thouse chais will stop working."),
//                primaryButton: .default(Text("Hide"),
//                                        action: {
//                                            do{
//                                                contactsData.updateHide(id: hide, upload: false, force: true){res in
//                                                    print("Hide result:")
//                                                    print(res)
//                                                    if (res == false){
//                                                        chansError = true
//                                                    }
//                                                    else{
//                                                        if (hideContacts == false){
//                                                            contactsData.Upload(initial: false)
//                                                        }
//                                                        presentationMode.wrappedValue.dismiss()
//                                                    }
//                                                }
//                                            }
//                                        }),
//                secondaryButton: .default(Text("Cancel"))
//            )
//        }
        
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
                                    alert = MyAlert(active: true, alert: Alert(title: Text("Limit"), message: Text("Maximum number of hidden contacts achieved"), dismissButton: .default(Text("Ok")) {
//                                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                                    }))

                                    //                                                alert = MyAlert(error: true, title: "", text: "Maximum number of hidden contacts achieved", button: "Ok", oneButton: true)
                                    //                                                alert = MyAlert(error: true, title: "", text: "Please enter a valid phone number", button: "Ok", oneButton: true)
                                }
                            }
                        }, label: {
                            HStack{
                                ContactRow(contact: contact, order: contactsData.order)
                                Spacer()
                                Image(systemName: hide.contains(contact.id) ? "checkmark.square" : "square")
                                    .foregroundColor(hide.contains(contact.id) ? Color.theme.accent : Color.secondary)
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
    
    
    
    
    
    
//    {
//
//        VStack{
//
//            if ((!contactsData.checkAccess()) && (!self.prev)){
//                VStack{
//                    Button(action:{
//                        if (!contactsData.checkAccess()){
//                            //                            alert = MyAlert(error: true, title: "Contacts access required.", text: "Go to Settings?", button: "Settings", button2: "Cancel", oneButton: false)
//                        }
//                        else{
//                            //                        contacts = ContactsData()
//                        }
//                    }){
//                        Text ("Fetch contacts")
//                    }
//                }
//                //                .frame(width: geometry.size.width)      // Make the scroll view full-width
//                //                            .frame(minHeight: geometry.size.height)
//            }
//            else{
//                //                            debugTime
//                //                            GeometryElement(hasScrolled: $hasScrolled, big: big, hasBack: false)
//                //                            Text("\(contacts.data.contacts.count)")
//                //                            Text("\(contacts.data.letters.count)")
//
//                if (contactsData.data.loaded){
//                    if (!contactsData.data.updated){
//                        Text ("Updating")
//                            .onDisappear{
//                                print("2")
//                            }
//                    }
//                    LazyVStack{
//                        Text("\(contactsData.data.contacts.count)")
//                        //            Text("\(contacts.data.showedHide ? "true" : "false")")
//                        //
//                        //            if (contacts.data.contacts != nil){
//                        ForEach(contactsData.data.contacts
//                            .filter { searchText.isEmpty || $0.longSearch.localizedStandardContains(searchText)}
//
//                        )
//                        { contact in
//                            VStack{
//                                HStack {
//                                    Button(action: {
//                                        if (hide.contains(contact.id)){
//                                            hide.remove(at: hide.firstIndex(where: {$0 == contact.id}) ?? 0)
//                                            //                                contacts.removeHide(id: contact.id)
//                                        }
//                                        else{
//                                            if (hide.count < 5){
//                                                hide.append(contact.id)
//                                                //                                    contacts.addHide(id: contact.id)
//                                            }
//                                            else{
//                                                //                                                alert = MyAlert(error: true, title: "", text: "Maximum number of hidden contacts achieved", button: "Ok", oneButton: true)
//                                                //                                                alert = MyAlert(error: true, title: "", text: "Please enter a valid phone number", button: "Ok", oneButton: true)
//                                            }
//                                        }
//                                    }, label: {
//                                        HStack{
//                                            ContactRow(contact: contact, order: contactsData.order)
//                                            Spacer()
//                                            Image(systemName: hide.contains(contact.id) ? "checkmark.square" : "square")
//                                                .foregroundColor(hide.contains(contact.id) ? Color.theme.accent : Color.secondary)
//                                            //                                    .onTapGesture {
//                                            //
//                                            //                                    }
//                                                .font(Font.custom("SFProDisplay-Regular", size: 20))
//
//                                        }
//                                    })
//                                    .foregroundColor(.black)
//                                    .padding(.leading, 13)
//
//
//
//                                }
//                                Divider()
//
//                            }
//                            .padding(.horizontal, 10)
//                            .padding(.vertical, 3)
//                            .id(contact.index)
//                        }
//                    }
//
//                }
//                else{
//                    Text("Loading")
//                }
//            }
//        }
//
//
//
//
//        //        }
//
//    }
}

struct HideContacts_Previews: PreviewProvider {
    static let debug: DebugData = DebugData()
    
    static let historyData: HistoryDataView = debug.historyData
    static let contactsData: ContactsDataView = debug.contactsData
    static let model: ChatScreenModel = debug.model
    static let userData: UserDataView = debug.userData
    static var previews: some View {
        HideContacts(alert: .constant(MyAlert()), root: false)
            .environmentObject(historyData)
            .environmentObject(contactsData)
            .environmentObject(model)
            .environmentObject(userData)
    }
}
