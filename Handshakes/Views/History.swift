//
//  History.swift
//  Handshakes
//
//  Created by Kirill Burchenko on 16.12.2021.
//

import SwiftUI
import UIKit
import PhoneNumberKit

struct History: View {
    
    @Binding var historyData: HistoryData
    
    @State var phoneNumber = String()
    @State private var validationError = false
    @State private var errorDesc = Text("")
    @State private var phoneField: PhoneNumberTextFieldView?
    @State private var validNumber: Bool = true
    @State private var code: String = ""
    
    
    let phoneNumberKit = PhoneNumberKit()
    
    @State var hasScrolled = false
    @State var search: Bool = false
    @State var big: Bool
    
    let dispatchGroup = DispatchGroup()
    
    @State private var hasBack: Bool = false

    
    
    @State var welcomeText: String = "Enter phone number to search:"
    
    
    @Binding var windowManager: WindowManager
    @AppStorage("selectedTab") var selectedTab: Tab = .search

    @EnvironmentObject private var contactsManager: ContactsDataView

    
    var body: some View {
        if (!windowManager.isSearchingNumber){
            ZStack {
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
                    .frame(height: 0)
                    hv
                }
                .safeAreaInset(edge: .top, content: {
                    Color.clear.frame(height: big ? 45: 75)
                })
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: big ? 55: 70)
                }
                .overlay(
                    NavigationBar(title: "Featured", hasScrolled: $hasScrolled, search: $search, showSearch: .constant(false), back: .constant(false))
                )
                .onTapGesture {
                    self.endEditing()
                }
                
            }
        }
        else{
            SearchingView(searchingNumber: $historyData.history[windowManager.searchingNumberIndex], windowManager: $windowManager, big: big)
        }
    }
    
    var hv : some View {
        
        VStack(){
            Text(welcomeText)
                .font(Font.custom("SFProDisplay-Regular", size: 20))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            phoneField
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                .keyboardType(.phonePad)
            
                .padding(.horizontal, 15)
                .background(Color.theme.input)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .padding()
            Button{Task {
                do{
                    //                                    Send code
                    let validatedPhoneNumber = try self.phoneNumberKit.parse(self.phoneNumber)
                    let number = self.phoneNumberKit.format(validatedPhoneNumber, toType: .international)
                    withAnimation(){
                        self.validNumber = true
                        historyData.history.insert(SearchHistory(id:UUID(),number:number, date:Date(), res: false, searching: true), at: 0)
                        historyData.save()
                        windowManager.searchingNumberIndex=0
                        windowManager.isSearchingNumber=true
                        selectedTab = .search
                    }
                    let row = historyData.history[0]
                    try API().GetPath(row: row, contactsManager: contactsManager){ (reses) in
//                        print(reses)
                        historyData.history[historyData.history.firstIndex(of: row)!] = reses
                        historyData.save()
                    }
//                    try await API1234().Load(row: row) { (reses) in
//                        historyData.history[historyData.history.firstIndex(of: row)!] = reses
//                        historyData.save()
//                    }
                }
                catch {
                    self.validationError = true
                    self.errorDesc = Text("Please enter a valid phone number")
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
            HStack(){
                Text("Search history:")
                    .font(Font.custom("SFProDisplay-Regular", size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Button(action:{
                    withAnimation(){
                        historyData.history = []
                        historyData.save()
                    }
                }){
                    Text("Clear")
                        .font(Font.custom("SFProDisplay-Regular", size: 16))
                        .frame(minWidth: 30)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 15)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(100)
                }
            }
            .padding()
            
            if (historyData.history.count > 0){
                ForEach(historyData.history)
                { row in
                    Button(action:{
                        withAnimation(){
                            windowManager.searchingNumberIndex = historyData.history.firstIndex(of: row)!
                            windowManager.isSearchingNumber=true
                        }
                    }){
                        HistoryRow(search: row)
                        .onDelete(perform:{
                            historyData.history.remove(at: historyData.history.firstIndex(of: row)!)
                            historyData.save()
                        })
                            
                    }
                    
                }
                
               
                
            }
        }
        .onAppear {
            self.phoneField = PhoneNumberTextFieldView(phoneNumber: self.$phoneNumber, isEdeted: self.$validNumber)
        }
        .alert(isPresented: self.$validationError) {
            Alert(title: Text(""), message: self.errorDesc, dismissButton: .default(Text("OK")))
        }
        
    }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
    
    func removeItems() {
        // You now know which category to delete from and at which index
    }
    
    
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        History(historyData: .constant(HistoryData()), big: false, windowManager: .constant(WindowManager()))
    }
}


struct HistoryRow: View {
    var search: SearchHistory
    
    var body: some View {
        HStack() {
            Text(search.number)
            Spacer()
            if (search.searching == true){
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
            else{
                Image(systemName: search.res ? "checkmark.circle" : "xmark.circle")
            }
        }
        .font(Font.custom("SFProDisplay-Regular", size: 16))
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
    }
}

