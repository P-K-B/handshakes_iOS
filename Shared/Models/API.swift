//
//  API.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 17.05.2022.
//

import Foundation
import Combine
import SwiftUI
//
//class API {
//
//    var pathSubscription: AnyCancellable?
//    var contactsUploadSunscription: AnyCancellable?
//    var contactsDeleteSunscription: AnyCancellable?
//    var verifySingUpCall: AnyCancellable?
//    var verifySingUpCallResend: AnyCancellable?
//    var signInUpCall: AnyCancellable?
//
//
//    func SignInUpCall(phone:String, agreement: Bool, token: String, completion: @escaping (StatusResponse) -> ()) throws {
//        guard let url = URL(string: "https://hand.freekiller.net/api/session") else { fatalError("Missing URL") }
//        var urlRequest = URLRequest(url: url)
//
//        urlRequest.httpMethod = "POST"
//        // Set HTTP Request Header
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let json = SingInUp(phone: phone, agreement_accepted: agreement, app_token: token)
//        let jsonData = try JSONEncoder().encode(json)
//        print(json)
//        urlRequest.httpBody = jsonData
//
//        signInUpCall = URLSession.shared.dataTaskPublisher(for: urlRequest).subscribe(on: DispatchQueue.global(qos: .default))
//            .tryMap { (output) -> Data in
//                print(output.response)
//                guard let response = output.response as? HTTPURLResponse,
//                      response.statusCode >= 200 && response.statusCode < 300 else{
//                    DispatchQueue.main.async {
//                        completion(StatusResponse(status_code: -1))
//                    }
//                    throw URLError(.badServerResponse)
//                }
//                return output.data
//            }
//            .receive(on: DispatchQueue.main)
//            .decode(type: StatusResponse.self, decoder: JSONDecoder())
//            .sink { (completion) in
//                switch completion{
//                case .finished:
//                    break
//                case .failure(let error):
//                    print (error.localizedDescription)
//                }
//            } receiveValue: { statusResponce in
//                print(statusResponce)
//                DispatchQueue.main.async {
//                    completion(statusResponce)
//                }
//                self.signInUpCall?.cancel()
//            }
//    }
//
//
//    func SignInUpCallAppToken(phone:String, token: String, completion: @escaping (AppTokenResponse) -> ()) throws {
//        guard let url = URL(string: "https://hand.freekiller.net/api/session") else { fatalError("Missing URL") }
//        var urlRequest = URLRequest(url: url)
//
//        urlRequest.httpMethod = "POST"
//        // Set HTTP Request Header
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let json = SingInUpToken(phone: phone, app_token: token)
//        let jsonData = try JSONEncoder().encode(json)
//        print(json)
//        urlRequest.httpBody = jsonData
//
//        signInUpCall = URLSession.shared.dataTaskPublisher(for: urlRequest).subscribe(on: DispatchQueue.global(qos: .default))
//            .tryMap { (output) -> Data in
//                print(output.response)
//                guard let response = output.response as? HTTPURLResponse,
//                      response.statusCode >= 200 && response.statusCode < 300 else{
//                    DispatchQueue.main.async {
//                        completion(AppTokenResponse(status_code: -1))
//                    }
//                    throw URLError(.badServerResponse)
//                }
//                return output.data
//            }
//            .receive(on: DispatchQueue.main)
//            .decode(type: AppTokenResponse.self, decoder: JSONDecoder())
//            .sink { (completion) in
//                switch completion{
//                case .finished:
//                    break
//                case .failure(let error):
//                    print (error.localizedDescription)
//                }
//            } receiveValue: { statusResponce in
//                print(statusResponce)
//                DispatchQueue.main.async {
//                    completion(statusResponce)
//                }
//                self.signInUpCall?.cancel()
//            }
//    }
//
//
//    func VerifySingUpCall(code: String, phone:String, token: String, completion: @escaping (SingInSMSResponse) -> ()) throws {
//        guard let url = URL(string: "https://hand.freekiller.net/api/session/verify") else { fatalError("Missing URL") }
//        var urlRequest = URLRequest(url: url)
//
//        urlRequest.httpMethod = "PUT"
//        // Set HTTP Request Header
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let json = VerifySingUp(code: code, phone: phone, app_token: token)
//        let jsonData = try JSONEncoder().encode(json)
//        print(json)
//        urlRequest.httpBody = jsonData
//
//        verifySingUpCall = URLSession.shared.dataTaskPublisher(for: urlRequest).subscribe(on: DispatchQueue.global(qos: .default))
//            .tryMap { (output) -> Data in
//                print(output.response)
//                guard let response = output.response as? HTTPURLResponse,
//                      response.statusCode >= 200 && response.statusCode < 300 else{
//                    DispatchQueue.main.async {
//                        completion(SingInSMSResponse(status_code: -1))
//                    }
//                    throw URLError(.badServerResponse)
//                }
//                return output.data
//            }
//            .receive(on: DispatchQueue.main)
//            .decode(type: SingInSMSResponse.self, decoder: JSONDecoder())
//            .sink { (completion) in
//                switch completion{
//                case .finished:
//                    break
//                case .failure(let error):
//                    print (error.localizedDescription)
//                }
//            } receiveValue: { statusResponce in
//                DispatchQueue.main.async {
//                    completion(statusResponce)
//                }
//                self.verifySingUpCall?.cancel()
//            }
//    }
//
//    func VerifySingUpCallResend(phone:String, completion: @escaping (SingInSMSResponse) -> ()) throws {
//        guard let url = URL(string: "https://hand.freekiller.net/api/session/verify") else { fatalError("Missing URL") }
//        var urlRequest = URLRequest(url: url)
//
//        urlRequest.httpMethod = "PUT"
//        // Set HTTP Request Header
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let json = PathNumber(phone: phone)
//
//        let jsonData = try JSONEncoder().encode(json)
//        print(json)
//        urlRequest.httpBody = jsonData
//
//        verifySingUpCallResend = URLSession.shared.dataTaskPublisher(for: urlRequest).subscribe(on: DispatchQueue.global(qos: .default))
//            .tryMap { (output) -> Data in
//                print(output.response)
//                guard let response = output.response as? HTTPURLResponse,
//                      response.statusCode >= 200 && response.statusCode < 300 else{
//                    DispatchQueue.main.async {
//                        completion(SingInSMSResponse(status_code: -1))
//                    }
//                    throw URLError(.badServerResponse)
//                }
//                return output.data
//            }
//            .receive(on: DispatchQueue.main)
//            .decode(type: SingInSMSResponse.self, decoder: JSONDecoder())
//            .sink { (completion) in
//                switch completion{
//                case .finished:
//                    break
//                case .failure(let error):
//                    print (error.localizedDescription)
//                }
//            } receiveValue: { statusResponce in
//                DispatchQueue.main.async {
//                    completion(statusResponce)
//                }
//                self.verifySingUpCallResend?.cancel()
//            }
//    }
//
//    //    func GetPath(row: SearchHistory, contactsManager: ContactsDataView , completion: @escaping (SearchHistory) -> ()) throws {
//    //        print (row.number)
//    //        guard let url = URL(string: "https://hand.freekiller.net/api/contacts/path") else { fatalError("Missing URL") }
//    //        var urlRequest = URLRequest(url: url)
//    //
//    //        urlRequest.httpMethod = "POST"
//    //        // Set HTTP Request Header
//    //        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
//    //        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    //        urlRequest.setValue( "Bearer \(jwt)", forHTTPHeaderField: "Authorization")
//    //
//    //        let json = PathNumber(phone: row.number)
//    //
//    //        let jsonData = try JSONEncoder().encode(json)
//    //        print(json)
//    //        print(jwt)
//    //        urlRequest.httpBody = jsonData
//    //        sleep(5)
//    //        pathSubscription = URLSession.shared.dataTaskPublisher(for: urlRequest)
//    //            .subscribe(on: DispatchQueue.global(qos: .default))
//    //            .tryMap { (output) -> Data in
//    //                print(output.response)
//    //                guard let response = output.response as? HTTPURLResponse,
//    //                      response.statusCode >= 200 && response.statusCode < 300 else{
//    //                    DispatchQueue.main.async {
//    //                        completion(SearchHistory(number: row.number, date: row.date, res: false, searching: false, handhsakes: [], error: URLError(.badServerResponse).localizedDescription))
//    //                    }
//    //                    throw URLError(.badServerResponse)
//    //                }
//    //                return output.data
//    //            }
//    //            .receive(on: DispatchQueue.main)
//    //            .decode(type: PathResponse.self, decoder: JSONDecoder())
//    //            .sink { (completion) in
//    //                switch completion{
//    //                case .finished:
//    //                    break
//    //                case .failure(let error):
//    //                    print (error.localizedDescription)
//    //                    break
//    //                }
//    //            } receiveValue: { statusResponce in
//    //                var decodedData: SearchHistory
//    //                if (statusResponce.status_code == 0){
//    //                    print(statusResponce.payload.path!)
//    //                    var decodedPathes:[SearchPathDecoded] = []
//    //                    var lines = 0
//    ////                    var j=0
//    //                    for shake_path in statusResponce.payload.path!{
//    //                        let path_len = shake_path.value.count
//    //                        //                        let index = contactsManager.contacts.enumerated().filter{$0.element.telephone.contains(where: {$0.phone == searchingNumber.handhsakes![key]![1].phone})}.map{ $0.offset }
//    //                        var decodedPath = SearchPathDecoded(path_id: shake_path.key, dep: path_len, path: [[]])
//    //                        if (path_len == 2){
//    //                            decodedPath = decodedPathes.first(where: {$0.dep == path_len}) ?? SearchPathDecoded(path_id: shake_path.key, dep: path_len, path: [[]])
//    //                            var i=0;
//    //                            for row in shake_path.value{
//    //                                if (i != 0){
//    //                                    if (!(decodedPath.path[0].contains(row.phone ?? ""))){
//    //                                        decodedPath.path[0].append(row.phone ?? "")
//    ////                                        let count = contactsManager.contacts.enumerated().filter{$0.element.telephone.contains(where: {$0.phone == row.phone})}.map{ $0.offset }
//    ////                                        lines += count.count
//    //                                    }
//    //                                    //                                print (row.guid)
//    //                                }
//    //                                i+=1
//    //                            }
//    //                        }
//    //                        else{
//    //                            decodedPath = SearchPathDecoded(path_id: shake_path.key, dep: path_len, path: [[]])
//    //                            var i=0;
//    //                            for row in shake_path.value{
//    //                                if (i != 0){
//    //                                    if (!(decodedPath.path[0].contains(row.phone ?? ""))){
//    //                                        decodedPath.path[0].append(row.phone ?? "")
//    ////                                        let count = contactsManager.contacts.enumerated().filter{$0.element.telephone.contains(where: {$0.phone == row.phone})}.map{ $0.offset }
//    ////                                        lines += count.count
//    //                                    }
//    //                                    //                                print (row.guid)
//    //                                }
//    //                                i+=1
//    //                            }
//    //                        }
//    ////                        j+=1
//    //
//    //
//    //
//    //                        let index = decodedPathes.enumerated().filter{$0.element.path == decodedPath.path}.map{ $0.offset }
//    ////                        let index = decodedPathes.enumerated().filter{$0.element.path_id == decodedPath.path_id}.map{ $0.offset }
//    //                        if (!index.isEmpty){
//    //                            for ind in index{
//    //                                decodedPathes[ind] = decodedPath
//    //                            }
//    //                        }
//    //                        else{
//    //                            for path in decodedPath.path{
//    //                                for number in path{
//    //                                    print(number)
//    //                                    if (number != ""){
//    //                                        let count = contactsManager.contacts.enumerated().filter{$0.element.telephone.contains(where: {$0.phone == number})}.map{ $0.offset }
//    //                                        lines += count.count
//    //                                    }
//    //                                }
//    //                            }
//    //                            decodedPathes.append(decodedPath)
//    //                        }
//    //                        print(decodedPath)
//    //                        print(shake_path.value.count)
//    //                    }
//    //                    print(decodedPathes)
//    //
//    //                    decodedData = SearchHistory(number: row.number, date: row.date, res: true, searching: false, handhsakes: decodedPathes, handshakes_lines: lines)
//    //                }
//    //                else{
//    //                    decodedData = SearchHistory(number: row.number, date: row.date, res: false, searching: false, handhsakes: [], error: statusResponce.status_text!)
//    //                }
//    //                DispatchQueue.main.async {
//    //                    print(decodedData)
//    //                    completion(decodedData)
//    //                }
//    //                self.pathSubscription?.cancel()
//    //            }
//    //    }
//    //
//    //    func UploadContacts(contacts: [FetchedContact] , completion: @escaping (UploadContactsResponse) -> ()) throws {
//    //        guard let url = URL(string: "https://hand.freekiller.net/api/clients") else { fatalError("Missing URL") }
//    //        var urlRequest = URLRequest(url: url)
//    //
//    //        urlRequest.httpMethod = "PUT"
//    //        // Set HTTP Request Header
//    //        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
//    //        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    //        urlRequest.setValue( "Bearer \(jwt)", forHTTPHeaderField: "Authorization")
//    //
//    //
//    //        var allContacts: [ContactWithInfo] = []
//    //        for contact in contacts{
//    //            for number in contact.telephone{
//    //                allContacts.append(ContactWithInfo(phone: number.phone, contact_info: String(data: try JSONEncoder().encode(contact.fullContact), encoding: .utf8) ?? ""))
//    //            }
//    //        }
//    //        let json = UploadContactsList(contacts: allContacts)
//    //        //        let json = AllContacts(contacs: [])
//    ////        print(json)
//    //        let jsonData = try JSONEncoder().encode(json)
//    //        urlRequest.httpBody = jsonData
//    //        contactsUploadSunscription = URLSession.shared.dataTaskPublisher(for: urlRequest).subscribe(on: DispatchQueue.global(qos: .default))
//    //            .tryMap { (output) -> Data in
//    //                print(output.response)
//    //                guard let response = output.response as? HTTPURLResponse,
//    //                      response.statusCode >= 200 && response.statusCode < 300 else{
//    //                    throw URLError(.badServerResponse)
//    //                }
//    //                return output.data
//    //                //                return '{"payload": {"contacts": {"199f0eda39df55bd344ab552a7690943": {"phone": "+7 000 000-00-01","title": null},"32c1137711a844e536eb75afa4c7f644": {"phone": "+7 000 000-00-02","title": null}}},"status_code": 0}'
//    //            }
//    //            .receive(on: DispatchQueue.main)
//    //            .decode(type: UploadContactsResponse.self, decoder: JSONDecoder())
//    //            .sink { (completion) in
//    //                switch completion{
//    //                case .finished:
//    //                    break
//    //                case .failure(let error):
//    //                    print (error.localizedDescription)
//    //                }
//    //            } receiveValue: { statusResponce in
//    //                DispatchQueue.main.async {
//    //                    completion(statusResponce)
//    //                }
//    //                self.contactsUploadSunscription?.cancel()
//    //            }
//    //    }
//    //
//    //    func DeleteContacts(contacts: [FetchedContact] , completion: @escaping (StatusResponse) -> ()) throws {
//    //        guard let url = URL(string: "https://hand.freekiller.net/api/clients/contacts") else { fatalError("Missing URL") }
//    //        var urlRequest = URLRequest(url: url)
//    //
//    //        urlRequest.httpMethod = "DELETE"
//    //        // Set HTTP Request Header
//    //        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
//    //        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    //        urlRequest.setValue( "Bearer \(jwt)", forHTTPHeaderField: "Authorization")
//    //
//    //        var allContacts: [String] = []
//    //        for contact in contacts {
//    //            for number in contact.telephone{
//    //                allContacts.append(number.phone)
//    //            }
//    //        }
//    //        let json = AllContacts(contacts: allContacts)
//    //        //        let json = AllContacts(contacs: [])
//    //
//    //        let jsonData = try JSONEncoder().encode(json)
//    //        //        print(jsonData)
//    //        urlRequest.httpBody = jsonData
//    //        //        print(urlRequest)
//    //        contactsDeleteSunscription = URLSession.shared.dataTaskPublisher(for: urlRequest).subscribe(on: DispatchQueue.global(qos: .default))
//    //            .tryMap { (output) -> Data in
//    //                print(output.response)
//    //                guard let response = output.response as? HTTPURLResponse,
//    //                      response.statusCode >= 200 && response.statusCode < 300 else{
//    //                    throw URLError(.badServerResponse)
//    //                }
//    //                return output.data
//    //            }
//    //            .receive(on: DispatchQueue.main)
//    //            .decode(type: StatusResponse.self, decoder: JSONDecoder())
//    //            .sink { (completion) in
//    //                switch completion{
//    //                case .finished:
//    //                    break
//    //                case .failure(let error):
//    //                    print (error.localizedDescription)
//    //                }
//    //            } receiveValue: { statusResponce in
//    //                DispatchQueue.main.async {
//    //                    completion(statusResponce)
//    //                }
//    //                self.contactsDeleteSunscription?.cancel()
//    //            }
//    //    }
//
//}


