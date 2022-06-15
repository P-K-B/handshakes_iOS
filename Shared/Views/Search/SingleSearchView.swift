//
//  SingleSearchView.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 29.05.2022.
//

import SwiftUI
import SnapToScroll

struct SingleSearchView: View {
    @EnvironmentObject var history: HistoryDataView
    @EnvironmentObject var contacts: ContactsDataView
    @State var hasScrolled: Bool = false
    @AppStorage("big") var big: Bool = IsBig()
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    //    @State var currentSearch: SearchHistory?
    @EnvironmentObject private var model: ChatScreenModel
    @EnvironmentObject var userData: UserDataView
    
    var body: some View {
        GeometryElement(hasScrolled: $hasScrolled, big: big, hasBack: false)
        VStack() {
            Text("Searching for: " + (history.datta.first(where: {$0.id == history.selectedHistory})?.number ?? ""))
                .font(Font.custom("SFProDisplay-Regular", size: 20))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            //                Text(history.datta.first(where: {$0.id == history.selectedHistory})?.number ?? "")
            //                    .font(Font.custom("SFProDisplay-Regular", size: 20))
            //                    .padding()
            //                    .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            VStack{
                VStack{
                    //                    HStackSnap(alignment: .center(32)) {
                    ScrollView(){
                        HStack{
                            ZStack{
                                GeometryReader{reader -> AnyView in
                                    let lyAxis=reader.frame(in: .global).minY
                                    let lxAxis=reader.frame(in: .global).minX

                                    
                                    print(lyAxis)
                                    print(lxAxis)
                                    
//                                    Path { path in
//
//
//                                        path.move(
//                                            to: CGPoint(
//                                                x: 1,
//                                                y: 1
//                                            )
//                                        )
//
//                                        path.addLine(
//                                            to: CGPoint(
//                                                x: 2,
//                                                y: 2
//                                            )
//                                        )
//                                        path.addLine(
//                                            to: CGPoint(
//                                                x: 3,
//                                                y: 3
//                                            )
//                                        )
//
//                                        path.closeSubpath()
//                                    }
                                    
                                    return AnyView(
                                        Color.red
//                                        Color.red.frame(width: 50)
                                    )
                                }
//                                .frame(height: 0)
                                Scl(letter: "I", frame: 50, font: 20, color: .green, text: "I")
                            }
                            .frame(width: 70)
                            VStack{
                                if (history.datta.first(where: {$0.id == history.selectedHistory})?.handhsakes != nil){
                                    ForEach (((history.datta.first(where: {$0.id == history.selectedHistory})?.handhsakes!.sorted(by: {$0.path.count < $1.path.count})))!, id: \.self){ handhsake in
                                        //                                Text("Path #\(index+1)")
                                        //                                Text("\(handhsake.path.count)")
                                        Grid_old(handshake: handhsake)
                                            .environmentObject(history)
                                            .environmentObject(contacts)
                                            .environmentObject(model)
                                            .environmentObject(userData)
                                        //                                    .padding()
                                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                                        
                                        //                                    .snapAlignmentHelper(id: "")
                                        
                                        //                                Grid_test()
                                        
                                    }
                                    
                                    //                                    ForEach (((history.datta.first(where: {$0.id == history.selectedHistory})?.handhsakes!.sorted(by: {$0.path.count < $1.path.count})))!, id: \.self){ handhsake in
                                    //                                        //                                Text("Path #\(index+1)")
                                    //                                        //                                Text("\(handhsake.path.count)")
                                    //                                        Grid_old(handshake: handhsake)
                                    //                                            .environmentObject(history)
                                    //                                            .environmentObject(contacts)
                                    //                                            .environmentObject(model)
                                    //                                            .environmentObject(userData)
                                    //                                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                                    //
                                    //                                        //                                    .padding()
                                    //                                        //                                    .snapAlignmentHelper(id: "")
                                    //
                                    //                                        //                                Grid_test()
                                    //
                                    //                                    }
                                }
                                else{
                                    Text("NIL")
                                }
                            }
                        }
                    }
                    
                    //                    } eventHandler: { event in
                    //
                    //                        handleSnapToScrollEvent(event: event)
                    //                    }
                    
                    //                    .background(.red)
                }
                //                .frame(maxHeight: 1000)
                
            }
            
        }
        
        .overlay(
            NavigationBar(title: "Searching", hasScrolled: $hasScrolled, search: .constant(false), showSearch: .constant(false), back: .search)
        )
        .onAppear{
            if ((history.selectedHistory == nil) && (selectedTab == .singleSearch)){
                selectedTab = .search
            }
        }
    }
    
    func handleSnapToScrollEvent(event: SnapToScrollEvent) {
        switch event {
        case let .didLayout(layoutInfo: layoutInfo):
            
            print("\(layoutInfo.keys.count) items layed out")
            
        case let .swipe(index: index):
            
            print("swiped to index: \(index)")
            selectedGettingStartedIndex = index
        }
    }
    
    // MARK: Private
    
    @State private var selectedGettingStartedIndex: Int = 0
}

