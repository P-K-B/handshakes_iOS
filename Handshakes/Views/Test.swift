
import SwiftUI
import UIKit

struct Test: View {
    
    var body: some View {
        Text("HI")
            .onAppear(perform: {
                print("HI")
//                let access = try await requestAccess()

            })
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
