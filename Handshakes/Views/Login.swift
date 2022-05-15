//
//  Login.swift
//  Handshakes
//
//  Created by Kirill Burchenko on 02.12.2021.
//

import SwiftUI
import UIKit
import PhoneNumberKit
import PDFKit

struct PhoneNumberTextFieldView: UIViewRepresentable {
    
    @Binding var phoneNumber: String
    @Binding var isEdeted: Bool
    private let textField = PhoneNumberTextField()
    
    func makeUIView(context: Context) -> PhoneNumberTextField {
        textField.withExamplePlaceholder = true
        textField.withFlag = true
        textField.withPrefix = true
        textField.font=UIFont(name: "SFProDisplay-Regular", size: 20)
        textField.addTarget(context.coordinator, action: #selector(Coordinator.onTextUpdate), for: .editingChanged)
        return textField
    }
    
    func updateUIView(_ view: PhoneNumberTextField, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        var control: PhoneNumberTextFieldView
        
        init(_ control: PhoneNumberTextFieldView) {
            self.control = control
        }
        
        @objc func onTextUpdate(textField: UITextField) {
            if (self.control.isEdeted){
                withAnimation(){
                    self.control.isEdeted=false
                }
            }
            self.control.phoneNumber = textField.text!
        }
        
    }
    
}


struct Login: View {
    
    @State private var phoneNumber = String()
    @State private var validationError = false
    @State private var errorDesc = Text("")
    @State private var phoneField: PhoneNumberTextFieldView?
    @State private var validNumber: Bool = false
    @State private var code: String = ""
    let phoneNumberKit = PhoneNumberKit()
    @State private var loading: Bool = false
    @State private var showAgreement: Bool = true
    @State private var userAgreement: Bool = false
    @State private var showAgreementFile: Bool = false
    let documentURL = URL(string: "http://www.africau.edu/images/default/sample.pdf")!
    
    
    @State var res: StatusResponse?
    
    
    @State var welcomeText: String = "Enter your phone number"
    
    @AppStorage("loggedIn") var loggedIn: Bool = false
    
    @AppStorage("jwt") var jwt: String = ""
    @AppStorage("number") var number: String = ""
    
    var body: some View {
        ZStack {
            //                        Image("Handshakes")
            Image("Demo2")
                .resizable()
                .ignoresSafeArea()
            VStack(){
                Text("Handshakes")
                    .font(Font.custom("SFProDisplay-Bold", size: 45))
                //                    .foregroundColor(.primary)
                    .gradientForeground(colors: [Color(hex:0x725252), Color(hex: 0x3A2F2F)])
                    .padding(.top, 40)
                Spacer()
                
                VStack(spacing: 5) {
                    //                    Phone number
                    numberView
                    //                    Nuber validation
                    codeView
                    
                }
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 34, style: .continuous))
                .padding()
                .onAppear {
                    self.phoneField = PhoneNumberTextFieldView(phoneNumber: self.$phoneNumber, isEdeted: self.$validNumber)
                }
                .alert(isPresented: self.$validationError) {
                    Alert(title: Text(""), message: self.errorDesc, dismissButton: .default(Text("OK")))
                }
                Spacer()
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
    
    var numberView : some View {
        VStack{
            numberField
            
            if (validNumber){
                codeField
            }
        }
    }
    
    var numberField: some View{
        VStack{
            Text(welcomeText)
                .font(Font.custom("SFProDisplay-Regular", size: 20))
                .padding()
            self.phoneField
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                .keyboardType(.phonePad)
            
                .padding(.horizontal, 15)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .padding()
        }
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
    
    
    
    var codeView : some View {
        VStack{
            if (!validNumber){
                if (showAgreement){
                    AgreementView
                        .padding()
                }
                sign_in_button
                    .padding()
            }
            else{
                VStack{
                    HStack {
                        //                            Resend code
                        resend_button
                        //                            Code validation
                        confirm_code_button
                    }
                    .padding()
                }
            }
        }
    }
    
    var AgreementView: some View{
        HStack{
            Image(systemName: userAgreement ? "checkmark.square" : "square")
                .foregroundColor(userAgreement ? Color.theme.accent : Color.secondary)
                .onTapGesture {
                    self.userAgreement.toggle()
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
    }
    
    var sign_in_button: some View{
        Button {
            Task {
                do{
                    //                                    Send code
                    let validatedPhoneNumber = try self.phoneNumberKit.parse(self.phoneNumber)
                    do{
                        let number = self.phoneNumberKit.format(validatedPhoneNumber, toType: .international)
                        self.loading = true
                        try API().SignInUpCall(phone: number, agreement: userAgreement, token: "123"
                        ) { (reses) in
                            print(reses)
                            withAnimation(){
                                if (reses.status_code == 0){
                                    if ((reses.payload?.meta?.is_new_user) != nil){
                                        self.showAgreement = true
                                        self.welcomeText="Accept \"User Agreement\""

                                    }
                                    else{
                                        self.validNumber = true
                                        self.welcomeText="Enter code from SMS"

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
    }
    
    var resend_button: some View{
        Button {
            Task {
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
        } label: {
            Text("Resend")
                .buttonStyleLogin(fontSize: 15, color: Color.secondary)
        }
    }
    
    var confirm_code_button: some View{
        Button {
            Task {
                self.loading = true
                if (!userAgreement){
                    self.validationError = true
                    self.errorDesc = Text("Please read and agree with \"User Agreement\"")
                    self.loading = false
                }
                do{
                    print("Code is: \(self.code)")
                    let validatedPhoneNumber = try self.phoneNumberKit.parse(self.phoneNumber)
                    let number = self.phoneNumberKit.format(validatedPhoneNumber, toType: .international)
                    try API().VerifySingUpCall(code: self.code, phone:number, token: ""){ (reses) in
                        print(reses)
                        if (reses.status_code == 0){
                            jwt=reses.payload?.jwt.jwt ?? ""
                            withAnimation(){
                                self.loggedIn = true;
                                self.loading = false
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
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}

struct ButtonStyleLogin: ViewModifier {
    var fontSize: CGFloat
    var color: Color
    //    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .frame(minWidth: 70)
            .padding(.vertical, 10)
            .padding(.horizontal, 30)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(100)
            .font(Font.custom("SFProDisplay-Regular", size: fontSize))
    }
}

extension View {
    func buttonStyleLogin(fontSize: CGFloat = 30, color: Color = Color.accentColor) -> some View {
        modifier(ButtonStyleLogin(fontSize: fontSize, color: color))
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}


struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL
    
    init(_ url: URL) {
        self.url = url
    }
    
    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        // Create a `PDFView` and set its `PDFDocument`.
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)
        pdfView.autoresizesSubviews = true
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleLeftMargin]
        pdfView.displayDirection = .vertical
        
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displaysPageBreaks = true
        
        return pdfView
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Update the view.
    }
}

struct PDFKitView: View {
    var url: URL
    
    var body: some View {
        PDFKitRepresentedView(url)
    }
}
