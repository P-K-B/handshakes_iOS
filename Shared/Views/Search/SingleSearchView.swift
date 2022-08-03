//
//  SingleSearchView.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 29.05.2022.
//

import SwiftUI


//struct SingleSearchView: View {
//    @EnvironmentObject var history: HistoryDataView
//    @EnvironmentObject var contacts: ContactsDataView
//    //    @State var hasScrolled: Bool = false
//    @AppStorage("big") var big: Bool = IsBig()
//    @AppStorage("selectedTab") var selectedTab: Tab = .search
//    //    @State var currentSearch: SearchHistory?
//    @EnvironmentObject private var model: ChatScreenModel
//    @EnvironmentObject var userData: UserDataView
//
//    var body: some View {
//        //        GeometryElement(hasScrolled: $hasScrolled, big: big, hasBack: false)
//        NavigationView {
//            VStack() {
//                Text("Searching for: " + (history.datta.first(where: {$0.id == history.selectedHistory})?.number ?? ""))
//                    .font(Font.custom("SFProDisplay-Regular", size: 20))
//                    .padding()
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                //                Text(history.datta.first(where: {$0.id == history.selectedHistory})?.number ?? "")
//                //                    .font(Font.custom("SFProDisplay-Regular", size: 20))
//                //                    .padding()
//                //                    .frame(maxWidth: .infinity, alignment: .leading)
//                Divider()
//                VStack{
//                    VStack{
//                        if (history.datta.first(where: {$0.id == history.selectedHistory})?.handhsakes != nil){
//
//                            if (history.datta.first(where: {$0.id == history.selectedHistory})?.handhsakes?.count == 0){
//                                Text("No results")
//                                    .frame(minHeight:200)
//                                    .frame(maxHeight: 1000)
//
//                            }
//                            else{
//                                //                    ScrollView(){
//                                //                        HStack{
//                                //                            VStack{
//
//                                ForEach (((history.datta.first(where: {$0.id == history.selectedHistory})?.handhsakes!.sorted(by: {$0.path.count < $1.path.count})))!, id: \.self){ handhsake in
//                                    //                                Text("Path #\(index+1)")
//                                    //                                Text("\(handhsake.path.count)")
//                                    Grid_old(handshake: handhsake, alert: .constant(MyAlert()))
//                                        .environmentObject(history)
//                                        .environmentObject(contacts)
//                                        .environmentObject(model)
//                                        .environmentObject(userData)
//                                        .frame(minHeight:200)
//                                    //                                                                    .padding()
//                                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
//                                        .frame(maxHeight: 1000)
//
//
//                                        .onAppear{print(handhsake)}
//
//                                }
//                            }
//
//                            //                        }
//
//
//                        }
//                        else{
//                            ProgressView()
//                                .frame(minHeight:200)
//                                .frame(maxHeight: 1000)
//
//                        }
//
//                        //                    .background(.red)
//                    }
//                    //                                .padding(.vertical, 200)
//                    //                                .frame(maxHeight: 1000)
//
//                }
//
//            }
//
//            .overlay(
//                NavigationBar(title: "Searching", search: .constant(false), showSearch: false, showProfile: false, hasBack: true)
//            )
//        }
//        //        .onAppear{
//        //            if ((history.selectedHistory == nil) && (selectedTab == .singleSearch)){
//        //                selectedTab = .search
//        //            }
//        //        }
//    }
//
//
//
//    // MARK: Private
//
//}

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

struct OneMore: View{
    
    var a: [FetchedContact]
    var i: Int
    var m: Int
    var order: Int
    @State var colors: [Color] = [Color.green, Color.blue, Color.pink]
    
