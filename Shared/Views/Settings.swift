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
    /// Flag to open ContentView
    @AppStorage("ContentMode") var contentMode: Bool = false
    /// Flaf to open LoginHi view
    @AppStorage("LoginMode") var loginMode: Bool = false
    @Binding var alert: MyAlert
    
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
                    
                    .padding(.top, 10)
                    
                    .padding(.bottom, 10)
                    .background(.gray.opacity(0.3))
                    
                    ScrollView{
                        NumberRow(number: Number(id: 0, title: "Your number", phone: userData.data.number, uuid: ""))
                            .listRowBackground(Color.clear)
                            .padding(.horizontal, 10)
                            .padding(.top, 10)
                        VStack(alignment: .leading, spacing: 12){
                            VStack(alignment: .leading){
                                NavigationLink(destination: HideContacts(alert: $alert, root: false)
                                    .environmentObject(history)
                                    .environmentObject(contacts)
                                    .environmentObject(model)
                                    .environmentObject(userData)
                                ){
                                    HStack(alignment:.center){
                                        Text("Hide contacts")
//                                            .font(Font.system(size: 18, weight: .regular, design: .default))
                                            .myFont(font: MyFonts().Body, type: .display, color: Color.black, weight: .regular)
                                            .foregroundColor(.black)
                                        Image(systemName: "eye")
                                        Spacer()
                                    }
                                    
                                }
                                .padding(.leading, 13)
                                Divider()
                                NavigationLink(destination: EmptyView()
                                ){
                                    HStack(alignment:.center){
                                        Text("Edit profile")
//                                            .font(Font.system(size: 18, weight: .regular, design: .default))
//                                            .myFont(font: MyFonts().Body, type: .display, color: Color.black, weight: .regular)
                                            .myFont(font: MyFonts().Body, type: .display, color: Color("GrayDisabled"), weight: .regular)
                                        Image(systemName: "person")
                                        Spacer()
                                    }
                                }
                                .disabled(true)
                                .padding(.leading, 13)
                                Divider()
                            }
                            Button(action:{
                                alert = MyAlert(active: true, alert: Alert(title: Text("Delete history?"), message: Text("This will delete your search history."), primaryButton: .destructive(Text("Delete")) {
                                    history.reset()
                                },
                                secondaryButton: .cancel()))
                            }){
                                HStack(alignment:.center){
                                    Text("Clear search history")
//                                        .font(Font.system(size: 18, weight: .regular, design: .default))
                                        .myFont(font: MyFonts().Body, type: .display, color: Color.black, weight: .regular)
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                            }
                            .padding(.leading, 13)
                            Divider()
                            Button(action:{
                                alert = MyAlert(active: true, alert: Alert(title: Text("Delete chats?"), message: Text("This will delete all your chats."), primaryButton: .destructive(Text("Delete")) {
                                    model.reset()
                                },
                                secondaryButton: .cancel()))
                            }){
                                HStack(alignment:.center){
                                    Text("Clear chats")
//                                        .font(Font.system(size: 18, weight: .regular, design: .default))
                                        .myFont(font: MyFonts().Body, type: .display, color: Color.black, weight: .regular)
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                
                            }
                            .padding(.leading, 13)
                            Divider()
                            Button(action:{ResetButton()}){
                                HStack(alignment:.center){
                                    Text("Logout")
//                                        .font(Font.system(size: 18, weight: .regular, design: .default))
                                        .myFont(font: MyFonts().Body, type: .display, color: Color.black, weight: .regular)
                                        .foregroundColor(.black)
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                    Spacer()
                                }
                                
                            }
                            .padding(.leading, 13)
                            Divider()
                            Button(action:{
                                
                            }){
                                HStack(alignment:.center){
                                    Text("Delete account")
//                                        .font(Font.system(size: 18, weight: .regular, design: .default))
                                        .myFont(font: MyFonts().Body, type: .display, color: Color("GrayDisabled"), weight: .regular)
                                    Image(systemName: "trash")
                                    Spacer()
                                }
                            }
                            .disabled(true)
                            .padding(.leading, 13)
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
        alert = MyAlert(active: true, alert: Alert(title: Text("Logout?"), message: Text("This will reset all app data."), primaryButton: .destructive(Text("Logout")) {
            userData.reset()
            loginMode = true
            contentMode = false
        },
        secondaryButton: .cancel()))
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings(alert: .constant(MyAlert()))
            .environmentObject(DebugData().userData)
            .environmentObject(DebugData().contactsData)
            .environmentObject(DebugData().historyData)
            .environmentObject(DebugData().model)
    }
}
