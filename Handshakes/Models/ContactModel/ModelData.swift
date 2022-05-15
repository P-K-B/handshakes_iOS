

import Foundation
import SwiftUI
import PhoneNumberKit
import UIKit
import Combine

//var contacts: [FetchedContact] = CList().contacts

//var history: [SearchHistory] = GetHistory().history


//var alphabet_all = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
//                    "А","Б", "В", "Г", "Д", "Е", "Ё", "Ж", "З", "И", "Й", "К", "Л", "М", "Н", "О", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ъ", "Ы", "Ь", "Э", "Ю", "Я"]

//var alphabet:[String]=CAlpha().letters

class ContactsDataView: ObservableObject {
    @Published var contacts: [FetchedContact] = []
    @Published var updated: Bool = false
    @Published var err: Bool = false
    
    private let contactsService = ContactsService()
    
    private var cansellables = Set<AnyCancellable>()
    
    init(){
        //        self.contacts = [FetchedContact(id: "1", firstName: "Kirill", lastName: "Burchenko", telephone: [Number(id: 1, title: "work", phone: "+7 916 009-81-09")], filterindex: "", shortSearch: "", longSearch: "", guid: [])]
        //        self.updated = true
        addDataSubscriber()
    }
    
    func addDataSubscriber(){
        contactsService.$contacts
            .sink {[weak self] (returnedContacts) in
                self?.contacts=returnedContacts
            }
            .store(in: &cansellables)
        contactsService.$updated
            .sink {[weak self] (updated) in
                self?.updated=updated
            }
            .store(in: &cansellables)
        contactsService.$err
            .sink {[weak self] (err) in
                self?.err=err
            }
            .store(in: &cansellables)
    }
}

class ContactsService{
    @Published var contacts: [FetchedContact] = []
    @Published var updated: Bool = false
    @Published var err: Bool = false
    var contactsUploadSunscription: AnyCancellable?
    @AppStorage("jwt") var jwt: String = ""
    var uploadedDone: Bool = false
    var deletedDone: Bool = false
    
