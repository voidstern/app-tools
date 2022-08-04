//
//  UIView+FadeTransition.swift
//  VSCAppTools
//
//  Created by Lukas on 2/27/17.
//  Copyright © 2017 Lukas. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    func animateTransition(_ type: CATransitionType, duration: TimeInterval = 0.25) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = type
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        transition.fillMode = CAMediaTimingFillMode.both
        layer.add(transition, forKey: kCATransition)
    }
}
