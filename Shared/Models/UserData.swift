//
//  UserData.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 17.05.2022.
//

import Foundation
import SwiftUI
import Combine

enum UserField: String {
    case id
    case jwt
    case number
    case loggedIn
    case uuid
    case isNewUser
    case loaded
}

struct UserUpdate{
    var field: UserField
    var string: String?
    var bool: Bool?
}

struct UserData: Decodable, Encodable, Identifiable {
    var id: String = ""
    var jwt: String = ""
    var number: String = ""
    var loggedIn: Bool = false
    var uuid: String = ""
    var isNewUser: Bool = false
    var loaded: Bool = false

    
}

class UserDataView: ObservableObject {
    
    @Published var data: UserData = UserData()
    
    private let userDataService = UserDataService()
    
    private var cansellables = Set<AnyCancellable>()
    
    init(d: Bool){
        addDataSubscriber(d: d)
    }
    
    func addDataSubscriber(d: Bool){
        if (d != true){
            userDataService.$data
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
                }
                .store(in: &cansellables)
        }
    }
    
    func update(newData: UserUpdate){
        userDataService.update(newData: newData)
    }
    
    func save() {
        userDataService.save()
    }
    
    func reset(){
        userDataService.reset()
    }
    
    func SignInUpCall(agreement: Bool, completion: @escaping (StatusResponse) -> ()) throws {
        try userDataService.SignInUpCall(agreement: agreement){ (reses) in
            completion(reses)
        }
    }
    
    func SignInUpCallAppToken( completion: @escaping (AppTokenResponse) -> ()) throws {
        try userDataService.SignInUpCallAppToken(){ (reses) in
            completion(reses)
        }
    }
    
    func  VerifySingUpCall(code: String, completion: @escaping (SingInSMSResponse) -> ()) throws {
        try userDataService.VerifySingUpCall(code: code){ (reses) in
            completion(reses)
        }
    }
    
    func VerifySingUpCallResend( completion: @escaping (SingInSMSResponse) -> ()) throws {
        try userDataService.VerifySingUpCallResend(){ (reses) in
            completion(reses)
        }
    }
    
}

class UserDataService{
    @Published var data: UserData = UserData()
    
    var pathSubscription: AnyCancellable?
    var contactsUploadSunscription: AnyCancellable?
    var contactsDeleteSunscription: AnyCancellable?
    var verifySingUpCall: AnyCancellable?
    var verifySingUpCallResend: AnyCancellable?
    var signInUpCall: AnyCancellable?
    
    init() {
        self.data.loaded = false
        if let data = UserDefaults.standard.data(forKey: "UserData") {
            if let decoded = try? JSONDecoder().decode(UserData.self, from: data) {
                print("UserData loaded")
                self.data = decoded
                self.data.id = "nil"
                self.data.jwt = ""
//                self.number = decoded.number
                self.data.loggedIn = false
//                self.uuid = decoded.uuid
                self.data.isNewUser = false
                self.data.loaded = true
                return
            }
        }
        self.data.id = "nil"
        self.data.jwt = "nil"
        self.data.number = "000"
        self.data.loggedIn = false
        self.data.uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        self.data.isNewUser = false
        self.data.loaded = true
        print("UserData fetched")
        self.save()
    }
    
    func update(newData: UserUpdate){
        
        switch newData.field {
        case .id:
            self.data.id = newData.string ?? ""
        case .number:
            self.data.number = newData.string ?? ""
        case .uuid:
            self.data.uuid = newData.string ?? ""
        case .jwt:
            self.data.jwt = newData.string ?? ""
        case .loaded:
            self.data.loaded = newData.bool ?? false
        case .isNewUser:
            self.data.isNewUser = newData.bool ?? false
        case .loggedIn:
            self.data.loggedIn = newData.bool ?? false
        }
        
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(self.data) {
            UserDefaults.standard.set(encoded, forKey: "UserData")
        }
        print("UserData saved!")
    }
    
