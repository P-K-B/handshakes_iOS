//
//  Login.swift
//  Handshakes
//
//  Created by Kirill Burchenko on 03.05.2022.
//

import SwiftUI
import PhoneNumberKit
import Foundation
import Combine



//class UserDataView: ObservableObject {
//    @Published var coreData: UserData = UserData()
//    //    @Published var updated: Bool = false
//    //    @Published var err: Bool = false
//
//    private let dataService = UserDataService()
//
//    private var cansellables = Set<AnyCancellable>()
//
//    init(){
//        addDataSubscriber()
//    }
//
//    func addDataSubscriber(){
//        dataService.$coreData
//            .sink {[weak self] (returnedData) in
//                self?.coreData=returnedData
//            }
//            .store(in: &cansellables)
//    }
//}
//
//class UserDataService{
//    @Published var coreData: UserData = UserData()
//    //    @Published var updated: Bool = false
//    //    @Published var err: Bool = false
//
//    init() {
//        //        print(UserDefaults.standard.data(forKey: "HistoryData")!)
//        if let data = UserDefaults.standard.data(forKey: "UserData") {
//            //            print(data)
//            if let decoded = try? JSONDecoder().decode(UserData.self, from: data) {
//                //                print(decoded)
//                print("UserData loaded")
//                self.coreData.id = decoded.id
//                self.coreData.jwt = decoded.jwt
//                self.coreData.number = decoded.number
//                self.coreData.loggedIn = decoded.loggedIn
//                self.coreData.uuid = decoded.uuid
//                self.coreData.isNewUser = decoded.isNewUser
//                return
//            }
//        }
//        self.coreData.id = "1234"
//        self.coreData.jwt = "jwt"
//        self.coreData.number = "+7 900 000-00-00"
//        self.coreData.loggedIn = false
//        self.coreData.uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
//        self.coreData.isNewUser = false
//        print("UserData fetched")
//        self.save()
//    }
//
//    func save() {
//        //        text = "new text"
//        //        self.text = newText
//        if let encoded = try? JSONEncoder().encode(self.coreData) {
//            UserDefaults.standard.set(encoded, forKey: "UserData")
//        }
//        print("UserData saved!")
//    }
//}
//
//struct UserData: Hashable, Codable, Identifiable {
//    var id: String = ""
//    var jwt: String = ""
//    var number: String = ""
//    var loggedIn: Bool = false
//    var uuid: String = ""
//    var isNewUser: Bool = false
//}

struct UserData: Decodable, Encodable, Identifiable {
    var id: String = ""
    var jwt: String = ""
    var number: String = ""
    var loggedIn: Bool = false
    var uuid: String = ""
    var isNewUser: Bool = false
    
    init() {
        //        print(UserDefaults.standard.data(forKey: "HistoryData")!)
        if let data = UserDefaults.standard.data(forKey: "UserData") {
            //            print(data)
            if let decoded = try? JSONDecoder().decode(UserData.self, from: data) {
                //                print(decoded)
                print("UserData loaded")
                self.id = decoded.id
                self.jwt = decoded.jwt
                self.number = decoded.number
//                self.loggedIn = decoded.loggedIn
                self.loggedIn = false
                self.uuid = decoded.uuid
                self.isNewUser = false
                return
            }
        }
        self.id = "1234"
        self.jwt = "jwt"
        self.number = "+7 900 000-00-00"
        self.loggedIn = false
        self.uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        self.isNewUser = false
        print("UserData fetched")
        self.save()
    }
    
    func save() {
        //        text = "new text"
        //        self.text = newText
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: "UserData")
        }
        print("UserData saved!")
    }
    
}


struct LoginView: View {
    
    //    Data:
    @Binding var user: UserData
    
    //    View vars
    
    //    PhoneNumberKit
    let phoneNumberKit = PhoneNumberKit()
    @State private var phoneField: PhoneNumberTextFieldView?
    @State private var validNumber: Bool = false
    @State private var phoneNumber = String()
    
    
    @State private var validationError = false
    @State private var errorDesc = Text("")
    
    @State private var code: String = ""
    
    @State private var loading: Bool = false
    //    @State private var showAgreement: Bool = false
        @State private var userAgreement: Bool = false
    @State private var showAgreementFile: Bool = false
    let documentURL = URL(string: "http://www.africau.edu/images/default/sample.pdf")!
    
    
    @State var res: StatusResponse?
    
    @AppStorage("jwt") var jwt: String = ""
    
    
    @State var hint: String = "Enter your phone number"
    
    var numberField: some View{
        self.phoneField
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
            .keyboardType(.phonePad)
            .padding(.horizontal, 15)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding()
    }
    var codeField: some View{
        SuperTextField(
            placeholder: Text("0000").foregroundColor(.secondary),
            all: .constant(Alignment (horizontal: .leading, vertical: .center)),
            text: $code
        )
        .font(Font.custom("SFProDisplay-Regular", size: 20))
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
        .keyboardType(.phonePad)
        .padding(.horizontal, 15)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding()
    }
    
    var userAgrimentField: some View{
        HStack{
            Image(systemName: userAgreement ? "checkmark.square" : "square")
                .foregroundColor(userAgreement ? Color.theme.accent : Color.secondary)
                .onTapGesture {
                    userAgreement.toggle()
                }
                .font(Font.custom("SFProDisplay-Regular", size: 20))
            Button(action:{
                showAgreementFile = true
            },
                   label: {
                Text("User Agreement")
                    .font(Font.custom("SFProDisplay-Regular", size: 20))
            }
            )
            .foregroundColor(.black)
            //            Toggle("User Agreement", isOn: $userAgreement)
            //                .toggleStyle(.checkbox)
        }
        .padding()
    }
    