    var body: some View{
        VStack{
            //                                        ContactRow(contact: a[0], order: contacts.order)
            //                                        if (a.count > 1){
            //                                            Text(" + \(a.count - 1)")
            //                                        }
            ZStack{
                if (i == m){
                    BigLetter(letter: String(a[0].filterindex.prefix(1)), frame: 60, font: 24, color: Color.theme.accent)
                }
                else{
                    BigLetter(letter: String(a[0].filterindex.prefix(1)), frame: 60, font: 24, color: colors[mloop(index: i-1)])
                }
                //                ContactRow(contact: a[0], order: order)
                if (a.count > 1){
                    BigLetter(letter: String("+" + String(a.count - 1)), frame: 16, font: 10, color: Color.blue)
                        .offset(x: 25, y: -25)
                }
            }
            //            HStack{
            //                Text ("Chat with")
            //                ContactRow(contact: a[0], order: order)
            //            }
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
                //                ZStack{
                BigLetter(letter: String("S"), frame: 60, font: 24, color: Color.theme.accent)
                //                }
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
                //            ScrollView{
                //            HStackSnap(alignment: .center(32)){
                //                                Text(handshake.path_id)
                let c: Int = handshake.path.count
                ForEach (0..<(c-1), id:\.self){i in
                    //                VStack{
                    let path = handshake.path[i]
                    let a = contacts.data.contacts.filter({$0.telephone.contains(where: {$0.phone == path.number})})
                    let aLast = contacts.data.contacts.filter({$0.telephone.contains(where: {$0.phone == handshake.path[c-1].number})})
                    if (c == 2){
                        OneMore3(i: i+1, c: c)
                        ContactRow(contact: aLast[0], order: contacts.order )
                    }
                    
                    if (i > 0){
                        //                                                        Text(path.number == "-" ? "You" : path.number)
                        
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
                                    //                        ForEach (a){contact in
                                    //                                Button (action:{
                                    //                                    self.openContact = a[0]
                                    //                                    withAnimation{
                                    //                                        //                                        print(extra)
                                    //                                        oneContact = true
                                    //                                    }
                                    //                                }) {
                                    if (i == (c - 1)){
                                        ContactRow(contact: a[0], order: contacts.order )
                                    }
                                    else{
                                        VStack{
                                            
                                            
                                            //                                }
                                            
                                            
                                            //                                .frame(height: 300)
                                            
                                            
                                            
                                            NavigationLink(destination:
                                                            ChatScreen(alert: $alert)
                                                .environmentObject(history)
                                                .environmentObject(contacts)
                                                .environmentObject(model)
                                                .environmentObject(userData)
                                            )
                                            {
                                                VStack {
                                                    
                                                    //                                                                        Text(a[0].firstName)
                                                    //                                        Text("Chat with ")
                                                    OneMore(a: a, i: i, m: c - 1, order: contacts.order)
                                                    ContactRow(contact: a[0], order: contacts.order )
                                                }
                                                
                                            }
                                            
                                            //                            .isDetailLink(false)
                                            .navigationViewStyle(.stack)
                                            .foregroundColor(Color.black)
                                            
                                            .simultaneousGesture(TapGesture().onEnded{
                                                model.OpenChat(chat: handshake.path_id+path.guid)
                                                //                                        model.openChat = handshake.path_id
                                                model.toGuid = path.guid
                                                model.addChat(a: handshake.path_id+path.guid)
                                                model.send(text: "", searchGuid: handshake.path_id, toGuid: path.guid, meta: Meta(number: history.datta.first(where: {$0.id == history.selectedHistory})?.number ?? "", asking_number: userData.data.number, res: path.number, chain: handshake.path_id))
                                                model.send(text: "Searching info about number \(history.datta.first(where: {$0.id == history.selectedHistory})?.number ?? "")", searchGuid: handshake.path_id, toGuid: path.guid, meta: nil)
                                                
                                            })
                                        }
                                        .frame(width: 300, height: 125, alignment: .center)
                                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 34, style: .continuous))
                                    }
                                }
                                .padding(.bottom, 10)
                                
                                //
                                
                                
                                //                                Button (action:{
                                //                                    withAnimation{
                                //                                        model.OpenChat(chat: handshake.path_id)
                                //                                        //                                        model.openChat = handshake.path_id
                                //                                        model.toGuid = path.guid
                                //                                        model.addChat(a: handshake.path_id, to: path.guid)
                                //                                        model.send(text: "", searchGuid: handshake.path_id, toGuid: path.guid, meta: Meta(number: history.datta.first(where: {$0.id == history.selectedHistory})?.number ?? "", asking_number: userData.data.number, res: path.number))
                                //                                        model.send(text: "Searching info about number \(path.number)", searchGuid: handshake.path_id, toGuid: path.guid, meta: nil)
                                //                                        selectedTab = .singleChat
                                //
                                //                                    }
                                //                                }) {
                                //                                    HStack {
                                //
                                //                                        //                                                                        Text(a[0].firstName)
                                //                                        Text("Chat with ")
                                //                                        ContactRow(contact: a[0], order: contacts.order )
                                //                                    }
                                //                                }
                                //                                .padding(.horizontal, 15)
                                //                                .padding()
                                //                        }
                            }
                            
                            
                            
                            
                        }
                        else{
                            VStack{
                                //                                OneMore(a: a, i: i, m: c - 1, order: contacts.order)
                                
                                //                                }
                                
                                
                                //                                .frame(height: 300)
                                
                                
                                
                                NavigationLink(destination:
                                                ChatScreen(alert: $alert)
                                    .environmentObject(history)
                                    .environmentObject(contacts)
                                    .environmentObject(model)
                                    .environmentObject(userData)
                                )
                                {
                                    HStack {
                                        
                                        //                                                                        Text(a[0].firstName)
                                        //                                        Text("Chat with ")
                                        //                                        ContactRow(contact: a[0], order: contacts.order )
                                        OneMore2(c: c, i: i)
                                    }
                                    
                                }
                                
                                //                            .isDetailLink(false)
                                .navigationViewStyle(.stack)
                                .foregroundColor(Color.black)
                                
                                .simultaneousGesture(TapGesture().onEnded{
                                    model.OpenChat(chat: handshake.path_id+path.guid)
                                    //                                        model.openChat = handshake.path_id
                                    model.toGuid = path.guid
                                    model.addChat(a: handshake.path_id+path.guid)
                                    model.send(text: "", searchGuid: handshake.path_id, toGuid: path.guid, meta: Meta(number: history.datta.first(where: {$0.id == history.selectedHistory})?.number ?? "", asking_number: userData.data.number, res: path.number, chain: handshake.path_id))
                                    model.send(text: "Searching info about number \(history.datta.first(where: {$0.id == history.selectedHistory})?.number ?? "")", searchGuid: handshake.path_id, toGuid: path.guid, meta: nil)
                                    
                                })
                            }
                            .frame(width: 300, height: 125, alignment: .center)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 34, style: .continuous))
                            
                            
                            .padding(.bottom, 10)
                            
                            //                                .background(.red)
                        }
                        //                        if (i < c - 1){
                        //                            //                        Divider()
                        //                            Image(systemName: "arrow.down")
                        //                        }
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
        .popover(isPresented: $oneContact) {
            OneContact(oneContact: $openContact)
                .environmentObject(history)
                .environmentObject(contacts)
                .environmentObject(model)
                .environmentObject(userData)
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

//struct Grid_Previews: PreviewProvider {
//    static var previews: some View {
//        Grid_old(handshake: SearchPathDecoded(path_id: "233DCB1EE69511ECAE590242AC120003", dep: 0, print: ["-", "+7 903 668-90-41", ""], path: [SearchPathDecodedPath(number: "-", guid: "233D3773E69511ECAE590242AC120003"), SearchPathDecodedPath(number: "+7 903 668-90-41", guid: "233D47D4E69511ECAE590242AC120003"), SearchPathDecodedPath(number: "", guid: "233DB13EE69511ECAE590242AC120003")]))
//            .environmentObject(DebugData().historyData)
//            .environmentObject(DebugData().contactsData)
//            .environmentObject(DebugData().model)
//            .environmentObject(DebugData().userData)
//
//        //            .environmentObject(history)
//        //            .environmentObject(contacts)
//        //            .environmentObject(model)
//    }
//}

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

//struct Grid: View{
//    @EnvironmentObject var history: HistoryDataView
//    @EnvironmentObject var contacts: ContactsDataView
//    @State var handshake: SearchPathDecoded
//    @EnvironmentObject private var model: ChatScreenModel
//    @EnvironmentObject var userData: UserDataView
//    @AppStorage("selectedTab") var selectedTab: Tab = .search
//    @State var moreContacts: Bool = false
//    @State var extra: [FetchedContact] = []
//    @State var colors: [Color] = [Color.theme.accent, .blue, .green]
//
//    var body: some View{
//        ScrollView(.horizontal){
//            HStack{
//
//                ForEach (0..<handshake.path.count, id:\.self){i in
//                    //                VStack{
//                    let path = handshake.path[i]
//                    //                    if (i > 0){
//                    //                        Text("\(i)")
//                    //                    if (i == 0){
//                    //                        VStack{
//                    //                            Scl(letter: "I", frame: 50, font: 20, color: .green, text: "I")
//                    //                        }
//                    //
//                    //                    }
//                    let ttt=(i == handshake.path.count - 1)
//
//                    //                                                        Text(path.number == "-" ? "You" : path.number)
//
//                    if (path.number != ""){
//
//                        //                        Text(i == (handshake.path.count - 1) ? "You know this number as:" : "Person who may know this number:")
//                        let a = contacts.data.contacts.filter({$0.telephone.contains(where: {$0.phone == path.number})})
//                        //                        if (a.count > 0){
//                        //                        if (i == handshake.path.count - 1){
//                        ZStack{
//                            ForEach (a.indices, id:\.self){index in
//
//
//
//                                VStack{
//                                    if (index > 0){
//                                        Scl(letter: String(a[index].filterindex.prefix(1) ?? ""), frame: 50, font: 20, color: ttt ? .orange : colors[mloop(index:index)], text: " ")
//                                            .offset(x: CGFloat(10*index))
//                                    }
//                                    else{
//                                        Scl(letter: String(a[index].filterindex.prefix(1) ?? ""), frame: 50, font: 20, color: ttt ? .orange : colors[mloop(index:index)] , text: a[index].firstName != "" ? a[index].firstName : a[index].lastName)
//                                            .offset(x: CGFloat(10*index))
//                                    }
//                                }
//                                .zIndex(Double(-1*index))
//                                //                                    Text("\(index)")
//
//                            }
//
//                        }
//                        //
//                        //                        }
//                        //                        else{
//                        //                            ForEach (a.indices, id:\.self){index in
//                        //
//                        //
//                        //                                VStack{
//                        //                                    Scl(letter: String(a[index].filterindex.prefix(1) ?? ""), frame: 50, font: 20, color: Color.theme.accent, text: a[index].firstName != "" ? a[index].firstName : a[index].lastName)
//                        //
//                        //                                }
//                        //
//                        //                            }
//                        //                        }
//
//
//                    }
//                    else{
//                        if (i == handshake.path.count - 1){
//                            //                            ForEach (a){contact in
//
//
//                            VStack{
//                                Scl(letter: "S", frame: 50, font: 20, color: .orange, text: "Someone")
//
//                            }
//
//                            //                            }
//                            //
//                        }
//                        else{
//                            //                            ForEach (a){contact in
//
//
//                            VStack{
//                                Scl(letter: "N", frame: 50, font: 20, color: Color.theme.accent, text: "Number")
//
//                            }
//
//                            //                            }
//                        }
//                    }
//
//
//                    //                    }
//                    if ((i < handshake.path.count-1 ) && (i > 0)){
//                        VStack{
//                            Image(systemName: "arrow.right")
//                                .padding(.vertical, 5)
//                            Text(" ")
//                        }
//                    }
//                    //                    if (i == handshake.path.count - 1){
//                    //                        VStack{
//                    //                        BigLetter(letter: String("N"), frame: 50, font: 20, color: .orange)
//                    //                            .padding()
//                    //                        Text("Number")
//                    //                        }
//                    //                    }
//
//                }
//
//            }
//        }
//        .onAppear{
//            print(handshake)
//        }
//        //        .frame(maxHeight: 500)
//
//        //        .padding()
//        //        .background(Color.white)
//
//
//        .font(Font.custom("SFProDisplay-Regular", size: 20))
//        .popover(isPresented: $moreContacts) {
//            MoreContacts(allContacts: $extra)
//                .environmentObject(history)
//                .environmentObject(contacts)
//                .environmentObject(model)
//                .environmentObject(userData)
//        }
//
//    }
//
//    func handleSnapToScrollEvent(event: SnapToScrollEvent) {
//        switch event {
//        case let .didLayout(layoutInfo: layoutInfo):
//
//            print("\(layoutInfo.keys.count) items layed out")
//
//        case let .swipe(index: index):
//
//            print("swiped to index: \(index)")
//            selectedGettingStartedIndex = index
//        }
//    }
//
//
//
//    // MARK: Private
//
//    @State private var selectedGettingStartedIndex: Int = 0
//}




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
    
    
    @State var currentPage = 0
    @State var numberOfPages = 0
    //    @State var number: Number?
    
    
    var body: some View {
        //        GeometryElement(hasScrolled: $hasScrolled, big: big, hasBack: false)
        NavigationView {
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
                                            .animatableFont(size: hasScrolled ? 22 : 36, weight: .bold)
                                            .foregroundColor(.black)
                                    }
                                }
                                Spacer()
                            }
                            .padding(.top, 30)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                        .padding(.top, 30)
                        .offset(y: hasScrolled ? -4 : 0)
                    }
                    .ignoresSafeArea()
                }
                //                .background(.green)
                
                
                
                
                Text("Searching for: " + (history.datta.first(where: {$0.id == history.selectedHistory})?.number ?? ""))
                    .font(Font.custom("SFProDisplay-Regular", size: 20))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                //                    .background(.pink)
                //                            Text(history.datta.first(where: {$0.id == history.selectedHistory})?.number ?? "")
                //                                .font(Font.custom("SFProDisplay-Regular", size: 20))
                //                                .padding()
                //                                .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                //                    .padding()
                //                    .background(.blue)
                VStack{
                    VStack{
                        if (history.datta.first(where: {$0.id == history.selectedHistory})?.handhsakes != nil){
                            if (history.datta.first(where: {$0.id == history.selectedHistory})?.handhsakes?.count == 0){
                                Text("No results")
                                    .frame(minHeight:200)
                                    .frame(maxHeight: 1000)
                            }
                            else{
                                //                    ScrollView(){
                                //                        HStack{
                                //                            VStack{
                                let a = (history.datta.first(where: {$0.id == history.selectedHistory})?.handhsakes!.sorted(by: {$0.path.count < $1.path.count}))!
                                //                                    self.numberOfPages = a.count
                                
                                VStack {
                                    //                                    Spacer()
                                    ZStack{
                                        
                                        TabView(selection: $currentPage) {
                                            ForEach (a.indices, id: \.self){ index in
                                                let handhsake = a[index]
                                                //                                Text("Path #\(index+1)")
                                                //                                Text("\(handhsake.path.count)")
                                                ScrollView{
                                                    PageControlView(currentPage: $currentPage, numberOfPages: a.count)
                                                        .padding(10)
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
                                                    
//                                                        .padding(.top, 45)
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
//                                            PageControlView(currentPage: $currentPage, numberOfPages: a.count)
//                                                .padding(10)
//                                                .padding(.bottom, 15)
//                                                .background(.ultraThinMaterial)
////                                                .background(.red)
//                                                .mask(
//                                                    LinearGradient(gradient: Gradient(stops: [
//                                                        Gradient.Stop(color: Color(white: 0, opacity: 1),
//                                                                      location: 0.65),
//                                                        Gradient.Stop(color: Color(white: 0, opacity: 0),
//                                                                      location: 1),
//                                                    ]), startPoint: .top, endPoint: .bottom)
//                                                )
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
                                    //                                    .background(.red)
                                    //                                        .padding(.vertical, 10)
                                }
                                
                                //                                .background(.red)
                            }
                            
                            //                        }
                            
                            
                        }
                        else{
                            ProgressView()
                                .frame(minHeight:200)
                                .frame(maxHeight: 1000)
                            
                        }
                        
                        //                    .background(.red)
                    }
                    //                                .padding(.vertical, 200)
                    //                                .frame(maxHeight: 1000)
                    
                }
                //                .background(.blue)
                .navigationBarHidden(true)
            }
            //        Text("HI")
            //            .onAppear{
            //                if (number != nil){
            //                    history.Add(number: number!.phone)
            //                }
            //            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
        
        
        //        .overlay(
        //            NavigationBar(title: "Searching2", hasScrolled: $hasScrolled, search: .constant(false), showSearch: false, showProfile: false, back: .search)
        //                .navigationBarHidden(true)
        //                .navigationBarBackButtonHidden(true)
        //        )
        //        .onAppear{
        //            if ((history.selectedHistory == nil) && (selectedTab == .singleSearch)){
        //                selectedTab = .search
        //            }
        //        }
        
    }
    
    
}


//struct SingleSearchView2_Previews: PreviewProvider {
//
//    static let debug: DebugData = DebugData()
//
//    static let historyData: HistoryDataView = debug.historyData
//    static let contactsData: ContactsDataView = debug.contactsData
//    static let model: ChatScreenModel = debug.model
//    static let userData: UserDataView = debug.userData
//
//    static var previews: some View {
////        Group {
//            SingleSearchView2()
//                .environmentObject(historyData)
//                .environmentObject(contactsData)
//                .environmentObject(model)
//                .environmentObject(userData)
//                .safeAreaInset(edge: .top, content: {
//                                            Color.clear.frame(height: 75)
//            })
////                .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
////            SingleSearchView2()
////                .environmentObject(DebugData().historyData)
////                .environmentObject(DebugData().contactsData)
////                .environmentObject(DebugData().userData)
////                .environmentObject(DebugData().model)
////                .safeAreaInset(edge: .top, content: {
////                    Color.clear.frame(height: 45)
////                })
////                .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
////        }
//    }
//}

struct SingleSearchView2_Previews: PreviewProvider {
    
    static let debug: DebugData = DebugData()
    
    static let historyData: HistoryDataView = debug.historyData
    static let contactsData: ContactsDataView = debug.contactsData
    static let model: ChatScreenModel = debug.model
    static let userData: UserDataView = debug.userData
    
    static var previews: some View {
        SingleSearchView2(alert: .constant(MyAlert()))
        //        SingleContactView2()
            .environmentObject(historyData)
            .environmentObject(contactsData)
            .environmentObject(model)
            .environmentObject(userData)
    }
}