    init() {
        print(jwt)
        if let data = UserDefaults.standard.data(forKey: "ContactsData") {
            if let decoded = try? JSONDecoder().decode([FetchedContact].self, from: data) {
                //                Update contacts
                self.contacts = decoded
                self.updated = true
                self.err = err
                //                Get all contacts
                CList().requestAccess(){
                    (data, err) in
                    var bcp = self.contacts
                    var index = 0
                    while index < bcp.count {
                        bcp[index].guid = []
                        index+=1
                    }
                    //                    Has changed contacts
                    //                    print(bcp)
                    //                    print(data)
                    if (bcp != data){
                        self.updated = false
                        self.err = err
                        //                        sleep(5)
                        print("New contacts found")
                        let compareSetNew = Set(bcp)
                        let compareSetDeleted = Set(data)
                        var new = data.filter { !compareSetNew.contains($0) }
                        let deleted = bcp.filter { !compareSetDeleted.contains($0) }
                        print("New contacts")
                        print(new)
                        print("Deleted contacts")
                        print(deleted)
                        
                        //                Upload new contacts
                        
                        //                Uploda deleted conatcs
                        if (!deleted.isEmpty){
                            do{
                                try API().DeleteContacts(contacts: deleted){
                                    (reses) in
                                    print(reses)
                                    for contact in deleted {
                                        let index = bcp.enumerated().filter{$0.element == contact}.map{ $0.offset }
                                        if (!index.isEmpty){
                                            print("Delete at")
                                            print(index)
                                            withAnimation{
                                                if (!data.enumerated().filter{$0.element.id == contact.id}.map{ $0.offset }.isEmpty){
                                                    print("Updated contact")
                                                }
                                                else{
                                                    print("Deleted contact")
                                                    self.contacts.remove(at: index[0])
                                                }
                                            }
                                        }
                                    }
                                    self.deletedDone = true
                                    if (self.uploadedDone && self.deletedDone){
                                        self.save()
                                        self.updated = true
                                    }
                                    if (!new.isEmpty){
                                        do{
                                            try API().UploadContacts(contacts: new){
                                                (reses) in
                                                print(reses)
                                                
                                                for contact in new{
                                                    let index = data.enumerated().filter{$0.element == contact}.map{ $0.offset }
                                                    if (!index.isEmpty){
                                                        print("Insert at")
                                                        print(index)
                                                        for number in contact.telephone{
                                                            for guid in reses.payload.contacts.filter({ $0.value.phone == number.phone }){
                                                                new[new.enumerated().filter{$0.element.id == contact.id}.map{ $0.offset }[0]].guid.append(guid.key)
                                                            }
                                                        }
                                                        //                                                        withAnimation{
                                                        if (self.contacts[index[0]].id == contact.id){
                                                            print("Updated contact")
                                                            self.contacts[index[0]] = new[new.enumerated().filter{$0.element.id == contact.id}.map{ $0.offset }[0]]
                                                        }
                                                        else{
                                                            print("New contact")
                                                            self.contacts.insert(new[new.enumerated().filter{$0.element.id == contact.id}.map{ $0.offset }[0]], at: index[0])
                                                        }
                                                        //                                                        }
                                                    }
                                                    
                                                }
                                                self.uploadedDone = true
                                                if (self.uploadedDone && self.deletedDone){
                                                    self.save()
                                                    self.updated = true
                                                }
                                            }
                                        }
                                        catch{
                                            print ("Error")
                                        }
                                    }
                                    else{
                                        self.uploadedDone = true
                                    }
                                }
                                
                            }
                            catch{
                                print ("Error")
                            }
                        }
                        else{
                            self.deletedDone = true
                            if (!new.isEmpty){
                                do{
                                    try API().UploadContacts(contacts: new){
                                        (reses) in
                                        print(reses)
                                        
                                        for contact in new{
                                            let index = data.enumerated().filter{$0.element == contact}.map{ $0.offset }
                                            if (!index.isEmpty){
                                                //                                                print("Insert at")
                                                //                                                print(index)
                                                for number in contact.telephone{
                                                    for guid in reses.payload.contacts.filter({ $0.value.phone == number.phone }){
                                                        new[new.enumerated().filter{$0.element.id == contact.id}.map{ $0.offset }[0]].guid.append(guid.key)
                                                    }
                                                }
                                                withAnimation{
                                                    if (self.contacts[index[0]].id == contact.id){
                                                        //                                                        print("Updated contact")
                                                        self.contacts[index[0]] = new[new.enumerated().filter{$0.element.id == contact.id}.map{ $0.offset }[0]]
                                                    }
                                                    else{
                                                        //                                                        print("New contact")
                                                        self.contacts.insert(new[new.enumerated().filter{$0.element.id == contact.id}.map{ $0.offset }[0]], at: index[0])
                                                    }
                                                }
                                            }
                                            
                                        }
                                        self.uploadedDone = true
                                        if (self.uploadedDone && self.deletedDone){
                                            self.save()
                                            self.updated = true
                                        }
                                    }
                                }
                                catch{
                                    print ("Error")
                                }
                            }
                            else{
                                self.uploadedDone = true
                            }
                        }
                        //                        Delete old contacts
                        //                        Add new contacts
                        
                        
                        self.err = err
                    }
                }
                print("Contacts loaded")
                //                print(self.contacts)
                return
            }
        }
        self.contacts = []
        //        First fetch contacts
        //        Get all contacts
        CList().requestAccess(){
            (data, err) in
            //            reset guid
            var bcp = self.contacts
            for var contact in bcp{
                contact.guid = []
            }
            //                    Has changed contacts
            if (bcp != data){
                self.updated = false
                self.err = err
                //                sleep(5)
                print("New contacts found")
                let compareSetNew = Set(self.contacts)
                let compareSetDeleted = Set(data)
                var new = data.filter { !compareSetNew.contains($0) }
                let deleted = self.contacts.filter { !compareSetDeleted.contains($0) }
                print("New contacts")
//                print(new)
                print("Deleted contacts")
//                print(deleted)
                self.deletedDone = true
                
                //                Upload new contacts
                if (!new.isEmpty){
                    do{
                        try API().UploadContacts(contacts: new){
                            (reses) in
                            print(reses)
                            
                            DispatchQueue.global(qos: .userInitiated).async {
                                // Do some time consuming task in this background thread
                                // Mobile app will remain to be responsive to user actions
                                
                                print("Performing time consuming task in this background thread")
                                
                                for guid in reses.payload.contacts{
                                    print(guid)
                                    let index = new.enumerated().filter{$0.element.telephone.contains(where: {$0.phone == guid.value.phone})}.map{ $0.offset }
                                    print(index)
                                    if (!index.isEmpty){
                                        for i in index{
                                            new[i].guid.append(guid.key)
                                        }
                                    }
                                }
                                
//                                for contact in new{
//                                    let index = data.enumerated().filter{$0.element == contact}.map{ $0.offset }
//                                    if (!index.isEmpty){
//                                        //                                    print("Insert at")
//                                        //                                    print(index)
//                                        for number in contact.telephone{
//                                            //                                        print(number)
//                                            for guid in reses.payload.contacts.filter({ $0.value.phone == number.phone }){
//                                                //                                            print(guid)
//                                                //                                            print(contact.id)
//                                                //                                            print(new[new.enumerated().filter{$0.element.id == contact.id}.map{ $0.offset }[0]])
//                                                new[new.enumerated().filter{$0.element.id == contact.id}.map{ $0.offset }[0]].guid.append(guid.key)
//                                            }
//                                        }
//                                        //                                    withAnimation{
//                                        self.contacts.append(new.first(where: {$0.id == contact.id})!)
//                                        //                                    }
//                                    }
//
//                                }
                                
                               DispatchQueue.main.async {
                                   self.contacts = new
                                    // Task consuming task has completed
                                    // Update UI from this block of code
                                    print("Time consuming task has completed. From here we are allowed to update user interface.")
                                   
                                   self.uploadedDone = true
                                   if (self.uploadedDone && self.deletedDone){
                                       self.save()
                                       self.updated = true
                                   }
                                }
                            }
                            
                            
                            
                        }
                    }
                    catch{
                        print ("Error")
                    }
                }
                else{
                    self.uploadedDone = true
                }
                
                
                
                //                self.err = err
            }
        }
        print("Contacts fetched")
    }
    
    
    func save() {
        if let encoded = try? JSONEncoder().encode(self.contacts) {
            UserDefaults.standard.set(encoded, forKey: "ContactsData")
        }
        print("Contacts saved!")
//        print(self.contacts)
    }
}

