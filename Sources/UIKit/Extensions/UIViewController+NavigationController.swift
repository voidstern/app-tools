//
//  UIViewController+NavigationController.swift
//  Dozzzer
//
//  Created by Lukas Burgstaller on 07.08.22.
//  Copyright © 2022 Lukas Burgstaller. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    var inNavigationController: UINavigationController {
        return UINavigationController(rootViewController: self)
    }
}
