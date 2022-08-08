//
//  StaticCell.swift
//  VSCAppTools
//
//  Created by Lukas on 28/06/2017.
//  Copyright © 2017 iTranslate. All rights reserved.
//

import UIKit

public class StaticCell: UITableViewCell, Cell {
    static public let identifier = "StaticCell"
    static public let xibName = "StaticCell"
    static public let bundle = Bundle.module

    override public func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
        detailTextLabel?.text = nil
        accessoryType = .none
        imageView?.image = nil
    }
}