class HistoryDataView: ObservableObject {
    @Published var history: [SearchHistory] = []
    //    @Published var updated: Bool = false
    //    @Published var err: Bool = false
    
    private let historyService = HistoryService()
    
    private var cansellables = Set<AnyCancellable>()
    
    init(){
        addDataSubscriber()
    }
    
    func addDataSubscriber(){
        historyService.$history
            .sink {[weak self] (returnedHistory) in
                self?.history=returnedHistory
            }
            .store(in: &cansellables)
    }
}

class HistoryService{
    @Published var history: [SearchHistory] = []
    //    @Published var updated: Bool = false
    //    @Published var err: Bool = false
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "HistoryData") {
            if let decoded = try? JSONDecoder().decode([SearchHistory].self, from: data) {
                self.history = decoded
                print("history loaded")
                return
            }
        }
        self.history = []
        print("history fetched")
        //        self.updated = true
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(self.history) {
            UserDefaults.standard.set(encoded, forKey: "HistoryData")
        }
        print("Contacts saved!")
    }
}

struct ContactsData: Decodable, Encodable, Identifiable {
    var id = UUID()
    
    var contacts: [FetchedContact] = []
    
    var updated = false
    
    var m: CList = CList()
    
    init() {
        //        print(UserDefaults.standard.data(forKey: "HistoryData")!)
        if let data = UserDefaults.standard.data(forKey: "ContactsData") {
            //            print(data)
            if let decoded = try? JSONDecoder().decode(ContactsData.self, from: data) {
                //                print(decoded)
                self = decoded
                self.updated = false
                //                self.update()
                
                print("Contacts loaded")
                return
            }
        }
        self.contacts = []
        print("Contacts fetched")
        self.updated = true
        self.save()
    }
    
