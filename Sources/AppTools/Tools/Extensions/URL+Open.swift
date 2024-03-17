//
//  File.swift
//  
//
//  Created by Lukas Burgstaller on 17.03.24.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

public extension URL {
    func open() {
#if canImport(UIKit)
        UIApplication.shared.open(self)
#else
        NSWorkspace.shared.open(self)
#endif

    }
}
