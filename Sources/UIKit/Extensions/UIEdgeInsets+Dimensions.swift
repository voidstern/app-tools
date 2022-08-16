//
//  File.swift
//  
//
//  Created by Lukas Burgstaller on 16.08.22.
//

import Foundation
import UIKit

extension UIEdgeInsets {
    var width: CGFloat {
        return self.left + self.right
    }
    
    var height: CGFloat {
        return self.top + self.bottom
    }
}
