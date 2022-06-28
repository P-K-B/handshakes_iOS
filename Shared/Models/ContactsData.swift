//
//  ContactsData.swift
//  Handshakes2
//
//  Created by Kirill Burchenko on 18.05.2022.
//

import Foundation
import Contacts
import PhoneNumberKit
import Combine
import UIKit
import SwiftUI

//struct ContactsDataView{
//}

struct ContactsData: Encodable, Decodable {
    var contacts: [FetchedContact] = []
    var hide:[String] = []
    var letters: [String] = []
    var updated: Bool = false
    var err: Bool = false
    var loaded: Bool = false
    var time: Date = Date()
    var time2: Date = Date()
    var time3: Date = Date()
    var time4: Date = Date()
    var time5: Date = Date()
    var time6: Date = Date()
    var time7: Date = Date()
    var time10: Date = Date()
    var time11: Date = Date()
//    var showedHide: Bool = false
}

struct CD: Encodable,Decodable{
    var contacts: [FetchedContact] = []
    var letters: [String] = []
    var order: Int
    var hide: [String] = []
//    var showHide: Bool
}

class ContactsDataView: ObservableObject {
    
    @Published var data: ContactsData = ContactsData()
    @Published var jwt: String = ""
    @Published var selectedContact: FetchedContact?
    @Published var order: Int = 0
    
    let contactsDataService = ContactsDataService()
    
    private var cansellables = Set<AnyCancellable>()
    
    init(){
        print("CONTACTS DATA: updated = \(data.updated)")
        addDataSubscriber()
    }
    
    func addDataSubscriber(){
        contactsDataService.$data
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    print (error.localizedDescription)
                }
            } receiveValue: { returnedData in
                self.data=returnedData
//                print("CONTACTS DATA: contacts = \(returnedData.contacts)")
            }
            .store(in: &cansellables)
        
        contactsDataService.$jwt
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    print (error.localizedDescription)
                }
            } receiveValue: { returnedData in
                self.jwt=returnedData
            }
            .store(in: &cansellables)
        contactsDataService.$selectedContact
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    print (error.localizedDescription)
                }
            } receiveValue: { returnedData in
                self.selectedContact=returnedData
            }
            .store(in: &cansellables)
        contactsDataService.$order
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    print (error.localizedDescription)
                }
            } receiveValue: { returnedData in
                self.order=returnedData
            }
            .store(in: &cansellables)
    }
    
    func save() {
        contactsDataService.save()
    }
    
    func reset(upload: Bool){
        contactsDataService.reset(upload: upload)
    }
    
    func SetJwt(jwt: String){
        contactsDataService.SetJwt(jwt: jwt)
    }
    
    func checkAccess() -> Bool{
        return contactsDataService.checkAccess()
    }
    
    //    func jwt(jwt: String){
    //        contactsDataService.SetJwt(jwt: jwt)
    //    }
    
    func SelectContact(contact: FetchedContact){
        contactsDataService.SelectContact(contact: contact)
    }
    
    func Load(upload: Bool){
        contactsDataService.Load(upload: upload)
    }
    
    func Delete(){
        contactsDataService.Delete()
    }
    
    func addHide(id: String){
        contactsDataService.addHide(id: id)
    }
    
    func removeHide(id: String){
        contactsDataService.removeHide(id: id)
    }
    
    func updateHide(id: [String]){
        contactsDataService.updateHide(id: id)
    }
    
    func Upload(){
        contactsDataService.UploadLater()
    }
    
//    func ShowedHideTrue(completion: @escaping (Bool) -> ()){
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.contactsDataService.ShowedHideTrue()
//            DispatchQueue.main.async {
//                completion(true)
//            }
//        }
//    }
}

class ContactsDataService  {
    
    @Published var data: ContactsData = ContactsData()
    @Published var jwt: String = ""
    @Published var selectedContact: FetchedContact?
    @Published var order: Int = 0
//    @AppStorage("fresh") var fresh: Bool = true
    
    var contactsUploadSunscription: AnyCancellable?
    var contactsDeleteSunscription: AnyCancellable?
    
    var new: [FetchedContact] = []
    var deleted: [FetchedContact] = []
    var contactsFromPhone: [FetchedContact] = []
    var contactsFromApp: [FetchedContact] = []
    var filterindexPhone: [String:String] = [:]
    var update: [FetchedContact] = []
    var contactsFromAppGuid: [FetchedContact] = []
    var res: ([FetchedContact], [String], Int) = ([],[],0)
    @AppStorage("hideContacts") var hideContacts: Bool = false
    
    init() {
        //        self.data.loaded = true
        //        self.data.time = Date()
        
        
        
    }
    
    func addHide(id: String){
        self.data.hide.append(id)
        self.save()
    }
    
    func removeHide(id: String){
        self.data.hide.remove(at: self.data.hide.firstIndex(where: {$0 == id}) ?? 0)
        self.save()
    }
    
//    func ShowedHideTrue(){
//        self.data.showedHide = true
//        self.save()
//    }
    
    func updateHide(id: [String]){
//        self.data.showedHide = true
        if (self.data.hide.sorted(by: {$0 > $1}) != id.sorted(by: {$0 > $1})){
            let old = self.data.hide
            self.data.hide = id
            self.save()
//            contactsFromApp.difference(from: deleted)
            
//            Upload!
//            let deleted = old.filter({!id.contains($0)})
//            let new = id.filter({!old.contains($0)})
////            print(deleted)
////            print(new)
//            let newContacts = self.data.contacts.filter({new.contains($0.id)})
//            let deletedContacts = self.data.contacts.filter({deleted.contains($0.id)})
//                        print(deletedContacts)
//                        print(newContacts)
//
//            if (!new.isEmpty || !deleted.isEmpty || !update.isEmpty){
//
//                self.Upload(new: deletedContacts, deleted: newContacts, contactsFromPhone: self.contactsFromPhone, contactsFromApp: self.contactsFromApp, filterindexPhone: self.filterindexPhone, update: [], contactsFromAppGuid: self.contactsFromAppGuid, res: self.res)
//            }
            
        }
    }
    