//struct SingleSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SingleSearchView()
//            .environmentObject(HistoryDataView())
//            .environmentObject(ContactsDataView())
//    }
//}

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


struct Grid_old: View{
    @EnvironmentObject var history: HistoryDataView
    @EnvironmentObject var contacts: ContactsDataView
    @State var handshake: SearchPathDecoded
    @EnvironmentObject private var model: ChatScreenModel
    @EnvironmentObject var userData: UserDataView
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    @State var moreContacts: Bool = false
    @State var extra: [FetchedContact] = []
    
    var body: some View{
        HStack{
            Spacer()
            VStack{
                //            ScrollView{
                //            HStackSnap(alignment: .center(32)){
                //                                Text(handshake.path_id)
                ForEach (0..<handshake.path.count, id:\.self){i in
                    //                VStack{
                    let path = handshake.path[i]
                    if (i > 0){
                        //                                                        Text(path.number == "-" ? "You" : path.number)
                        
                        if (path.number != ""){
                            
                            Text(i == (handshake.path.count - 1) ? "You know this number as:" : "Person who may know this number:")
                            let a = contacts.data.contacts.filter({$0.telephone.contains(where: {$0.phone == path.number})})
                            if (a.count > 0){
                                //                        ForEach (a){contact in
                                
                                ContactRow(contact: a[0], order: contacts.order)
                                if (a.count > 1){
                                    Text("This contacts has more entries in you Contacts")
                                    Button (action:{
                                        self.extra = a
                                        withAnimation{
                                            print(extra)
                                            moreContacts = true
                                        }
                                    }) {
                                        HStack {
                                            
                                            //                                                                        Text(a[0].firstName)
                                            Text("Show all")
                                            
                                        }
                                    }
                                }
                                //                                .frame(height: 300)
                                
                                Button (action:{
                                    withAnimation{
                                        model.OpenChat(chat: handshake.path_id)
//                                        model.openChat = handshake.path_id
                                        model.toGuid = path.guid
                                        model.addChat(a: handshake.path_id, to: path.guid)
                                        model.send(text: "", searchGuid: handshake.path_id, toGuid: path.guid, meta: Meta(number: history.datta.first(where: {$0.id == history.selectedHistory})?.number ?? "", asking_number: userData.data.number, res: path.number))
                                        model.send(text: "Searching info about number \(path.number)", searchGuid: handshake.path_id, toGuid: path.guid, meta: nil)
                                        selectedTab = .singleChat
                                        
                                    }
                                }) {
                                    HStack {
                                        
                                        //                                                                        Text(a[0].firstName)
                                        Text("Chat")
                                    }
                                }
                                .padding(.horizontal, 15)
                                .padding()
                                //                        }
                            }
                            
                            
                        }
                        if (i < handshake.path.count - 1){
                            //                        Divider()
                            Image(systemName: "arrow.down")
                        }
                    }
                    
                }
            }
            Spacer()
            
        }
        //        .frame(maxHeight: 500)
        
        //        .padding()
        //        .background(Color.white)
        
        
        .font(Font.custom("SFProDisplay-Regular", size: 20))
        .popover(isPresented: $moreContacts) {
            MoreContacts(allContacts: $extra)
                .environmentObject(history)
                .environmentObject(contacts)
                .environmentObject(model)
                .environmentObject(userData)
        }
        
    }
    
    func handleSnapToScrollEvent(event: SnapToScrollEvent) {
        switch event {
        case let .didLayout(layoutInfo: layoutInfo):
            
            print("\(layoutInfo.keys.count) items layed out")
            
        case let .swipe(index: index):
            
            print("swiped to index: \(index)")
            selectedGettingStartedIndex = index
        }
    }
    
    // MARK: Private
    
