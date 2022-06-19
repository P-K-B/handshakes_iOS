//
//  SwiftUIView.swift
//  Handshakes2 (iOS)
//
//  Created by Maxim Fisher on 19.06.2022.
//

import SwiftUI

struct LoginFormInitialView: View {
    @State private var selection: String? = nil
    
    func onRegistrationCompleted() {
        print("Registration completed")
    }
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination:LoginFormSignUpView(onSubmit: {self.selection="Verify"}), tag: "PhoneNumber", selection: $selection) { EmptyView() }
                NavigationLink(destination: LoginFormVerifyView(onSubmit: onRegistrationCompleted), tag: "Verify", selection: $selection) { EmptyView() }
                    Image("Logo")
                        .resizable()
                        .frame(width: 150, height: 150, alignment: .bottom)
                Spacer()
                Text("Handshakes").font(.title.weight(.bold))
                Text("People are closer, than you think").font(.caption)
                Spacer()
                Button("Log In") {
                    self.selection = "PhoneNumber"
                }
                .frame(width: 150.0, height: 45.0)
                .background(.red)
                .foregroundColor(.white)
                Spacer()
            }
            //                   .navigationTitle("Handshakes")
        }
        
    }
}

struct LoginFormSignUpView: View {
    var onSubmit: () -> Void
    init(onSubmit: @escaping () -> Void) {
        self.onSubmit = onSubmit
    }
    var body: some View {
        VStack{
            HStack{
                Text("Log in to Handshakes").font(.title2.bold())
            }
            ZStack{
                Image("Logo")
                    .resizable()
                    .ignoresSafeArea()
                    .frame(width: 150, height: 150, alignment: .leading)
                    .rotationEffect(Angle.degrees(180))
            }
            Spacer()
            Text("Enter your phone number")
            Spacer()
            Button("Log In", action: self.onSubmit)
                .frame(width: 150.0, height: 45.0)
                .background(.red)
                .foregroundColor(.white)
            Spacer()
        }
    }
}

struct LoginFormVerifyView: View {
    var onSubmit: () -> Void
    init(onSubmit: @escaping () -> Void) {
        self.onSubmit = onSubmit
    }
    func onResend() {
        print("Resending SMS")
    }
    var body: some View {
        VStack{
            HStack{
                Text("Log in to Handshakes").font(.title2.bold())
            }
            Image("Logo")
                .resizable()
                .ignoresSafeArea()
                .frame(width: 300, height: 300, alignment: .bottom)
                .rotationEffect(Angle.degrees(180))
            Spacer()
            Text("Enter code from SMS")
            Button("Resend", action: self.onResend)
                .frame(width: 150.0, height: 45.0)
                .background(.gray)
                .foregroundColor(.white)
            Button("Log In", action: self.onSubmit)
                .frame(width: 150.0, height: 45.0)
                .background(.red)
                .foregroundColor(.white)
            Text("Verify SMS view!")
        }
        
    }
}

struct LoginFormInitialView_Previews: PreviewProvider {
    static var previews: some View {
        LoginFormInitialView()
    }
}
