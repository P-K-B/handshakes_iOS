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
            VStack(spacing: 0){
                VStack(spacing: 0){
                    //                                Head
                    //                    VStack{
                    //                        ZStack {
                    //                            VStack (alignment: .leading){
                    //                                HStack{
                    //                                    Button(action:{
                    //                                        withAnimation(){
                    //                                            presentationMode.wrappedValue.dismiss()
                    //                                        }
                    //                                    }){
                    //                                        HStack(spacing: 10){
                    //                                            Image(systemName: "chevron.left")
                    //                                                .resizable()
                    //                                                .aspectRatio(contentMode: .fit)
                    //                                                .frame(width: 15)
                    //                                                .foregroundColor(Color.accentColor) //Apply color for arrow only
                    //                                            Text("Profile")
                    //                                                .animatableFont(size: 36, weight: .bold)
                    //                                                .foregroundColor(.black)
                    //                                        }
                    //                                    }
                    //                                    Spacer()
                    //                                }
                    //                                .padding(.top, 30)
                    ////                                .background(.green)
                    //                            }
                    //                            .frame(maxWidth: .infinity, alignment: .leading)
                    //                            .padding(.leading, 20)
                    //                            .padding(.top, 30)
                    //                            //                    .offset(y: hasScrolled ? -4 : 0)
                    //                        }
                    ////                                                            .frame(height: 110, alignment: .top)
                    ////                                                            .frame(maxHeight: .infinity, alignment: .top)
                    //                        .ignoresSafeArea()
                    ////                        .background(.blue)
                    //                    }
                    
                    VStack (alignment: .leading){
                        //                    if (true){
                        Button(action:{
                            withAnimation(){
                                //                        selectedTab = .contacts
                                presentationMode.wrappedValue.dismiss()
                            }
                        }){
                            HStack(spacing: 5){
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 15)
                                    .foregroundColor(Color.accentColor) //Apply color for arrow only
                                Text("Profile")
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
                                    Text("First name")
                                        .font(Font.system(size: 24, weight: .bold, design: .default))
                                        .lineLimit(1)
                                    //                            }
                                    Spacer()
                                    Image("Logo")
                                        .resizable()
                                        .frame(width: 150, height: 150, alignment: .bottom)
                                    //                                        .frame(minWidth: 50, idealWidth: 150, maxWidth: 150, minHeight: 50, idealHeight: 150, maxHeight: 50, alignment: .bottom)
                                    //                                        .aspectRatio(contentMode: .fill)
                                }
                                .padding(.top, 10)
                                //                        .background(.red)
                                
                                Text("Last name")
                                    .font(Font.system(size: 24, weight: .bold, design: .default))
                                    .lineLimit(1)
                                
                            }
                            Spacer()
                        }
                        
                        .padding(.horizontal, 10)
                        
                    }
                    
                    .padding(.top, 20)
                    
                    .padding(.bottom, 10)
                    .background(.gray.opacity(0.3))
                    
                    
                    //                    .background(.red)
                    //                    Spacer(minLength: 20)
                    
                    ScrollView{
                        NumberRow(number: Number(id: 0, title: "Your number", phone: userData.data.number, uuid: ""))
                            .listRowBackground(Color.clear)
                            .padding(.horizontal, 10)
                            .padding(.top, 10)
                        
                        //            .background(.red)
                        
                        //            Spacer()
                        //                        VStack{
                        //                            Text("id: " + userData.data.id)
                        //                            Text("jwt: " + userData.data.jwt)
                        //                            Text("number: " + userData.data.number)
                        //                            Text("loggedIn: " + String(userData.data.loggedIn))
                        //                            Text("uuid: " + userData.data.uuid)
                        //                            Text("isNewUser: " + String(userData.data.isNewUser))
                        //                        }
//                        HStack(alignment:.bottom){
//                        Spacer()
                        VStack(alignment: .leading, spacing: 12){
                            VStack(alignment: .leading){
                                NavigationLink(destination: HideContacts(root: false)
                                    .environmentObject(history)
                                    .environmentObject(contacts)
                                    .environmentObject(model)
                                    .environmentObject(userData)
                                ){
                                    HStack(alignment:.center){
                                        Text("Hide contacts")
                                        //                                .buttonStyleLogin(fontSize: 20, color: Color.accentColor)
                                            .font(Font.system(size: 18, weight: .regular, design: .default))
                                            .foregroundColor(.black)
                                        Image(systemName: "eye")
                                    }
                                    
                                }
                                Divider()
                                NavigationLink(destination: HideContacts(root: false)
                                    .environmentObject(history)
                                    .environmentObject(contacts)
                                    .environmentObject(model)
                                    .environmentObject(userData)
                                ){
                                    HStack(alignment:.center){
                                        Text("Edit profile")
                                        //                                .buttonStyleLogin(fontSize: 20, color: Color.accentColor)
                                            .font(Font.system(size: 18, weight: .regular, design: .default))
                                        //                                    .foregroundColor(.black)
                                        Image(systemName: "person")
                                    }
                                }
                                .disabled(true)
                                Divider()
                            }
                            Button(action:{history.reset()}){
                                
                                HStack(alignment:.center){
                                    Text("Clear search history")
                                    //                                .buttonStyleLogin(fontSize: 20, color: Color.accentColor)
                                        .font(Font.system(size: 18, weight: .regular, design: .default))
                                        .foregroundColor(.black)
//                                    Image(systemName: "trash")
                                }
                            }
                            Divider()
                            Button(action:{model.reset()}){
                                HStack(alignment:.center){
                                    Text("Clear chats")
                                    //                                .buttonStyleLogin(fontSize: 20, color: Color.accentColor)
                                        .font(Font.system(size: 18, weight: .regular, design: .default))
                                        .foregroundColor(.black)
//                                    Image(systemName: "trash")
                                }
                                
                            }
                            Divider()
                            Button(action:{ResetButton()}){
                                HStack(alignment:.center){
                                    Text("Logout")
                                    //                                .buttonStyleLogin(fontSize: 20, color: Color.accentColor)
                                        .font(Font.system(size: 18, weight: .regular, design: .default))
                                        .foregroundColor(.black)
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                }
                                
                            }
                            Divider()
                            Button(action:{history.reset()}){
                                HStack(alignment:.center){
                                    Text("Delete account")
                                    //                                .buttonStyleLogin(fontSize: 20, color: Color.accentColor)
                                        .font(Font.system(size: 18, weight: .regular, design: .default))
                                    //                                    .foregroundColor(.black)
                                    Image(systemName: "trash")
                                }
                                
                            }
                            .disabled(true)
                            Divider()
                            //            NavigationLink(destination: HideContacts(showHide: $showHide, showHideAlert: $showHideAlert).environmentObject(userData).environmentObject(contacts).environmentObject(model).environmentObject(history), isActive: $showHide) { EmptyView() }
                            //            Button(action:{showHide = true}){
                            //                Text("Hide contacts")
                            //                    .buttonStyleLogin(fontSize: 20, color: Color.accentColor)
                            //            }
                            //                        NavigationLink(destination: InfoPageView()
                            //                            .environmentObject(userData)
                            //                            .environmentObject(contacts)
                            //                            .environmentObject(history)
                            //                            .environmentObject(model)
                            //                        ){
                            //                            Text("Info")
                            //                        }
                            //                        Button(action:{ResetButton()}){
                            //                            Text("Logout")
                            //                                .buttonStyleLogin(fontSize: 20, color: Color.accentColor)
                            //                        }
                            //                        Button(action:{selectedTab = .search}){
                            //                            Text("Back")
                            //                                .buttonStyleLogin(fontSize: 20, color: Color.accentColor)
                            //                        }
                            //            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 10)
//                        }
//                        .frame(maxHeight: .infinity, alignment: .leading)
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

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
            .environmentObject(DebugData().userData)
            .environmentObject(DebugData().contactsData)
            .environmentObject(DebugData().historyData)
            .environmentObject(DebugData().model)
    }
}
