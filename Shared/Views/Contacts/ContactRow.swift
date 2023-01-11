//
//  ContactRow.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 28.05.2022.
//

import SwiftUI

struct ContactRow: View {
    var contact: FetchedContact
    var order: Int
    
    var body: some View {
        VStack(alignment: .center){
            HStack(spacing: 2) {
                //            Text("\(contact.index)")
                //            Text("\(contact.hiden ? "true" : "false")")
                if (order == 3){
                    Text(contact.firstName == "" ? "" : (contact.firstName + " "))
                    //                    .font(Font.system(size: 18, weight: .regular, design: .default))
                        .myFont(font: MyFonts().Body, type: .display, color: Color.black, weight: .regular)
                    
                    Text(contact.lastName)
                    //                    .font(Font.system(size: 18, weight: .semibold, design: .default))
                        .myFont(font: MyFonts().Body, type: .display, color: Color.black, weight: .semibold)
                    
                    
                }
                else{
                    Text(contact.lastName == "" ? "" : (contact.lastName + " "))
                    //                            .font(Font.system(size: 18, weight: .semibold, design: .default))
                        .myFont(font: MyFonts().Body, type: .display, color: Color.black, weight: .semibold)
                    //                    .font(Font.custom("Inter-SemiBold", size: 40))
                    
                    Text(contact.firstName)
                    //                        .font(Font.system(size: 18, weight: .regular, design: .default))
                        .myFont(font: MyFonts().Body, type: .display, color: Color.black, weight: .regular)
                }
            }
        }
    }
}

struct ContactRowN: View {
    var string: String
    
    var body: some View {
        
        Text(string)
            .font(Font.system(size: 18, weight: .regular, design: .default))
    }
}
