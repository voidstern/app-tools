//
//  DelayedBlock.swift
//  AppToolsMobile
//
//  Created by Lukas Burgstaller on 04.07.20.
//  Copyright © 2020 Lukas. All rights reserved.
//

import Foundation

public class DelayedBlock: NSObject {
    var timer: Timer?
    @objc var delay: TimeInterval
    @objc var block: (()->())?
    
    @objc init(block: (()->())? = nil, delay: TimeInterval = 0.3) {
        self.block = block
        self.delay = delay
    }
    
    @objc public func triggerNow(block: (()->())? = nil) {
        if let block = block {
            self.block = block
        }
        
        perform()
    }
    
    @objc public func triggerDelayed(block: (()->())? = nil) {
        if let block = block {
            self.block = block
        }
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false, block: { (timer) in
            self.perform()
        })
    }
    
    private func perform() {
        timer?.invalidate()
        timer = nil
        block?()
    }
}
