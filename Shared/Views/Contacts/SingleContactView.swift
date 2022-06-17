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
    @State var offset: CGFloat = 267
    
    var body: some View {
        
        VStack( spacing: 0){
            
            VStack (alignment: .leading){
                //                    if (true){
                Button(action:{
                    withAnimation(){
                        selectedTab = .contacts
                    }
                }){
                    HStack(spacing: 5){
                        Image(systemName: "chevron.left")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15)
                            .foregroundColor(Color.accentColor) //Apply color for arrow only
                        Text("Contacts")
                            .animatableFont(size: 20, weight: .bold)
                            .foregroundColor(.black)
                    }
                }
                .padding(.leading, 10)
                //
//                    Spacer()
                HStack{
                    VStack(alignment: .leading, spacing: 0){
                        HStack (alignment: .bottom){
//                            VStack{
//                                Spacer()
                        Text((contacts.order == 3) ? (contacts.selectedContact?.firstName == "" ? "" : ((contacts.selectedContact?.firstName ?? "") + " ")) : (contacts.selectedContact?.lastName == "" ? "" : ((contacts.selectedContact?.lastName ?? "") + " ")))
                            .font(Font.system(size: 24, weight: .bold, design: .default))
//                            }
                            Spacer()
                            Image("Logo")
                                .resizable()
                                .frame(width: 150, height: 150, alignment: .bottom)
                        }
                        .padding(.top, 10)
//                        .background(.red)
                        
                        Text((contacts.order == 3) ? (contacts.selectedContact?.lastName ?? "") : (contacts.selectedContact?.firstName ?? ""))
                            .font(Font.system(size: 24, weight: .bold, design: .default))
//                            .background(.blue)
                        
//                        if (contacts.order == 3){
//                            Text(contacts.selectedContact?.firstName == "" ? "" : ((contacts.selectedContact?.firstName ?? "") + " "))
//                                .font(Font.system(size: 24, weight: .bold, design: .default))
//                            Text(contacts.selectedContact?.lastName ?? "")
//                                .font(Font.system(size: 24, weight: .bold, design: .default))
//
//
//                        }
//                        else{
//                            Text(contacts.selectedContact?.lastName == "" ? "" : ((contacts.selectedContact?.lastName ?? "") + " "))
//                                .font(Font.system(size: 24, weight: .bold, design: .default))
//                            //                    .font(Font.custom("Inter-SemiBold", size: 40))
//                            Text(contacts.selectedContact?.firstName ?? "")
//                                .font(Font.system(size: 24, weight: .bold, design: .default))
//                        }
                    }
                    Spacer()
                }
                //                .frame(minWidth: .infinity)
//                .padding(.top, 10)
//                                    .padding(.bottom, 10)
                .padding(.horizontal, 10)
                
            }
//            .frame(maxWidth: .infinity, alignment: .leading)
            
                            .padding(.top, 20)
            //                .offset(y: 0)
            //                .background(.red)
            .padding(.bottom, 10)
            .background(.gray.opacity(0.3))

            
            ScrollView{
//                            GeometryElement(hasScrolled: $hasScrolled, big: big, hasBack: false)
                
                
                
                
                
                
                
//                GeometryReader{reader -> AnyView in
//                    let yAxis=reader.frame(in: .global).minY
//                                                        print(yAxis)
//                    DispatchQueue.main.async {
//                        withAnimation(.easeInOut) {
//                            offset = yAxis
//                        }
//                    }
//
//
//                    return AnyView(
//                        Color.clear.frame(width: 0, height: 0))
//                }
//                .frame(height: 0)
//                .background(.red)
                
                
                
                
                
                //                            .background(.blue)
                VStack(alignment: .leading) {
                    //                BigLetter(letter: String(contacts.selectedContact?.filterindex.prefix(1) ?? ""), frame: 130, font: 96, color: Color.accentColor)
                    
                    //                }
                    //                Text((contacts.selectedContact?.firstName ?? "") + " " + (contacts.selectedContact?.lastName ?? ""))
                    //                    .font(Font.custom("SFProDisplay-Regular", size: 25))
                    HStack(){
                        Spacer()
                        Text("Select a number to search handshakes:")
                            .font(Font.system(size: 18, weight: .thin, design: .default))
                        Spacer()
                    }
                    .padding(.vertical, 5)
                    //                .padding(.horizontal, 10)
                    .padding(.top, 20)
                    .padding(.bottom, 25)
                    //                Divider()
                    VStack (spacing: 25){
                        ForEach (contacts.selectedContact?.telephone ?? []){ number in
                            Button{Task {
                                withAnimation(){
                                    history.Add(number: number.phone)
                                }
                            }
                            }
                        label: {
                            HStack{
                                
                                NumberRow(number: number)
                                    .listRowBackground(Color.clear)
                                    .padding(.horizontal, 10)
                                //                        Spacer()
                            }
                        }
                            
                            //                .padding()
                            
                        }
                    }
                    //                ForEach (contacts.selectedContact?.guid ?? [], id: \.self){ number in
                    //
                    //
                    //                    HStack{
                    //                        Text(number)
                    //                    }
                    //
                    //                }
                    
                    
                    
                }
            }
//            .background(.red)
//            .padding(.top, 10)
//            .safeAreaInset(edge: .top, content: {
//                Color.clear.frame(height: 250)
//            })
//            .ignoresSafeArea()
            .onAppear{
                if ((contacts.selectedContact == nil) && (selectedTab == .singleContact)){
                    selectedTab = .contacts
                }
            }

            
//            ZStack {
//
//
//
//                //            }
//            }
//            .frame(height: hasScrolled ? 100: 200)
//            .frame(maxHeight: .infinity, alignment: .top)
            //            .background(.blue)
        }
//        .background(.blue)
    }
}

//struct SingleContactView_Previews: PreviewProvider {
//    static var previews: some View {
//        SingleContactView()
//    }
//}
