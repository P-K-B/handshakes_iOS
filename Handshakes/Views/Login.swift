//
//  Login.swift
//  Handshakes
//
//  Created by Kirill Burchenko on 02.12.2021.
//

import SwiftUI
import UIKit
import PhoneNumberKit

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
    }
    
    var numberView : some View {
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
            
            if (validNumber){
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
        }
    }
    var codeView : some View {
        VStack{
            if (!validNumber){
                Button {
                    Task {
                        do{
                            //                                    Send code
                            let validatedPhoneNumber = try self.phoneNumberKit.parse(self.phoneNumber)
                            do{
                                let number = self.phoneNumberKit.format(validatedPhoneNumber, toType: .international)
                                self.loading = true
                                try API().SignInUpCall(firstName: "firstName", lastName: "lastName", phone: number
                                ) { (reses) in
                                    
                                    
                                    withAnimation(){
                                        self.validNumber = true
                                        self.welcomeText="Enter code from SMS"
                                        self.code=""
                                        self.loading = false
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
                .padding()
            }
            else{
                HStack {
                    //                            Resend code
                    
                    Button {
                        Task {
                            do{
//                                print("Code is: \(self.code)")
//                                self.loading = true
                                let validatedPhoneNumber = try self.phoneNumberKit.parse(self.phoneNumber)
                                let number = self.phoneNumberKit.format(validatedPhoneNumber, toType: .international)
                                try API().VerifySingUpCallResend(phone:number){ (reses) in
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
                    //                            Code validation
                    Button {
                        Task {
                            do{
                                print("Code is: \(self.code)")
                                self.loading = true
                                let validatedPhoneNumber = try self.phoneNumberKit.parse(self.phoneNumber)
                                let number = self.phoneNumberKit.format(validatedPhoneNumber, toType: .international)
                                try API().VerifySingUpCall(code: self.code, phone:number){ (reses) in
                                    jwt=reses.payload?.jwt.jwt ?? ""
                                    withAnimation(){
                                        self.loggedIn = true;
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
                .padding()
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