struct StatusResponse: Decodable {
    var payload: SessionPayload?
    var status_code: Int
    var status_text: String?
}

struct AppTokenResponse: Decodable {
    var payload: SessionPayload?
    var status_code: Int
    var status_text: String?
}

struct SessionPayload: Decodable{
    var meta: NewUser?
    var jwt: JWT?
}

struct NewUser: Decodable{
    var is_new_user: Bool
}

struct SingInSMSResponse: Decodable {
    var payload: PayloadSMS?
    var status_code: Int
    var status_text: String?
}

struct PayloadSMS: Decodable{
    var jwt: JWT
}

public struct JWT: Decodable{
    var jwt:String
    var id:Int
}


struct SingInUp: Codable {
    var id: Int?
    var phone: String
    var agreement_accepted: Bool?
    var app_token: String
}

struct SingInUpToken: Codable {
    var phone: String
    var app_token: String
}

struct VerifySingUp: Codable {
    var id: Int?
    var code: String
    var phone: String
    var app_token: String?
}

struct AllContacts: Codable{
    var contacts: [String]
}

struct UploadContactsList: Codable{
    var contacts: [ContactWithInfo]
}

struct ContactWithInfo: Codable{
    var phone: String
    var uuid: String
    var guid: String
    var contact_info: String
}