    func reset(){
        self.data.loaded = false
        self.data.id = "nil"
        self.data.jwt = "nil"
        self.data.number = "000"
        self.data.loggedIn = false
        self.data.uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        self.data.isNewUser = false
        self.data.loaded = true
        print("UserData reseted")
        self.save()
    }
    
    
    func SignInUpCall(agreement: Bool, completion: @escaping (StatusResponse) -> ()) throws {
        #if DEBUG
            let baseUrl="https://develop.freekiller.net"
        #else
            let baseUrl="https://hand.freekiller.net"
        #endif
        guard let url = URL(string: baseUrl + "/api/session") else { fatalError("Missing URL") }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        // Set HTTP Request Header
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json = SingInUp(phone: data.number, agreement_accepted: agreement, app_token: data.uuid)
        let jsonData = try JSONEncoder().encode(json)
        print(json)
        urlRequest.httpBody = jsonData
        
        signInUpCall = URLSession.shared.dataTaskPublisher(for: urlRequest).subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                print(output.response)
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else{
                    DispatchQueue.main.async {
                        completion(StatusResponse(status_code: -1))
                    }
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .replaceError(with: Data("{\"status_code\": -1}".data(using: .utf8)!))
            .decode(type: StatusResponse.self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    print (error.localizedDescription)
                }
            } receiveValue: { statusResponce in
                print(statusResponce)
                DispatchQueue.main.async {
                    completion(statusResponce)
                }
                self.signInUpCall?.cancel()
            }
    }
    
    
    func SignInUpCallAppToken(completion: @escaping (AppTokenResponse) -> ()) throws {
        #if DEBUG
            let baseUrl="https://develop.freekiller.net"
        #else
            let baseUrl="https://hand.freekiller.net"
        #endif
        guard let url = URL(string: baseUrl + "/api/session") else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        // Set HTTP Request Header
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json = SingInUpToken(phone: data.number, app_token: data.uuid)
        let jsonData = try JSONEncoder().encode(json)
        print(json)
        urlRequest.httpBody = jsonData
        
        signInUpCall = URLSession.shared.dataTaskPublisher(for: urlRequest)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                print(output.response)
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else{
                    DispatchQueue.main.async {
                        completion(AppTokenResponse(status_code: -1))
                    }
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
        
            .receive(on: DispatchQueue.main)
            .replaceError(with: Data("{\"status_code\": -1}".data(using: .utf8)!))
            .decode(type: AppTokenResponse.self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    print (error.localizedDescription)
//                    DispatchQueue.main.async {
//                        completion(AppTokenResponse( status_code: -1))
//                    }
                }
            } receiveValue: { statusResponce in
                print(statusResponce)
                DispatchQueue.main.async {
                    completion(statusResponce)
                }
                self.signInUpCall?.cancel()
            }
            
    }
    
    
    func VerifySingUpCall(code: String, completion: @escaping (SingInSMSResponse) -> ()) throws {
        #if DEBUG
            let baseUrl="https://develop.freekiller.net"
        #else
            let baseUrl="https://hand.freekiller.net"
        #endif
        guard let url = URL(string: baseUrl + "/api/session/verify") else { fatalError("Missing URL") }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "PUT"
        // Set HTTP Request Header
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json = VerifySingUp(code: code, phone: data.number, app_token: data.uuid)
        let jsonData = try JSONEncoder().encode(json)
        print(json)
        urlRequest.httpBody = jsonData
        
        verifySingUpCall = URLSession.shared.dataTaskPublisher(for: urlRequest).subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                print(output.response)
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else{
                    DispatchQueue.main.async {
                        completion(SingInSMSResponse(status_code: -1))
                    }
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .replaceError(with: Data("{\"status_code\": -1}".data(using: .utf8)!))
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
    
    func VerifySingUpCallResend(completion: @escaping (SingInSMSResponse) -> ()) throws {
        #if DEBUG
            let baseUrl="https://develop.freekiller.net"
        #else
            let baseUrl="https://hand.freekiller.net"
        #endif
        guard let url = URL(string: baseUrl + "/api/session/verify") else { fatalError("Missing URL") }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "PUT"
        // Set HTTP Request Header
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json = PathNumber(phone: data.number)
        
        let jsonData = try JSONEncoder().encode(json)
        print(json)
        urlRequest.httpBody = jsonData
        
        verifySingUpCallResend = URLSession.shared.dataTaskPublisher(for: urlRequest).subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                print(output.response)
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else{
                    DispatchQueue.main.async {
                        completion(SingInSMSResponse(status_code: -1))
                    }
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
    
}
