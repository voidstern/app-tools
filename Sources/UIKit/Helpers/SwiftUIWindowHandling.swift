//
//  SwiftUIWindowHandling.swift
//  GamePlan
//
//  Created by Lukas Burgstaller on 28.08.23.
//

import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit

public func SwiftUIWindows() -> [UIWindow] {
    let windows: [[UIWindow]] = UIApplication.shared.connectedScenes.compactMap({ ($0 as? UIWindowScene)?.windows })
    return windows.reduce([], +)
}

extension UIWindow {
    public var topViewController: UIViewController? {
        var topViewController: UIViewController? = rootViewController
        
        while topViewController?.presentedViewController != nil {
            topViewController = topViewController?.presentedViewController
        }
        
        return topViewController
    }
}
#endif
