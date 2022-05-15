

import Foundation
import SwiftUI
import Contacts
import PhoneNumberKit

struct FetchedContact: Hashable, Encodable, Decodable,  Identifiable {
    var id: String
    let firstName: String
    let lastName: String
    //    let job: String
    var telephone: [Number]
    //    let emails: [String]
    //    let company: String
    var filterindex: String
    var shortSearch: String
    var longSearch: String
    var guid: [String]
    let fullContact: FullContact
    
    ////    extra
    ////    name
    //    let type: String?
    //    let property: String?
    //    let prefix: String?
    //    let middleName: String?
    //    let prevFamilyName: String?
    //    let nameSuffix: String?
    //    let nickname: String?
    //    let phoneticGivenName: String?
    //    let phoneticMiddleName: String?
    //    let pgoneticFamilyName: String?
    ////    job
    //    let department: String?
    //    let organization: String?
    //    let phoneticOrganization: String?
    //
    ////    addresses
    //    let postalAddresses: String?
    //    let urlAddresses: [String]?
    //    let instantMessageAddresses: [String]?
    //
    ////    Social Profiles
    //    let socialProfiles: [String]?
    //
    ////    Birthday
    //    let birthday: String?
    //    let nonGregorianBirthday: String?
    //    let dates: [String]?
    //
    ////    Notes (Permition needed)
    //    let noteKey: String?
    //
    ////    Images
    //    let imageData: String?
    //    let thumbnailImageData: String?
    //    let imageDataAvailable: String?
    //
    ////    Relationships
    //    let relations: [String]?
    
    //    func CompareNew (a: FetchedContact) -> Bool{
    //        var aa = a
    //        aa.guid = []
    //        if (self == aa){
    //            return true
    //        }
    //        return false
    //    }
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
}

//struct FullContact: Hashable, Codable{
//
//    //        Contact Identification
//    let identifierKey: String?
//    //        The contact’s unique identifier.
//
//    //    extra
//    //    name
//    let namePrefix: String?
//    //        The prefix for the contact's name.
//    let givenName: String?
//    //        The contact's given name.
//    let middleName: String?
//    //        The contact's middle name.
//    let familyName: String?
//    //        The contact's family name.
//    let previousFamilyNameKey: String?
//    //        The contact's previous family name.
//    let nameSuffix: String?
//    //        The contact's name suffix.
//    //    let nickname: String
//    //        The contact's nickname.
//    let phoneticGivenName: String?
//    //        The phonetic spelling of the contact's given name.
//    let phoneticMiddleName: String?
//    //        The phonetic spelling of the contact's middle name.
//    let phoneticFamilyName: String?
//    //        The phonetic spelling of the contact's family name.
//
//    //    job
//    let department: String?
//    let organization: String?
//    let phoneticOrganization: String?
//
//    //    addresses
//    let postalAddresses: String?
//    let urlAddresses: [String]?
//    let instantMessageAddresses: [String]?
//
//    //    Social Profiles
//    let socialProfiles: [String]?
//
//    //    Birthday
//    let birthday: String?
//    let nonGregorianBirthday: String?
//    let dates: [String]?
//
//    //    Notes (Permition needed)
//    let noteKey: String?
//
//    //    Images
//    let imageData: String?
//    let thumbnailImageData: String?
//    let imageDataAvailable: String?
//
//    //    Relationships
//    let relations: [String]?
//}

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

