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
        
            VStack(spacing: 0){
                VStack(spacing: 0){
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
                                Text("Profile")
                                    .animatableFont(size: 20, weight: .bold)
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.leading, 10)
                        HStack{
                            VStack(alignment: .leading, spacing: 0){
                                HStack (alignment: .bottom){
                                    Text("First name")
                                        .font(Font.system(size: 24, weight: .bold, design: .default))
                                        .lineLimit(1)
                                    Spacer()
                                    Image("Logo")
                                        .resizable()
                                        .frame(width: 150, height: 150, alignment: .bottom)
                                }
                                .padding(.top, 10)
                                
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
                    
                    ScrollView{
                        NumberRow(number: Number(id: 0, title: "Your number", phone: userData.data.number, uuid: ""))
                            .listRowBackground(Color.clear)
                            .padding(.horizontal, 10)
                            .padding(.top, 10)
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
                                            .font(Font.system(size: 18, weight: .regular, design: .default))
                                            .foregroundColor(.black)
                                        Image(systemName: "eye")
                                        Spacer()
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
                                            .font(Font.system(size: 18, weight: .regular, design: .default))
                                        Image(systemName: "person")
                                        Spacer()
                                    }
                                }
                                .disabled(true)
                                Divider()
                            }
                            Button(action:{history.reset()}){
                                
                                HStack(alignment:.center){
                                    Text("Clear search history")
                                        .font(Font.system(size: 18, weight: .regular, design: .default))
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                            }
                            Divider()
                            Button(action:{model.reset()}){
                                HStack(alignment:.center){
                                    Text("Clear chats")
                                        .font(Font.system(size: 18, weight: .regular, design: .default))
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                
                            }
                            Divider()
                            Button(action:{ResetButton()}){
                                HStack(alignment:.center){
                                    Text("Logout")
                                        .font(Font.system(size: 18, weight: .regular, design: .default))
                                        .foregroundColor(.black)
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                    Spacer()
                                }
                                
                            }
                            Divider()
                            Button(action:{history.reset()}){
                                HStack(alignment:.center){
                                    Text("Delete account")
                                        .font(Font.system(size: 18, weight: .regular, design: .default))
                                    Image(systemName: "trash")
                                    Spacer()
                                }
                                
                            }
                            .disabled(true)
                            Divider()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 10)
                    }
                }
            }
            .navigationBarHidden(true)
            .myBackGesture()
    }
    
    func ResetButton(){
        userData.reset()
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
