//
//  Array+RemoveObject.swift
//  VSCAppTools
//
//  Created by Lukas on 25/05/2017.
//  Copyright © 2017 Lukas. All rights reserved.
//

import Foundation

public extension Array where Element: Equatable {

    // Remove first collection element that is equal to the given `object`:
    mutating func remove(_ object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
}
