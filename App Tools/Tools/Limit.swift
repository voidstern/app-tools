//
//  Limit.swift
//  Dozzzer
//
//  Created by Lukas on 4/20/17.
//  Copyright © 2017 Lukas Burgstaller. All rights reserved.
//

import Foundation

public func limit<T: Comparable> (_ value: T, maximum: T, minimum: T) -> T {
    return min(max(value, minimum), maximum)
}
