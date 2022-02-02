//
//  SearchingView.swift
//  Handshakes
//
//  Created by Kirill Burchenko on 23.12.2021.
//

import SwiftUI

struct SearchingView: View {
    
    @Binding var searchingNumber: SearchHistory
    //    @Binding var isSearchingNumber: Bool
    @Binding var windowManager: WindowManager
    //    @Binding var historyData: HistoryData
    @GestureState private var dragOffset = CGSize.zero
    @State var big: Bool
    @State var hasScrolled = false
    @State private var hasBack: Bool = true
    @EnvironmentObject private var contactsManager: ContactsDataView
    @State var b: FetchedContact?
    
    
    
    var body: some View {
        if (!windowManager.isContactDetailsSearch){
            ZStack{
                Color.theme.background
                    .ignoresSafeArea()
                VStack{
                    
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
                        Text("Searching for:")
                            .font(Font.custom("SFProDisplay-Bold", size: 16))
                        Text(searchingNumber.number)
                            .font(Font.custom("SFProDisplay-Bold", size: 16))
                        VStack{
                            VStack{
                                Text ("You")
                                    .font(Font.custom("SFProDisplay-Bold", size: 16))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                            .background(Color.theme.input)
                            .cornerRadius(10)
                            .padding()
                            Image(systemName: "arrow.down")
                            if (searchingNumber.searching == false){
                                if (!searchingNumber.handhsakes!.isEmpty){
                                    
                                    ForEach(searchingNumber.handhsakes!, id: \.self)
                                    { shake_row in
                                        
                                        if (shake_row.count < 3){
                                            Text("This number is in your contacts list")
                                            let a = contactsManager.contacts.first(where: { $0.telephone.contains(where: {$0.phone == shake_row[1]})}) ?? nil
                                            VStack{
                                                HStack {
                                                    ContactRow(contact: a!)
                                                    Spacer()
                                                    Image(systemName: "chevron.right")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 7)
                                                        .foregroundColor(Color.accentColor) //Apply color for arrow only
                                                        .padding(.trailing, 5)
                                                }
                                                .padding(.horizontal, 15)
                                                .padding()
                                            }
                                            .background(Color.theme.input)
                                            .cornerRadius(10)
                                            .padding()
                                            
                                        }
                                    }
                                    
                                    
                                    Text("Contacts who may know this number:")
                                    
                                    
                                    
                                    VStack{
                                        ForEach(searchingNumber.handhsakes!, id: \.self)
                                        { shake_row in
                                            let a = shake_row.count
                                            Divider()
                                                ForEach(shake_row, id: \.self)
                                                { shake in
                                                    if (a > 2){
                                                    let index = shake_row.firstIndex(of: shake) ?? 0
                                                    if (index > 0 && index < a-1){
                                                        let a = contactsManager.contacts.first(where: { $0.telephone.contains(where: {$0.phone == shake})}) ?? nil
                                                        if a != nil{
                                                            Button (action:{
                                                                withAnimation{
                                                                    windowManager.contactDetailsIndex = contactsManager.contacts.firstIndex(of: a!)!
                                                                    windowManager.isContactDetailsSearch = true
                                                                }
                                                            }) {
                                                                HStack {
                                                                    ContactRow(contact: a!)
                                                                    
                                                                    Spacer()
                                                                    Image(systemName: "chevron.right")
                                                                        .resizable()
                                                                        .aspectRatio(contentMode: .fit)
                                                                        .frame(width: 7)
                                                                        .foregroundColor(Color.accentColor) //Apply color for arrow only
                                                                        .padding(.trailing, 5)
                                                                }
                                                                .padding(.horizontal, 15)
                                                                .padding()
                                                                
                                                                //                                                            if (a?.telephone.contains(where: {$0.phone == searchingNumber.number})){
                                                            }
                                                            .foregroundColor(.primary)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        
                                    }
                                    .background(Color.theme.input)
                                    .cornerRadius(10)
                                    .padding()
                                }
                                else{
                                    VStack{
                                        Text ("No handshakes found")
                                            .font(Font.custom("SFProDisplay-Bold", size: 16))
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                    }
                                    .background(Color.theme.input)
                                    .cornerRadius(10)
                                    .padding()
                                }
                            }
                            else{
                                VStack{
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                }
                                .background(Color.theme.input)
                                .cornerRadius(10)
                                .padding()
                            }
                            //                            if (searchingNumber.searching || searchingNumber.handhsakes!.count >= 3){
                            Image(systemName: "arrow.down")
                            VStack{
                                Text (searchingNumber.number)
                                    .font(Font.custom("SFProDisplay-Bold", size: 16))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                            .background(Color.theme.input)
                            .cornerRadius(10)
                            .padding()
                            //                            }
                        }
                        Button(action:{
                            withAnimation(){
                                windowManager.isSearchingNumber = false
                            }
                        }){
                            Text("Back")
                        }
                    }
                }
            }
            //        .onBack(perform:{
            //            windowManager.isSearchingNumber = false
            
            //        })
            .safeAreaInset(edge: .top, content: {
                Color.clear.frame(height: big ? 45 : 75)
            })
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: big ? 55 : 70)
            }
            .overlay(
                NavigationBar(title: "Search", hasScrolled: $hasScrolled, search: .constant(false), showSearch: .constant(false), back: $windowManager.isSearchingNumber)
                    .onAppear(){
                        print(searchingNumber)
                    }
            )
            
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onBack(perform:{
                windowManager.isSearchingNumber = false
                
            })
        }
        else{
            ContactDetailSearch(contact: contactsManager.contacts[windowManager.contactDetailsIndex], windowManager: $windowManager)
            
        }
    }
    
    
    private func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

struct SearchingView_Previews: PreviewProvider {
    static var previews: some View {
        SearchingView(searchingNumber: .constant(SearchHistory(number: "+7 916 009-81-09", date: Date(), res: true, searching: false, handhsakes: [["+7 916 009-81-09"]])), windowManager: .constant(WindowManager()), big: true)
            .environmentObject(ContactsDataView())
        
        //        SearchingView(searchingNumber: .constant(HistoryData().history[1]), windowManager: .constant(WindowManager()), historyData: .constant(HistoryData()))
        //        SearchingView(searchingNumber: .constant(HistoryData().history[2]), windowManager: .constant(WindowManager()), historyData: .constant(HistoryData()))
    }
}
