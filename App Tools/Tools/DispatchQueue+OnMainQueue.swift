//
//  DispatchQueue+OnMainQueue.swift
//  VSCAppTools
//
//  Created by Lukas on 15/05/2017.
//  Copyright © 2017 Lukas. All rights reserved.
//

import Foundation

extension DispatchQueue {
    public static func onMainQueue(_ block: @escaping () -> ()) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async(execute: block)
        }
    }
    
    public func async(after timeInterval: TimeInterval, execute: @escaping () -> Void) {
        asyncAfter(deadline: DispatchTime.now() + timeInterval, execute: execute)
    }
}
