//
//  Date+Rounding.swift
//  Greendrive
//
//  Created by Lukas Burgstaller on 17.05.22.
//  Copyright © 2022 Gutschi.Net. All rights reserved.
//

import Foundation

public extension Date {
    func ceil(roundingInterval: TimeInterval) -> Date {
        let roundedInterval: TimeInterval = Darwin.ceil(self.timeIntervalSince1970 / roundingInterval)
        return Date(timeIntervalSince1970: roundedInterval * roundingInterval)
    }
    
    func floor(roundingInterval: TimeInterval) -> Date {
        let roundedInterval: TimeInterval = Darwin.floor(self.timeIntervalSince1970 / roundingInterval)
        return Date(timeIntervalSince1970: roundedInterval * roundingInterval)
    }
    
    func round(roundingInterval: TimeInterval) -> Date {
        let roundedInterval: TimeInterval = Darwin.round(self.timeIntervalSince1970 / roundingInterval)
        return Date(timeIntervalSince1970: roundedInterval * roundingInterval)
    }
}
