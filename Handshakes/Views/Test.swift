//
//  Test.swift
//  Handshakes
//
//  Created by Kirill Burchenko on 01.12.2021.
//

import SwiftUI
import UIKit
import PhoneNumberKit

import Contacts

//struct Test: View {
//
//    @State private var contacts = [ContactInfo.init(firstName: "", lastName: "", phoneNumber: nil)]
//    //    @State var m: CList = CList()
//    @State var err: Bool = false
//
//    var body: some View {
//        VStack{
//
//            List {
//                Button(action:{
//                    self.requestAccess()
//
//                }){
//                    Text ("Fetch contacts")
//                }
//                ForEach (self.contacts){ contact in
//                    ContactRow2(contact: contact)
//                }
//
//            }
//        }
//        .onAppear() {
//            self.requestAccess()
//        }
//        .alert(isPresented: self.$err) {
//            Alert (title: Text("Contacts access required."),
//                   message: Text("Go to Settings?"),
//                   primaryButton: .default(Text("Settings"), action: {
//                       UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
//                   }),
//                   secondaryButton: .default(Text("Cancel")))
//        }
//    }
//
//    func getContacts() {
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
//            self.contacts = FetchContacts().fetchingContacts()
//
//        }
//    }
//
//    func requestAccess() {
//        let store = CNContactStore()
//        switch CNContactStore.authorizationStatus(for: .contacts) {
//        case .authorized:
//            self.getContacts()
//        case .denied, .restricted:
//            self.err = true
//        case .notDetermined:
//            store.requestAccess(for: .contacts) { granted, error in
//                if granted {
//                    self.getContacts()
//                }
//            }
//        @unknown default:
//            print("error")
//        }
//    }
//}
//
//struct ContactInfo : Identifiable{
//    var id = UUID()
//    var firstName: String
//    var lastName: String
//    var phoneNumber: CNPhoneNumber?
//}
//
//class FetchContacts {
//
//    func fetchingContacts() -> [ContactInfo]{
//        var contacts = [ContactInfo]()
//        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
//        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
//        do {
//            try CNContactStore().enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
//                contacts.append(ContactInfo(firstName: contact.givenName, lastName: contact.familyName, phoneNumber: contact.phoneNumbers.first?.value))
//            })
//        } catch let error {
//            print("Failed", error)
//        }
//        contacts = contacts.sorted {
//            $0.firstName < $1.firstName
//        }
//        return contacts
//    }
//}
//
//struct ContactRow2: View {
//    var contact: ContactInfo
//    var body: some View {
//        Text("\(contact.firstName) \(contact.lastName)").foregroundColor(.primary)
//    }
//}

//
//
struct Test: View {
    
    @State private var contacts: [FetchedContact] = []
    //    @State var m: CList = CList()
    @State var err: Bool = false
    
    var body: some View {
        VStack{
            List {
                Button(action:{
                    CList2().requestAccess(){
                        (data, err) in
                        self.contacts = data
                        self.err = err
                    }
                    
                }){
                    Text ("Fetch contacts")
                }
                ProgressView()
                ForEach (self.contacts){ contact in
                    ContactRow2(contact: contact)
                }
                
            }
        }
        .onAppear() {
            CList2().requestAccess(){
                (data, err) in
                self.contacts = data
                self.err = err
            }
        }
        .alert(isPresented: self.$err) {
            Alert (title: Text("Contacts access required."),
                   message: Text("Go to Settings?"),
                   primaryButton: .default(Text("Settings"), action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }),
                   secondaryButton: .default(Text("Cancel")))
        }
    }
    
    
    
    
}


struct ContactRow2: View {
    var contact: FetchedContact
    var body: some View {
        Text("\(contact.firstName) \(contact.lastName) \(contact.telephone[0].phone)").foregroundColor(.primary)
    }
}


class CList2: Decodable, Encodable {
    
    init() {
    }
    
    func getContacts(returnCompletion: @escaping ([FetchedContact]) -> () ) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
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
        
        let keys = [CNContactIdentifierKey, CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactJobTitleKey, CNGroupNameKey, CNGroupIdentifierKey, CNContainerNameKey, CNContainerTypeKey, CNContactOrganizationNameKey, CNContactEmailAddressesKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        request.sortOrder = CNContactSortOrder.userDefault
        
        print("DEFAULT ORDER")
        
        let sortOrder = CNContactsUserDefaults.shared().sortOrder
        print(sortOrder.rawValue)
        let queue: DispatchQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
        let group: DispatchGroup = DispatchGroup()
        group.enter()
        queue.async {
            do {
                
                try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
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

