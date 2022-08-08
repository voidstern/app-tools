//
//  Animations.swift
//  Dozzzer 4
//
//  Created by Lukas Burgstaller on 27/10/2016.
//  Copyright © 2016 Lukas Burgstaller. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    static func animateWithDefaults(_ animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        animateWithDefaults(animations: animations, completion: completion)
    }
    
    static func animateWithDefaults(animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.35, options: [.allowAnimatedContent, .allowUserInteraction], animations: animations, completion: completion)
    }
}