    var signinButton: some View{
        Button {
            Task {
                SignInButton()
            }
        } label: {
            if (!loading){
                Text("Sign in")
                    .frame(minWidth: 70)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 30)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(100)
            }
            else{
                ProgressView()
                    .frame(minWidth: 70)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 30)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(100)
            }
            
        }
        .padding()
    }
    
    func SignInButton(){
        do{
            //                                    Send code
            let validatedPhoneNumber = try self.phoneNumberKit.parse(self.phoneNumber)
            if (user.isNewUser && !userAgreement){
                self.validationError = true
                self.errorDesc = Text("Accept \"User Agreement\"")
                self.loading = false
                return
            }
            do{
                let number = self.phoneNumberKit.format(validatedPhoneNumber, toType: .international)
                user.number = number
                self.loading = true
                try API().SignInUpCall(phone: number, agreement: userAgreement, token: user.uuid
                ) { (reses) in
                    print(reses)
                    withAnimation(){
                        if (reses.status_code == 0){
                            if ((reses.payload?.meta?.is_new_user) != nil){
                                user.isNewUser = true
                                //                                        self.showAgreement = true
                                self.hint="Accept \"User Agreement\""
                                user.save()
                            }
                            else{
                                self.validNumber = true
                                self.hint="Enter code from SMS"
                                
                            }
                            self.code=""
                            self.loading = false
                        }
                    }
                }
            }
            catch{
                self.validationError = true
                self.errorDesc = Text("Error while fetching data")
                self.loading = false
            }
        }
        catch {
            self.validationError = true
            self.errorDesc = Text("Please enter a valid phone number")
            self.loading = false
        }
    }
    
    var resendButton: some View{
        Button {
            Task {
                
            }
        } label: {
            Text("Resend")
                .buttonStyleLogin(fontSize: 15, color: Color.secondary)
        }
    }
    
    func ResendButton(){
        do{
            //                                print("Code is: \(self.code)")
            //                                self.loading = true
            let validatedPhoneNumber = try self.phoneNumberKit.parse(self.phoneNumber)
            let number = self.phoneNumberKit.format(validatedPhoneNumber, toType: .international)
            try API().VerifySingUpCallResend(phone:number){ (reses) in
                print(reses)
            }
        }
        catch {
            self.validationError = true
            self.errorDesc = Text("Error while fetching data")
        }
    }
    
    var confirmButton: some View{
        Button {
            Task {
                ConfirmButton()
            }
        } label: {
            if (!loading){
                Text("Confirm")
                    .buttonStyleLogin(fontSize: 20, color: Color.accentColor)
            }
            else{
                ProgressView()
                    .buttonStyleLogin(fontSize: 20, color: Color.accentColor)
            }
        }
    }
    
    func ConfirmButton(){
        self.loading = true
        if (!user.isNewUser){
            self.validationError = true
            self.errorDesc = Text("Please read and agree with \"User Agreement\"")
            self.loading = false
        }
        do{
            print("Code is: \(self.code)")
            let validatedPhoneNumber = try self.phoneNumberKit.parse(self.phoneNumber)
            let number = self.phoneNumberKit.format(validatedPhoneNumber, toType: .international)
            try API().VerifySingUpCall(code: self.code, phone:user.number, token: user.uuid){ (reses) in
                print(reses)
                if (reses.status_code == 0){
                    user.jwt=reses.payload?.jwt.jwt ?? ""
                    jwt=reses.payload?.jwt.jwt ?? ""
                    withAnimation(){
                        user.loggedIn = true;
                        self.loading = false
                        user.save()
                    }
                }
                else{
                    self.validationError = true
                    self.errorDesc = Text(reses.status_text ?? "")
                    self.loading = false
                }
            }
        }
        catch {
            self.validationError = true
            self.errorDesc = Text("Error while fetching data")
            self.loading = false
        }
        print(self.user)
    }
    
    
    var body: some View {
        VStack(){
            VStack(spacing: 5) {
                Text(hint)
                    .font(Font.custom("SFProDisplay-Regular", size: 20))
                    .padding()
                //                    Phone number
                VStack{
                    numberField
                    
                    if (validNumber){
                        codeField
                    }
                }
                //                    Nuber validation
                VStack{
                    if (!validNumber){
                        if (user.isNewUser){
                            userAgrimentField
                        }
                        signinButton
                    }
                    else{
                        VStack{
                            HStack {
                                //                            Resend code
                                resendButton
                                //                            Code validation
                                confirmButton
                            }
                            .padding()
                        }
                    }
                }
                
            }
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 34, style: .continuous))
            .padding()
            .onAppear {
                self.phoneField = PhoneNumberTextFieldView(phoneNumber: self.$phoneNumber, isEdeted: self.$validNumber)
            }
            .alert(isPresented: self.$validationError) {
                Alert(title: Text(""), message: self.errorDesc, dismissButton: .default(Text("OK")))
            }
        }
        .onTapGesture {
            self.endEditing()
        }
        .popover(isPresented: $showAgreementFile) {
            PDFView
        }
    }
    
    
    var PDFView:some View{
        VStack{
            HStack{
                Button(action:{showAgreementFile = false}, label: {
                    HStack{
                        Spacer()
                        Image(systemName: "xmark.circle")
                            .padding()
                    }
                })
            }
            PDFKitView(url: documentURL)
        }
    }
    
    
    
    
    
    
    
    
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}
//
//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//            .environmentObject(User())
//    }
//}
