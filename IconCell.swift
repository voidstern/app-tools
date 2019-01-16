//
//  IconCell.swift
//  VSCAppTools
//
//  Created by Lukas on 28/06/2017.
//  Copyright © 2017 iTranslate. All rights reserved.
//

import UIKit

public final class IconCell: UITableViewCell, Cell {
    static public let identifier = "IconCell"
    static public let xibName = "IconCell"
    
    @IBOutlet public weak var iconView: UIImageView!
    @IBOutlet public weak var label: UILabel!
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
        detailTextLabel?.text = nil
        accessoryType = .none
        imageView?.image = nil
    }
}
