//
//  PhoneNumberTextFieldView.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 17.05.2022.
//

import SwiftUI
import PhoneNumberKit

struct PhoneNumberTextFieldView: UIViewRepresentable {
    
    @Binding var phoneNumber: String
    @Binding var isEdeted: Bool
    @State var maxDigits: Int
    private let textField = PhoneNumberTextField()
    
    func makeUIView(context: Context) -> PhoneNumberTextField {
        textField.withExamplePlaceholder = true
        textField.withFlag = true
        textField.withPrefix = true
        textField.maxDigits = self.maxDigits
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

struct PhoneNumberTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberTextFieldView(phoneNumber: .constant("+1 888-555-1212"), isEdeted: .constant(true), maxDigits: 15)
    }
}