    func Load(upload: Bool){
        if let data = UserDefaults.standard.data(forKey: "ContactsData") {
            if let decoded = try? JSONDecoder().decode(CD.self, from: data) {
                print("ContactsData loaded")
                self.data.contacts = decoded.contacts
                self.data.letters = decoded.letters
                self.order = decoded.order
                self.data.hide = decoded.hide
//                self.data.showedHide = decoded.showHide
                                self.data.loaded = true
                DispatchQueue.global(qos: .userInitiated).async {
                    self.GetNewContacts(upload: upload)
                    DispatchQueue.main.async {
                        // Task consuming task has completed
                        // Update UI from this block of code
                        //                        self.data.loaded = true
                        print("Time consuming task has completed. From here we are allowed to update user interface.")
                        
                    }
                }
                return
            }
        }
        else{
            self.data.contacts = []
            self.data.letters = []
//            self.data.hide = []
//            self.data.showedHide = false
            DispatchQueue.global(qos: .userInitiated).async {
                //                var parse =
                //                self.data.contacts = self.fetchContacts()
                                self.data.loaded = true
                self.GetNewContacts(upload: upload)
                DispatchQueue.main.async {
                    // Task consuming task has completed
                    // Update UI from this block of code
                    //                    self.data.loaded = true
                    print("Time consuming task has completed. From here we are allowed to update user interface.")
                    
                }
            }
        }
    }
    
    func Delete(){
        self.data = ContactsData()
        hideContacts = false
        self.save()
    }
    
    func SetJwt(jwt: String){
        self.jwt = jwt
    }
    
    func SelectContact(contact: FetchedContact){
        self.selectedContact = contact
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(CD(contacts: self.data.contacts, letters: self.data.letters, order: self.order, hide: self.data.hide)) {
            UserDefaults.standard.set(encoded, forKey: "ContactsData")
        }
        print("ContactsData saved!")
    }
    
    func reset(upload: Bool){
        self.data.contacts = []
        self.data.letters = []
        self.data.hide = []
        self.save()
        //        self.data.time = Date()
        DispatchQueue.global(qos: .userInitiated).async {
            //            var parse =
            //            self.data.contacts = self.fetchContacts()
            self.data.loaded = true
            self.GetNewContacts(upload: upload)
            DispatchQueue.main.async {
                // Task consuming task has completed
                // Update UI from this block of code
                print("Time consuming task has completed. From here we are allowed to update user interface.")
                
            }
        }
        //        self.data.updated = false
        //        self.data.err = false
        //        self.data.loaded = false
        print("UserData reseted")
        //        self.save()
    }
    
