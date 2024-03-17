//
//  Data+hexString.swift
//  AppTools
//
//  Created by Lukas on 22/08/2017.
//  Copyright © 2017 Lukas. All rights reserved.
//

import Foundation

public extension Data {
    var hexString: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }

    var utf8String: String? {
        return String(data: self, encoding: String.Encoding.utf8)
    }
}
