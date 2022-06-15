//
//  NavigationBar.swift
//  Handshakes
//
//  Created by Kirill Burchenko on 27.11.2021.
//

import SwiftUI

struct NavigationBar: View {
    var title = ""
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    @Binding var hasScrolled: Bool
    
    @Binding var search: Bool
    @AppStorage("profile") var profile: Bool = false
    
    @Binding var showSearch: Bool
    
    @State var back: Tab?
    
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
                .opacity(hasScrolled ? 1 : 0)
            
            VStack (alignment: .leading){
                if (back != nil){
                    Button(action:{
                        withAnimation(){
                            selectedTab = back ?? .search
                        }
                    }){
                        HStack(spacing: 10){
                            Image(systemName: "chevron.left")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15)
                                .foregroundColor(Color.accentColor) //Apply color for arrow only
                            Text(title)
                                .animatableFont(size: hasScrolled ? 22 : 36, weight: .bold)
                                .foregroundColor(.black)
                        }
                    }
                }
                else{
                    Text(title)
                        .animatableFont(size: hasScrolled ? 22 : 36, weight: .bold)
                }
                //                    .frame(maxWidth: .infinity, alignment: .leading)
                //                    .padding(.leading, 20)
                //                    .padding(.top, 30)
                //                    .offset(y: hasScrolled ? -4 : 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            .padding(.top, 30)
            .offset(y: hasScrolled ? -4 : 0)
            
                
                HStack(spacing: 16) {
                    if (showSearch){
                        Button(action:{self.search = true}){
                            Image(systemName: "magnifyingglass")
                                .font(.body.weight(.bold))
                                .frame(width: 36, height: 36)
                                .foregroundColor(Color.theme.accent)
                                .background(Color.theme.input)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                                .strokeStyle(cornerRadius: 14)
                        }
                    }
                        Button(action:{self.profile = true}){
                            Image(systemName: "person.crop.circle")
                                .font(.body.weight(.bold))
                                .frame(width: 36, height: 36)
                                .foregroundColor(Color.theme.accent)
                                .background(Color.theme.input)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                                .strokeStyle(cornerRadius: 14)
                        }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 20)
                .padding(.top, 30)
                .offset(y: hasScrolled ? -4 : 0)
//            }
        }
        .frame(height: hasScrolled ? 110 : 134)
        .frame(maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea()
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(title: "Featured", hasScrolled: .constant(true), search: .constant(true), showSearch: .constant(true), back: .contacts)
    }
}