    func requestAccess() {
        _ = CNContactStore()
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            print("ok")
        case .denied, .restricted:
            print("not ok")
            
        case .notDetermined:
            print("not ok")
        @unknown default:
            print("error")
        }
    }
    
    func checkAccess() -> Bool {
        _ = CNContactStore()
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            return true
        case .denied, .restricted:
            return false
        case .notDetermined:
            return false
        @unknown default:
            return false
        }
    }
    
    func fetchContacts() -> ([FetchedContact],[String],Int) {
        
        let store = CNContactStore()
        let phoneNumberKit = PhoneNumberKit()
        
        var allNumbers: [String] = []
        let t0 = DispatchTime.now()
        
        var contacts: [FetchedContact] = []
        
        var insertedCount = 0
        var letters: [String] = []
        
        
        let keys = [
            //        Contact Identification
            CNContactIdentifierKey,
            //        The contact’s unique identifier.
            CNContactTypeKey,
            //        The type of contact.
            CNContactPropertyAttribute,
            //        The contact's name component property key.
            
            //        Name
            CNContactNamePrefixKey,
            //        The prefix for the contact's name.
            CNContactGivenNameKey,
            //        The contact's given name.
            CNContactMiddleNameKey,
            //        The contact's middle name.
            CNContactFamilyNameKey,
            //        The contact's family name.
            CNContactPreviousFamilyNameKey,
            //        The contact's previous family name.
            CNContactNameSuffixKey,
            //        The contact's name suffix.
            CNContactNicknameKey,
            //        The contact's nickname.
            CNContactPhoneticGivenNameKey,
            //        The phonetic spelling of the contact's given name.
            CNContactPhoneticMiddleNameKey,
            //        The phonetic spelling of the contact's middle name.
            CNContactPhoneticFamilyNameKey,
            //        The phonetic spelling of the contact's family name.
            
            //        Work
            CNContactJobTitleKey,
            //        The contact's job title.
            CNContactDepartmentNameKey,
            //        The contact's department name.
            CNContactOrganizationNameKey,
            //        The contact's organization name.
            CNContactPhoneticOrganizationNameKey,
            //        The phonetic spelling of the contact's organization name.
            
            //        Addresses
            CNContactPostalAddressesKey,
            //        The postal addresses of the contact.
            CNContactEmailAddressesKey,
            //        The email addresses of the contact.
            CNContactUrlAddressesKey,
            //        The URL addresses of the contact.
            CNContactInstantMessageAddressesKey,
            //        The instant message addresses of the contact.
            
            //        Phone
            CNContactPhoneNumbersKey,
            //        A phone numbers of a contact.
            
            //        Social Profiles
            CNContactSocialProfilesKey,
            //        A social profiles of a contact.
            
            //        Birthday
            CNContactBirthdayKey,
            //        The birthday of a contact.
            CNContactNonGregorianBirthdayKey,
            //        The non-Gregorian birthday of the contact.
            CNContactDatesKey,
            //        Dates associated with a contact.
            
            //        Notes (Permition needed)
            //         CNContactNoteKey,
            //        A note associated with a contact.
            //        com.apple.developer.contacts.notes
            //        A Boolean value that indicates whether the app may access the notes stored in contacts.
            
            //        Images
            CNContactImageDataKey,
            //        Image data for a contact.
            CNContactThumbnailImageDataKey,
            //        Thumbnail data for a contact.
            CNContactImageDataAvailableKey,
            //        Image data availability for a contact.
            
            //        Relationships
            CNContactRelationsKey,
            //        The relationships of the contact.
            
            //        Groups and Containers
            CNGroupNameKey,
            //        The name of the group.
            CNGroupIdentifierKey,
            //        The identifier of the group.
            CNContainerNameKey,
            //        The name of the container.
            CNContainerTypeKey,
            //        The type of the container.
            
            //        Instant Messaging Keys
            CNInstantMessageAddressServiceKey,
            //        Instant message address service key.
            CNInstantMessageAddressUsernameKey,
            //        Instant message address username key.
            
            //        Social Profile Keys
            CNSocialProfileServiceKey,
            //        The social profile service.
            CNSocialProfileURLStringKey,
            //        The social profile URL.
            CNSocialProfileUsernameKey,
            //        The social profile user name.
            CNSocialProfileUserIdentifierKey
            //        The social profile user identifier.
        ]
        
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        request.sortOrder = CNContactSortOrder.userDefault
        
        print("DEFAULT ORDER")
        
        let sortOrder = CNContactsUserDefaults.shared().sortOrder
        print(sortOrder.rawValue)
        
        do {
            
            try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                //                    print(contact.socialProfiles)
                var i=0
                var lsn=""
                var nn:[Number] = []
                for number in contact.phoneNumbers{
                    var numberOk = number.value.stringValue
                    if (numberOk.prefix(1) == "8"){
                        numberOk = "+7" + numberOk.dropFirst()
                    }
                    if (numberOk.prefix(1) != "+"){
                        numberOk = "+" + numberOk
                    }
                    allNumbers.append(numberOk)
                    nn.append(Number(id: i, title: number.label?.replacingOccurrences(of: "_$!<", with: "").replacingOccurrences(of: ">!$_", with: "") ?? "Phone", phone: numberOk))
                    i+=1
                    lsn+=numberOk
                }
                if (!nn.isEmpty){
                    
                    var addreses: [Addres] = []
                    var emails: [Email] = []
                    var dates: [Dates] = []
                    
                    for addres in contact.postalAddresses{
                        addreses.append(Addres(lable: addres.label ?? "", street: addres.value.street, subLocality: addres.value.subLocality, city: addres.value.subLocality, subAdministrativeArea: addres.value.subAdministrativeArea, state: addres.value.state, postalCode: addres.value.postalCode, country: addres.value.country, countryCode: addres.value.isoCountryCode))
                    }
                    
                    for email in contact.emailAddresses{
                        emails.append(Email(lable: email.label ?? "", value: email.value as String))
                    }
                    for date in contact.dates{
                        dates.append(Dates(lable: date.label ?? "", value: DatePart(year: date.value.year, month: date.value.month, day: date.value.day)))
                    }
                    
                    let fullContact = FullContact(namePrefix: contact.namePrefix, givenName: contact.givenName, middleName: contact.middleName, familyName: contact.familyName, previousFamilyName: contact.previousFamilyName, nameSuffix: contact.nameSuffix, nickname: contact.nickname, phoneticGivenName: contact.phoneticGivenName, phoneticMiddleName: contact.phoneticMiddleName, phoneticFamilyName: contact.phoneticFamilyName, jobTitle: contact.jobTitle, departmentName: contact.departmentName, organizationName: contact.organizationName, phoneticOrganizationName: contact.phoneticOrganizationName, postalAddresses: addreses, emailAddresses: emails, birthday: Birthday(year: contact.birthday?.year ?? 0, month: contact.birthday?.month ?? 0, day: contact.birthday?.day ?? 0), dates: dates)
                    
                    insertedCount += nn.count
                    
                    i=0
                    var lsm=""
                    var em:[String] = []
                    for email in contact.emailAddresses{
                        em.append(String(email.value))
                        i+=1
                        lsm+=String(email.value)
                    }
                    var l=false
                    var f=false
                    for letter in contact.givenName {
                        if (letter.isNumber){
                            f=true
                        }
                    }
                    for letter in contact.familyName {
                        if (letter.isNumber){
                            l=true
                        }
                    }
                    if (sortOrder.rawValue == 3){
                        //                            familyName
                        if (l){
                            contacts.append(FetchedContact(id: contact.identifier, firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: contact.familyName, shortSearch: contact.givenName + contact.familyName + lsn, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact, index: 0))
                        }
                        else{
                            if (contact.familyName.trimmingCharacters(in: CharacterSet(charactersIn: " ")) != ""){
                                contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: contact.familyName, shortSearch: contact.givenName + contact.familyName + lsn, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact, index: 0))
                            }
                            else{
                                //                                last name is not empty
                                if (contact.givenName.trimmingCharacters(in: CharacterSet(charactersIn: " ")) != ""){
                                    contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: contact.givenName, shortSearch: contact.givenName + contact.familyName + lsn, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact, index: 0))
                                }
                                //                                    use company name
                                else{
                                    if (contact.organizationName != ""){
                                        contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: contact.organizationName, shortSearch: contact.givenName + contact.familyName + lsn, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact, index: 0))
                                    }
                                    //                                        use email
                                    else{
                                        if (em.count > 0){
                                            contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: em[0], shortSearch: contact.givenName + contact.familyName + lsn, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact, index: 0))
                                        }
                                        else{
                                            contacts.append(FetchedContact(id: contact.identifier,firstName: lsn, lastName: contact.familyName,  telephone: nn, filterindex: lsn, shortSearch: contact.givenName + contact.familyName + lsn, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact, index: 0))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else{
                        //                            givenName
                        //                            given name is number
                        if (f){
                            contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: contact.givenName, shortSearch: contact.givenName + contact.familyName + lsn, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact, index: 0))
                        }
                        else{
                            if (contact.givenName.trimmingCharacters(in: CharacterSet(charactersIn: " ")) != ""){
                                contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: contact.givenName, shortSearch: contact.givenName + contact.familyName + lsn, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact, index: 0))
                            }
                            else{
                                //                                last name is not empty
                                if (contact.familyName.trimmingCharacters(in: CharacterSet(charactersIn: " ")) != ""){
                                    contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: contact.familyName, shortSearch: contact.givenName + contact.familyName + lsn, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact, index: 0))
                                }
                                //                                    use company name
                                else{
                                    if (contact.organizationName != ""){
                                        contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: contact.organizationName, shortSearch: contact.givenName + contact.familyName + lsn, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact, index: 0))
                                    }
                                    //                                        use email
                                    else{
                                        if (em.count > 0){
                                            contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: em[0], shortSearch: contact.givenName + contact.familyName + lsn, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact, index: 0))
                                        }
                                        else{
                                            contacts.append(FetchedContact(id: contact.identifier,firstName: lsn, lastName: contact.familyName,  telephone: nn, filterindex: lsn, shortSearch: contact.givenName + contact.familyName + lsn, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact, index: 0))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    let ii=contacts.count-1
                    contacts[ii].filterindex = contacts[ii].filterindex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
                    //                    print(contacts[ii].filterindex)
                    
                }
            })
            
            print("load time:")
            print((DispatchTime.now().uptimeNanoseconds - t0.uptimeNanoseconds)/1_000_000_000)
            let t = DispatchTime.now()
            let validatedPhoneNumber = phoneNumberKit.parse(allNumbers, shouldReturnFailedEmptyNumbers: true)
            print("format time:")
            print((DispatchTime.now().uptimeNanoseconds - t.uptimeNanoseconds)/1_000_000_000)
            var p = 0;
            var newContacts: [FetchedContact] = []
            for i in 0..<contacts.count{
                var newTelephone: [Number] = []
                for j in 0..<contacts[i].telephone.count{
                    if (validatedPhoneNumber[p].type != .notParsed){
                        newTelephone.append(Number(id: contacts[i].telephone[j].id, title: contacts[i].telephone[j].title, phone: phoneNumberKit.format(validatedPhoneNumber[p], toType: .international)))
                    }
                    p+=1
                }
                if (!newTelephone.isEmpty){
                    newContacts.append(FetchedContact(id: contacts[i].id, firstName: contacts[i].firstName, lastName: contacts[i].lastName, telephone: newTelephone, filterindex: contacts[i].filterindex, shortSearch: contacts[i].shortSearch, longSearch: contacts[i].longSearch, guid: contacts[i].guid, fullContact: contacts[i].fullContact, index: 0))
                    if (!letters.contains(String(contacts[i].filterindex.prefix(1)).uppercased())){
                        letters.append(String(contacts[i].filterindex.prefix(1)).uppercased())
                    }
                }
            }
            contacts = newContacts
            print("format time:")
            print((DispatchTime.now().uptimeNanoseconds - t.uptimeNanoseconds)/1_000_000_000)
            return (contacts, letters, sortOrder.rawValue)
        } catch let error {
            print("Failed to enumerate contact", error)
        }
        return ([], [], 0)
    }
    
    func UploadContacts(contacts: [FetchedContact] , completion: @escaping (UploadContactsResponse) -> ()) throws {
#if DEBUG
        let baseUrl="https://develop.freekiller.net"
#else
        let baseUrl="https://hand.freekiller.net"
#endif
        guard let url = URL(string: baseUrl + "/api/clients") else { fatalError("Missing URL") }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "PUT"
        // Set HTTP Request Header
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue( "Bearer \(jwt)", forHTTPHeaderField: "Authorization")
        
        
        var allContacts: [ContactWithInfo] = []
        for contact in contacts{
            for number in contact.telephone{
                allContacts.append(ContactWithInfo(phone: number.phone, contact_info: String(data: try JSONEncoder().encode(contact.fullContact), encoding: .utf8) ?? ""))
            }
        }
        let json = UploadContactsList(contacts: allContacts)
        let jsonData = try JSONEncoder().encode(json)
        //        print(jsonData)
        //        print(String(data: try! JSONEncoder().encode(json), encoding: String.Encoding.utf8)?.replacingOccurrences(of: "\\\"", with: "\"")  )
        urlRequest.httpBody = jsonData
        contactsUploadSunscription = URLSession.shared.dataTaskPublisher(for: urlRequest).subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                print(output.response)
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else{
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: UploadContactsResponse.self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    print (error.localizedDescription)
                }
            } receiveValue: { statusResponce in
                DispatchQueue.main.async {
                    completion(statusResponce)
                }
                self.contactsUploadSunscription?.cancel()
            }
    }
    
    func DeleteContacts(contacts: [FetchedContact] , completion: @escaping (StatusResponse) -> ()) throws {
#if DEBUG
        let baseUrl="https://develop.freekiller.net"
#else
        let baseUrl="https://hand.freekiller.net"
#endif
        guard let url = URL(string: baseUrl + "/api/clients/contacts") else { fatalError("Missing URL") }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "DELETE"
        // Set HTTP Request Header
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue( "Bearer \(jwt)", forHTTPHeaderField: "Authorization")
        
        var allContacts: [String] = []
        for contact in contacts {
            for number in contact.telephone{
                allContacts.append(number.phone)
            }
        }
        let json = AllContacts(contacts: allContacts)
        //        let json = AllContacts(contacs: [])
        
        let jsonData = try JSONEncoder().encode(json)
        //        print(jsonData)
        urlRequest.httpBody = jsonData
        //        print(urlRequest)
        contactsDeleteSunscription = URLSession.shared.dataTaskPublisher(for: urlRequest).subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                print(output.response)
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else{
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: StatusResponse.self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    print (error.localizedDescription)
                }
            } receiveValue: { statusResponce in
                DispatchQueue.main.async {
                    completion(statusResponce)
                }
                self.contactsDeleteSunscription?.cancel()
            }
    }
    
    func GetIds(contacts: [FetchedContact]) -> [String]{
        var res: [String] = []
        for contact in contacts{
            res.append(contact.id)
        }
        return res
    }
    
    func GetNewContacts(upload: Bool){
        
        print("HERE!!!")
        self.data.updated = false
        let res = self.fetchContacts()
        
        if (self.order != res.2){
            print("ReOrder")
            self.data.contacts = self.ReOrder(contacts: self.data.contacts, etalon: res.0)
        }
        
        //        var contactsFromPhone = res.0

        self.order = res.2
        let contactsFromAppGuid = self.data.contacts
        let res2 = self.CleanMemoryContacts(contacts: self.data.contacts)
        let res3 = self.CleanMemoryContacts(contacts: res.0)
        let contactsFromApp = res2.0
        let contactsFromPhone = res3.0
        //        let filterindexApp = res2.1
        let filterindexPhone = res3.1
        //        self.data.time11 = Date()
        var new: [FetchedContact] = []
        var deleted: [FetchedContact] = []
        var update: [FetchedContact] = []
        var new_id: [String] = []
        var deleted_id: [String] = []
        var update_id: [String] = []
        if (contactsFromPhone != contactsFromApp){
            //            self.data.updated = false
            print("New contacts found")
            let compareSetNew = Set(contactsFromApp)
            let compareSetDeleted = Set(contactsFromPhone)
            new = contactsFromPhone.filter { !compareSetNew.contains($0) }
            deleted = contactsFromApp.filter { !compareSetDeleted.contains($0) }
            
            new_id = GetIds(contacts: new)
            deleted_id = GetIds(contacts: deleted)
            update = new.filter({ (new_id.contains($0.id) && (deleted_id.contains($0.id)))})
            update_id = GetIds(contacts: update)
            new = new.filter({!update_id.contains($0.id)})
            deleted = deleted.filter({!update_id.contains($0.id)})
            
            print("New contacts")
            print(new.count)
            print("Deleted contacts")
            print(deleted.count)
            print("Updated contacts")
            print(update.count)
        }
        else{
            print("Contacts hasn't changed")
        }
        new = new.filter({!self.data.hide.contains($0.id)})
        deleted = deleted.filter({!self.data.hide.contains($0.id)})
        update = update.filter({!self.data.hide.contains($0.id)})
        
        self.new = new
        self.deleted = deleted
        self.contactsFromPhone = contactsFromPhone
        self.contactsFromApp = contactsFromApp
        self.filterindexPhone = filterindexPhone
        self.update = update
        self.contactsFromAppGuid = contactsFromAppGuid
        self.res = res
        
        //        self.data.time2 = Date()
        if (!new.isEmpty || !deleted.isEmpty || !update.isEmpty){
//            if (contactsFromApp.count != 0){
//                self.data.contacts = contactsFromAppGuid
//                self.data.letters = res.1
//            }
//            //            else{
//            //                self.data.contacts = contactsFromPhone
//            //            }
//            self.ManageContacts(new: new, deleted: deleted, contactsFromPhone: contactsFromPhone, contactsFromApp: contactsFromAppGuid, filterindexPhone: filterindexPhone, update: update)
            if (upload){

                self.Upload(new: new, deleted: deleted, contactsFromPhone: contactsFromPhone, contactsFromApp: contactsFromApp, filterindexPhone: filterindexPhone, update: update, contactsFromAppGuid: contactsFromAppGuid, res: res)
            }
            else{

                
                var app = self.ReOrder(contacts: contactsFromPhone, etalon: contactsFromPhone)
                app = self.RestoreIndex(contacts: app, index: filterindexPhone)
                self.data.contacts = app
                self.data.letters = res.1
                self.save()
                //            self.data.loaded = true
                //            sleep(1)
                self.data.updated = true
            }
        }
        else{
            print("Contacts fetched")
            self.data.letters = res.1
            self.save()
            //            self.data.loaded = true
            //            sleep(1)
            self.data.updated = true
            //            self.data.time10 = Date()
        }
        //        return contactsFromApp
    }
    
