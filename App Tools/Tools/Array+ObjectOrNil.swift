//
//  Array+ObjectOrNil.swift
//  iTranslateConverse
//
//  Created by Lukas on 3/8/17.
//  Copyright © 2017 Lukas. All rights reserved.
//

import Foundation

extension Array {

    public func objectOrNil(at index: Int) -> Element? {
        if indices.contains(index) {
            return self[index]
        }
        return nil
    }
    
}