//FullContact(namePrefix: "Mr", givenName: "Full", middleName: "", familyName: "Contact", previousFamilyName: "", nameSuffix: "", nickname: "Bu", phoneticGivenName: "", phoneticMiddleName: "", phoneticFamilyName: "", jobTitle: "", departmentName: "Back", organizationName: "PKB", phoneticOrganizationName: "",
//            cnContactPostalAddressesKey: [<CNLabeledValue: 0x600002f68600: identifier=693A3943-3884-4545-BBBB-9B3AFC61C5E7, label=_$!<Home>!$_, value=<CNMutablePostalAddress: 0x6000019e5ae0: street=Altufevo 88, subLocality=, city=Moscow, subAdministrativeArea=, state=Moscow, postalCode=127349, country=Russia, countryCode=ru>, iOSLegacyIdentifier=0>],
//            cnContactEmailAddressesKey: [<CNLabeledValue: 0x600002f686c0: identifier=A297BE7F-FF80-47F1-98B6-86AD9BEEB544, label=_$!<Home>!$_, value=htc.burchenko@gmail.com, iOSLegacyIdentifier=0>, <CNLabeledValue: 0x600002f68700: identifier=65DD0C91-CBCE-48DA-8B88-CFA326CB4A79, label=_$!<Work>!$_, value=kirill.burchenko@protonmail.com, iOSLegacyIdentifier=1>],
//            cnContactBirthdayKey: calendar: gregorian (fixed) year: 2015 month: 2 day: 25 isLeapMonth: false ,
//            cnContactNonGregorianBirthdayKey: isLeapMonth: false ,
//            cnContactDatesKey: [<CNLabeledValue: 0x600002f685c0: identifier=5C11B1C1-26DC-44B5-B099-740C181E8602, label=_$!<Anniversary>!$_,
//                                value=<NSDateComponents: 0x6000038d31b0> {
//    Calendar: <CFCalendar 0x6000019e5a90 [0x7fff8a349bf0]>{identifier = 'gregorian'}
//    Calendar Year: 2016
//    Month: 7
//    Leap Month: 0
//    Day: 20, iOSLegacyIdentifier=0>])

//class GList{
//
//    var groups:[FetchedGroup] = []
//
//    init() {
//        fetchGroups()
//        print (groups)
//    }
//
//    public func fetchGroups() {
//        var i=0;
//        let store = CNContactStore()
//
//        var allContainers: [CNContainer] = []
//        do{
//            allContainers = try store.containers(matching: nil)
//        }
//        catch{
//            print ("error")
//        }
//
//        for container in allContainers{
//            print(container)
//            self.groups.append(FetchedGroup(id:i, name: container.name, accountid: container.identifier))
//            i+=1
//        }
//
//
//    }
//}

class CList: Decodable, Encodable {
    init() {
    }
    
    func getContacts(returnCompletion: @escaping ([FetchedContact]) -> () ) {
        //        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
        DispatchQueue.main.async() {
            self.fetchContacts(){
                (data) in
                returnCompletion(data as [FetchedContact])
            }
        }
    }
    
