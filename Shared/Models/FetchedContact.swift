//
//  FetchedContact.swift
//  Handshakes2
//
//  Created by Kirill Burchenko on 18.05.2022.
//

import Foundation
import Contacts
import PhoneNumberKit

struct FetchedContact: Hashable, Encodable, Decodable,  Identifiable {
    var id: String
    let firstName: String
    let lastName: String
    var telephone: [Number]
    var filterindex: String
    var shortSearch: String
    var longSearch: String
//    var guid: [String]
    let fullContact: FullContact
    var index: Int
    var hiden: Bool
}

struct FetchedGroup: Hashable, Codable, Identifiable {
    let id: Int
    let name: String
    let accountid: String
    
}

struct Number: Hashable, Codable, Identifiable{
    let id: Int
    let title: String
    var phone: String
    var guid: String
}

struct FullContact: Hashable, Codable {
    let namePrefix, givenName, middleName, familyName, previousFamilyName, nameSuffix, nickname, phoneticGivenName, phoneticMiddleName, phoneticFamilyName: String
    let jobTitle, departmentName, organizationName, phoneticOrganizationName: String
    let postalAddresses:[Addres]
    let emailAddresses:[Email]
    let birthday: Birthday
    let dates: [Dates]
}

struct Addres: Hashable, Codable{
    var lable, street, subLocality, city, subAdministrativeArea, state, postalCode, country, countryCode: String
    
}

struct Email: Hashable, Codable{
    var lable, value: String
}

struct Birthday: Hashable, Codable{
    var year, month, day: Int
}

struct Dates: Hashable, Codable{
    var lable: String
    var value: DatePart
}

struct DatePart: Hashable, Codable{
    var year, month, day: Int
}

