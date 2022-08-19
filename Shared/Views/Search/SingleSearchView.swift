//
//  SingleSearchView.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 29.05.2022.
//

import SwiftUI

struct Grid_test: View{
    var body: some View{
        ScrollView(.horizontal){
            HStack(spacing: 100){
                Text("1")
                Text("2")
                Text("3")
                Text("4")
                Text("5")
                Text("6")
            }
        }
    }
}

struct OneMore: View{
    
    var a: [FetchedContact]
    var i: Int
    var m: Int
    var order: Int
    @State var colors: [Color] = [Color.green, Color.blue, Color.pink]
    
    var body: some View{
        VStack{
            ZStack{
                if (i == m){
                    BigLetter(letter: String(a[0].filterindex.prefix(1)), frame: 60, font: 24, color: Color.theme.accent)
                }
                else{
                    BigLetter(letter: String(a[0].filterindex.prefix(1)), frame: 60, font: 24, color: colors[mloop(index: i-1)])
                }
                if (a.count > 1){
                    BigLetter(letter: String("+" + String(a.count - 1)), frame: 16, font: 10, color: Color.blue)
                        .offset(x: 25, y: -25)
                }
            }
        }
    }
    
    
    func mloop(index: Int) -> Int{
        return index % self.colors.count
    }
}

struct OneMore2: View{
    
    var c: Int
    var i: Int
    @State var colors: [Color] = [Color.green, Color.blue, Color.pink]
    
    var body: some View{
        VStack{
            if (i < (c - 1)){
                BigLetter(letter: String("S"), frame: 60, font: 24, color: colors[mloop(index: i-1)])
                ContactRowN(string: "Someone")
            }
            else{
                BigLetter(letter: String("S"), frame: 60, font: 24, color: Color.theme.accent)
                ContactRowN(string: "Number")
            }
        }
    }
    
    
    func mloop(index: Int) -> Int{
        return index % self.colors.count
    }
}


