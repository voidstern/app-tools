//
//  UIView+FadeTransition.swift
//  VSCAppTools
//
//  Created by Lukas on 2/27/17.
//  Copyright © 2017 Lukas. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    public func animateTransition(_ type: String, duration: TimeInterval = 0.25) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = type
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        transition.fillMode = kCAFillModeBoth
        layer.add(transition, forKey: kCATransition)
    }
}
