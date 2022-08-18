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
    @AppStorage("hideContacts") var hideContacts: Bool = false
    @AppStorage("selectedTab") var selectedTab: Tab = .search
    @AppStorage("reopen") var reopen: Bool = false
    
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    
    //    PhoneNumberKit
    let phoneNumberKit = PhoneNumberKit()
    
    //    view behavior
    @State private var validNumber: Bool = false
    @State private var validationError = false
    @State private var errorDesc = Text("")
    @State var hint: String = "Enter your phone number"
    @State private var loading: Bool = false
    /// Flag to open ContentView
    @AppStorage("ContentMode") var contentMode: Bool = false
    /// Flaf to open LoginHi view
    @AppStorage("LoginMode") var loginMode: Bool = false
    
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
                        .frame(width: UIScreen.screenHeight/2.5, height: UIScreen.screenHeight/2.5)
                        .offset(x: UIScreen.screenWidth/3, y: -UIScreen.screenHeight/8)
                    Spacer()
                }
                .ignoresSafeArea()
            }
            VStack{
                VStack(){
                    HStack{
                        VStack(alignment: .leading){
                            Text("Log in to")
//                                .font(.largeTitle).fontWeight(.bold)
                                .myFont(font: MyFonts().LargeTitle, type: .display, color: Color.black, weight: .bold)
                                .padding(.top, 20)
                            Text("Handshakes")
//                                .font(.largeTitle).fontWeight(.bold)
                                .myFont(font: MyFonts().LargeTitle, type: .display, color: Color.black, weight: .bold)
                        }
                        .padding()
                        Spacer()
                    }
                }
                Spacer()
                VStack {
                    
                    Text(hint)
//                        .font(.title3).fontWeight(.semibold)
                        .myFont(font: MyFonts().Title3, type: .display, color: Color.black, weight: .semibold)
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
                                .padding(.horizontal, 10)
                            }
                        }
                    }
                    
                }
                Spacer()
                Spacer()
                    .onAppear {
                        self.phoneField = PhoneNumberTextFieldView(phoneNumber: $phoneNumber, isEdeted: $validNumber, maxDigits: 16, fontName: "SFProDisplay-Regular", fontSize: MyFonts().Title3.size)
                        validationError = true
                    }
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 50)
            }
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
    }
    var codeField: some View{
        SuperTextField(
            placeholder: Text("000000").foregroundColor(.secondary),
            all: .constant(Alignment (horizontal: .leading, vertical: .center)),
            text: $code
        )
//        .font(Font.custom("SFProDisplay-Regular", size: 20))
        .myFont(font: MyFonts().Title3, type: .display, color: Color.black, weight: .regular)
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
//                .font(Font.custom("SFProDisplay-Regular", size: 20))
                .myFont(font: MyFonts().Body, type: .display, color: ColorTheme().accent, weight: .regular)
            Button(action:{
                showAgreementFile = true
            },
                   label: {
                Text("User Agreement")
//                    .font(Font.custom("SFProDisplay-Regular", size: 20))
                    .underline()
                    .myFont(font: MyFonts().Body, type: .display, color: ColorTheme().accent, weight: .regular)
                    .foregroundColor(Color.theme.accent)
            }
            )
            .foregroundColor(Color.theme.accent)
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
                    .buttonStyleLogin(fontSize: 20, color: ColorTheme().accent)
                    .myFont(font: MyFonts().Callout, type: .display, color: Color.black, weight: .regular)
            }
            else{
                ProgressView()
                    .buttonStyleLogin(fontSize: 20, color: ColorTheme().accent)
                    .myFont(font: MyFonts().Callout, type: .display, color: Color.black, weight: .regular)
            }
            
        }
        //        .padding()
        .padding(.vertical, big ? 10 : 3)
        .padding(.horizontal, 10)
    }
    
    func SignInButton(){
        do{
            if ((userData.data.isNewUser) && (userAgreement == false)){
                //                alert = MyAlert(error: true, title: "", text: "Please read and agree with \"User Agreement\"", button: "Ok", oneButton: true)
                alert = MyAlert(active: true, alert: Alert(title: Text("Error"), message: Text("Please read and agree with \"User Agreement\""), dismissButton: .default(Text("Ok"))))
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
                userData.update(newData: UserUpdate(field: .number, string: number))
                loading = true
                try userData.SignInUpCall(agreement: userAgreement
                ) { (reses) in
                    print(reses)
                    withAnimation(){
                        if (reses.status_code == 0){
                            if ((reses.payload?.meta?.is_new_user) != nil){
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
                            //                            alert = MyAlert(error: true, title: "", text: reses.status_text ?? "Error while fetching data", button: "Ok", oneButton: true)
                            alert = MyAlert(active: true, alert: Alert(title: Text("Error"), message: Text("Error while fetching data"), dismissButton: .default(Text("Ok"))))

                        }
                        code=""
                        loading = false
                    }
                }
            }
            catch{
                //                alert = MyAlert(error: true, title: "", text: "Error while fetching data", button: "Ok", oneButton: true)
                alert = MyAlert(active: true, alert: Alert(title: Text("Error"), message: Text("Error while fetching data"), dismissButton: .default(Text("Ok"))))

                loading = false
            }
        }
        catch {
            //            alert = MyAlert(error: true, title: "", text: "Please enter a valid phone number", button: "Ok", oneButton: true)
            alert = MyAlert(active: true, alert: Alert(title: Text("Error"), message: Text("Please enter a valid phone number"), dismissButton: .default(Text("Ok").foregroundColor(ColorTheme().accent))))

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
                .myFont(font: MyFonts().Callout, type: .display, color: Color.black, weight: .regular)
        }
    }
    
    func ResendButton(){
        do{
            try userData.VerifySingUpCallResend(){ (reses) in
                print(reses)
                if (reses.status_code == 0){
                }
                else{
                    //                    alert = MyAlert(error: true, title: "", text: reses.status_text ?? "Error while fetching data", button: "Ok", oneButton: true)
                    alert = MyAlert(active: true, alert: Alert(title: Text("Error"), message: Text(reses.status_text ?? "Error while fetching data"), dismissButton: .default(Text("Ok"))))

                }
                self.loading = false
            }
        }
        catch {
            //            alert = MyAlert(error: true, title: "", text: "Error while fetching data", button: "Ok", oneButton: true)
            alert = MyAlert(active: true, alert: Alert(title: Text("Error"), message: Text("Please enter a valid phone number"), dismissButton: .default(Text("Ok"))))

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
                    .buttonStyleLogin(fontSize: 20, color: ColorTheme().accent)
                    .myFont(font: MyFonts().Callout, type: .display, color: Color.black, weight: .regular)
            }
            else{
                ProgressView()
                    .buttonStyleLogin(fontSize: 20, color: ColorTheme().accent)
                    .myFont(font: MyFonts().Callout, type: .display, color: Color.black, weight: .regular)
            }
        }
    }
    
    func ConfirmButton(){
        self.loading = true
        do{
            //            print("Code is: \(self.code)")
            try userData.VerifySingUpCall(code: self.code){ (reses) in
                print(reses)
                if (reses.status_code == 0){
                    userData.update(newData: UserUpdate(field: .jwt, string: reses.payload?.jwt.jwt ?? ""))
                    userData.update(newData: UserUpdate(field: .id, string: String(reses.payload?.jwt.id ?? -1)))
                    contactsData.Delete()
                    model.reset()
                    historyData.reset()
                    self.hideContacts = false
                    withAnimation(){
                        userData.update(newData: UserUpdate(field: .loggedIn, bool: true))
                        userData.save()
//                        selectedTab = .search
                        reopen = true
                        selectedTab = .hide
                        loginMode = false
                        contentMode = true
//                        loginMode = false
                    }
                }
                else{
                    //                    alert = MyAlert(error: true, title: "", text: reses.status_text ?? "Error while fetching data", button: "Ok", oneButton: true)
                    alert = MyAlert(active: true, alert: Alert(title: Text("Error"), message: Text(reses.status_text ?? "Error while fetching data"), dismissButton: .default(Text("Ok"))))

                }
                loading = false
            }
        }
        catch {
            //            alert = MyAlert(error: true, title: "", text: "Error while fetching data", button: "Ok", oneButton: true)
            alert = MyAlert(active: true, alert: Alert(title: Text("Error"), message: Text("Please enter a valid phone number"), dismissButton: .default(Text("Ok"))))

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
}



struct LoginView_Previews: PreviewProvider {
    static let debug: DebugData = DebugData()
    
    static let historyData: HistoryDataView = debug.historyData
    static let contactsData: ContactsDataView = debug.contactsData
    static let model: ChatScreenModel = debug.model
    static let userData: UserDataView = debug.userData
    static var previews: some View {
        Group{
            NavigationView{
                LoginView(alert: .constant(MyAlert()))
                    .environmentObject(historyData)
                    .environmentObject(contactsData)
                    .environmentObject(model)
                    .environmentObject(userData)
                
            }
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
            NavigationView{
                LoginView(alert: .constant(MyAlert()))
                    .environmentObject(historyData)
                    .environmentObject(contactsData)
                    .environmentObject(model)
                    .environmentObject(userData)
                
            }
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
            NavigationView{
                LoginView(alert: .constant(MyAlert()))
                    .environmentObject(historyData)
                    .environmentObject(contactsData)
                    .environmentObject(model)
                    .environmentObject(userData)
                
            }
            .previewDevice(PreviewDevice(rawValue: "iPhone 13"))
            NavigationView{
                LoginView(alert: .constant(MyAlert()))
                    .environmentObject(historyData)
                    .environmentObject(contactsData)
                    .environmentObject(model)
                    .environmentObject(userData)
                
            }
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 mini"))
        }
    }
}
