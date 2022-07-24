//
//  LoginView.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 17.05.2022.
//

import SwiftUI
import PhoneNumberKit
import Foundation
import Combine




struct LoginView: View {
    
    //    Data:
    @Binding var alert: MyAlert
    @EnvironmentObject var historyData: HistoryDataView
    @EnvironmentObject var contactsData: ContactsDataView
    @EnvironmentObject var model: ChatScreenModel
    @EnvironmentObject var userData: UserDataView
    
    @AppStorage("big") var big: Bool = IsBig()
//    @AppStorage("fresh") var fresh: Bool = true
    @AppStorage("hideContacts") var hideContacts: Bool = false
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    
    //    PhoneNumberKit
    let phoneNumberKit = PhoneNumberKit()
    
    //    view behavior
    @State private var validNumber: Bool = false
    @State private var validationError = false
    @State private var errorDesc = Text("")
    @State var hint: String = "Enter your phone number"
    @State private var loading: Bool = false
    
    //    user input
    @State private var code: String = ""
    @State private var phoneField: PhoneNumberTextFieldView?
    @State private var phoneNumber = String()
    
    //    user agreement
    @State private var userAgreement: Bool = false
    @State private var showAgreementFile: Bool = false
    let documentURL = URL(string: "http://www.africau.edu/images/default/sample.pdf")!
    
    
    var body: some View {
        ZStack{
            VStack{
                
                VStack{
                    Image("Logo")
                        .resizable()
                        .rotationEffect(.degrees(180))
                        .frame(width: UIScreen.screenHeight/2.9, height: UIScreen.screenHeight/2.9)
                        .offset(x: UIScreen.screenWidth/3, y: -UIScreen.screenHeight/8)
                    Spacer()
                }
                .ignoresSafeArea()
                //                        .background(.blue)
                
                
            }
            //            .background(.red)
            VStack{
//                if (validNumber == false && big == false){
//                    Spacer()
//                }
                //            Spacer()
                VStack(){
                    //                Spacer()
                    HStack{
                        VStack(alignment: .leading){
                            Text("Log in to").font(.largeTitle).fontWeight(.bold)
                            Text("Handshakes").font(.largeTitle).fontWeight(.bold)
                        }
                        //                        .font(.largeTitle).fontWeight(.bold)
                        .padding()
                        //                        .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    //                Spacer()
                    //                .padding(.top, 100)
                }
                //            if (!validNumber && big){
                Spacer()
                //            }
                VStack {
                    //                Text(String(validationError))
                    //                Text("\(errorDesc)")
                    Text(hint)
                    //                    .font(Font.custom("SFProDisplay-Regular", size: 20))
                        .font(.title3).fontWeight(.semibold)
                        .padding()
                    //                    Phone number
                    VStack {
                        numberField
                        
                        if (validNumber){
                            codeField
                        }
                    }
                    //                    Nuber validation
                    VStack{
                        if (!validNumber){
                            if (userData.data.isNewUser){
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
                                //                            .padding()
//                                .padding(.vertical, big ? 10 : 3)
                                .padding(.horizontal, 10)
                                

                            }
                        }
                    }
                    
                }
                Spacer()
                Spacer()
                
                //            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 34, style: .continuous))
                //            .padding()
                    .onAppear {
                        self.phoneField = PhoneNumberTextFieldView(phoneNumber: $phoneNumber, isEdeted: $validNumber, maxDigits: 16)
                        validationError = true
                    }
                
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 50)
            }
//            .offset(y: kGuardian.slide).animation(.easeInOut(duration: 1.0))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            print("Tap")
            self.endEditing()
        }
        .popover(isPresented: $showAgreementFile) {
            PDFView
        }
        
    }
    
    
    
    
    
    
    
