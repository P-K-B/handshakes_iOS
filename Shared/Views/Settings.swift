//
//  Settings.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 28.06.2022.
//

import SwiftUI

struct Settings: View {
    @EnvironmentObject var userData: UserDataView
    @EnvironmentObject var contacts: ContactsDataView
    @EnvironmentObject var history: HistoryDataView
    @EnvironmentObject private var model: ChatScreenModel
    
    //    @Binding var showHide: Bool
    //    @Binding var showHideAlert: Bool
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    @AppStorage("big") var big: Bool = IsBig()
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView{
            VStack{
                VStack{
                    //                                Head
                    VStack{
                        ZStack {
                            VStack (alignment: .leading){
                                HStack{
                                    Button(action:{
                                        withAnimation(){
                                            presentationMode.wrappedValue.dismiss()
                                        }
                                    }){
                                        HStack(spacing: 10){
                                            Image(systemName: "chevron.left")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 15)
                                                .foregroundColor(Color.accentColor) //Apply color for arrow only
                                            Text("Profile")
                                                .animatableFont(size: 36, weight: .bold)
                                                .foregroundColor(.black)
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.top, 30)
//                                .background(.green)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                            .padding(.top, 30)
                            //                    .offset(y: hasScrolled ? -4 : 0)
                        }
//                                                            .frame(height: 110, alignment: .top)
//                                                            .frame(maxHeight: .infinity, alignment: .top)
                        .ignoresSafeArea()
//                        .background(.blue)
                    }
                    
//                    .background(.red)
                    
                    ScrollView{
                        
                        //            .background(.red)
                        
                        //            Spacer()
                        VStack{
                            Text("id: " + userData.data.id)
                            Text("jwt: " + userData.data.jwt)
                            Text("number: " + userData.data.number)
                            Text("loggedIn: " + String(userData.data.loggedIn))
                            Text("uuid: " + userData.data.uuid)
                            Text("isNewUser: " + String(userData.data.isNewUser))
                        }
                        NavigationLink(destination: HideContacts()
                            .environmentObject(history)
                            .environmentObject(contacts)
                            .environmentObject(model)
                            .environmentObject(userData)
                        ){
                            Text("Hide contacts")
                                .buttonStyleLogin(fontSize: 20, color: Color.accentColor)
                        }
                        //            NavigationLink(destination: HideContacts(showHide: $showHide, showHideAlert: $showHideAlert).environmentObject(userData).environmentObject(contacts).environmentObject(model).environmentObject(history), isActive: $showHide) { EmptyView() }
                        //            Button(action:{showHide = true}){
                        //                Text("Hide contacts")
                        //                    .buttonStyleLogin(fontSize: 20, color: Color.accentColor)
                        //            }
                        NavigationLink(destination: InfoPageView()
                            .environmentObject(userData)
                            .environmentObject(contacts)
                            .environmentObject(history)
                            .environmentObject(model)
                        ){
                            Text("Info")
                        }
                        Button(action:{ResetButton()}){
                            Text("Logout")
                                .buttonStyleLogin(fontSize: 20, color: Color.accentColor)
                        }
                        Button(action:{selectedTab = .search}){
                            Text("Back")
                                .buttonStyleLogin(fontSize: 20, color: Color.accentColor)
                        }
                        //            Spacer()
                    }
                }
                //                        .frame(maxHeight:.infinity)
                //                        .background(.red)
                
                //        .overlay(
                //            NavigationBar(title: "Profile", search: .constant(false), showSearch: false, showProfile: false, hasBack: true)
                //                .environmentObject(history)
                //                .environmentObject(contacts)
                //                .environmentObject(model)
                //                .environmentObject(userData)
                //
                //        )
                //                        .navigationBarHidden(true)
                //                        .navigationBarBackButtonHidden(true)
            }
//            .safeAreaInset(edge: .top, content: {
//                Color.clear.frame(height: big ? 45: 75)
//            })
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            
            
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
        
        
    }
    
    func ResetButton(){
        userData.reset()
        //        contacts.reset()
    }
}

//struct Settings_Previews: PreviewProvider {
//    static var previews: some View {
//        Settings()
//            .environmentObject(DebugData().userData)
//            .environmentObject(DebugData().contactsData)
//            .environmentObject(DebugData().historyData)
//            .environmentObject(DebugData().model)
//    }
//}
