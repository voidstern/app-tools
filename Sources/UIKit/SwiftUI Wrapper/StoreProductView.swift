//
//  StoreProductView.swift
//  GamePlan
//
//  Created by Lukas Burgstaller on 28.08.23.
//

import Foundation
import SwiftUI
import StoreKit

#if os(iOS)
struct StoreProductView: UIViewControllerRepresentable {
    let productID: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let storeView = SKStoreProductViewController()
        storeView.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: productID])
        return storeView
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject {
        var parent: StoreProductView
        
        init(_ imagePickerController: StoreProductView) {
            self.parent = imagePickerController
        }
    }
}
#endif