    var numberField: some View{
        self.phoneField
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
            .keyboardType(.phonePad)
            .padding(.horizontal, 15)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding(.vertical, big ? 10 : 3)
            .padding(.horizontal, 10)
        //            .font(.largeTitle)
    }
    var codeField: some View{
        SuperTextField(
            placeholder: Text("000000").foregroundColor(.secondary),
            all: .constant(Alignment (horizontal: .leading, vertical: .center)),
            text: $code
        )
        .font(Font.custom("SFProDisplay-Regular", size: 20))
        //        .font(.body)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
        .keyboardType(.phonePad).padding(.horizontal, 15)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(.vertical, big ? 10 : 3)
        .padding(.horizontal, 10)
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
                    .underline()
                    .foregroundColor(Color.theme.accent)
            }
            )
            .foregroundColor(Color.theme.accent)
            //                        Toggle("User Agreement", isOn: $userAgreement)
            //                            .toggleStyle(.checkbox)
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
                    .buttonStyleLogin(fontSize: 20, color: Color.accentColor)
            }
            else{
                ProgressView()
                    .buttonStyleLogin(fontSize: 20, color: Color.accentColor)
            }
            
        }
        //        .padding()
        .padding(.vertical, big ? 10 : 3)
        .padding(.horizontal, 10)
    }
    
    func SignInButton(){
        do{
            if ((userData.data.isNewUser) && (userAgreement == false)){
                alert = MyAlert(error: true, title: "", text: "Please read and agree with \"User Agreement\"", button: "Ok", oneButton: true)
                self.loading = false
            }
            //                                    Send code
            let validatedPhoneNumber = try phoneNumberKit.parse(phoneNumber)
            if (userData.data.isNewUser && !userAgreement){
                validationError = true
                errorDesc = Text("Accept \"User Agreement\"")
                loading = false
                return
            }
            do{
                let number = phoneNumberKit.format(validatedPhoneNumber, toType: .international)
                //                userData.data.number = number
                userData.update(newData: UserUpdate(field: .number, string: number))
                loading = true
                try userData.SignInUpCall(agreement: userAgreement
                ) { (reses) in
                    print(reses)
                    withAnimation(){
                        if (reses.status_code == 0){
                            if ((reses.payload?.meta?.is_new_user) != nil){
                                //                                userData.data.isNewUser = true
                                userData.update(newData: UserUpdate(field: .isNewUser, bool: true))
                                hint="Accept \"User Agreement\""
                                userData.save()
                            }
                            else{
                                validNumber = true
                                hint="Enter code from SMS"
                                
                            }
                        }
                        else {
                            alert = MyAlert(error: true, title: "", text: reses.status_text ?? "Error while fetching data", button: "Ok", oneButton: true)
                        }
                        code=""
                        loading = false
                    }
                }
            }
            catch{
                alert = MyAlert(error: true, title: "", text: "Error while fetching data", button: "Ok", oneButton: true)
                loading = false
            }
        }
        catch {
            alert = MyAlert(error: true, title: "", text: "Please enter a valid phone number", button: "Ok", oneButton: true)
            loading = false
        }
    }
    
    var resendButton: some View{
        Button {
            Task {
                ResendButton()
            }
        } label: {
            Text("Resend")
                .buttonStyleLogin(fontSize: 20, color: Color.secondary)
        }
    }
    
    func ResendButton(){
        do{
            //                                print("Code is: \(self.code)")
            //                                self.loading = true
            //            let validatedPhoneNumber = try self.phoneNumberKit.parse(self.phoneNumber)
            //            let number = self.phoneNumberKit.format(validatedPhoneNumber, toType: .international)
            try userData.VerifySingUpCallResend(){ (reses) in
                print(reses)
                if (reses.status_code == 0){
                }
                else{
                    alert = MyAlert(error: true, title: "", text: reses.status_text ?? "Error while fetching data", button: "Ok", oneButton: true)
                }
                self.loading = false
            }
        }
        catch {
            alert = MyAlert(error: true, title: "", text: "Error while fetching data", button: "Ok", oneButton: true)
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
        do{
            print("Code is: \(self.code)")
            //            let validatedPhoneNumber = try self.phoneNumberKit.parse(self.phoneNumber)
            //            let number = self.phoneNumberKit.format(validatedPhoneNumber, toType: .international)
            try userData.VerifySingUpCall(code: self.code){ (reses) in
                print(reses)
                if (reses.status_code == 0){
                    //                    userData.data.jwt=reses.payload?.jwt.jwt ?? ""
                    userData.update(newData: UserUpdate(field: .jwt, string: reses.payload?.jwt.jwt ?? ""))
                    userData.update(newData: UserUpdate(field: .id, string: String(reses.payload?.jwt.id ?? -1)))
                    //                    fresh = true
                    contactsData.Delete()
                    model.reset()
                    historyData.reset()
                    self.hideContacts = false
                    withAnimation(){
                        //                        userData.data.loggedIn = true
                        userData.update(newData: UserUpdate(field: .loggedIn, bool: true))
                        userData.save()
                    }
                }
                else{
                    alert = MyAlert(error: true, title: "", text: reses.status_text ?? "Error while fetching data", button: "Ok", oneButton: true)
                }
                loading = false
            }
        }
        catch {
            alert = MyAlert(error: true, title: "", text: "Error while fetching data", button: "Ok", oneButton: true)
            self.loading = false
        }
        print(self.userData.data)
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
    
    
    
    
    
    
    
    
    
    //    private func endEditing() {
    //        UIApplication.shared.endEditing()
    //    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(alert: .constant(MyAlert()))
            .environmentObject(DebugData().userData)
    }
}
