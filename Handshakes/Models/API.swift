//
//  API.swift
//  Handshakes
//
//  Created by Kirill Burchenko on 06.12.2021.
//

import Foundation
import SwiftUI
import Combine

class API {
    @AppStorage("jwt") var jwt: String = ""

    var pathSubscription: AnyCancellable?
    var contactsUploadSunscription: AnyCancellable?
    var contactsDeleteSunscription: AnyCancellable?
    var verifySingUpCall: AnyCancellable?
    var verifySingUpCallResend: AnyCancellable?
    var signInUpCall: AnyCancellable?

    
    func SignInUpCall(firstName: String, lastName: String, phone:String, completion: @escaping (StatusResponse) -> ()) throws {
        guard let url = URL(string: "https://hand.freekiller.net/api/session") else { fatalError("Missing URL") }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        // Set HTTP Request Header
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        urlRequest.setValue( "Bearer \(jwt)", forHTTPHeaderField: "Authorization")
        
        let json = SingInUp(first_name: firstName, last_name: lastName, phone: phone)
//        print(json)
        let jsonData = try JSONEncoder().encode(json)
        print(json)
        urlRequest.httpBody = jsonData
        
        signInUpCall = URLSession.shared.dataTaskPublisher(for: urlRequest).subscribe(on: DispatchQueue.global(qos: .default))
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
                self.signInUpCall?.cancel()
            }
    }
    
    
    func VerifySingUpCall(code: String, phone:String, completion: @escaping (SingInSMSResponse) -> ()) throws {
        guard let url = URL(string: "https://hand.freekiller.net/api/session/verify") else { fatalError("Missing URL") }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "PUT"
        // Set HTTP Request Header
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        urlRequest.setValue( "Bearer \(jwt)", forHTTPHeaderField: "Authorization")
        
        let json = VerifySingUp(code: code, phone: phone)

        let jsonData = try JSONEncoder().encode(json)
        print(json)
        urlRequest.httpBody = jsonData
        
        verifySingUpCall = URLSession.shared.dataTaskPublisher(for: urlRequest).subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                print(output.response)
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else{
                          throw URLError(.badServerResponse)
                      }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: SingInSMSResponse.self, decoder: JSONDecoder())
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
                self.verifySingUpCall?.cancel()
            }
    }
    
    func VerifySingUpCallResend(phone:String, completion: @escaping (SingInSMSResponse) -> ()) throws {
        guard let url = URL(string: "https://hand.freekiller.net/api/session/verify") else { fatalError("Missing URL") }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "PUT"
        // Set HTTP Request Header
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        urlRequest.setValue( "Bearer \(jwt)", forHTTPHeaderField: "Authorization")
        
        let json = PathNumber(phone: phone)

        let jsonData = try JSONEncoder().encode(json)
        print(json)
        urlRequest.httpBody = jsonData
        
        verifySingUpCallResend = URLSession.shared.dataTaskPublisher(for: urlRequest).subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                print(output.response)
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else{
                          throw URLError(.badServerResponse)
                      }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: SingInSMSResponse.self, decoder: JSONDecoder())
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
                self.verifySingUpCallResend?.cancel()
            }
    }
    
    func GetPath(row: SearchHistory , completion: @escaping (SearchHistory) -> ()) throws {
        print (row.number)
        guard let url = URL(string: "https://hand.freekiller.net/api/contacts/path") else { fatalError("Missing URL") }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        // Set HTTP Request Header
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue( "Bearer \(jwt)", forHTTPHeaderField: "Authorization")
        
        let json = PathNumber(phone: row.number)
        
        let jsonData = try JSONEncoder().encode(json)
        print(json)
        urlRequest.httpBody = jsonData
        
        pathSubscription = URLSession.shared.dataTaskPublisher(for: urlRequest).subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                print(output.response)
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else{
                          throw URLError(.badServerResponse)
                      }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: PathResponse.self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    print (error.localizedDescription)
                }
            } receiveValue: { statusResponce in
                var shakes:[[String]]=[]
                for path in statusResponce.payload.path{
                    var numbers: [String] = []
                    print(path)
                    for row in path.value{
                        print(row)
                        numbers.append(row.phone)
                    }
                    shakes.append(numbers)
                }
                let decodedData = SearchHistory(number: row.number, date: row.date, res: true, searching: false, handhsakes: shakes)
                DispatchQueue.main.async {
                    completion(decodedData)
                }
                self.pathSubscription?.cancel()
            }
    }
    
    func UploadContacts(contacts: [String] , completion: @escaping (StatusResponse) -> ()) throws {
        guard let url = URL(string: "https://hand.freekiller.net/api/clients") else { fatalError("Missing URL") }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "PUT"
        // Set HTTP Request Header
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue( "Bearer \(jwt)", forHTTPHeaderField: "Authorization")
        
        let json = AllContacts(contacts: contacts)
        //        let json = AllContacts(contacs: [])
        
        let jsonData = try JSONEncoder().encode(json)
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
                self.contactsUploadSunscription?.cancel()
            }
    }
    
    func DeleteContacts(contacts: [String] , completion: @escaping (StatusResponse) -> ()) throws {
        guard let url = URL(string: "https://hand.freekiller.net/api/clients/contacts") else { fatalError("Missing URL") }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "DELETE"
        // Set HTTP Request Header
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue( "Bearer \(jwt)", forHTTPHeaderField: "Authorization")
        
        let json = AllContacts(contacts: contacts)
        //        let json = AllContacts(contacs: [])
        
        let jsonData = try JSONEncoder().encode(json)
        urlRequest.httpBody = jsonData
        contactsDeleteSunscription = URLSession.shared.dataTaskPublisher(for: urlRequest).subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
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
}


struct StatusResponse: Decodable {
    var status_code: Int
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
    var first_name: String
    var last_name: String
    var phone: String
}

struct VerifySingUp: Codable {
    var id: Int?
    var code: String
    var phone: String
}

struct AllContacts: Codable{
    var contacts: [String]
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
    
}

struct PathPath: Decodable{
    var path:[String: [SearchPath]]
}

struct SearchPath: Decodable {
    let userID: String?
    let phone: String
    let prev, next: String?

    enum CodingKeys: String, CodingKey {
        case userID = "UserID"
        case phone = "Phone"
        case prev = "Prev"
        case next = "Next"
    }
}

struct PathNumber: Codable {
    let phone: String
}
