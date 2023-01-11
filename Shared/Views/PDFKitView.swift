//
//  PDFView.swift
//  Handshakes2 (iOS)
//
//  Created by Kirill Burchenko on 17.05.2022.
//

import SwiftUI
import PDFKit

struct PDFKitView: View {
    var url: URL
    
    var body: some View {
        PDFKitRepresentedView(url)
    }
}

struct PDFView_Previews: PreviewProvider {
    static var previews: some View {
        PDFKitView(url: URL(string: "http://www.africau.edu/images/default/sample.pdf")!)
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
