//
//  ContactsRow.swift
//  Handshakes
//
//  Created by Kirill Burchenko on 26.11.2021.
//

import SwiftUI

struct ContactRow: View {
    var contact: FetchedContact
    
    var a: Bool = true
    
    var body: some View {
        HStack() {
            Text(contact.lastName.isEmpty ? "" : contact.lastName + " ")
                .font(Font.custom("SFProDisplay-Bold", size: 20))
            +
            Text(contact.firstName)
                .font(Font.custom("SFProDisplay-Regular", size: 20))
        }
    }
}

struct ContactRow_Previews: PreviewProvider {
    static var previews: some View {
            ContactRow(contact: ContactsDataView().contacts[0])
        .previewLayout(.fixed(width: 300, height: 100))
    }
}
