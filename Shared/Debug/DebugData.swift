//
//  DebugData.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 09.06.2022.
//

import Foundation

class DebugData{
    var userData: UserDataView
    var contactsData: ContactsDataView = ContactsDataView(d: true)
    var historyData: HistoryDataView = HistoryDataView(d: true)
    var model: ChatScreenModel
    
    init(){
        
        userData = UserDataView()
//        contactsData = ContactsDataView()
//        historyData = HistoryDataView()
        model = ChatScreenModel()
        
        userData.data = UserData(id: "138", jwt: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMTM4In0.pe8IG0ProtmY-82JXZhI1EZeQU3sPjm55HQ9GqjTxHg", number: "+1 888-555-1212", loggedIn: true, uuid: "37873335-BBB1-4588-BA79-B1F51B35D2DA", isNewUser: false, loaded: true)
        
        contactsData.data = ContactsData(contacts: [Handshakes2.FetchedContact(id: "410FE041-5C4E-48DA-B4DE-04C15EA3DBAC", firstName: "John", lastName: "Appleseed", telephone: [Handshakes2.Number(id: 0, title: "Mobile", phone: "+1 888-555-5512", guid: ""), Handshakes2.Number(id: 1, title: "Home", phone: "+1 888-555-1212", guid: "")], filterindex: "Appleseed", shortSearch: "JohnAppleseed888-555-5512888-555-1212", longSearch: "JohnAppleseed888-555-5512888-555-1212John-Appleseed@mac.com", fullContact: Handshakes2.FullContact(namePrefix: "", givenName: "John", middleName: "", familyName: "Appleseed", previousFamilyName: "", nameSuffix: "", nickname: "", phoneticGivenName: "", phoneticMiddleName: "", phoneticFamilyName: "", jobTitle: "", departmentName: "", organizationName: "", phoneticOrganizationName: "", postalAddresses: [Handshakes2.Addres(lable: "_$!<Work>!$_", street: "3494 Kuhl Avenue", subLocality: "", city: "", subAdministrativeArea: "", state: "GA", postalCode: "30303", country: "USA", countryCode: "us"), Handshakes2.Addres(lable: "_$!<Home>!$_", street: "1234 Laurel Street", subLocality: "", city: "", subAdministrativeArea: "", state: "GA", postalCode: "30303", country: "USA", countryCode: "us")], emailAddresses: [Handshakes2.Email(lable: "_$!<Work>!$_", value: "John-Appleseed@mac.com")], birthday: Handshakes2.Birthday(year: 1980, month: 6, day: 22), dates: []), index: 0, hiden: false), Handshakes2.FetchedContact(id: "177C371E-701D-42F8-A03B-C61CA31627F6", firstName: "Kate", lastName: "Bell", telephone: [Handshakes2.Number(id: 1, title: "Main", phone: "+1 415-555-3695", guid: "")], filterindex: "Bell", shortSearch: "KateBell(555) 564-8583(415) 555-3695", longSearch: "KateBellProducer(555) 564-8583(415) 555-3695kate-bell@mac.comCreative Consulting", fullContact: Handshakes2.FullContact(namePrefix: "", givenName: "Kate", middleName: "", familyName: "Bell", previousFamilyName: "", nameSuffix: "", nickname: "", phoneticGivenName: "", phoneticMiddleName: "", phoneticFamilyName: "", jobTitle: "Producer", departmentName: "", organizationName: "Creative Consulting", phoneticOrganizationName: "", postalAddresses: [Handshakes2.Addres(lable: "_$!<Work>!$_", street: "165 Davis Street", subLocality: "", city: "", subAdministrativeArea: "", state: "CA", postalCode: "94010", country: "", countryCode: "us")], emailAddresses: [Handshakes2.Email(lable: "_$!<Work>!$_", value: "kate-bell@mac.com")], birthday: Handshakes2.Birthday(year: 1978, month: 1, day: 20), dates: []), index: 1, hiden: false), Handshakes2.FetchedContact(id: "AB211C5F-9EC9-429F-9466-B9382FF61035", firstName: "Daniel", lastName: "Higgins", telephone: [Handshakes2.Number(id: 1, title: "Mobile", phone: "+1 408-555-5270", guid: ""), Handshakes2.Number(id: 2, title: "HomeFAX", phone: "+1 408-555-3514", guid: "")], filterindex: "Higgins", shortSearch: "DanielHiggins555-478-7672(408) 555-5270(408) 555-3514", longSearch: "DanielHiggins555-478-7672(408) 555-5270(408) 555-3514d-higgins@mac.com", fullContact: Handshakes2.FullContact(namePrefix: "", givenName: "Daniel", middleName: "", familyName: "Higgins", previousFamilyName: "", nameSuffix: "Jr.", nickname: "", phoneticGivenName: "", phoneticMiddleName: "", phoneticFamilyName: "", jobTitle: "", departmentName: "", organizationName: "", phoneticOrganizationName: "", postalAddresses: [Handshakes2.Addres(lable: "_$!<Home>!$_", street: "332 Laguna Street", subLocality: "", city: "", subAdministrativeArea: "", state: "CA", postalCode: "94925", country: "USA", countryCode: "us")], emailAddresses: [Handshakes2.Email(lable: "_$!<Home>!$_", value: "d-higgins@mac.com")], birthday: Handshakes2.Birthday(year: 0, month: 0, day: 0), dates: []), index: 2, hiden: false), Handshakes2.FetchedContact(id: "2E73EE73-C03F-4D5F-B1E8-44E85A70F170", firstName: "Hank", lastName: "Zakroff", telephone: [Handshakes2.Number(id: 1, title: "Other", phone: "+1 707-555-1854", guid: "")], filterindex: "Zakroff", shortSearch: "HankZakroff(555) 766-4823(707) 555-1854", longSearch: "HankZakroffPortfolio Manager(555) 766-4823(707) 555-1854hank-zakroff@mac.comFinancial Services Inc.", fullContact: Handshakes2.FullContact(namePrefix: "", givenName: "Hank", middleName: "M.", familyName: "Zakroff", previousFamilyName: "", nameSuffix: "", nickname: "", phoneticGivenName: "", phoneticMiddleName: "", phoneticFamilyName: "", jobTitle: "Portfolio Manager", departmentName: "", organizationName: "Financial Services Inc.", phoneticOrganizationName: "", postalAddresses: [Handshakes2.Addres(lable: "_$!<Work>!$_", street: "1741 Kearny Street", subLocality: "", city: "", subAdministrativeArea: "", state: "CA", postalCode: "94901", country: "", countryCode: "us")], emailAddresses: [Handshakes2.Email(lable: "_$!<Work>!$_", value: "hank-zakroff@mac.com")], birthday: Handshakes2.Birthday(year: 0, month: 0, day: 0), dates: []), index: 3, hiden: false)], hide: [], letters: ["A", "B", "H", "Z"], updated: true, err: false, loaded: true)
        contactsData.order = 3
        contactsData.jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMTM4In0.pe8IG0ProtmY-82JXZhI1EZeQU3sPjm55HQ9GqjTxHg"
        
        historyData.jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMTM4In0.pe8IG0ProtmY-82JXZhI1EZeQU3sPjm55HQ9GqjTxHg"

        historyData.datta = [Handshakes2.SearchHistory(id: UUID(uuidString: "9BD1B71F-14DA-41EC-9346-83AA967BD28D")! , number: "+1 888-555-5512", date: Date(), res: true, searching: false, handhsakes: Optional([Handshakes2.SearchPathDecoded(path_id: "A8EB7B670B6511EDA3230242AC120002", dep: 0, print: ["-", "+1 408-555-3514", "+1 888-555-5512"], path: [Handshakes2.SearchPathDecodedPath(number: "-", guid: "d953ac524b7178ca979246700071f3de"), Handshakes2.SearchPathDecodedPath(number: "+1 408-555-3514", guid: "4f940bb687a150fe3112bbf0551a6f69"), Handshakes2.SearchPathDecodedPath(number: "+1 888-555-5512", guid: "58efa711d89305c5808f24e409ef1d1e")]), Handshakes2.SearchPathDecoded(path_id: "A865387A0B6511EDA3230242AC120002", dep: 0, print: ["-", "+1 888-555-5512"], path: [Handshakes2.SearchPathDecodedPath(number: "-", guid: "c72e3395bee7157e4f2f6807046fa9b2"), Handshakes2.SearchPathDecodedPath(number: "+1 888-555-5512", guid: "1f9ea3208218de204000fec2bc589850")]), Handshakes2.SearchPathDecoded(path_id: "A8E8E89C0B6511EDA3230242AC120002", dep: 0, print: ["-", "+1 888-555-1212", "+1 888-555-5512"], path: [Handshakes2.SearchPathDecodedPath(number: "-", guid: "7b7f69fa8c05c35c912967ab3a7e6408"), Handshakes2.SearchPathDecodedPath(number: "+1 888-555-1212", guid: "31172a090821a13c1d557bf9e850c57d"), Handshakes2.SearchPathDecodedPath(number: "+1 888-555-5512", guid: "870be77fd7fc684b365daae3636155cf")]), Handshakes2.SearchPathDecoded(path_id: "A8EA67690B6511EDA3230242AC120002", dep: 0, print: ["-", "+1 707-555-1854", "+1 888-555-5512"], path: [Handshakes2.SearchPathDecodedPath(number: "-", guid: "9a393723f74a7b513ba81c3253ccca2a"), Handshakes2.SearchPathDecodedPath(number: "+1 707-555-1854", guid: "562fa16bf1ff0c241afe315e04f62c8a"), Handshakes2.SearchPathDecodedPath(number: "+1 888-555-5512", guid: "f800ba22c4de6a45740587e0714a9c7c")]), Handshakes2.SearchPathDecoded(path_id: "A8EABF5D0B6511EDA3230242AC120002", dep: 0, print: ["-", "+1 415-555-3695", "+1 888-555-5512"], path: [Handshakes2.SearchPathDecodedPath(number: "-", guid: "a6ff71a933a1913f04ae16d91d1ca934"), Handshakes2.SearchPathDecodedPath(number: "+1 415-555-3695", guid: "a019b179f261b721cc90100dbfe5a94d"), Handshakes2.SearchPathDecodedPath(number: "+1 888-555-5512", guid: "8d0fbcbc1f9b7fdd50a2d7598f867787")]), Handshakes2.SearchPathDecoded(path_id: "A8EB42620B6511EDA3230242AC120002", dep: 0, print: ["-", "+1 408-555-5270", "+1 888-555-5512"], path: [Handshakes2.SearchPathDecodedPath(number: "-", guid: "7f32ac29a648aaee5d99a44eae0c7242"), Handshakes2.SearchPathDecodedPath(number: "+1 408-555-5270", guid: "3c93fc13acf4717364353f429e6810cd"), Handshakes2.SearchPathDecodedPath(number: "+1 888-555-5512", guid: "32345b8144026d87188972f0c04cdcec")])]), error: "", handshakes_lines: 10)]

        historyData.selectedHistory = UUID(uuidString: "9BD1B71F-14DA-41EC-9346-83AA967BD28D")
        historyData.updated = true
        
        model.chats = Chats(allChats: [
            "233DCB1EE69511ECAE590242AC120003": [
                Handshakes2.ReceivingChatMessage(
                    message_id: 288,
                    from: "233D3773E69511ECAE590242AC120003",
                    to: "233D47D4E69511ECAE590242AC120003",
                    sent_on: Optional(1654628888),
                    read_on: nil,
                    search_chain: "233DCB1EE69511ECAE590242AC120003",
                    marker: "new_chat_meta",
                    body: "{\"number\":\"+7 909 909-00-09\",\"asking_number\":\"+1 888-555-1212\"}",
                    is_sender: Optional(true),
                    meta: Optional(Handshakes2.Meta(number: "+7 909 909-00-09", asking_number: "+1 888-555-1212", res: ""))
                ), Handshakes2.ReceivingChatMessage(
                    message_id: 289,
                    from: "233D3773E69511ECAE590242AC120003",
                    to: "233D47D4E69511ECAE590242AC120003",
                    sent_on: Optional(1654628911),
                    read_on: nil, search_chain: "233DCB1EE69511ECAE590242AC120003",
                    marker: "new_message",
                    body: "123",
                    is_sender: Optional(true),
                    meta: nil
                ), Handshakes2.ReceivingChatMessage(
                    message_id: 290,
                    from: "233D47D4E69511ECAE590242AC120003",
                    to: "233D3773E69511ECAE590242AC120003",
                    sent_on: Optional(1654628920),
                    read_on: nil,
                    search_chain: "233DCB1EE69511ECAE590242AC120003",
                    marker: "new_message",
                    body: "Hihi",
                    is_sender: nil,
                    meta: nil
                ), Handshakes2.ReceivingChatMessage(
                    message_id: 291, from: "233D47D4E69511ECAE590242AC120003",
                    to: "233D3773E69511ECAE590242AC120003", sent_on: Optional(1654629002),
                    read_on: nil,
                    search_chain: "233DCB1EE69511ECAE590242AC120003",
                    marker: "new_message",
                    body: "Lol",
                    is_sender: nil,
                    meta: nil
                ), Handshakes2.ReceivingChatMessage(
                    message_id: 292, from: "233D3773E69511ECAE590242AC120003",
                    to: "233D47D4E69511ECAE590242AC120003", sent_on: Optional(1654629006), read_on: nil,
                    search_chain: "233DCB1EE69511ECAE590242AC120003", marker: "new_message",
                    body: "I’m here",
                    is_sender: Optional(true),
                    meta: nil
                )
            ]
        ])

    }
}
