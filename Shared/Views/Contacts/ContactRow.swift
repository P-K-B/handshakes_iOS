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
        HStack() {
            Text("\(contact.index)")
            if (order == 3){
                Text(contact.firstName == "" ? "" : (contact.firstName + " "))
                    .font(Font.system(size: 18, weight: .regular, design: .default))
                +
                Text(contact.lastName)
                    .font(Font.system(size: 18, weight: .semibold, design: .default))

                
            }
            else{
                Text(contact.lastName == "" ? "" : (contact.lastName + " "))
                            .font(Font.system(size: 18, weight: .semibold, design: .default))
                          //                    .font(Font.custom("Inter-SemiBold", size: 40))
                +
                Text(contact.firstName)
                        .font(Font.system(size: 18, weight: .regular, design: .default))
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