struct Grid_old: View{
    @EnvironmentObject var history: HistoryDataView
    @EnvironmentObject var contacts: ContactsDataView
    @State var handshake: SearchPathDecoded
    @EnvironmentObject private var model: ChatScreenModel
    @EnvironmentObject var userData: UserDataView
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    @State var moreContacts: Bool = false
    @State var oneContact: Bool = false
    @State var extra: [FetchedContact] = []
    @State var openContact: FetchedContact?
    @Binding var alert: MyAlert
    
    
    
    
    var body: some View{
        HStack{
            Spacer()
            VStack{
                let c: Int = handshake.path.count
                ForEach (0..<(c-1), id:\.self){i in
                    let path = handshake.path[i]
                    let a = contacts.data.contacts.filter({$0.telephone.contains(where: {$0.phone == path.number})})
                    let aLast = contacts.data.contacts.filter({$0.telephone.contains(where: {$0.phone == handshake.path[c-1].number})})
                    if (c == 2){
                        OneMore3(i: i+1, c: c)
                        ContactRow(contact: aLast[0], order: contacts.order )
                    }
                    if (i > 0){
                        if (path.number != ""){
                            
                            OneMore3(i: i, c: c)
                            if (i == 1){
                                if (aLast.count > 0){
                                    ContactRow(contact: aLast[0], order: contacts.order )
                                }
                                else{
                                    Text(history.datta.first(where: {$0.id == history.selectedHistory})?.number ?? "")
                                        .font(Font.system(size: 18, weight: .regular, design: .default))
                                }
                            }
                            
                            if (a.count > 0){
                                
                                VStack(){
//                                    Text("\(i)")
//                                    Text("\(c)")
                                    if (i == (c - 1)){
                                        ContactRow(contact: a[0], order: contacts.order )
                                    }
                                    else{
                                        VStack{
                                            OneMore4(i: i, a: a, c: c, alert: $alert, handshake: handshake, path: path)
                                                .environmentObject(history)
                                                .environmentObject(contacts)
                                                .environmentObject(model)
                                                .environmentObject(userData)
//                                            if (i == 1){
//                                                NavigationLink(destination:
//                                                                ChatScreen(alert: $alert)
//                                                    .environmentObject(history)
//                                                    .environmentObject(contacts)
//                                                    .environmentObject(model)
//                                                    .environmentObject(userData)
//                                                )
//                                                {
//                                                    VStack {
//                                                        OneMore(a: a, i: i, m: c - 1, order: contacts.order)
//                                                        ContactRow(contact: a[0], order: contacts.order )
//                                                    }
//                                                    .background(.red)
//
//                                                }
//                                                .navigationViewStyle(.stack)
//                                                .foregroundColor(Color.black)
//                                                .simultaneousGesture(TapGesture().onEnded{
//                                                    model.OpenChat(chat: handshake.path_id+path.guid)
//                                                    model.toGuid = path.guid
//                                                    model.addChat(a: handshake.path_id+path.guid)
//                                                    model.send(text: "", searchGuid: handshake.path_id, toGuid: path.guid, meta: Meta(number: history.datta.first(where: {$0.id == history.selectedHistory})?.number ?? "", asking_number: userData.data.number, res: path.number, chain: handshake.path_id))
//                                                    model.send(text: "Searching info about number \(history.datta.first(where: {$0.id == history.selectedHistory})?.number ?? "")", searchGuid: handshake.path_id, toGuid: path.guid, meta: nil)
//
//                                                })
//                                            }
//                                            else{
//                                                VStack {
//                                                    OneMore(a: a, i: i, m: c - 1, order: contacts.order)
//                                                    ContactRow(contact: a[0], order: contacts.order )
//                                                }
//                                            }
                                        }
                                        .frame(width: 300, height: 125, alignment: .center)
                                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 34, style: .continuous))
                                    }
                                }
                                .padding(.bottom, 10)
                            }
                        }
                        else{
                            VStack{
                                NavigationLink(destination:
                                                ChatScreen(alert: $alert)
                                    .environmentObject(history)
                                    .environmentObject(contacts)
                                    .environmentObject(model)
                                    .environmentObject(userData)
                                )
                                {
                                    HStack {
                                        OneMore2(c: c, i: i)
                                    }
                                }
                                .navigationViewStyle(.stack)
                                .foregroundColor(Color.black)
                                .simultaneousGesture(TapGesture().onEnded{
                                    model.OpenChat(chat: handshake.path_id+path.guid)
                                    model.toGuid = path.guid
                                    model.addChat(a: handshake.path_id+path.guid)
                                    model.send(text: "", searchGuid: handshake.path_id, toGuid: path.guid, meta: Meta(number: history.datta.first(where: {$0.id == history.selectedHistory})?.number ?? "", asking_number: userData.data.number, res: path.number, chain: handshake.path_id))
                                    model.send(text: "Searching info about number \(history.datta.first(where: {$0.id == history.selectedHistory})?.number ?? "")", searchGuid: handshake.path_id, toGuid: path.guid, meta: nil)
                                    
                                })
                            }
                            .frame(width: 300, height: 125, alignment: .center)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 34, style: .continuous))
                            
                            
                            .padding(.bottom, 10)
                        }
                    }
                    
                }
            }
            Spacer()
            
        }
        .font(Font.custom("SFProDisplay-Regular", size: 20))
        .popover(isPresented: $moreContacts) {
            MoreContacts(allContacts: $extra)
                .environmentObject(history)
                .environmentObject(contacts)
                .environmentObject(model)
                .environmentObject(userData)
        }
        .popover(isPresented: $oneContact) {
            OneContact(oneContact: $openContact)
                .environmentObject(history)
                .environmentObject(contacts)
                .environmentObject(model)
                .environmentObject(userData)
        }
        
    }
    
    
    
}

struct OneMore4: View{

    let i: Int
    let a: [FetchedContact]
    let c: Int
    @Binding var alert: MyAlert
    @State var handshake: SearchPathDecoded
    @State var path: SearchPathDecodedPath
    
    @EnvironmentObject var history: HistoryDataView
    @EnvironmentObject var contacts: ContactsDataView
    @EnvironmentObject private var model: ChatScreenModel
    @EnvironmentObject var userData: UserDataView

    var body: some View{
        if ((i == 1) || (i == c - 2)){
            NavigationLink(destination:
                            ChatScreen(alert: $alert)
                .environmentObject(history)
                .environmentObject(contacts)
                .environmentObject(model)
                .environmentObject(userData)
            )
            {
                VStack {
                    OneMore(a: a, i: i, m: c - 1, order: contacts.order)
                    ContactRow(contact: a[0], order: contacts.order )
                    Text("Tap to chat")
//                        .padding()
                        .myFont(font: MyFonts().Footnote, type: .display, color: ColorTheme().accent, weight: .regular)
//                        .padding()
                }
//                .background(.red)

            }
            .navigationViewStyle(.stack)
            .foregroundColor(Color.black)
            .simultaneousGesture(TapGesture().onEnded{
                model.OpenChat(chat: handshake.path_id+path.guid)
                model.toGuid = path.guid
                model.addChat(a: handshake.path_id+path.guid)
                model.send(text: "", searchGuid: handshake.path_id, toGuid: path.guid, meta: Meta(number: history.datta.first(where: {$0.id == history.selectedHistory})?.number ?? "", asking_number: userData.data.number, res: path.number, chain: handshake.path_id))
                model.send(text: "Searching info about number \(history.datta.first(where: {$0.id == history.selectedHistory})?.number ?? "")", searchGuid: handshake.path_id, toGuid: path.guid, meta: nil)

            })
        }
        else{
            VStack {
                OneMore(a: a, i: i, m: c - 1, order: contacts.order)
                ContactRow(contact: a[0], order: contacts.order )
            }
        }
    }
}

