//
//  SearchHistory.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 29.05.2022.
//

import Foundation
import SwiftUI
import Combine

struct SearchHistory:  Codable, Identifiable, Equatable, Hashable {
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



class HistoryDataView: ObservableObject {
    
    @Published var datta: [SearchHistory] = []
    @Published var jwt: String = ""
    @Published var selectedHistory: UUID?
    @Published var updated: Bool = false
    
//    @AppStorage("selectedTab") var selectedTab: Tab = .search
    
    private let historyDataService = HistoryDataService()
    
    private var cansellables = Set<AnyCancellable>()
    
    init(d: Bool){
        addDataSubscriber(d: d)
    }
    
    func addDataSubscriber(d: Bool){
        if (d == false){
            historyDataService.$data
                .receive(on: DispatchQueue.main)
                .sink { (completion) in
                    switch completion{
                    case .finished:
                        break
                    case .failure(let error):
                        print (error.localizedDescription)
                    }
                } receiveValue: { returnedData in
                    self.datta=returnedData
                }
                .store(in: &cansellables)
            
            historyDataService.$jwt
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
            historyDataService.$selectedHistory
                .receive(on: DispatchQueue.main)
                .sink { (completion) in
                    switch completion{
                    case .finished:
                        break
                    case .failure(let error):
                        print (error.localizedDescription)
                    }
                } receiveValue: { returnedData in
                    self.selectedHistory=returnedData
                    if (!self.datta.isEmpty){
                        if (self.selectedHistory == self.datta[0].id){
//                            self.selectedTab = .singleSearch
                        }
                    }
                }
                .store(in: &cansellables)
            historyDataService.$updated
                .receive(on: DispatchQueue.main)
                .sink { (completion) in
                    switch completion{
                    case .finished:
                        break
                    case .failure(let error):
                        print (error.localizedDescription)
                    }
                } receiveValue: { returnedData in
                    self.updated=returnedData
                }
                .store(in: &cansellables)
            }
    }
    
    func save() {
        historyDataService.save()
    }
    
    func reset(){
        historyDataService.reset()
    }
    
    func SetJwt(jwt: String){
        historyDataService.SetJwt(jwt: jwt)
    }
    
    func SelectHistory(history: UUID){
        historyDataService.SelectHistory(history: history)
    }
    
    func Add(number: String) {
        historyDataService.Add(number: number)
    }
    
    func Delete(){
        historyDataService.Delete()
    }
    
    func Load(){
        historyDataService.Load()
    }
}

class HistoryDataService {
    
    @Published var data: [SearchHistory] = []
    @Published var jwt: String = ""
    @Published var selectedHistory: UUID?
    @Published var updated: Bool = false
    
    var pathSubscription: AnyCancellable?
    
    init() {
        
        self.updated = false
        if let data = UserDefaults.standard.data(forKey: "HistoryData") {
            if let decoded = try? JSONDecoder().decode([SearchHistory].self, from: data) {
                print("HistoryData loaded")
                self.data = decoded
                self.updated = true
                return
            }
        }
        else{
            self.data = []
            self.updated = true
        }
        
    }
    
    func Load(){
        
    }
    
    func Delete(){
        self.data = []
        self.save()
    }
    
    func Add(number: String){
        data.insert(SearchHistory(number: number), at: 0)
        self.selectedHistory = self.data[0].id
        save()
        
        DispatchQueue.global(qos: .userInitiated).async {
            print("Performing time consuming task in this background thread")
            do{
                do{
                    try self.GetPath(row: self.data[0])
                    { (reses) in
                        print(reses)
                        let i = self.data.firstIndex(where: {$0.id == reses.id}) ?? 0
                        self.data[i].handshakes_lines = reses.handshakes_lines
                        self.data[i].handhsakes = reses.handhsakes
                        self.data[i].searching = reses.searching
                        self.data[i].res = reses.res
                        self.save()
                    }
                }
                catch{
                    print("here1")
                }
            }

            DispatchQueue.main.async {
                // Task consuming task has completed
                // Update UI from this block of code
                print("Time consuming task has completed. From here we are allowed to update user interface.")
            }
        }
        
    }
    
    func SetJwt(jwt: String){
        self.jwt = jwt
    }
    
    func SelectHistory(history: UUID){
        self.selectedHistory = history
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(self.data) {
            UserDefaults.standard.set(encoded, forKey: "HistoryData")
        }
        print("HistoryData saved!")
    }
    
    func reset(){
        self.updated = false
        self.data = []
        self.save()
        self.updated = true
    }
    
    func GetPath(row: SearchHistory, completion: @escaping (SearchHistory) -> ()) throws {
        #if DEBUG
            let baseUrl="https://develop.freekiller.net"
        #else
            let baseUrl="https://hand.freekiller.net"
        #endif
        guard let url = URL(string: baseUrl + "/api/contacts/path") else { fatalError("Missing URL") }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        // Set HTTP Request Header
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue( "Bearer \(jwt)", forHTTPHeaderField: "Authorization")
        
        let json = PathNumber(phone: row.number)
        
        let jsonData = try JSONEncoder().encode(json)
        print(json)
        print(jwt)
        urlRequest.httpBody = jsonData
        sleep(5)
        pathSubscription = URLSession.shared.dataTaskPublisher(for: urlRequest)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                print(output.response)
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else{
                    DispatchQueue.main.async {
                        completion(SearchHistory(number: row.number, date: row.date, res: false, searching: false, handhsakes: [], error: URLError(.badServerResponse).localizedDescription))
                    }
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
                    break
                }
            } receiveValue: { statusResponce in
                var decodedData: SearchHistory
                if (statusResponce.status_code == 0){
                    print(statusResponce.payload.path!)
                    var decodedPathes: [SearchPathDecoded] = []
//                    _ = 0
//                    var j=0
                    for shake_path in statusResponce.payload.path!{
//                        print(shake_path)
                        var p: [SearchPathDecodedPath] = []
                        var numbersPrint: [String] = []
                        for path in shake_path.value{
                            p.append(SearchPathDecodedPath(number: path.phone ?? "", guid: path.guid))
                            if (!numbersPrint.contains(path.phone ?? "")){
                                numbersPrint.append(path.phone ?? "")
                            }
                        }
                        if (!decodedPathes.contains(where: {$0.print == numbersPrint})){
//                            decodedPathes[shake_path.key] = []
                            decodedPathes.append(SearchPathDecoded(path_id: shake_path.key, dep: 0, print: numbersPrint, path: p))
                        }
//                        decodedPathes[shake_path.key]=p
                    }
//                    print(decodedPathes)
//                            print(String(data: try! JSONEncoder().encode(decodedPathes), encoding: String.Encoding.utf8)  )
                    
                    decodedData = SearchHistory(number: row.number, date: row.date, res: decodedPathes.count > 0 ? true : false, searching: false, handhsakes: decodedPathes, handshakes_lines: 10)
                }
                else{
                    decodedData = SearchHistory(number: row.number, date: row.date, res: false, searching: false, handhsakes: [], error: statusResponce.status_text!)
                }
                DispatchQueue.main.async {
//                    print(decodedData)
                    completion(decodedData)
                }
                self.pathSubscription?.cancel()
            }
    }
}


struct SearchPathDecoded: Decodable, Encodable, Hashable {
    let path_id: String
    let dep: Int
    var print:[String]
    var path: [SearchPathDecodedPath]
}

struct SearchPathDecodedPath: Decodable, Encodable, Equatable, Hashable{
    var number: String
    var guid: String
}
