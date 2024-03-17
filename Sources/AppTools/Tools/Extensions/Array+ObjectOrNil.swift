//
//  Array+ObjectOrNil.swift
//  VSCAppTools
//
//  Created by Lukas on 3/8/17.
//  Copyright © 2017 Lukas. All rights reserved.
//

import Foundation

public extension Array {
    func objectOrNil(at index: Int) -> Element? {
        if indices.contains(index) {
            return self[index]
        }
        return nil
    }
}

public extension Collection {
    subscript(safe index: Index) -> Element? {
        return startIndex <= index && index < endIndex ? self[index] : nil
    }
}
