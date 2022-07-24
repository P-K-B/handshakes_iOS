//
//  NavigationBar.swift
//  Handshakes
//
//  Created by Kirill Burchenko on 27.11.2021.
//

import SwiftUI

struct NavigationBar: View {
    var title = ""
//    @AppStorage("selectedTab") var selectedTab: Tab = .search
//    @Binding var hasScrolled: Bool
    
    @Binding var search: Bool
//    @AppStorage("profile") var profile: Bool = false
    
    @State var showSearch: Bool
    @State var showProfile: Bool
    @State var hasBack: Bool
    
    @EnvironmentObject var historyData: HistoryDataView
    @EnvironmentObject var contactsData: ContactsDataView
    @EnvironmentObject var model: ChatScreenModel
    @EnvironmentObject var userData: UserDataView
    
//    @State var back: Tab?
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            Color.clear
                .background(.ultraThinMaterial)
            //                .blur(radius: 5)
                .mask(
                    LinearGradient(gradient: Gradient(stops: [
                        Gradient.Stop(color: Color(white: 0, opacity: 1),
                                      location: 0.8),
                        Gradient.Stop(color: Color(white: 0, opacity: 0),
                                      location: 1),
                    ]), startPoint: .top, endPoint: .bottom)
                )
//                .opacity(hasScrolled ? 1 : 0)
            
            VStack (alignment: .leading){
                if (hasBack){
                    Button(action:{
                        withAnimation(){
//                            selectedTab = back ?? .search
                            presentationMode.wrappedValue.dismiss()
                        }
                    }){
                        HStack(spacing: 10){
                            Image(systemName: "chevron.left")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15)
                                .foregroundColor(Color.accentColor) //Apply color for arrow only
                            Text(title)
                                .animatableFont(size: 36, weight: .bold)
                                .foregroundColor(.black)
                        }
                    }
                }
                else{
                    Text(title)
                        .animatableFont(size: 36, weight: .bold)
                }
                //                    .frame(maxWidth: .infinity, alignment: .leading)
                //                    .padding(.leading, 20)
                //                    .padding(.top, 30)
                //                    .offset(y: hasScrolled ? -4 : 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            .padding(.top, 30)
//            .background(.blue)
//            .offset(y: hasScrolled ? -4 : 0)
            
                
                HStack(spacing: 16) {
                    if (showSearch){
                        Button(action:{
                            self.search = true
                        }){
                            Image(systemName: "magnifyingglass")
                                .font(.body.weight(.bold))
                                .foregroundColor(Color.theme.accent)
                                .frame(width: 36, height: 36)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                                .background(Color.theme.input, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                                .strokeStyle(cornerRadius: 14)
                        }
                    }
                    if (showProfile){
                        
                        
                        NavigationLink(destination:
                                        Settings()
                            .environmentObject(userData)
                            .environmentObject(contactsData)
                            .environmentObject(historyData)
                            .environmentObject(model)
//                                                   SingleContactView2()
//                            .environmentObject(contacts)
//                            .environmentObject(historyData)
                        ) {  HStack{
                            Image(systemName: "person.crop.circle")
                                .font(.body.weight(.bold))
                                .foregroundColor(Color.theme.accent)
                            .frame(width: 36, height: 36)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .background(Color.theme.input, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .strokeStyle(cornerRadius: 14)
                        }
//                                    .background(.black)
                        }
                        .navigationViewStyle(.stack)

                        .foregroundColor(Color.black)
                        
                        
                        
                        
//                        Button(action:{
//
//                        }){
//                            Image(systemName: "person.crop.circle")
//                                .font(.body.weight(.bold))
//                                .foregroundColor(Color.theme.accent)
//                            .frame(width: 36, height: 36)
//                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
//                            .background(Color.theme.input, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
//                            .strokeStyle(cornerRadius: 14)
//                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 20)
                .padding(.top, 30)
//            }
        }
        .frame(height: 110)
        .frame(maxHeight: .infinity, alignment: .top)
//        .background(.red)
        .ignoresSafeArea()
    }
}

struct NavigationBar_Previews: PreviewProvider {
    
    static let debug: DebugData = DebugData()
    
    static let historyData: HistoryDataView = debug.historyData
    static let contactsData: ContactsDataView = debug.contactsData
    static let model: ChatScreenModel = debug.model
    static let userData: UserDataView = debug.userData
    
    static var previews: some View {
        NavigationBar(title: "Featured", search: .constant(false), showSearch: true, showProfile: true, hasBack: true)
            .environmentObject(historyData)
            .environmentObject(contactsData)
            .environmentObject(model)
            .environmentObject(userData)
    }
}
