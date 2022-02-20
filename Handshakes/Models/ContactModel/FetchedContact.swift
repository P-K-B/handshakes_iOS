

import Foundation
import SwiftUI
import Contacts
import PhoneNumberKit

struct FetchedContact: Hashable, Codable, Identifiable {
    var id: String
    let firstName: String
    let lastName: String
    let job: String
    var telephone: [Number]
    let emails: [String]
    let company: String
    var filterindex:String
    var shortSearch: String
    var longSearch: String
    
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
                    print(contact.socialProfiles)
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
                                contacts.append(FetchedContact(id: contact.identifier, firstName: contact.givenName, lastName: contact.familyName, job: contact.jobTitle, telephone: nn, emails: em, company: contact.organizationName, filterindex: contact.familyName, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName))
                            }
                            else{
                                if (contact.familyName.trimmingCharacters(in: CharacterSet(charactersIn: " ")) != ""){
                                    contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName, job: contact.jobTitle, telephone: nn, emails: em, company: contact.organizationName, filterindex: contact.familyName, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName))
                                }
                                else{
                                    //                                last name is not empty
                                    if (contact.givenName.trimmingCharacters(in: CharacterSet(charactersIn: " ")) != ""){
                                        contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName, job: contact.jobTitle, telephone: nn, emails: em, company: contact.organizationName, filterindex: contact.givenName, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName))
                                    }
                                    //                                    use company name
                                    else{
                                        if (contact.organizationName != ""){
                                            contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName, job: contact.jobTitle, telephone: nn, emails: em, company: contact.organizationName, filterindex: contact.organizationName, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName))
                                        }
                                        //                                        use email
                                        else{
                                            if (em.count > 0){
                                                contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName, job: contact.jobTitle, telephone: nn, emails: em, company: contact.organizationName, filterindex: em[0], shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName))
                                            }
                                            else{
                                                contacts.append(FetchedContact(id: contact.identifier,firstName: lsn, lastName: contact.familyName, job: contact.jobTitle, telephone: nn, emails: em, company: contact.organizationName, filterindex: lsn, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName))
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
                                contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName, job: contact.jobTitle, telephone: nn, emails: em, company: contact.organizationName, filterindex: contact.givenName, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName))
                            }
                            else{
                                if (contact.givenName.trimmingCharacters(in: CharacterSet(charactersIn: " ")) != ""){
                                    contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName, job: contact.jobTitle, telephone: nn, emails: em, company: contact.organizationName, filterindex: contact.givenName, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName))
                                }
                                else{
                                    //                                last name is not empty
                                    if (contact.familyName.trimmingCharacters(in: CharacterSet(charactersIn: " ")) != ""){
                                        contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName, job: contact.jobTitle, telephone: nn, emails: em, company: contact.organizationName, filterindex: contact.familyName, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName))
                                    }
                                    //                                    use company name
                                    else{
                                        if (contact.organizationName != ""){
                                            contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName, job: contact.jobTitle, telephone: nn, emails: em, company: contact.organizationName, filterindex: contact.organizationName, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName))
                                        }
                                        //                                        use email
                                        else{
                                            if (em.count > 0){
                                                contacts.append(FetchedContact(id: contact.identifier,firstName: contact.givenName, lastName: contact.familyName, job: contact.jobTitle, telephone: nn, emails: em, company: contact.organizationName, filterindex: em[0], shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName))
                                            }
                                            else{
                                                contacts.append(FetchedContact(id: contact.identifier,firstName: lsn, lastName: contact.familyName, job: contact.jobTitle, telephone: nn, emails: em, company: contact.organizationName, filterindex: lsn, shortSearch: contact.givenName + contact.familyName, longSearch: contact.givenName+contact.familyName+contact.jobTitle+lsn+lsm+contact.organizationName))
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
                        newContacts.append(FetchedContact(id: contacts[i].id, firstName: contacts[i].firstName, lastName: contacts[i].lastName, job: contacts[i].job, telephone: newTelephone, emails: contacts[i].emails, company: contacts[i].company, filterindex: contacts[i].filterindex, shortSearch: contacts[i].shortSearch, longSearch: contacts[i].longSearch))
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
