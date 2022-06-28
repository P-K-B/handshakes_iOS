//
//  SearchHistory.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 29.05.2022.
//

import SwiftUI
import PhoneNumberKit

struct SearchList: View, KeyboardReadable {
    
    //    App data
    @Binding var alert: MyAlert
    @EnvironmentObject var history: HistoryDataView
    
    //    view data
    @State var hasScrolled: Bool = false
    @AppStorage("big") var big: Bool = IsBig()
    @State var selectedHistory: UUID?
//    @State var search: Bool = false
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    
    
    let phoneNumberKit = PhoneNumberKit()
    @State private var phoneField: PhoneNumberTextFieldView?
    @State private var phoneNumber = String()
    @State private var validNumber: Bool = false
    @State var welcomeText: String = "Enter phone number to search:"
    @State private var isKeyboardVisible = false


    
    var body: some View {
        //        lazyV
//        VStack{
            hardV
            .onTapGesture {
                self.endEditing()
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: isKeyboardVisible ? 0 : (big ? 55: 70))
            }
//        }
//            .onAppear{
//                if (history.datta.count < 5){
//                history.Add(number: "\(UUID())")
//                }
//            }
    }
    
       
    
    var numberField: some View{
        self.phoneField
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
            .keyboardType(.phonePad)
            .padding(.horizontal, 15)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding()
    }
    
    var inputRow: some View{
        VStack{
            Text(welcomeText)
                .font(Font.custom("SFProDisplay-Regular", size: 20))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            numberField
                .onReceive(keyboardPublisher) { newIsKeyboardVisible in
                                print("Is keyboard visible? ", newIsKeyboardVisible)
                                isKeyboardVisible = newIsKeyboardVisible
                            }
            Button{Task {
                do{
                    //                                    Send code
                    let validatedPhoneNumber = try self.phoneNumberKit.parse(self.phoneNumber)
                    let number = self.phoneNumberKit.format(validatedPhoneNumber, toType: .international)
                    withAnimation(){
                        selectedHistory = history.Add(number: number)
                        
//                        sleep(1)
//                        print(history.datta)
//                        print(history.selectedHistory)
//                        selectedTab = .singleSearch
//                        history.save()
                    }
                }
                catch {
                    alert = MyAlert(error: true, title: "", text: "Please enter a valid phone number", button: "Ok", oneButton: true)
                }
            }
            }
        label: {
            Text("Search")
                .frame(minWidth: 70)
                .padding(.vertical, 10)
                .padding(.horizontal, 30)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(100)
        }
        .padding()
        }
        .onAppear{
            self.phoneField = PhoneNumberTextFieldView(phoneNumber: $phoneNumber, isEdeted: $validNumber, maxDigits: 16)
        }
    }
    
    var hardV: some View{
        ZStack{
            //            if (windowManager.isContactDetails == false){
            ZStack{
                Color.theme.background
                    .ignoresSafeArea()
                VStack{
                    inputRow
                    Divider()
                    GeometryReader { geometry in

                    ScrollView() {
                        //                            debugTime
//                        GeometryElement(hasScrolled: $hasScrolled, big: big, hasBack: false)
                        if (history.datta.count > 0){
                        if (history.updated){
                                //                                ForEach(contacts.data.contacts){ contact in
                                //                                    HStack() {
                            HistoryRows
                            //                                    }
                            //                                }
                        }
                        else{
                            Text("Loading")
                        }
                        }
                       
                    
                    else{
                        VStack{
                       Text("Search history is empty")
                                .font(Font.system(size: 16, weight: .light, design: .default))
                        }
                        .frame(width: geometry.size.width)      // Make the scroll view full-width
                                    .frame(minHeight: geometry.size.height)
                            
                    }
                    }
            }
                }
                    .overlay(
                        NavigationBar(title: "Search", hasScrolled: $hasScrolled, search: .constant(false), showSearch: false, showProfile: true)
                    )
            }
        }
    }
    
    var HistoryRows: some View{
        LazyVStack(){
//            ForEach(contacts.data.letters, id: \.self) { letter in
//                Section(header: SectionLetter(text:letter)) {
            ForEach(history.datta) { search in
                        ZStack{
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
                                        history.selectedHistory = search.id
//                                        print(history.selectedHistory)
                                        selectedTab = .singleSearch
                                    }
                                }, label: {
                                    HStack{
                                        HistoryRow(history: search)
//                                            .onAppear{
//                                                if (search.id == selectedHistory){
//                                                    withAnimation(){
////                                                        history.selectedHistory = search.id
////                                                        print(history.selectedHistory)
//                                                        selectedTab = .singleSearch
//                                                    }
//                                                }
//                                            }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 7)
                                            .foregroundColor(Color.accentColor) //Apply color for arrow only
                                            .padding(.trailing, 5)
                                    }
                                })
                                .foregroundColor(.black)
                                
                            }
                            .padding(.horizontal, 15)
                            //                            }
                            //                            .foregroundColor(.primary)
                            
//                        }
//                    }
                        }
                }
            }
                
//            }
//        }
    }
}

//struct SearchList_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchList()
//    }
//}
