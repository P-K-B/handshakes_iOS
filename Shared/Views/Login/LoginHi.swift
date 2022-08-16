//
//  LoginHi.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 19.06.2022.
//

import SwiftUI

struct LoginHi: View {
    
    /// Main app data
    ///
    /// Alert object
    @Binding var alert: MyAlert
    /// Search history data
    @EnvironmentObject var historyData: HistoryDataView
    /// Data about user's contacts
    @EnvironmentObject var contactsData: ContactsDataView
    /// Chat data
    @EnvironmentObject var model: ChatScreenModel
    /// Data about user
    @EnvironmentObject var userData: UserDataView
    
    /// View data
    ///
    /// Flaf to open LoginView
    @State private var isShowingDetailView = false
    
    var body: some View {
        ZStack{
            VStack{
                /// Logo in upper right corner
                VStack{
                    HStack{
                        Spacer()
                        Image("Logo")
                            .resizable()
                            .frame(width: UIScreen.screenHeight/5, height: UIScreen.screenHeight/5, alignment: .center)
                            .padding()
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                /// Main text
                VStack{
                    Text("Handshakes")
//                        .font(.largeTitle).fontWeight(.semibold)
                        .myFont(font: MyFonts().LargeTitle, type: .rounded, color: Color.black, weight: .semibold)
//                        .font(Font.custom("SFProRounded-Regular", size: 20))
                    Text("People are closer, than you think")
//                        .font(.callout).fontWeight(.regular)
                        .myFont(font: MyFonts().Headline, type: .rounded, color: Color.black, weight: .light)
                        .frame(width: 200)
                        .multilineTextAlignment(.center)
                }
                .offset(x: 0, y: -50)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                /// Sing in button
                VStack{
                    NavigationLink(destination: LoginView(alert: $alert)
                        .environmentObject(historyData)
                        .environmentObject(contactsData)
                        .environmentObject(model)
                        .environmentObject(userData), isActive: $isShowingDetailView)
                    { Text("Sign in")
                            .buttonStyleLogin(fontSize: 20, color: ColorTheme().accent)
                            .myFont(font: MyFonts().Callout, type: .display, color: Color.black, weight: .regular)
                            .padding()
                        
                    }
                    
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
        }
        /// Background circles
        .background(ZStack{
            Circle()
                .fill(Color.theme.myYellow)
                .frame(width: UIScreen.screenHeight/2, height: UIScreen.screenHeight/2, alignment: .center)
                .offset(x: -UIScreen.screenWidth/2 + UIScreen.screenHeight/2/10, y: UIScreen.screenHeight/2 - UIScreen.screenHeight/2/4)
            
            Circle()
                .fill(Color.theme.myBlur)
                .frame(width: UIScreen.screenWidth/6, height: UIScreen.screenWidth/6, alignment: .center)
                .offset(x: 80, y: 100)
            
            Circle()
                .fill(Color.theme.myGray)
                .frame(width: UIScreen.screenWidth/3, height: UIScreen.screenWidth/3, alignment: .center)
                .offset(x: UIScreen.screenWidth/2-UIScreen.screenWidth/20, y: UIScreen.screenHeight/2-UIScreen.screenWidth/3)
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity))
        .navigationBarHidden(true)
    }
}

struct LoginHi_Previews: PreviewProvider {
    static let debug: DebugData = DebugData()
    
    static let historyData: HistoryDataView = debug.historyData
    static let contactsData: ContactsDataView = debug.contactsData
    static let model: ChatScreenModel = debug.model
    static let userData: UserDataView = debug.userData
    static var previews: some View {
        NavigationView{
            Group{
                LoginHi(alert: .constant(MyAlert()))
                    .environmentObject(historyData)
                    .environmentObject(contactsData)
                    .environmentObject(model)
                    .environmentObject(userData)
                    .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
                LoginHi(alert: .constant(MyAlert()))
                    .environmentObject(historyData)
                    .environmentObject(contactsData)
                    .environmentObject(model)
                    .environmentObject(userData)
                    .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
            }
        }
    }
}
