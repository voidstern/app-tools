//
//  ColorManager.swift
//  VSCAppTools
//
//  Created by Lukas on 04/06/2017.
//  Copyright © 2017 Lukas. All rights reserved.
//

import Foundation
import UIKit

final public class ColorManager {
    static public let shared = ColorManager()

    public static let colorsChangedNotificationName = NSNotification.Name(rawValue: "net.voidstern.color.changed")

    open class Color: ExpressibleByStringLiteral, LosslessStringConvertible {
        public typealias StringLiteralType = String
        public let name: String
        
        public init(name: String) {
            self.name = name
        }
        
        required public init?(_ description: String) {
            self.name = description
        }
        
        required public init(stringLiteral value: ColorManager.Color.StringLiteralType) {
            self.name = value
        }

        public var uiColor: UIColor {
            return UIColor(color: self)
        }
        
        public var description: String {
            return name
        }

        public static func == (lhs: Color, rhs: Color) -> Bool {
            return lhs.name == rhs.name
        }
    }

    public typealias ColorDef = [String: String]

    fileprivate var lightColors: ColorDef = [:]
    fileprivate var darkColors: ColorDef = [:]

    public func loadColors(light: ColorDef, dark: ColorDef) {
        self.lightColors = light
        self.darkColors = dark
        
        DispatchQueue.onMainQueue {
            NotificationCenter.default.post(name: ColorManager.colorsChangedNotificationName, object: self)
        }
    }

    public func loadColors(json jsonURL: URL?) {
        loadColors(light: jsonURL, dark: jsonURL)
    }

    public func loadColors(light lightJSONURL: URL?, dark darkJSONURL: URL?) {
        guard let lightJSONURL = lightJSONURL else {
            return
        }
        
        guard let lightData = try? Data(contentsOf: lightJSONURL), let lightColorsDict = ((try? JSONSerialization.jsonObject(with: lightData, options: []) as? ColorDef) as ColorManager.ColorDef??), let lightColors = lightColorsDict else {
            print("Failed to load light colors json dict for \(lightJSONURL.absoluteString)")
            return
        }
        
        let darkJSONURL = darkJSONURL ?? lightJSONURL
        guard let darkData = try? Data(contentsOf: darkJSONURL), let darkColorsDict = ((try? JSONSerialization.jsonObject(with: darkData, options: []) as? ColorDef) as ColorManager.ColorDef??), let darkColors = darkColorsDict else {
            print("Failed to load light colors json dict for \(darkJSONURL.absoluteString)")
            return
        }
        
        loadColors(light: lightColors, dark: darkColors)
    }

    fileprivate func lightColor(for color: Color) -> UIColor {
        return UIColor(rgba: lightColors[color.name] ?? "#FAFAFA")
    }

    fileprivate func darkColor(for color: Color) -> UIColor {
        return UIColor(rgba: darkColors[color.name] ?? "#232323")
    }
}

extension UIColor {
    public convenience init(color: ColorManager.Color) {
        #if os(iOS)
        let cm = ColorManager.shared
        if #available(iOS 13.0, *) {
            self.init(light: cm.lightColor(for: color), dark: cm.darkColor(for: color))
        } else {
            self.init(rgba: ColorManager.shared.lightColors[color.name] ?? "#FAFAFA")
        }
        #else
        self.init(rgba: ColorManager.shared.lightColors[color.name] ?? "#FAFAFA")
        #endif
    }
}

#if os(iOS)
@available(iOS 13.0, *)
extension UIColor {
    convenience init(light: UIColor, dark: UIColor) {
        self.init(dynamicProvider: { (traits) in
            switch traits.userInterfaceStyle {
            case .unspecified, .light: return light
            case .dark: return dark
            @unknown default: return light
            }
        })
    }
}
#endif
