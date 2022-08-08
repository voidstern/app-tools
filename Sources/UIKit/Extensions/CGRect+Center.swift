//
//  CGRect+Center.swift
//  AppToolsMobile
//
//  Created by Lukas on 24.08.19.
//  Copyright © 2019 Lukas. All rights reserved.
//

import Foundation
import UIKit

public extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}
