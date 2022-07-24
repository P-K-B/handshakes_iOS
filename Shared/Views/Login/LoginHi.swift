//
//  LoginHi.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 19.06.2022.
//

import SwiftUI

struct LoginHi: View {
    
    @Binding var alert: MyAlert
    @EnvironmentObject var historyData: HistoryDataView
    @EnvironmentObject var contactsData: ContactsDataView
    @EnvironmentObject var model: ChatScreenModel
    @EnvironmentObject var userData: UserDataView
    @State private var isShowingDetailView = false
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView{
            ZStack{
                //            .background(.red)
                VStack{
                    VStack{
                        HStack{
                            Spacer()
                            Image("Logo")
                                .resizable()
                                .frame(width: UIScreen.screenHeight/5, height: UIScreen.screenHeight/5, alignment: .center)
                                .padding()
                            //                    .offset(x: 40, y: 0)
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    VStack{
                        Text("Handshakes")
//                            .font(Font.system(size: .title, weight: .semibold, design: .default))
                            .font(.largeTitle).fontWeight(.semibold)
                        Text("People are closer, than you think")
//                            .font(Font.system(size: 20, weight: .regular, design: .default))
                            .font(.callout).fontWeight(.regular)
                            .frame(width: 200)
                            .multilineTextAlignment(.center)
                    }
                    .offset(x: 0, y: -50)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    VStack{
                        NavigationLink(destination: LoginView(alert: $alert)
                            .environmentObject(historyData)
                            .environmentObject(contactsData)
                            .environmentObject(model)
                            .environmentObject(userData), isActive: $isShowingDetailView) { EmptyView() }
                        
                        Button {
                            Task {
                                isShowingDetailView = true
                            }
                        } label: {
                            Text("Sign in")
                                .buttonStyleLogin(fontSize: 20, color: Color.accentColor)
                        }
                        .padding()
                        
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                }
            }
            .navigationBarHidden(true)
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
        }
    }
}

struct LoginHi_Previews: PreviewProvider {
    static var previews: some View {
        LoginHi(alert: .constant(MyAlert()))
            .environmentObject(DebugData().userData)
    }
}
