//
//  UITableView+deselectRow.swift
//  VSCAppTools
//
//  Created by Lukas on 20/05/2017.
//  Copyright © 2017 Lukas. All rights reserved.
//

import Foundation
import UIKit

public extension UITableView {
    public func deselectRows(animated: Bool = true) {
        for row in indexPathsForVisibleRows ?? [] {
            deselectRow(at: row, animated: animated)
        }
    }
}
