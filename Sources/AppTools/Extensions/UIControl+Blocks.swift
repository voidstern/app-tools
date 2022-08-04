//
//  UIControl+Blocks.swift
//  Dozzzer
//
//  Created by Lukas on 11/3/16.
//  Copyright © 2016 Lukas Burgstaller. All rights reserved.
//

import Foundation
import ObjectiveC
import UIKit

var actionBlockKey: UInt8 = 0

// a type for our action block closure
public typealias BlockButtonActionBlock = (_ sender: UISwitch) -> Void

public class ActionBlockWrapper: NSObject {
    var block: BlockButtonActionBlock
    init(block: @escaping BlockButtonActionBlock) {
        self.block = block
    }
}

extension UISwitch {
    func block_setAction(block: @escaping BlockButtonActionBlock) {
        objc_setAssociatedObject(self, &actionBlockKey, ActionBlockWrapper(block: block), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addTarget(self, action: #selector(UISwitch.block_handleAction(_: )), for: .touchUpInside)
    }
    
    @objc func block_handleAction(_ sender: UISwitch) {
        let wrapper = objc_getAssociatedObject(self, &actionBlockKey) as! ActionBlockWrapper
        wrapper.block(sender)
    }
}
