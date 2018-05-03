//
//  Data+hexString.swift
//  AppTools
//
//  Created by Lukas on 22/08/2017.
//  Copyright © 2017 Lukas. All rights reserved.
//

import Foundation

extension Data {
    public var hexString: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }

    public var utf8String: String? {
        return String(data: self, encoding: String.Encoding.utf8)
    }
}
