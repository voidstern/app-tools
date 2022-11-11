//
//  WhatsNewTableCell.swift
//  Dozzzer
//
//  Created by Lukas Burgstaller on 11.11.22.
//  Copyright © 2022 Lukas Burgstaller. All rights reserved.
//

import Foundation
import UIKit

internal class UpdateNewsTableCell: UITableViewCell, Cell {
    static let identifier = "UpdateNewsTableCell"
    static let xibName = "UpdateNewsTableCell"
    static let bundle = Bundle(for: UpdateNewsTableCell.self)
    
    @IBOutlet weak var entryIcon: UIImageView!
    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var entrySubtitleLabel: UILabel!
}
