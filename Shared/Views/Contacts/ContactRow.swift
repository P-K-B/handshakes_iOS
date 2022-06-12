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
            if (order == 3){
                Text(contact.firstName == "" ? "" : (contact.firstName + " "))
                    .font(Font.custom("SFProDisplay-Regular", size: 20))
                +
                Text(contact.lastName)
                    .font(Font.custom("SFProDisplay-Bold", size: 20))
            }
            else{
                Text(contact.lastName == "" ? "" : (contact.lastName + " "))
                    .font(Font.custom("SFProDisplay-Bold", size: 20))
                +
                Text(contact.firstName)
                    .font(Font.custom("SFProDisplay-Regular", size: 20))
            }
        }
    }
}
