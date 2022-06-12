//
//  SearchBar.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 28.05.2022.
//

import Foundation
import SwiftUI

struct SearchBarMy: View{
    
    @Binding var searchText: String
    @State var showCancelButton: Bool = false
    
    var body: some View{
        HStack {
            HStack {
                //search bar magnifying glass image
                Image(systemName: "magnifyingglass").foregroundColor(.secondary)
                
                //search bar text field
                TextField("search", text: self.$searchText, onEditingChanged: { isEditing in
                    self.showCancelButton = true
                })
                
                // x Button
                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .opacity(self.searchText == "" ? 0 : 1)
                }
            }
            .padding(8)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            
            // Cancel Button
            if self.showCancelButton  {
                Button("Cancel") {
                    self.endEditing()
                    self.searchText = ""
                    self.showCancelButton = false
                }
            }
        }
        .padding([.leading, .trailing,.top])
    }
}
