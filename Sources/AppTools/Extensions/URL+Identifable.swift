//
//  File.swift
//  
//
//  Created by Lukas Burgstaller on 22.02.24.
//

import Foundation

extension URL: Identifiable {
    public var id: String {
        return absoluteString
    }
}