    func requestAccess(returnCompletion: @escaping ([FetchedContact], Bool) -> () ) {
        let store = CNContactStore()
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            self.getContacts(){
                (data) in
                //                self.contacts = data
                returnCompletion(data as [FetchedContact], false)
            }
        case .denied, .restricted:
            //            self.err = true
            returnCompletion([], true)
            
        case .notDetermined:
            store.requestAccess(for: .contacts) { granted, error in
                if granted {
                    self.getContacts(){
                        (data) in
                        returnCompletion(data as [FetchedContact], false)
                        //                        self.contacts = data
                    }
                }
                else{
                    returnCompletion([], true)
                }
            }
        @unknown default:
            print("error")
        }
    }
    
    private func fetchContacts(returnCompletion: @escaping ([FetchedContact]) -> () ){
        
        let store = CNContactStore()
        let phoneNumberKit = PhoneNumberKit()
        
        var allNumbers: [String] = []
        let t0 = DispatchTime.now()
        
        var contacts: [FetchedContact] = []
        
        var insertedCount = 0
        
        
        //                contacts = []
        
        //        let keys = [CNContactIdentifierKey, CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactJobTitleKey, CNGroupNameKey, CNGroupIdentifierKey, CNContainerNameKey, CNContainerTypeKey, CNContactOrganizationNameKey, CNContactEmailAddressesKey]
        
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
        let queue: DispatchQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
        let group: DispatchGroup = DispatchGroup()
        group.enter()
        queue.async {
            do {
                
                try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
//                    print(contact.socialProfiles)
                    var i=0
                    var lsn=""
                    var nn:[Number] = []
                    for number in contact.phoneNumbers{
                        let numberOk = number.value.stringValue
                        allNumbers.append(numberOk)
                        nn.append(Number(id: i, title: number.label?.replacingOccurrences(of: "_$!<", with: "").replacingOccurrences(of: ">!$_", with: "") ?? "", phone: numberOk))
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
//                        , cnContactPostalAddressesKey: contact.postalAddresses, cnContactEmailAddressesKey: contact.emailAddresses, cnContactBirthdayKey: contact.birthday ?? DateComponents(), cnContactNonGregorianBirthdayKey: contact.nonGregorianBirthday ?? DateComponents(), cnContactDatesKey: contact.dates)
//                        
//                        print(fullContact)
                        
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
                                contacts.append(FetchedContact(id: contact.identifier, firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: contact.familyName, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact))
                            }
                            else{
                                if (contact.familyName.trimmingCharacters(in: CharacterSet(charactersIn: " ")) != ""){
                                    contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: contact.familyName, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact))
                                }
                                else{
                                    //                                last name is not empty
                                    if (contact.givenName.trimmingCharacters(in: CharacterSet(charactersIn: " ")) != ""){
                                        contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: contact.givenName, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact))
                                    }
                                    //                                    use company name
                                    else{
                                        if (contact.organizationName != ""){
                                            contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: contact.organizationName, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact))
                                        }
                                        //                                        use email
                                        else{
                                            if (em.count > 0){
                                                contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: em[0], shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact))
                                            }
                                            else{
                                                contacts.append(FetchedContact(id: contact.identifier,firstName: lsn, lastName: contact.familyName,  telephone: nn, filterindex: lsn, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact))
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
                                contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: contact.givenName, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact))
                            }
                            else{
                                if (contact.givenName.trimmingCharacters(in: CharacterSet(charactersIn: " ")) != ""){
                                    contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: contact.givenName, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact))
                                }
                                else{
                                    //                                last name is not empty
                                    if (contact.familyName.trimmingCharacters(in: CharacterSet(charactersIn: " ")) != ""){
                                        contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: contact.familyName, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact))
                                    }
                                    //                                    use company name
                                    else{
                                        if (contact.organizationName != ""){
                                            contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: contact.organizationName, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact))
                                        }
                                        //                                        use email
                                        else{
                                            if (em.count > 0){
                                                contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName,  telephone: nn, filterindex: em[0], shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact))
                                            }
                                            else{
                                                contacts.append(FetchedContact(id: contact.identifier,firstName: lsn, lastName: contact.familyName,  telephone: nn, filterindex: lsn, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName, guid: [], fullContact: fullContact))
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        contacts[contacts.count-1].filterindex = contacts[contacts.count-1].filterindex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
                    }
                })
                
                print("load time:")
                print((DispatchTime.now().uptimeNanoseconds - t0.uptimeNanoseconds)/1_000_000_000)
                let t = DispatchTime.now()
                //        print(t)
                //        print(allNumbers)
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
                        //                if (allNumbers[p] != contacts[i].telephone[j].phone){
                        //                    print ("HERE!")
                        //                }
                        //                print ("\(allNumbers[p]) \(contacts[i].telephone[j].phone) -> \(validatedPhoneNumber[p].numberString) \(contacts[i].shortSearch)")
                        p+=1
                    }
                    if (!newTelephone.isEmpty){
                        newContacts.append(FetchedContact(id: contacts[i].id, firstName: contacts[i].firstName, lastName: contacts[i].lastName, telephone: newTelephone, filterindex: contacts[i].filterindex, shortSearch: contacts[i].shortSearch, longSearch: contacts[i].longSearch, guid: contacts[i].guid, fullContact: contacts[i].fullContact))
                    }
                }
                //        print(validatedPhoneNumber)
                contacts = newContacts
                //        print ("\(allNumbers.count) : \(validatedPhoneNumber.count) p=\(p) : \(insertedCount)")
                //        print(allNumbers)
                print("format time:")
                print((DispatchTime.now().uptimeNanoseconds - t.uptimeNanoseconds)/1_000_000_000)
                returnCompletion(contacts as [FetchedContact])
                group.leave()
            } catch let error {
                print("Failed to enumerate contact", error)
            }
            
            
            
        }
        group.notify(queue: DispatchQueue.main) {
            print("done!")
        }
        
        
        //                       print(contacts[0])
    }
    
}


class CAlpha {
    
    var letters: [String]
    
    var code: String
    
    //    var extra: Bool
    
    init(contacts: [FetchedContact]) {
        letters=[]
        code = CNContactsUserDefaults.shared().countryCode
        //        extra = false
        GetLetters(contacts: contacts)
        
        //        print (contacts)
    }
    
    public func GetLetters(contacts: [FetchedContact]) {
        for contact in contacts{
            if (!self.letters.contains(String(contact.filterindex.prefix(1)).uppercased())){
                self.letters.append(String(contact.filterindex.prefix(1)).uppercased())
            }
        }
    }
}
