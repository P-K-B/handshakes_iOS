//
//  DebugData.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 09.06.2022.
//

import Foundation

class DebugData{
    var userData: UserDataView = UserDataView()
    var contactsData: ContactsDataView = ContactsDataView()
    var historyData: HistoryDataView = HistoryDataView()
    var model: ChatScreenModel = ChatScreenModel()
    
    init(){
        
        userData.data = UserData(id: "196", jwt: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMTk2In0.5va4GSF251o7ZanaZ6kI22N19gHsY_h9PWarCEMvcY4", number: "+1 888-555-1212", loggedIn: true, uuid: "36F3D851-D39D-4E5A-A1E9-12DF55DACB37", isNewUser: false, loaded: true)
        
//        contactsData.data = ContactsData(contacts: [Handshakes2.FetchedContact(id: "433AB0B1-255C-4E1E-88B4-03152472155F:ABPerson", firstName: "Кирилл", lastName: "", telephone: [Handshakes2.Number(id: 0, title: "Mobile", phone: "+7 916 009-81-09")], filterindex: "Кирилл", shortSearch: "Кирилл+7 (916) 009-81-09", longSearch: "Кирилл+7 (916) 009-81-09", guid: ["7a28ddcc8b36501a2e808f9a0ebf1331"], fullContact: Handshakes2.FullContact(namePrefix: "", givenName: "Кирилл", middleName: "", familyName: "", previousFamilyName: "", nameSuffix: "", nickname: "", phoneticGivenName: "", phoneticMiddleName: "", phoneticFamilyName: "", jobTitle: "", departmentName: "", organizationName: "", phoneticOrganizationName: "", postalAddresses: [], emailAddresses: [], birthday: Handshakes2.Birthday(year: 0, month: 0, day: 0), dates: [])), Handshakes2.FetchedContact(id: "ACCB6F51-418A-4224-B3DD-69A908489129:ABPerson", firstName: "Удалить", lastName: "", telephone: [Handshakes2.Number(id: 0, title: "Mobile", phone: "+7 903 668-90-41"), Handshakes2.Number(id: 1, title: "Home", phone: "+7 909 556-53-12")], filterindex: "Удалить", shortSearch: "Удалить+7 (903) 668-90-41+7 (909) 556-53-12", longSearch: "Удалить+7 (903) 668-90-41+7 (909) 556-53-12", guid: ["cfca9626900264852caef9af37075376", "453645a26e568c277c8b936cf7281973"], fullContact: Handshakes2.FullContact(namePrefix: "", givenName: "Удалить", middleName: "", familyName: "", previousFamilyName: "", nameSuffix: "", nickname: "", phoneticGivenName: "", phoneticMiddleName: "", phoneticFamilyName: "", jobTitle: "", departmentName: "", organizationName: "", phoneticOrganizationName: "", postalAddresses: [], emailAddresses: [], birthday: Handshakes2.Birthday(year: 0, month: 0, day: 0), dates: [])), Handshakes2.FetchedContact(id: "F86BE8D1-1A3E-49E7-8046-B880E308E886:ABPerson", firstName: "Aabaaba", lastName: "", telephone: [Handshakes2.Number(id: 0, title: "Mobile", phone: "+1 888-555-1212")], filterindex: "Aabaaba", shortSearch: "Aabaaba+1 (888) 555-1212", longSearch: "Aabaaba+1 (888) 555-1212", guid: ["5cc4c3e2eec082113b7e8ee8045de02f", "65720c53932317a28e82c11225984c23", "28b551cc9b0735addb892c2c99abe06c"], fullContact: Handshakes2.FullContact(namePrefix: "", givenName: "Aabaaba", middleName: "", familyName: "", previousFamilyName: "", nameSuffix: "", nickname: "", phoneticGivenName: "", phoneticMiddleName: "", phoneticFamilyName: "", jobTitle: "", departmentName: "", organizationName: "", phoneticOrganizationName: "", postalAddresses: [], emailAddresses: [], birthday: Handshakes2.Birthday(year: 0, month: 0, day: 0), dates: [])), Handshakes2.FetchedContact(id: "410FE041-5C4E-48DA-B4DE-04C15EA3DBAC", firstName: "John", lastName: "Appleseed", telephone: [Handshakes2.Number(id: 0, title: "Mobile", phone: "+1 888-555-5512"), Handshakes2.Number(id: 1, title: "Home", phone: "+1 888-555-1212")], filterindex: "Appleseed", shortSearch: "JohnAppleseed888-555-5512888-555-1212", longSearch: "JohnAppleseed888-555-5512888-555-1212John-Appleseed@mac.com", guid: ["202c2b92bc969dec01b717985cf67e4e", "5cc4c3e2eec082113b7e8ee8045de02f", "65720c53932317a28e82c11225984c23", "28b551cc9b0735addb892c2c99abe06c"], fullContact: Handshakes2.FullContact(namePrefix: "", givenName: "John", middleName: "", familyName: "Appleseed", previousFamilyName: "", nameSuffix: "", nickname: "", phoneticGivenName: "", phoneticMiddleName: "", phoneticFamilyName: "", jobTitle: "", departmentName: "", organizationName: "", phoneticOrganizationName: "", postalAddresses: [Handshakes2.Addres(lable: "_$!<Work>!$_", street: "3494 Kuhl Avenue", subLocality: "", city: "", subAdministrativeArea: "", state: "GA", postalCode: "30303", country: "USA", countryCode: "us"), Handshakes2.Addres(lable: "_$!<Home>!$_", street: "1234 Laurel Street", subLocality: "", city: "", subAdministrativeArea: "", state: "GA", postalCode: "30303", country: "USA", countryCode: "us")], emailAddresses: [Handshakes2.Email(lable: "_$!<Work>!$_", value: "John-Appleseed@mac.com")], birthday: Handshakes2.Birthday(year: 1980, month: 6, day: 22), dates: [])), Handshakes2.FetchedContact(id: "177C371E-701D-42F8-A03B-C61CA31627F6", firstName: "Kate", lastName: "Bell", telephone: [Handshakes2.Number(id: 1, title: "Main", phone: "+1 415-555-3695")], filterindex: "Bell", shortSearch: "KateBell(555) 564-8583(415) 555-3695", longSearch: "KateBellProducer(555) 564-8583(415) 555-3695kate-bell@mac.comCreative Consulting", guid: ["5f5a4b57d16b473f4c7b438a6966564e"], fullContact: Handshakes2.FullContact(namePrefix: "", givenName: "Kate", middleName: "", familyName: "Bell", previousFamilyName: "", nameSuffix: "", nickname: "", phoneticGivenName: "", phoneticMiddleName: "", phoneticFamilyName: "", jobTitle: "Producer", departmentName: "", organizationName: "Creative Consulting", phoneticOrganizationName: "", postalAddresses: [Handshakes2.Addres(lable: "_$!<Work>!$_", street: "165 Davis Street", subLocality: "", city: "", subAdministrativeArea: "", state: "CA", postalCode: "94010", country: "", countryCode: "us")], emailAddresses: [Handshakes2.Email(lable: "_$!<Work>!$_", value: "kate-bell@mac.com")], birthday: Handshakes2.Birthday(year: 1978, month: 1, day: 20), dates: [])), Handshakes2.FetchedContact(id: "AB211C5F-9EC9-429F-9466-B9382FF61035", firstName: "Daniel", lastName: "Higgins", telephone: [Handshakes2.Number(id: 1, title: "Mobile", phone: "+1 408-555-5270"), Handshakes2.Number(id: 2, title: "HomeFAX", phone: "+1 408-555-3514")], filterindex: "Higgins", shortSearch: "DanielHiggins555-478-7672(408) 555-5270(408) 555-3514", longSearch: "DanielHiggins555-478-7672(408) 555-5270(408) 555-3514d-higgins@mac.com", guid: ["0801895f41d8e7a8ec8bdf99e17d99e4", "ce7846f4bace209c7d7dd6f33e24af25"], fullContact: Handshakes2.FullContact(namePrefix: "", givenName: "Daniel", middleName: "", familyName: "Higgins", previousFamilyName: "", nameSuffix: "Jr.", nickname: "", phoneticGivenName: "", phoneticMiddleName: "", phoneticFamilyName: "", jobTitle: "", departmentName: "", organizationName: "", phoneticOrganizationName: "", postalAddresses: [Handshakes2.Addres(lable: "_$!<Home>!$_", street: "332 Laguna Street", subLocality: "", city: "", subAdministrativeArea: "", state: "CA", postalCode: "94925", country: "USA", countryCode: "us")], emailAddresses: [Handshakes2.Email(lable: "_$!<Home>!$_", value: "d-higgins@mac.com")], birthday: Handshakes2.Birthday(year: 0, month: 0, day: 0), dates: [])), Handshakes2.FetchedContact(id: "2E73EE73-C03F-4D5F-B1E8-44E85A70F170", firstName: "Hank", lastName: "Zakroff", telephone: [Handshakes2.Number(id: 1, title: "Other", phone: "+1 707-555-1854")], filterindex: "Zakroff", shortSearch: "HankZakroff(555) 766-4823(707) 555-1854", longSearch: "HankZakroffPortfolio Manager(555) 766-4823(707) 555-1854hank-zakroff@mac.comFinancial Services Inc.", guid: ["997e1f35f1805615315360985b04f944"], fullContact: Handshakes2.FullContact(namePrefix: "", givenName: "Hank", middleName: "M.", familyName: "Zakroff", previousFamilyName: "", nameSuffix: "", nickname: "", phoneticGivenName: "", phoneticMiddleName: "", phoneticFamilyName: "", jobTitle: "Portfolio Manager", departmentName: "", organizationName: "Financial Services Inc.", phoneticOrganizationName: "", postalAddresses: [Handshakes2.Addres(lable: "_$!<Work>!$_", street: "1741 Kearny Street", subLocality: "", city: "", subAdministrativeArea: "", state: "CA", postalCode: "94901", country: "", countryCode: "us")], emailAddresses: [Handshakes2.Email(lable: "_$!<Work>!$_", value: "hank-zakroff@mac.com")], birthday: Handshakes2.Birthday(year: 0, month: 0, day: 0), dates: [])), Handshakes2.FetchedContact(id: "104C0F03-86DF-4479-A35B-7635757B9B12:ABPerson", firstName: "1234", lastName: "1234", telephone: [Handshakes2.Number(id: 0, title: "Mobile", phone: "+1 888-555-1212"), Handshakes2.Number(id: 1, title: "Home", phone: "+1 888-556-5233")], filterindex: "1234", shortSearch: "12341234+1 (888) 555-1212+1 (888) 556-5233", longSearch: "12341234+1 (888) 555-1212+1 (888) 556-52331234", guid: ["5cc4c3e2eec082113b7e8ee8045de02f", "65720c53932317a28e82c11225984c23", "28b551cc9b0735addb892c2c99abe06c", "9a9f17e3ed2e33c8944c2ec207e3a687"], fullContact: Handshakes2.FullContact(namePrefix: "", givenName: "1234", middleName: "", familyName: "1234", previousFamilyName: "", nameSuffix: "", nickname: "", phoneticGivenName: "", phoneticMiddleName: "", phoneticFamilyName: "", jobTitle: "", departmentName: "", organizationName: "1234", phoneticOrganizationName: "", postalAddresses: [], emailAddresses: [], birthday: Handshakes2.Birthday(year: 0, month: 0, day: 0), dates: []))], letters: ["К", "У", "A", "B", "H", "Z", "1"], updated: true, err: false, loaded: true)
        contactsData.order = 3
        contactsData.jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMTk2In0.5va4GSF251o7ZanaZ6kI22N19gHsY_h9PWarCEMvcY4"
        
        historyData.jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMTk2In0.5va4GSF251o7ZanaZ6kI22N19gHsY_h9PWarCEMvcY4"
        
        historyData.datta = [Handshakes2.SearchHistory(id: UUID(uuidString: "2A079572-1C2C-48ED-857A-1DF4B7A97195")!, number: "+7 909 909-00-09", date: Date(), res: true, searching: false, handhsakes: Optional([Handshakes2.SearchPathDecoded(path_id: "233DCB1EE69511ECAE590242AC120003", dep: 0, print: ["-", "+7 903 668-90-41", ""], path: [Handshakes2.SearchPathDecodedPath(number: "-", guid: "233D3773E69511ECAE590242AC120003"), Handshakes2.SearchPathDecodedPath(number: "+7 903 668-90-41", guid: "233D47D4E69511ECAE590242AC120003"), Handshakes2.SearchPathDecodedPath(number: "", guid: "233DB13EE69511ECAE590242AC120003")])]), error: "", handshakes_lines: 10)]

        historyData.selectedHistory = UUID(uuidString: "2A079572-1C2C-48ED-857A-1DF4B7A97195")
        
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
