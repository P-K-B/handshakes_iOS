//
//  TabBar.swift
//  Handshakes
//
//  Created by Kirill Burchenko on 27.11.2021.
//

import SwiftUI

struct TabBar: View {
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    @State var big: Bool = true
    @AppStorage("TabColor") var color: Color = Color.theme.accent
    @State var tabItemWidth: CGFloat = 0
    @EnvironmentObject var model: ChatScreenModel
    
    var body: some View {
        HStack {
            buttons
        }
        .padding(.horizontal, 8)
        .padding(.top, 14)
        .frame(height: big ? 88 : 70, alignment: .top)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: big ? 34 : 0, style: .continuous))
        .cornerRadius(big ? 0 : 34, corners: [.topLeft, .topRight])
        .background(
            background
        )
        .overlay(
            overlay
        )
        .frame(maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .onAppear{
            big = (wphone() > 3) ? true : false
        }
    }
    
    var buttons: some View {
        ForEach(tabItems) { item in
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedTab = item.tab
                    color = item.color
                }
            } label: {
                VStack(spacing: 0) {
                    let u = model.chats.allChats.filter({$0.value.contains(where: {(($0.read != true) && ($0.is_sender != true))})})
                    if ((item.tab == .chats) && (u.count > 0)){
                        ZStack{
                            Image(systemName: item.icon)
                                .symbolVariant(.fill)
                                .font(.body.bold())
                                .frame(width: 44, height: 29)
                                .blendMode(selectedTab == item.tab ? .overlay : .normal)
                            Circle()
                                .fill(Color.theme.accent)
                                .frame(width: 10, height: 10, alignment: .center)
                                .offset(x: 8, y: -8)
                        }
                    }
                    else{
                        Image(systemName: item.icon)
                            .symbolVariant(.fill)
                            .font(.body.bold())
                            .frame(width: 44, height: 29)
                            .blendMode(selectedTab == item.tab ? .overlay : .normal)
                    }
                    Text(item.text)
                        .font(.caption2)
                    //                            .myFont(font: MyFonts().Caption2, type: .display, color: Color.black, weight: .regular)
                        .lineLimit(1)
                        .blendMode(selectedTab == item.tab ? .overlay : .normal)
                }
                .frame(maxWidth: .infinity)
            }
            .foregroundStyle(selectedTab == item.tab ? .primary : .secondary)
            //            .blendMode(selectedTab == item.tab ? .overlay : .normal)
            .overlay(
                GeometryReader { proxy in
                    //                            Text("\(proxy.size.width)")
                    Color.clear.preference(key: TabPreferenceKey.self, value: proxy.size.width)
                }
            )
            .onPreferenceChange(TabPreferenceKey.self) { value in
                tabItemWidth = value
            }
        }
    }
    
    var background: some View {
        HStack {
            if selectedTab == .search { Spacer() }
            if ((selectedTab == .chats) ) { Spacer() }
            Circle().fill(color).frame(width: tabItemWidth)
            if selectedTab == .search { Spacer() }
            if ((selectedTab == .contacts) ) { Spacer() }
        }
        .padding(.horizontal, 8)
    }
    
    var overlay: some View {
        HStack {
            if selectedTab == .search { Spacer() }
            if ((selectedTab == .chats) ) { Spacer() }
            Rectangle()
                .fill(color)
                .frame(width: 28, height: 5)
                .cornerRadius(3)
                .frame(width: tabItemWidth)
                .frame(maxHeight: .infinity, alignment: .top)
            if selectedTab == .search { Spacer() }
            if ((selectedTab == .contacts)) { Spacer() }
        }
        .padding(.horizontal, 8)
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
        TabBar()
            .previewDevice("Iphone 8 Plus")
    }
}
