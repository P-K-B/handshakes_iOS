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
//                            VStack{
//                                Text ("You")
//                                    .font(Font.custom("SFProDisplay-Bold", size: 16))
//                                    .frame(maxWidth: .infinity)
//                                    .padding()
//                            }
//                            .background(Color.theme.input)
//                            .cornerRadius(10)
//                            .padding()
//                            Image(systemName: "arrow.down")
                            
                            if (searchingNumber.searching == false){
                                if (searchingNumber.handhsakes != nil){
                                    if (!searchingNumber.handhsakes!.isEmpty){
//                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(alignment: .center, spacing: 30){
                                                ForEach(searchingNumber.handhsakes!, id: \.self) { shake_row in
//                                                    if (shake_row.depth < 3){
//                                                        ForEach(shake_row.path[0], id: \.self){shake_path in
//
////                                                            Text(shake_path)
//                                                            let index = contactsManager.contacts.enumerated().filter{$0.element.telephone.contains(where: {$0.phone == shake_path})}.map{ $0.offset }
//                                                            VStack{
//                                                                Text("You know this number as:")
//                                                                ForEach(index, id: \.self) {ind in
//                                                                    //
//                                                                    Res(windowManager: $windowManager, ind: ind)
//                //                                                        .environmentObject(<#T##T#>)
//                                                                }
////                                                                Text (searchingNumber.number)
////                                                                    .font(Font.custom("SFProDisplay-Bold", size: 16))
////                                                                    .frame(maxWidth: .infinity)
////                                                                    .padding()
//
//
//                                                            }
//                                                            .background(Color.theme.input)
//                                                            .cornerRadius(10)
//                                                            .padding()
//                                                        }
//                                                    }
//                                                    if (shake_row.depth == 3){
                                                        ForEach(shake_row.path, id: \.self){p in
                                                            ForEach(p, id: \.self){shake_path in
//
//                                                                Text(shake_path)
                                                                let index = contactsManager.contacts.enumerated().filter{$0.element.telephone.contains(where: {$0.phone == shake_path})}.map{ $0.offset }
                                                                if (!index.isEmpty){
                                                                    ForEach(index, id: \.self) {ind in
                                                                    VStack{
                                                                        
                                                                        if (shake_row.depth == 2){
                                                                            Text("You know this number as:")
                                                                        }
                                                                        else{
                                                                            Text("This people may know:")
                                                                        }
//
                                                                        
                                                                            //
                                                                            Res(windowManager: $windowManager, ind: ind)
                        //                                                        .environmentObject(<#T##T#>)
//                                                                        }
        //                                                                Text (searchingNumber.number)
        //                                                                    .font(Font.custom("SFProDisplay-Bold", size: 16))
        //                                                                    .frame(maxWidth: .infinity)
        //                                                                    .padding()

                                                                        }
//                                                                    }
                                                                    .frame(width: 250, height: 400, alignment: .center)
                                                                    .background(Color.theme.input)
                                                                    .cornerRadius(10)
//                                                                    .padding()
                                                                    }
                                                            }
                                                            }
                                                        }
//                                                    }
                                                }
                                                    
//                                            }
                                        }
                                            .modifier(ScrollingHStackModifier(items: searchingNumber.handshakes_lines, itemWidth: 250, itemSpacing: 30))
                                    }
                                }
                                else{
                                    VStack{
                                        Text ("No handshakes found")
                                            .font(Font.custom("SFProDisplay-Bold", size: 16))
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                        if (searchingNumber.res == false){
                                            Text (searchingNumber.error)
                                                .font(Font.custom("SFProDisplay-Bold", size: 16))
                                                .frame(maxWidth: .infinity)
                                                .padding()
                                        }
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
                            //                            Image(systemName: "arrow.down")
                            //                            VStack{
                            //                                Text (searchingNumber.number)
                            //                                    .font(Font.custom("SFProDisplay-Bold", size: 16))
                            //                                    .frame(maxWidth: .infinity)
                            //                                    .padding()
                            //                            }
                            //                            .background(Color.theme.input)
                            //                            .cornerRadius(10)
                            //                            .padding()
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
            .frame(maxWidth: UIScreen.main.bounds.size.width)
            //        .onBack(perform:{
            //            windowManager.isSearchingNumber = false
            
            //        })
            .onAppear{
                print(contactsManager.contacts[0].guid[0])
            }
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
            ContactDetailSearch(contact: contactsManager.contacts.first(where: {$0.id == windowManager.contactDetailsIndex})!, windowManager: $windowManager)
            
        }
        
    }

    
//    var Res (Int: ind): some View{
//
//    }
    
    private func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

struct SearchingView_Previews: PreviewProvider {
    static var previews: some View {
        SearchingView(searchingNumber: .constant(SearchHistory(number: "+7 916 009-81-09", date: Date(), res: true, searching: false)), windowManager: .constant(WindowManager()), big: true)
            .environmentObject(ContactsDataView())
        
        //        SearchingView(searchingNumber: .constant(HistoryData().history[1]), windowManager: .constant(WindowManager()), historyData: .constant(HistoryData()))
        //        SearchingView(searchingNumber: .constant(HistoryData().history[2]), windowManager: .constant(WindowManager()), historyData: .constant(HistoryData()))
    }
}

struct Res : View {
    @Binding var windowManager: WindowManager
    var ind: Int
    @EnvironmentObject private var contactsManager: ContactsDataView

    var body: some View {
        VStack{
            let a = contactsManager.contacts[ind]
            Button (action:{
                withAnimation{
                    windowManager.contactDetailsIndex = a.id
                    windowManager.isContactDetailsSearch = true
                }
            }) {
                HStack {
                    ContactRow(contact: a)
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
        }

    }
}