//    func UploadHide(){
//
////        print("HERE!!!")
////        self.data.updated = false
//        let res = self.fetchContacts()
//
//        if (self.order != res.2){
//            print("ReOrder")
////            self.data.contacts = self.ReOrder(contacts: self.data.contacts, etalon: res.0)
//        }
//
//        //        var contactsFromPhone = res.0
//
//        self.order = res.2
//        let contactsFromAppGuid = self.data.contacts
//        let res2 = self.CleanMemoryContacts(contacts: self.data.contacts)
//        let res3 = self.CleanMemoryContacts(contacts: res.0)
//        let contactsFromApp = res2.0
//        let contactsFromPhone = res3.0
//        //        let filterindexApp = res2.1
//        let filterindexPhone = res3.1
//        //        self.data.time11 = Date()
//        var new: [FetchedContact] = []
//        var deleted: [FetchedContact] = []
//        var update: [FetchedContact] = []
//        var new_id: [String] = []
//        var deleted_id: [String] = []
//        var update_id: [String] = []
//        if (contactsFromPhone != contactsFromApp){
//            //            self.data.updated = false
//            print("New contacts found")
//            let compareSetNew = Set(contactsFromApp)
//            let compareSetDeleted = Set(contactsFromPhone)
//            new = contactsFromPhone.filter { !compareSetNew.contains($0) }
//            deleted = contactsFromApp.filter { !compareSetDeleted.contains($0) }
//
//            new_id = GetIds(contacts: new)
//            deleted_id = GetIds(contacts: deleted)
//            update = new.filter({ (new_id.contains($0.id) && (deleted_id.contains($0.id)))})
//            update_id = GetIds(contacts: update)
//            new = new.filter({!update_id.contains($0.id)})
//            deleted = deleted.filter({!update_id.contains($0.id)})
//
//            print("New contacts")
//            print(new.count)
//            print("Deleted contacts")
//            print(deleted.count)
//            print("Updated contacts")
//            print(update.count)
//        }
//        else{
//            print("Contacts hasn't changed")
//        }
//        new = new.filter({!self.data.hide.contains($0.id)})
//        deleted = deleted.filter({!self.data.hide.contains($0.id)})
//        update = update.filter({!self.data.hide.contains($0.id)})
//        //        self.data.time2 = Date()
//        if (!new.isEmpty || !deleted.isEmpty || !update.isEmpty){
////            if (contactsFromApp.count != 0){
////                self.data.contacts = contactsFromAppGuid
////                self.data.letters = res.1
////            }
////            //            else{
////            //                self.data.contacts = contactsFromPhone
////            //            }
////            self.ManageContacts(new: new, deleted: deleted, contactsFromPhone: contactsFromPhone, contactsFromApp: contactsFromAppGuid, filterindexPhone: filterindexPhone, update: update)
//            if (upload){
//
//                self.Upload(new: new, deleted: deleted, contactsFromPhone: contactsFromPhone, contactsFromApp: contactsFromApp, filterindexPhone: filterindexPhone, update: update, contactsFromAppGuid: contactsFromAppGuid, res: res)
//            }
//            else{
//                self.new = new
//                self.deleted = deleted
//                self.contactsFromPhone = contactsFromPhone
//                self.contactsFromApp = contactsFromApp
//                self.filterindexPhone = filterindexPhone
//                self.update = update
//                self.contactsFromAppGuid = contactsFromAppGuid
//                self.res = res
//
//                var app = self.ReOrder(contacts: contactsFromPhone, etalon: contactsFromPhone)
//                app = self.RestoreIndex(contacts: app, index: filterindexPhone)
//                self.data.contacts = app
//                self.data.letters = res.1
//                self.save()
//                //            self.data.loaded = true
//                //            sleep(1)
//                self.data.updated = true
//            }
//        }
//        else{
//            print("Contacts fetched")
//            self.data.letters = res.1
//            self.save()
//            //            self.data.loaded = true
//            //            sleep(1)
//            self.data.updated = true
//            //            self.data.time10 = Date()
//        }
//        //        return contactsFromApp
//    }
    
    func UploadLater(){
        let new = self.new.filter({!self.data.hide.contains($0.id)})
        let deleted = self.deleted.filter({!self.data.hide.contains($0.id)})
        let update = self.update.filter({!self.data.hide.contains($0.id)})
        self.Upload(new: new, deleted: deleted, contactsFromPhone: self.contactsFromPhone, contactsFromApp: self.contactsFromAppGuid, filterindexPhone: self.filterindexPhone, update: update, contactsFromAppGuid: self.contactsFromAppGuid, res: self.res)
    }
    
    func Upload(new: [FetchedContact], deleted: [FetchedContact], contactsFromPhone: [FetchedContact], contactsFromApp: [FetchedContact], filterindexPhone: [String:String], update: [FetchedContact], contactsFromAppGuid: [FetchedContact], res: ([FetchedContact], [String], Int)){
        if (!new.isEmpty || !deleted.isEmpty || !update.isEmpty){
            if (contactsFromApp.count != 0){
                self.data.contacts = contactsFromAppGuid
                self.data.letters = res.1
            }
            //            else{
            //                self.data.contacts = contactsFromPhone
            //            }
            self.ManageContacts(new: new, deleted: deleted, contactsFromPhone: contactsFromPhone, contactsFromApp: contactsFromAppGuid, filterindexPhone: filterindexPhone, update: update, letters: res.1)
        }
    }
    
    
    
    func ManageContacts(new: [FetchedContact], deleted: [FetchedContact], contactsFromPhone: [FetchedContact], contactsFromApp: [FetchedContact], filterindexPhone: [String:String], update: [FetchedContact], letters: [String]){
        //        var uploadResult: UploadContactsResponsePayload = UploadContactsResponsePayload(contacts: [:])
        //        var _: [FetchedContact] = []
        var res1: UploadContactsResponsePayload = UploadContactsResponsePayload(contacts: [:])
        var res2: UploadContactsResponsePayload = UploadContactsResponsePayload(contacts: [:])
        //        Delete
        if (!deleted.isEmpty){
            DispatchQueue.global(qos: .userInitiated).async {
                
                let group = DispatchGroup()
                group.enter()
                
                // avoid deadlocks by not using .main queue here
                DispatchQueue.global().async {
                    while self.jwt == "" {
                    }
                    group.leave()
                }
                
                // wait ...
                group.wait()
//                sleep(3)
                do{
                    try self.DeleteContacts(contacts: deleted)
                    { (reses) in
                        //                        print(reses)
                        if (reses.status_code == 0){
                            
                            //                            new
                            if (!new.isEmpty){
                                do{
                                    try self.UploadContacts(contacts: new)
                                    { (reses2) in
                                        //                                    print(reses2)
                                        //                                    self.data.time4 = Date()
                                        res1 = reses2.payload
                                        
                                        //                                Show
                                        self.EditContacts(new: new, deleted: deleted, updated: update, contactsFromPhone: contactsFromPhone, contactsFromApp: contactsFromApp, uploadResult: res1, updateResult: res2, filterindexphone: filterindexPhone){re in
                                            self.data.contacts =  re
                                            self.data.letters = letters
                                            print("UserData fetched")
                                            self.save()
                                            self.data.updated = true
                                            //                                        self.data.time10 = Date()
                                        }
                                        
                                    }
                                }
                                catch{
                                    
                                }
                            }
                            else{
                                //                                Show
                                self.EditContacts(new: new, deleted: deleted, updated: update, contactsFromPhone: contactsFromPhone, contactsFromApp: contactsFromApp, uploadResult: res1, updateResult: res2, filterindexphone: filterindexPhone){re in
                                    self.data.contacts =  re
                                    self.data.letters = letters
                                    print("UserData fetched")
                                    self.save()
                                    self.data.updated = true
                                    //                                        self.data.time10 = Date()
                                }
                            }
                            
                        }
                    }
                }
                catch{
                }
                
                DispatchQueue.main.async {
                    // Task consuming task has completed
                    // Update UI from this block of code
                    print("Time consuming task has completed. From here we are allowed to update user interface.")
                    //                    self.data.contacts = res
                }
            }
        }
        //        New
        else if (!new.isEmpty){
            DispatchQueue.global(qos: .userInitiated).async {
                
                let group = DispatchGroup()
                group.enter()
                
                // avoid deadlocks by not using .main queue here
                DispatchQueue.global().async {
                    while self.jwt == "" {
                    }
                    group.leave()
                }
                
                // wait ...
                group.wait()
//                sleep(3)
                do{
                try self.UploadContacts(contacts: new)
                { (reses2) in
                    //                                    print(reses2)
                    //                                    self.data.time4 = Date()
                    res1 = reses2.payload
                    
                    //                                Show
                    self.EditContacts(new: new, deleted: deleted, updated: update, contactsFromPhone: contactsFromPhone, contactsFromApp: contactsFromApp, uploadResult: res1, updateResult: res2, filterindexphone: filterindexPhone){re in
                        self.data.contacts =  re
                        self.data.letters = letters
                        print("UserData fetched")
                        self.save()
                        self.data.updated = true
                        //                                        self.data.time10 = Date()
                    }
                    
                }
            }
            catch{
                
            }
                DispatchQueue.main.async {
                    // Task consuming task has completed
                    // Update UI from this block of code
                    print("Time consuming task has completed. From here we are allowed to update user interface.")
                    //                    self.data.contacts = res
                }
            }
        }
        else if (!update.isEmpty){
            DispatchQueue.global(qos: .userInitiated).async {
                
                let group = DispatchGroup()
                group.enter()
                
                // avoid deadlocks by not using .main queue here
                DispatchQueue.global().async {
                    while self.jwt == "" {
                    }
                    group.leave()
                }
                
                // wait ...
                group.wait()
//                sleep(3)
                do{
//                try self.UpdateContacts(contacts: new)
//                { (reses2) in
//                    //                                    print(reses2)
//                    //                                    self.data.time4 = Date()
//                    res2 = reses2.payload
//
//                    //                                Show
                    self.EditContacts(new: new, deleted: deleted, updated: update, contactsFromPhone: contactsFromPhone, contactsFromApp: contactsFromApp, uploadResult: res1, updateResult: res2, filterindexphone: filterindexPhone){re in
                        self.data.contacts =  re
                        self.data.letters = letters
                        print("Contacts fetched")
                        self.save()
                        self.data.updated = true
                        //                                        self.data.time10 = Date()
                    }
//
//                }
            }
            catch{
                
            }
                DispatchQueue.main.async {
                    // Task consuming task has completed
                    // Update UI from this block of code
                    print("Time consuming task has completed. From here we are allowed to update user interface.")
                    //                    self.data.contacts = res
                }
            }
        }
        
        
//                if (!update.isEmpty){
//                    do{
//                        try self.UpdateContacts(contacts: new)
//                        { (reses2) in
//                            //                                    print(reses2)
//        //                                    self.data.time4 = Date()
//                            res2 = reses2.payload
//
//
//
//                        }
//                    }
//                    catch{
//
//                    }
//                }
        
        
        //        else{
        //            DispatchQueue.global(qos: .userInitiated).async {
        //
        //                let group = DispatchGroup()
        //                group.enter()
        //
        //                // avoid deadlocks by not using .main queue here
        //                DispatchQueue.global().async {
        //                    while self.jwt == "" {
        //                    }
        //                    group.leave()
        //                }
        //
        //                // wait ...
        //                group.wait()
        //
        ////                self.data.time3 = Date()
        //
        //                do{
        //                    try self.UploadContacts(contacts: new)
        //                    { (reses) in
        //                        //                        print(reses)
        ////                        self.data.time4 = Date()
        //                        uploadResult = reses.payload
        //                        self.EditContacts(new: new, deleted: deleted, contactsFromPhone: contactsFromPhone, contactsFromApp: contactsFromApp, uploadResult: uploadResult, filterindexphone: filterindexPhone) {re in
        //                            self.data.contacts =  re
        //                            print("UserData fetched")
        //                            self.save()
        //                            self.data.updated = true
        ////                            self.data.time10 = Date()
        //                        }
        //
        //                    }
        //                }
        //                catch{
        //                }
        //
        //                DispatchQueue.main.async {
        //                    // Task consuming task has completed
        //                    // Update UI from this block of code
        //                    print("Time consuming task has completed. From here we are allowed to update user interface.")
        //                    //                    self.data.contacts = res
        //                }
        //            }
        //        }
        
        
        //        add guid
        
    }
    
    func EditContacts(new: [FetchedContact], deleted: [FetchedContact], updated: [FetchedContact], contactsFromPhone: [FetchedContact], contactsFromApp: [FetchedContact], uploadResult: UploadContactsResponsePayload, updateResult: UploadContactsResponsePayload, filterindexphone: [String:String] , completion: @escaping ([FetchedContact]) -> ()){
        var newGuid: [FetchedContact] = []
        var app: [FetchedContact] = []
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            var newNewGuid: [String:[String]] = [:]
            
            for guid in uploadResult.contacts{
                if (newNewGuid[guid.value.phone] == nil){
                    newNewGuid[guid.value.phone] = []
                }
                newNewGuid[guid.value.phone]?.append(guid.key)
            }
            //            print(newNewGuid)
            for contact in new {
                var a = contact
                for number in contact.telephone {
                    //                    a.guid.append(uploadResult.contacts.first{$0.value.phone == number.phone}?.key ?? "")
                    a.guid.append(contentsOf: newNewGuid[number.phone] ?? [])
                }
                newGuid.append(a)
            }
            
            if (deleted.isEmpty){
                app = contactsFromApp
            }
            else{
                app = contactsFromApp.difference(from: deleted)
            }
            
            app.append(contentsOf: newGuid)
            
//            Update
            if (updateResult.contacts.count > 0){
                print("Error?")
            }
            
            for contact in updated{
//                let guid = contact.guid
//                let filter = contact.filterindex
                let a = contactsFromApp.firstIndex(where: {$0.id == contact.id})
                let b = contactsFromPhone.firstIndex(where: {$0.id == contact.id})
                let c = app.firstIndex(where: {$0.id == contact.id})
                if ((b != nil) && (c != nil)){
//                var b = contactsFromApp[a ?? 0]
                    app[c ?? 0] = contactsFromPhone[b ?? 0]
                    app[c ?? 0].guid = contactsFromApp[a ?? 0].guid
                    app[c ?? 0].filterindex = contactsFromApp[a ?? 0].filterindex
                }
            }
            app.append(contentsOf: contactsFromPhone.filter({self.data.hide.contains($0.id)}))
            

            
            app = self.ReOrder(contacts: app, etalon: contactsFromPhone)
            app = self.RestoreIndex(contacts: app, index: filterindexphone)
            
            //            self.data.time7 = Date()
            
            
            DispatchQueue.main.async {
                // Task consuming task has completed
                // Update UI from this block of code
                print("Time consuming task has completed. From here we are allowed to update user interface.")
                //                    self.data.contacts = res
                completion(app)
            }
        }
        
        
        
    }
    
    func ReOrder(contacts: [FetchedContact], etalon: [FetchedContact]) -> [FetchedContact]{
        var ind:[String: Int] = [:]
        var i=0;
        for contact in etalon {
            ind[contact.id] = i
            i+=1
        }
        var a = contacts.sorted(by: {ind[$0.id] ?? 0 < ind[$1.id] ?? 0})
        for i in 0..<a.count{
            a[i].index = i
        }
        return a
        
    }
    
    //    func SaveIndex(contacts: [FetchedContact]) -> ([FetchedContact],[String:String]){
    //        var ind:[String: String] = [:]
    //        for contact in contacts {
    //            ind[contact.id] = contact.filterindex
    //        }
    //        return ind
    //    }
    
    func RestoreIndex(contacts: [FetchedContact], index:[String:String]) -> [FetchedContact]{
        var res: [FetchedContact] = []
        for contact in contacts {
            var a = contact
            a.filterindex = index[contact.id] ?? ""
            res.append(a)
        }
        return res
    }
    
    func CleanMemoryContacts(contacts: [FetchedContact]) -> ([FetchedContact], [String:String]){
        var clean = contacts
        var ind:[String: String] = [:]
        var index = 0
        while index < clean.count {
            ind[clean[index].id] = clean[index].filterindex
            clean[index].guid = []
            clean[index].filterindex = ""
            clean[index].index = 0
            index+=1
        }
        return (clean, ind)
    }
    
    
    //    func DeleteFromServer(delete: [FetchedContact]){
    //        DispatchQueue.global(qos: .userInitiated).async {
    //            do{
    //                try self.DeleteContacts(contacts: delete)
    //                { (reses) in
    //                    print(reses)
    //                }
    //            }
    //            catch{
    //            }
    //
    //            DispatchQueue.main.async {
    //                // Task consuming task has completed
    //                // Update UI from this block of code
    //                print("Time consuming task has completed. From here we are allowed to update user interface.")
    //            }
    //        }
    //    }
    //
    //    func UploadToServer(new: [FetchedContact]){
    //        DispatchQueue.global(qos: .userInitiated).async {
    //            do{
    //                try self.UploadContacts(contacts: new)
    //                { (reses) in
    //                    print(reses)
    //                }
    //            }
    //            catch{
    //            }
    //
    //            DispatchQueue.main.async {
    //                // Task consuming task has completed
    //                // Update UI from this block of code
    //                print("Time consuming task has completed. From here we are allowed to update user interface.")
    //            }
    //        }
    //    }
}


extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
