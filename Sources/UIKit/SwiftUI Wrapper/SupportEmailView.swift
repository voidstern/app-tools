//
//  SupportEmailView.swift
//  GamePlan
//
//  Created by Lukas Burgstaller on 28.08.23.
//

import Foundation
import SwiftUI
import AppTools

struct SupportEmailView: UIViewControllerRepresentable {
    let mailAddress: String
    let rcid: String?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return SupportMailController.create(mailAdress: mailAddress, rcid: rcid)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject {
        var parent: SupportEmailView
        
        init(_ imagePickerController: SupportEmailView) {
            self.parent = imagePickerController
        }
    }
}
