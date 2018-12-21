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
        transition.type = convertToCATransitionType(type)
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        transition.fillMode = CAMediaTimingFillMode.both
        layer.add(transition, forKey: kCATransition)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToCATransitionType(_ input: String) -> CATransitionType {
	return CATransitionType(rawValue: input)
}