//class CList: Decodable, Encodable {
//    init() {
//    }
//    
//    func getContacts(returnCompletion: @escaping ([FetchedContact]) -> () ) {
//        DispatchQueue.main.async() {
//            self.fetchContacts(){
//                (data) in
//                returnCompletion(data as [FetchedContact])
//            }
//        }
//    }
//    
//    func requestAccess(returnCompletion: @escaping ([FetchedContact], Bool) -> () ) {
//        let store = CNContactStore()
//        switch CNContactStore.authorizationStatus(for: .contacts) {
//        case .authorized:
//            self.getContacts(){
//                (data) in
//                returnCompletion(data as [FetchedContact], false)
//            }
//        case .denied, .restricted:
//            returnCompletion([], true)
//            
//        case .notDetermined:
//            store.requestAccess(for: .contacts) { granted, error in
//                if granted {
//                    self.getContacts(){
//                        (data) in
//                        returnCompletion(data as [FetchedContact], false)
//                    }
//                }
//                else{
//                    returnCompletion([], true)
//                }
//            }
//        @unknown default:
//            print("error")
//        }
//    }
//    
//    private func fetchContacts(returnCompletion: @escaping ([FetchedContact]) -> () ){
//        
//        let store = CNContactStore()
//        let phoneNumberKit = PhoneNumberKit()
//        
//        var allNumbers: [String] = []
//        let t0 = DispatchTime.now()
//        
//        var contacts: [FetchedContact] = []
//        
//        var insertedCount = 0
//
//        
//        let keys = [
//            //        Contact Identification
//            CNContactIdentifierKey,
//            //        The contact’s unique identifier.
//            CNContactTypeKey,
//            //        The type of contact.
//            CNContactPropertyAttribute,
//            //        The contact's name component property key.
//            
//            //        Name
//            CNContactNamePrefixKey,
//            //        The prefix for the contact's name.
//            CNContactGivenNameKey,
//            //        The contact's given name.
//            CNContactMiddleNameKey,
//            //        The contact's middle name.
//            CNContactFamilyNameKey,
//            //        The contact's family name.
//            CNContactPreviousFamilyNameKey,
//            //        The contact's previous family name.
//            CNContactNameSuffixKey,
//            //        The contact's name suffix.
//            CNContactNicknameKey,
//            //        The contact's nickname.
//            CNContactPhoneticGivenNameKey,
//            //        The phonetic spelling of the contact's given name.
//            CNContactPhoneticMiddleNameKey,
//            //        The phonetic spelling of the contact's middle name.
//            CNContactPhoneticFamilyNameKey,
//            //        The phonetic spelling of the contact's family name.
//            
//            //        Work
//            CNContactJobTitleKey,
//            //        The contact's job title.
//            CNContactDepartmentNameKey,
//            //        The contact's department name.
//            CNContactOrganizationNameKey,
//            //        The contact's organization name.
//            CNContactPhoneticOrganizationNameKey,
//            //        The phonetic spelling of the contact's organization name.
//            
//            //        Addresses
//            CNContactPostalAddressesKey,
//            //        The postal addresses of the contact.
//            CNContactEmailAddressesKey,
//            //        The email addresses of the contact.
//            CNContactUrlAddressesKey,
//            //        The URL addresses of the contact.
//            CNContactInstantMessageAddressesKey,
//            //        The instant message addresses of the contact.
//            
//            //        Phone
//            CNContactPhoneNumbersKey,
//            //        A phone numbers of a contact.
//            
//            //        Social Profiles
//            CNContactSocialProfilesKey,
//            //        A social profiles of a contact.
//            
//            //        Birthday
//            CNContactBirthdayKey,
//            //        The birthday of a contact.
//            CNContactNonGregorianBirthdayKey,
//            //        The non-Gregorian birthday of the contact.
//            CNContactDatesKey,
//            //        Dates associated with a contact.
//            
//            //        Notes (Permition needed)
//            //         CNContactNoteKey,
//            //        A note associated with a contact.
//            //        com.apple.developer.contacts.notes
//            //        A Boolean value that indicates whether the app may access the notes stored in contacts.
//            
//            //        Images
//            CNContactImageDataKey,
//            //        Image data for a contact.
//            CNContactThumbnailImageDataKey,
//            //        Thumbnail data for a contact.
//            CNContactImageDataAvailableKey,
//            //        Image data availability for a contact.
//            
//            //        Relationships
//            CNContactRelationsKey,
//            //        The relationships of the contact.
//            
//            //        Groups and Containers
//            CNGroupNameKey,
//            //        The name of the group.
//            CNGroupIdentifierKey,
//            //        The identifier of the group.
//            CNContainerNameKey,
//            //        The name of the container.
//            CNContainerTypeKey,
//            //        The type of the container.
//            
//            //        Instant Messaging Keys
//            CNInstantMessageAddressServiceKey,
//            //        Instant message address service key.
//            CNInstantMessageAddressUsernameKey,
//            //        Instant message address username key.
//            
//            //        Social Profile Keys
//            CNSocialProfileServiceKey,
//            //        The social profile service.
//            CNSocialProfileURLStringKey,
//            //        The social profile URL.
//            CNSocialProfileUsernameKey,
//            //        The social profile user name.
//            CNSocialProfileUserIdentifierKey
//            //        The social profile user identifier.
//        ]
//        
//        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
//        request.sortOrder = CNContactSortOrder.userDefault
//        
//        print("DEFAULT ORDER")
//        
//        let sortOrder = CNContactsUserDefaults.shared().sortOrder
//        print(sortOrder.rawValue)
//        let queue: DispatchQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
//        let group: DispatchGroup = DispatchGroup()
//        group.enter()
//        queue.async {
//            do {
//                
//                try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
////                    print(contact.socialProfiles)
//                    var i=0
//                    var lsn=""
//                    var nn:[Number] = []
//                    for number in contact.phoneNumbers{
//                        let numberOk = number.value.stringValue
//                        allNumbers.append(numberOk)
//                        nn.append(Number(id: i, title: number.label?.replacingOccurrences(of: "_$!<", with: "").replacingOccurrences(of: ">!$_", with: "") ?? "", phone: numberOk, guid: ""))
//                        i+=1
//                        lsn+=numberOk
//                    }
//                    if (!nn.isEmpty){
//                        
//                        var addreses: [Addres] = []
//                        var emails: [Email] = []
//                        var dates: [Dates] = []
//                        
//                        for addres in contact.postalAddresses{
//                            addreses.append(Addres(lable: addres.label ?? "", street: addres.value.street, subLocality: addres.value.subLocality, city: addres.value.subLocality, subAdministrativeArea: addres.value.subAdministrativeArea, state: addres.value.state, postalCode: addres.value.postalCode, country: addres.value.country, countryCode: addres.value.isoCountryCode))
//                        }
//                        
//                        for email in contact.emailAddresses{
//                            emails.append(Email(lable: email.label ?? "", value: email.value as String))
//                        }
//                        for date in contact.dates{
//                            dates.append(Dates(lable: date.label ?? "", value: DatePart(year: date.value.year, month: date.value.month, day: date.value.day)))
//                        }
//                        
//                        let fullContact = FullContact(namePrefix: contact.namePrefix, givenName: contact.givenName, middleName: contact.middleName, familyName: contact.familyName, previousFamilyName: contact.previousFamilyName, nameSuffix: contact.nameSuffix, nickname: contact.nickname, phoneticGivenName: contact.phoneticGivenName, phoneticMiddleName: contact.phoneticMiddleName, phoneticFamilyName: contact.phoneticFamilyName, jobTitle: contact.jobTitle, departmentName: contact.departmentName, organizationName: contact.organizationName, phoneticOrganizationName: contact.phoneticOrganizationName, postalAddresses: addreses, emailAddresses: emails, birthday: Birthday(year: contact.birthday?.year ?? 0, month: contact.birthday?.month ?? 0, day: contact.birthday?.day ?? 0), dates: dates)
//                        
//                        insertedCount += nn.count
//                        
//                        i=0
//                        var lsm=""
//                        var em:[String] = []
//                        for email in contact.emailAddresses{
//                            em.append(String(email.value))
//                            i+=1
//                            lsm+=String(email.value)
//                        }
//                        var l=false
//                        var f=false
//                        for letter in contact.givenName {
//                            if (letter.isNumber){
//                                f=true
//                            }
//                        }
//                        for letter in contact.familyName {
//                            if (letter.isNumber){
//                                l=true
//                            }
//                        }
//                        if (sortOrder.rawValue == 3){
//                            //                            familyName
//                            if (l){
//                                contacts.append(FetchedContact(id: contact.identifier, firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: contact.familyName, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact, index: 0))
//                            }
//                            else{
//                                if (contact.familyName.trimmingCharacters(in: CharacterSet(charactersIn: " ")) != ""){
//                                    contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: contact.familyName, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact, index: 0))
//                                }
//                                else{
//                                    //                                last name is not empty
//                                    if (contact.givenName.trimmingCharacters(in: CharacterSet(charactersIn: " ")) != ""){
//                                        contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: contact.givenName, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact, index: 0))
//                                    }
//                                    //                                    use company name
//                                    else{
//                                        if (contact.organizationName != ""){
//                                            contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: contact.organizationName, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact, index: 0))
//                                        }
//                                        //                                        use email
//                                        else{
//                                            if (em.count > 0){
//                                                contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: em[0], shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact, index: 0))
//                                            }
//                                            else{
//                                                contacts.append(FetchedContact(id: contact.identifier,firstName: lsn, lastName: contact.familyName,  telephone: nn, filterindex: lsn, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact, index: 0))
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                        else{
//                            //                            givenName
//                            //                            given name is number
//                            if (f){
//                                contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: contact.givenName, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact, index: 0))
//                            }
//                            else{
//                                if (contact.givenName.trimmingCharacters(in: CharacterSet(charactersIn: " ")) != ""){
//                                    contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: contact.givenName, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact, index: 0))
//                                }
//                                else{
//                                    //                                last name is not empty
//                                    if (contact.familyName.trimmingCharacters(in: CharacterSet(charactersIn: " ")) != ""){
//                                        contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: contact.familyName, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact, index: 0))
//                                    }
//                                    //                                    use company name
//                                    else{
//                                        if (contact.organizationName != ""){
//                                            contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: contact.organizationName, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact, index: 0))
//                                        }
//                                        //                                        use email
//                                        else{
//                                            if (em.count > 0){
//                                                contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: em[0], shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact, index: 0))
//                                            }
//                                            else{
//                                                contacts.append(FetchedContact(id: contact.identifier,firstName: lsn, lastName: contact.familyName,  telephone: nn, filterindex: lsn, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact, index: 0))
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                        contacts[contacts.count-1].filterindex = contacts[contacts.count-1].filterindex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//                    }
//                })
//                
//                print("load time:")
//                print((DispatchTime.now().uptimeNanoseconds - t0.uptimeNanoseconds)/1_000_000_000)
//                let t = DispatchTime.now()
//                let validatedPhoneNumber = phoneNumberKit.parse(allNumbers, shouldReturnFailedEmptyNumbers: true)
//                print("format time:")
//                print((DispatchTime.now().uptimeNanoseconds - t.uptimeNanoseconds)/1_000_000_000)
//                var p = 0;
//                var newContacts: [FetchedContact] = []
//                for i in 0..<contacts.count{
//                    var newTelephone: [Number] = []
//                    for j in 0..<contacts[i].telephone.count{
//                        if (validatedPhoneNumber[p].type != .notParsed){
//                            newTelephone.append(Number(id: contacts[i].telephone[j].id, title: contacts[i].telephone[j].title, phone: phoneNumberKit.format(validatedPhoneNumber[p], toType: .international), guid: ""))
//                        }
//                        p+=1
//                    }
//                    if (!newTelephone.isEmpty){
//                        newContacts.append(FetchedContact(id: contacts[i].id, firstName: contacts[i].firstName, lastName: contacts[i].lastName, telephone: newTelephone, filterindex: contacts[i].filterindex, shortSearch: contacts[i].shortSearch, longSearch: contacts[i].longSearch, guid: contacts[i].guid, fullContact: contacts[i].fullContact, index: 0))
//                    }
//                }
//                contacts = newContacts
//                print("format time:")
//                print((DispatchTime.now().uptimeNanoseconds - t.uptimeNanoseconds)/1_000_000_000)
//                returnCompletion(contacts as [FetchedContact])
//                group.leave()
//            } catch let error {
//                print("Failed to enumerate contact", error)
//            }
//            
//            
//            
//        }
//        group.notify(queue: DispatchQueue.main) {
//            print("done!")
//        }
//    }
//    
//}