    mutating func save() {
        //        text = "new text"
        //        self.text = newText
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: "ContactsData")
        }
        print("Contacts saved!")
    }
    
    
    mutating func update(){
        var result =  self
        CList().requestAccess(){
            (data, err) in
            result.contacts = data
            print(result.contacts)
            print("Contacts updated!")
            //            self.err = err
        }
        self = result
        self.save()
    }
    
    //    mutating func getContacts() {
    //        DispatchQueue.main.async {
    //            self.contacts = m.requestAccess() ?? []
    //        }
    //    }
}



struct SearchHistory: Hashable, Codable, Identifiable {
    var id = UUID()
    //    let firstName: String
    //    let lastName: String
    //    let job: String
    //    let telephone: [Number]
    let number: String
    var date: Date = Date()
    var res: Bool = false
    var searching: Bool = true
    var handhsakes: [SearchPathDecoded]?
    var error: String = ""
    var handshakes_lines: Int = 0
    
}

class GetHistory{
    var history = [SearchHistory(number:"+79160098110"),
                   SearchHistory(number:"+79160098110"),
                   SearchHistory(number:"+79160098110"),
                   SearchHistory(number:"+79160098110")
    ]
}

struct HistoryData: Decodable, Encodable, Identifiable {
    var id = UUID()
    
    var history: [SearchHistory]
    
    init() {
        //        print(UserDefaults.standard.data(forKey: "HistoryData")!)
        if let data = UserDefaults.standard.data(forKey: "HistoryData") {
            //            print(data)
            if let decoded = try? JSONDecoder().decode(HistoryData.self, from: data) {
                //                print(decoded)
                print("History loaded")
                self = decoded
                var index = 0;
                while index < self.history.count{
                    if (self.history[index].searching){
                        self.history[index].res = false
                        self.history[index].searching = false
                        self.history[index].error = "Loading failed"
                        self.history[index].handhsakes = []
                    }
                    index += 1
                }
                return
            }
        }
        //        self.history = GetHistory().history
        //        self.history = [SearchHistory(number: "+79160098109", date: Date(), res: true, searching: false, handhsakes: ["+79160098109","+35799206068","+79160098109","+35799206068","+79160098109"])]
        self.history = []
        print("History fetched")
        self.save()
    }
    
    mutating func save() {
        //        text = "new text"
        //        self.text = newText
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: "HistoryData")
        }
        print("History saved!")
    }
    
}


class API1234 {
    
    func ValidateNumber(contact: FetchedContact,completion: @escaping (FetchedContact) -> ()) async{
        
        print(contact.firstName)
        
        let phoneNumberKit = PhoneNumberKit()
        var new = contact
        var numbers: [Number] = []
        
        //        for i in 0..<new.count{
        for j in 0..<new.telephone.count{
            do{
                let validatedPhoneNumber = try phoneNumberKit.parse(new.telephone[j].phone)
                numbers.append(Number(id: new.telephone[j].id, title: new.telephone[j].title, phone: phoneNumberKit.format(validatedPhoneNumber, toType: .international)))
            }
            catch {
                print ("error")
            }
        }
        //        }
        new.telephone = numbers
        let decodedData = new
        DispatchQueue.main.async {
            completion(decodedData)
        }
    }
    