struct UploadContactsResponse: Decodable{
    var payload: UploadContactsResponsePayload
    var status_code: Int
}

struct UploadContactsResponsePayload: Decodable{
    var contacts: [String: ResponseContact]
}

struct ResponseContact: Decodable{
    var phone: String
    var uuid: String
    var title: String?
}

//{
//    "payload": {
//        "path": {
//            "E771665D806D11ECA83B0242AC1B0003": [{
//                "UserID": 22,
//                "Phone": "-",
//                "Prev": null,
//                "Next": null
//            }, {
//                "UserID": null,
//                "Phone": "31",
//                "Prev": null,
//                "Next": null
//            }],
//            "E771667A806D11ECA83B0242AC1B0003": [{
//                "UserID": 22,
//                "Phone": "-",
//                "Prev": null,
//                "Next": null
//            }, {
//                "UserID": null,
//                "Phone": "31",
//                "Prev": null,
//                "Next": null
//            }]
//        }
//    },
//    "status_code": 0
//}

struct PathResponse: Decodable{
    //    var payload: [String: [SearchPath]]
    var payload: PathPath
    var status_code: Int
    var status_text: String?
    
}

struct PathPath: Decodable{
    var path:[String: [SearchPath]]?
}

struct SearchPath: Decodable, Hashable, Encodable {
    let guid: String
    let phone: String?
    let prev: String?
    let next: String?
}

//struct SearchPathDecoded: Decodable, Hashable, Encodable {
//    let path_id: String
//    let dep: Int
//    var path: [[String]]
//}

struct PathNumber: Codable {
    let phone: String
}
