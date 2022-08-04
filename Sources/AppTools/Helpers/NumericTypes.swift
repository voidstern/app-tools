//
//  NumericTypes.swift
//  AppToolsMobile
//
//  Created by Lukas on 24.02.19.
//  Copyright © 2019 Lukas. All rights reserved.
//

import Foundation
import CoreGraphics

public extension Int {
    var uInt: UInt {
        return UInt(self)
    }
    
    var double: Double {
        return Double(self)
    }
    
    var float: Float {
        return Float(self)
    }
    
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
}

public extension UInt {
    var int: Int {
        return Int(self)
    }
    
    var double: Double {
        return Double(self)
    }
    
    var float: Float {
        return Float(self)
    }
    
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
}

public extension Float {
    var uInt: UInt {
        return UInt(self)
    }
    
    var int: Int {
        return Int(self)
    }
    
    var double: Double {
        return Double(self)
    }
    
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
}

public extension CGFloat {
    var uInt: UInt {
        return UInt(self)
    }
    
    var int: Int {
        return Int(self)
    }
    
    var double: Double {
        return Double(self)
    }
    
    var float: Float {
        return Float(self)
    }
}