    //    func Load(row: SearchHistory, completion: @escaping (SearchHistory) -> ()) async throws {
    //        await Task.sleep(UInt64(Double(Int.random(in: 2...4)) * Double(NSEC_PER_SEC)))
    //        let r = Int.random(in: 1...3)
    //        switch r {
    //        case 1:
    //            let decodedData = SearchHistory(number: row.number, date: row.date, res: false, searching: false, handhsakes: [])
    //            //            decodedData.searching = false
    //            //            decodedData.res = false
    //            //            decodedData.handhsakes = []
    //            //            print ("no")
    //            //            print(decodedData)
    //            DispatchQueue.main.async {
    //                completion(decodedData)
    //            }
    //            //            historyData.save()
    //        case 2:
    //            let decodedData = SearchHistory(number: row.number, date: row.date, res: true, searching: false, handhsakes: ["+1 888-555-5512"])
    //            //            decodedData.searching = false
    //            //            decodedData.res = true
    //            //            decodedData.handhsakes = ["+79160098109"]
    //            //            print ("1")
    //            //            print(decodedData)
    //            DispatchQueue.main.async {
    //                completion(decodedData)
    //            }
    //            //            historyData.save()
    //        case 3:
    //            let decodedData = SearchHistory(number: row.number, date: row.date, res: true, searching: false, handhsakes: ["+79160098109","+35799206068","+79160098109","+35799206068","+79160098109"])
    //            //            decodedData.searching = false
    //            //            decodedData.res = true
    //            //            decodedData.handhsakes = ["+79160098109","+35799206068","+79160098109","+35799206068","+79160098109"]
    //            //            print ("5")
    //            //            print(decodedData)
    //            DispatchQueue.main.async {
    //                completion(decodedData)
    //            }
    //            //            historyData.save()
    //        default:
    //            let decodedData = SearchHistory(number: row.number, date: row.date, res: false, searching: false, handhsakes: [])
    //            //            decodedData.searching = false
    //            //            decodedData.res = false
    //            //            decodedData.handhsakes = []
    //            //            print ("def")
    //            //            print(decodedData)
    //            DispatchQueue.main.async {
    //                completion(decodedData)
    //            }
    //        }
    //
    //
    //    }
    
    func ModeContacts(contacts: [FetchedContact], completion: @escaping ([FetchedContact]) -> ()) async throws {
        await Task.sleep(UInt64(Double(Int.random(in: 2...4)) * Double(NSEC_PER_SEC)))
        //        let decodedData = SearchHistory(number: row.number, date: row.date, res: false, searching: false, handhsakes: [])
        let decodedData: [FetchedContact] = []
        //            decodedData.searching = false
        //            decodedData.res = false
        //            decodedData.handhsakes = []
        //            print ("no")
        //            print(decodedData)
        DispatchQueue.main.async {
            completion(decodedData)
        }
    }
    
    func ValidateContacts(contacts: [FetchedContact], completion: @escaping ([FetchedContact]) -> ()) async throws {
        
        //        await Task.sleep(UInt64(Double(Int.random(in: 2...4)) * Double(NSEC_PER_SEC)))
        let phoneNumberKit = PhoneNumberKit()
        var allNumbers:[String] = []
        
        for i in 0..<contacts.count{
            for j in 0..<contacts[i].telephone.count{
                allNumbers.append(contacts[i].telephone[j].phone)
            }
        }
        
        let validatedPhoneNumber = phoneNumberKit.parse(allNumbers, shouldReturnFailedEmptyNumbers: true)
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
                newContacts.append(FetchedContact(id: contacts[i].id, firstName: contacts[i].firstName, lastName: contacts[i].lastName, telephone: newTelephone, filterindex: contacts[i].filterindex, shortSearch: contacts[i].shortSearch, longSearch: contacts[i].longSearch, guid: contacts[i].guid, fullContact: contacts[i].fullContact))
                //                newContacts.append(FetchedContact(id: contacts[i].id, firstName: contacts[i].firstName, lastName: contacts[i].lastName, telephone: newTelephone, filterindex: contacts[i].filterindex, shortSearch: contacts[i].shortSearch, longSearch: contacts[i].longSearch, guid: contacts[i].guid))
            }
        }
        let decodedData = newContacts
        DispatchQueue.main.async {
            completion(decodedData)
        }
    }
    
    //    func UpdateContacts( completion: @escaping ([FetchedContact]) -> ()) throws {
    //
    ////
    //        guard let decodedData = CList.requestAccess() else { return nil}
    //
    //        DispatchQueue.main.async {
    //            completion(decodedData)
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
