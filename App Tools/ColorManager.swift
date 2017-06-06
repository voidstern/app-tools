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

    open class Color {
        public let name: String
        public init(name: String) {
            self.name = name
        }

        public var uiColor: UIColor {
            return UIColor(rgba: ColorManager.shared.hexString(for: self))
        }

        public static func == (lhs: Color, rhs: Color) -> Bool {
            return lhs.name == rhs.name
        }
    }

    public typealias ColorDef = [String: String]

    private var colors: ColorDef = [:]

    public func loadColors(_ colors: ColorDef) {
        self.colors = colors
        NotificationCenter.default.post(name: ColorManager.colorsChangedNotificationName, object: self)
    }

    public func loadColors(json jsonURL: URL?) {
        if let jsonURL = jsonURL, let data = try? Data(contentsOf: jsonURL), let colorsDict = try? JSONSerialization.jsonObject(with: data, options: []) as? ColorDef, let colors = colorsDict {
            self.colors = colors
            NotificationCenter.default.post(name: ColorManager.colorsChangedNotificationName, object: self)
        } else {
            print("Failed to load colors json dict for \(jsonURL?.absoluteString ?? "<nil>")")
        }
    }

    public func hexString(for color: Color) -> String {
        return colors[color.name] ?? "#000000"
    }

}

extension UIColor {
    
    public convenience init(color: ColorManager.Color) {
        self.init(rgba: ColorManager.shared.hexString(for: color))
    }
}
