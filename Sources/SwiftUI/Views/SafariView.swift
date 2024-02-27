//
//  File.swift
//  
//
//  Created by Lukas Burgstaller on 22.02.24.
//

import Foundation
import SwiftUI

#if canImport(SafariServices)

import SafariServices

public struct SafariWebView: UIViewControllerRepresentable {
    let url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    public func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
}

#endif