struct OneContact: View{
    @EnvironmentObject var history: HistoryDataView
    @EnvironmentObject var contacts: ContactsDataView
    @EnvironmentObject private var model: ChatScreenModel
    @EnvironmentObject var userData: UserDataView
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    @Binding var oneContact: FetchedContact?
    
    var body: some View{
        Text("HI")
    }
}

struct OneMore3: View{
    
    var i:Int
    var c:Int
    
    var body: some View{
        if (i < 2){
            Text(i == (c - 1) ? "You know this number as:" : "Person who knows")
                .font(Font.system(size: 18, weight: .regular, design: .default))
                .foregroundColor(Color.theme.contactsHeadLetter)
                .padding(5)
        }
    }
}

struct MoreContacts: View{
    @EnvironmentObject var history: HistoryDataView
    @EnvironmentObject var contacts: ContactsDataView
    @EnvironmentObject private var model: ChatScreenModel
    @EnvironmentObject var userData: UserDataView
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    @Binding var allContacts: [FetchedContact]
    
    var body: some View{
        ScrollView{
            Text("HI")
            ForEach (allContacts) { contact in
                ContactRow (contact: contact, order: contacts.order)
            }
        }
        .onAppear{
            print(allContacts)
        }
    }
}


struct Scl: View{
    @State var letter: String
    @State var frame: CGFloat
    @State var font: CGFloat
    @State var color: Color
    @State var text: String
    
    var body: some View{
        VStack{
            BigLetter(letter: letter, frame: frame, font: font, color: color)
                .padding(5)
            Text(text)
        }
        .frame(height: 100)
    }
    
}

struct SingleSearchView2: View {
    @EnvironmentObject var history: HistoryDataView
    @EnvironmentObject var contacts: ContactsDataView
    @State var hasScrolled: Bool = false
    @AppStorage("big") var big: Bool = IsBig()
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    //    @State var currentSearch: SearchHistory?
    @EnvironmentObject private var model: ChatScreenModel
    @EnvironmentObject var userData: UserDataView
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Binding var alert: MyAlert
    