    @State private var selectedGettingStartedIndex: Int = 0
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

struct Grid_Previews: PreviewProvider {
    static var previews: some View {
        Grid(handshake: SearchPathDecoded(path_id: "233DCB1EE69511ECAE590242AC120003", dep: 0, print: ["-", "+7 903 668-90-41", ""], path: [SearchPathDecodedPath(number: "-", guid: "233D3773E69511ECAE590242AC120003"), SearchPathDecodedPath(number: "+7 903 668-90-41", guid: "233D47D4E69511ECAE590242AC120003"), SearchPathDecodedPath(number: "", guid: "233DB13EE69511ECAE590242AC120003")]))
            .environmentObject(DebugData().historyData)
            .environmentObject(DebugData().contactsData)
            .environmentObject(DebugData().model)
            .environmentObject(DebugData().userData)
        
        //            .environmentObject(history)
        //            .environmentObject(contacts)
        //            .environmentObject(model)
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

struct Grid: View{
    @EnvironmentObject var history: HistoryDataView
    @EnvironmentObject var contacts: ContactsDataView
    @State var handshake: SearchPathDecoded
    @EnvironmentObject private var model: ChatScreenModel
    @EnvironmentObject var userData: UserDataView
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    @State var moreContacts: Bool = false
    @State var extra: [FetchedContact] = []
    @State var colors: [Color] = [Color.theme.accent, .blue, .green]
    
    var body: some View{
        ScrollView(.horizontal){
            HStack{
                
                ForEach (0..<handshake.path.count, id:\.self){i in
                    //                VStack{
                    let path = handshake.path[i]
                    //                    if (i > 0){
                    //                        Text("\(i)")
                    //                    if (i == 0){
                    //                        VStack{
                    //                            Scl(letter: "I", frame: 50, font: 20, color: .green, text: "I")
                    //                        }
                    //
                    //                    }
                    let ttt=(i == handshake.path.count - 1)
                    
                    //                                                        Text(path.number == "-" ? "You" : path.number)
                    
                    if (path.number != ""){
                        
                        //                        Text(i == (handshake.path.count - 1) ? "You know this number as:" : "Person who may know this number:")
                        let a = contacts.data.contacts.filter({$0.telephone.contains(where: {$0.phone == path.number})})
                        //                        if (a.count > 0){
                        //                        if (i == handshake.path.count - 1){
                        ZStack{
                            ForEach (a.indices, id:\.self){index in
                                
                                
                                
                                VStack{
                                    if (index > 0){
                                        Scl(letter: String(a[index].filterindex.prefix(1) ?? ""), frame: 50, font: 20, color: ttt ? .orange : colors[mloop(index:index)], text: " ")
                                            .offset(x: CGFloat(10*index))
                                    }
                                    else{
                                        Scl(letter: String(a[index].filterindex.prefix(1) ?? ""), frame: 50, font: 20, color: ttt ? .orange : colors[mloop(index:index)] , text: a[index].firstName != "" ? a[index].firstName : a[index].lastName)
                                            .offset(x: CGFloat(10*index))
                                    }
                                }
                                .zIndex(Double(-1*index))
                                //                                    Text("\(index)")
                                
                            }
                            
                        }
                        //
                        //                        }
                        //                        else{
                        //                            ForEach (a.indices, id:\.self){index in
                        //
                        //
                        //                                VStack{
                        //                                    Scl(letter: String(a[index].filterindex.prefix(1) ?? ""), frame: 50, font: 20, color: Color.theme.accent, text: a[index].firstName != "" ? a[index].firstName : a[index].lastName)
                        //
                        //                                }
                        //
                        //                            }
                        //                        }
                        
                        
                    }
                    else{
                        if (i == handshake.path.count - 1){
                            //                            ForEach (a){contact in
                            
                            
                            VStack{
                                Scl(letter: "S", frame: 50, font: 20, color: .orange, text: "Someone")
                                
                            }
                            
                            //                            }
                            //
                        }
                        else{
                            //                            ForEach (a){contact in
                            
                            
                            VStack{
                                Scl(letter: "N", frame: 50, font: 20, color: Color.theme.accent, text: "Number")
                                
                            }
                            
                            //                            }
                        }
                    }
                    
                    
                    //                    }
                    if ((i < handshake.path.count-1 ) && (i > 0)){
                        VStack{
                            Image(systemName: "arrow.right")
                                .padding(.vertical, 5)
                            Text(" ")
                        }
                    }
                    //                    if (i == handshake.path.count - 1){
                    //                        VStack{
                    //                        BigLetter(letter: String("N"), frame: 50, font: 20, color: .orange)
                    //                            .padding()
                    //                        Text("Number")
                    //                        }
                    //                    }
                    
                }
                
            }
        }
        .onAppear{
            print(handshake)
        }
        //        .frame(maxHeight: 500)
        
        //        .padding()
        //        .background(Color.white)
        
        
        .font(Font.custom("SFProDisplay-Regular", size: 20))
        .popover(isPresented: $moreContacts) {
            MoreContacts(allContacts: $extra)
                .environmentObject(history)
                .environmentObject(contacts)
                .environmentObject(model)
                .environmentObject(userData)
        }
        
    }
    
    func handleSnapToScrollEvent(event: SnapToScrollEvent) {
        switch event {
        case let .didLayout(layoutInfo: layoutInfo):
            
            print("\(layoutInfo.keys.count) items layed out")
            
        case let .swipe(index: index):
            
            print("swiped to index: \(index)")
            selectedGettingStartedIndex = index
        }
    }
    
    func mloop(index: Int) -> Int{
        return index % self.colors.count
    }
    
    // MARK: Private
    
    @State private var selectedGettingStartedIndex: Int = 0
}
