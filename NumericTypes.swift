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
    public var uInt: UInt {
        return UInt(self)
    }
    
    public var double: Double {
        return Double(self)
    }
    
    public var float: Float {
        return Float(self)
    }
    
    public var cgFloat: CGFloat {
        return CGFloat(self)
    }
}

public extension UInt {
    public var int: Int {
        return Int(self)
    }
    
    public var double: Double {
        return Double(self)
    }
    
    public var float: Float {
        return Float(self)
    }
    
    public var cgFloat: CGFloat {
        return CGFloat(self)
    }
}

public extension Float {
    public var uInt: UInt {
        return UInt(self)
    }
    
    public var int: Int {
        return Int(self)
    }
    
    public var double: Double {
        return Double(self)
    }
    
    public var cgFloat: CGFloat {
        return CGFloat(self)
    }
}

public extension CGFloat {
    public var uInt: UInt {
        return UInt(self)
    }
    
    public var int: Int {
        return Int(self)
    }
    
    public var double: Double {
        return Double(self)
    }
    
    public var float: Float {
        return Float(self)
    }
}
