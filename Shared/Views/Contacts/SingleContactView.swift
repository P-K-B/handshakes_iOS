//
//  SingleContactView.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 26.05.2022.
//

import SwiftUI


struct SingleContactView2: View {
    
    //    @State var contact: FetchedContact
    @EnvironmentObject var historyData: HistoryDataView
    @EnvironmentObject var contactsData: ContactsDataView
    @EnvironmentObject var model: ChatScreenModel
    @EnvironmentObject var userData: UserDataView
    @State var hasScrolled: Bool = false
    @AppStorage("big") var big: Bool = IsBig()
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    @State var offset: CGFloat = 267
    @State var selectedContact: FetchedContact
    
    @State var active: Bool = false
    
    @Binding var alert: MyAlert
    
    
    
    //    Navigation
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack( spacing: 0){
            
            VStack (alignment: .leading){
                Button(action:{
                    withAnimation(){
                        presentationMode.wrappedValue.dismiss()
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
                
                HStack{
                    VStack(alignment: .leading, spacing: 0){
                        HStack (alignment: .bottom){
                            Text((contactsData.order == 3) ? (selectedContact.firstName == "" ? "" : ((selectedContact.firstName ) + " ")) : (selectedContact.lastName == "" ? "" : ((selectedContact.lastName ) + " ")))
                                .font(Font.system(size: 24, weight: .bold, design: .default))
                            //                            }
                            Spacer()
                            Image("Logo")
                                .resizable()
                                .frame(width: 150, height: 150, alignment: .bottom)
                        }
                        .padding(.top, 10)
                        Text((contactsData.order == 3) ? (selectedContact.lastName ) : (selectedContact.firstName ))
                            .font(Font.system(size: 24, weight: .bold, design: .default))
                        
                    }
                    Spacer()
                }
                
                .padding(.horizontal, 10)
                
            }
            
            .padding(.top, 20)
            
            .padding(.bottom, 10)
            .background(.gray.opacity(0.3))
            
            
            ScrollView{
                VStack(alignment: .leading) {
                    
                    HStack(){
                        Spacer()
                        Text("Select a number to search handshakes:")
                            .font(Font.system(size: 18, weight: .thin, design: .default))
                        Spacer()
                    }
                    .padding(.vertical, 5)
                    .padding(.top, 20)
                    .padding(.bottom, 25)
                    VStack (spacing: 25){
                        ForEach (selectedContact.telephone ?? []){ number in
                            NavigationLink(destination: SingleSearchView2(alert: $alert)
                                .environmentObject(historyData)
                                .environmentObject(contactsData)
                                .environmentObject(model)
                                .environmentObject(userData)
                            )
                            {
                                HStack{
                                    NumberRow(number: number)
                                        .listRowBackground(Color.clear)
                                        .padding(.horizontal, 10)
                                }
                            }
                            .navigationViewStyle(.stack)
                            .foregroundColor(Color.black)
                            .simultaneousGesture(TapGesture().onEnded{
                                historyData.Add(number: number.phone)
                            })
                            
                        }
                    }
                    
                    
                }
            }
            
        }
        .myBackGesture()
        .navigationBarHidden(true)
    }
}


struct SingleContactView2_Previews: PreviewProvider {
    
    static let debug: DebugData = DebugData()
    
    static let historyData: HistoryDataView = debug.historyData
    static let contactsData: ContactsDataView = debug.contactsData
    static let model: ChatScreenModel = debug.model
    static let userData: UserDataView = debug.userData
    
    static var previews: some View {
        SingleContactView2(selectedContact: contactsData.data.contacts[0], alert: .constant(MyAlert()))
            .environmentObject(historyData)
            .environmentObject(contactsData)
            .environmentObject(model)
            .environmentObject(userData)
    }
}
