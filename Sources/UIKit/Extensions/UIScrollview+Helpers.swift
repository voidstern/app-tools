//
//  File.swift
//  
//
//  Created by Lukas Burgstaller on 11.04.23.
//

import Foundation
import UIKit

extension UIScrollView {
    public var numberOfPages: Int {
        guard bounds.width > 0 && contentSize.width > 0 else {
            return 0
        }
        
        return Int(round(contentSize.width / bounds.width))
    }
    
    public var currentPage: Int {
        get {
            guard bounds.width > 0 && contentSize.width > 0 else {
                return 0
            }
            
            return Int(round(contentOffset.x / bounds.width))
        }
        
        set {
            guard bounds.width > 0 && contentSize.width > 0 else {
                return
            }
            
            let desiredOffset = bounds.width * CGFloat(newValue)
            if abs(contentOffset.x - desiredOffset) > 5 { // Catch rounding issues
                contentOffset.x = desiredOffset
            }
        }
    }
    
    public func contentOffset(for page: Int) -> CGPoint {
        CGPoint(x: bounds.width * CGFloat(page), y: 0)
    }
    
    public func setOffset(for page: Int) {
        contentOffset = contentOffset(for: page)
    }
}