    @Namespace var namespace
    
    
    @State var currentPage = 0
    @State var numberOfPages = 0
    
    
    var body: some View {
        VStack(spacing: 0) {
            
            //            Head
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
                                    Text("Searching")
                                        .animatableFont(size: 36, weight: .bold)
                                        .foregroundColor(.black)
                                }
                            }
                            Spacer()
                        }
                        .padding(.top, 30)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                }
                .frame(height: 110)
                .ignoresSafeArea()
            }
            Text("Searching for: " + (history.datta.first(where: {$0.id == history.selectedHistory})?.number ?? ""))
                .font(Font.custom("SFProDisplay-Regular", size: 20))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            
            VStack{
                VStack{
                    if (history.datta.first(where: {$0.id == history.selectedHistory})?.handhsakes != nil){
                        if (history.datta.first(where: {$0.id == history.selectedHistory})?.handhsakes?.count == 0){
                            Text("No results")
                                .frame(minHeight:200)
                                .frame(maxHeight: 1000)
                        }
                        else{
                            
                            let a = (history.datta.first(where: {$0.id == history.selectedHistory})?.handhsakes!.sorted(by: {$0.path.count < $1.path.count}))!
                            VStack {
                                ZStack{

                                                                        TabView(selection: $currentPage) {
                                                                            ForEach (a.indices, id: \.self){ index in
                                                                                let handhsake = a[index]
                                                                                //                                Text("Path #\(index+1)")
                                                                                //                                Text("\(handhsake.path.count)")
                                                                                ScrollView{
                                                                                    Grid_old(handshake: handhsake, alert: $alert)
                                                                                        .environmentObject(history)
                                                                                        .environmentObject(contacts)
                                                                                        .environmentObject(model)
                                                                                        .environmentObject(userData)
                                                                                        .frame(minHeight:200)
                                                                                    //                                                .padding()
                                                                                    //                                                                    .padding()
                                                                                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                                                                                        .padding(.horizontal, 10)
                                                                                    //                                                .frame(maxHeight: 1000)

                                                                                        .onAppear{print(handhsake)}

                                                                                        .padding(.top, 45)
                                                                                    //                                                                                                    .offset(y: 45)
                                                                                }
                                                                                //                                                .padding(.top, 45)
                                                                                //                                                .offset(y: 45)
                                                                                .tag(index)
                                                                                .safeAreaInset(edge: .bottom, content: {
                                                                                                            Color.clear.frame(height: big ? 45: 75)
                                                                                }
                                                                                               )
                                                                            }
                                                                        }
                                                                        .tabViewStyle(.page(indexDisplayMode: .never))
                                                                        .indexViewStyle(.page(backgroundDisplayMode: .always))
                                                                        //                                        .background(.red)
                                                                        VStack{
                                                                            PageControlView(currentPage: $currentPage, numberOfPages: a.count)
                                                                                .padding(10)
                                                                            Spacer()
                                                                            HStack{
                                                                                Image(systemName: "info.circle")
                                                                                    .foregroundColor(ColorTheme().accent)
                                                                                Text("Tap on a search card to start a chat")
                                                                            }
                                                                            .padding(30)
                                                                            .frame(maxWidth: .infinity)
                                //                                            .background(.green)
                                                                            //                                                .background(.blue)
                                                                            .background(.ultraThinMaterial)
                                                                            .mask(
                                                                                LinearGradient(gradient: Gradient(stops: [
                                                                                    Gradient.Stop(color: Color(white: 0, opacity: 0),
                                                                                                  location: 0),
                                                                                    Gradient.Stop(color: Color(white: 0, opacity: 1),
                                                                                                  location: 0.5),
                                                                                ]), startPoint: .top, endPoint: .bottom)
                                                                            )
                                                                        }
                                                                        .ignoresSafeArea()
                                                                    }
                                                                   
//                                ZStack{
//                                    TabView(selection: $currentPage) {
//                                        ForEach (a.indices, id: \.self){ index in
//                                            let handhsake = a[index]
//                                            ScrollView{
//                                                PageControlView(currentPage: $currentPage, numberOfPages: a.count)
//                                                    .padding(10)
////                                                    .matchedGeometryEffect(id: "Dots", in: namespace)
//                                                Grid_old(handshake: handhsake, alert: $alert)
//                                                    .environmentObject(history)
//                                                    .environmentObject(contacts)
//                                                    .environmentObject(model)
//                                                    .environmentObject(userData)
//                                                    .frame(minHeight:200)
//                                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
//                                                    .padding(.horizontal, 10)
//                                                    .onAppear{print(handhsake)}
//                                            }
//                                            .tag(index)
//                                            .safeAreaInset(edge: .bottom, content: {
//                                                Color.clear.frame(height: big ? 45: 75)
//                                            }
//                                            )
//                                        }
//                                    }
//                                    .tabViewStyle(.page(indexDisplayMode: .never))
//                                    .indexViewStyle(.page(backgroundDisplayMode: .always))
//                                    VStack{
//                                        Spacer()
//                                        HStack{
//                                            Image(systemName: "info.circle")
//                                                .foregroundColor(ColorTheme().accent)
//                                            Text("Tap on a search card to start a chat")
//                                        }
//                                        .padding(30)
//                                        .frame(maxWidth: .infinity)
//                                        .background(.ultraThinMaterial)
//                                        .mask(
//                                            LinearGradient(gradient: Gradient(stops: [
//                                                Gradient.Stop(color: Color(white: 0, opacity: 0),
//                                                              location: 0),
//                                                Gradient.Stop(color: Color(white: 0, opacity: 1),
//                                                              location: 0.5),
//                                            ]), startPoint: .top, endPoint: .bottom)
//                                        )
//                                    }
//                                    .ignoresSafeArea()
//                                }
                            }
                        }
                    }
                    else{
                        ProgressView()
                            .frame(minHeight:200)
                            .frame(maxHeight: 1000)
                        
                    }
                }
            }
        }
        .myBackGesture()
        .navigationBarHidden(true)
    }
}

struct SingleSearchView2_Previews: PreviewProvider {
    
    static let debug: DebugData = DebugData()
    
    static let historyData: HistoryDataView = debug.historyData
    static let contactsData: ContactsDataView = debug.contactsData
    static let model: ChatScreenModel = debug.model
    static let userData: UserDataView = debug.userData
    
    static var previews: some View {
        SingleSearchView2(alert: .constant(MyAlert()))
            .environmentObject(historyData)
            .environmentObject(contactsData)
            .environmentObject(model)
            .environmentObject(userData)
    }
}
