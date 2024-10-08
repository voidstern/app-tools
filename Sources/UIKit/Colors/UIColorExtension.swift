//
//  UIColorExtension.swift
//  HEXColor
//
//  Created by R0CKSTAR on 6/13/14.
//  Copyright (c) 2014 P.D.Q. All rights reserved.
//

import UIKit

/**
MissingHashMarkAsPrefix:   "Invalid RGB string, missing '#' as prefix"
UnableToScanHexValue:      "Scan hex error"
MismatchedHexStringLength: "Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8"
*/
public enum UIColorInputError : Error {
    case missingHashMarkAsPrefix,
    unableToScanHexValue,
    mismatchedHexStringLength
}

extension UIColor {
    /**
    The shorthand three-digit hexadecimal representation of color.
    #RGB defines to the color #RRGGBB.
    
    - parameter hex3: Three-digit hexadecimal value.
    - parameter alpha: 0.0 - 1.0. The default is 1.0.
    */
    public convenience init(hex3: UInt16, alpha: CGFloat = 1) {
        let divisor = CGFloat(15)
        let red     = CGFloat((hex3 & 0xF00) >> 8) / divisor
        let green   = CGFloat((hex3 & 0x0F0) >> 4) / divisor
        let blue    = CGFloat( hex3 & 0x00F      ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
    The shorthand four-digit hexadecimal representation of color with alpha.
    #RGBA defines to the color #RRGGBBAA.
    
    - parameter hex4: Four-digit hexadecimal value.
    */
    public convenience init(hex4: UInt16) {
        let divisor = CGFloat(15)
        let red     = CGFloat((hex4 & 0xF000) >> 12) / divisor
        let green   = CGFloat((hex4 & 0x0F00) >>  8) / divisor
        let blue    = CGFloat((hex4 & 0x00F0) >>  4) / divisor
        let alpha   = CGFloat( hex4 & 0x000F       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
    The six-digit hexadecimal representation of color of the form #RRGGBB.
    
    - parameter hex6: Six-digit hexadecimal value.
    */
    public convenience init(hex6: UInt32, alpha: CGFloat = 1) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex6 & 0x0000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
    The six-digit hexadecimal representation of color with alpha of the form #RRGGBBAA.
    
    - parameter hex8: Eight-digit hexadecimal value.
    */
    public convenience init(hex8: UInt32) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex8 & 0xFF000000) >> 24) / divisor
        let green   = CGFloat((hex8 & 0x00FF0000) >> 16) / divisor
        let blue    = CGFloat((hex8 & 0x0000FF00) >>  8) / divisor
        let alpha   = CGFloat( hex8 & 0x000000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
    The rgba string representation of color with alpha of the form #RRGGBBAA/#RRGGBB, throws error.
    
    - parameter rgba: String value.
    */
    public convenience init(rgba_throws rgba: String) throws {
        guard rgba.hasPrefix("#") else {
            throw UIColorInputError.missingHashMarkAsPrefix
        }

        let index = rgba.index(rgba.startIndex, offsetBy: 1)
        let hexString: String = String(rgba[index...])
        var hexValue: UInt64 = 0

        guard Scanner(string: hexString).scanHexInt64(&hexValue) else {
                throw UIColorInputError.unableToScanHexValue
        }

        guard hexString.count  == 3 || hexString.count == 4 || hexString.count == 6  || hexString.count == 8 else {
                throw UIColorInputError.mismatchedHexStringLength
        }
        
        switch (hexString.count) {
        case 3:
            self.init(hex3: UInt16(hexValue))
        case 4:
            self.init(hex4: UInt16(hexValue))
        case 6:
            self.init(hex6: UInt32(hexValue))
        default:
            self.init(hex8: UInt32(hexValue))
        }
    }
    
    /**
    The rgba string representation of color with alpha of the form #RRGGBBAA/#RRGGBB, fails to default color.
    
    - parameter rgba: String value.
    */
    public convenience init(rgba: String, defaultColor: UIColor = UIColor.clear) {
        guard let color = try? UIColor(rgba_throws: rgba) else {
            self.init(cgColor: defaultColor.cgColor)
            return
        }
        self.init(cgColor: color.cgColor)
    }
    
    public static func rgbaOrSystem(_ rgbaOrSystem: String) -> UIColor {
        if UIColor.responds(to: Selector(rgbaOrSystem)) {
            if let color = UIColor.perform(Selector(rgbaOrSystem))?.takeRetainedValue() as? UIColor {
                return color
            }
        }
        
        return UIColor(rgba: rgbaOrSystem)
    }
}
