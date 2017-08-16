//
//  SwitchTableViewCell.swift
//  VSCAppTools
//
//  Created by Lukas on 12/07/2017.
//  Copyright © 2017 iTranslate. All rights reserved.
//

import UIKit

public protocol SwitchCellDelegate: class {
    func switchCellDidChange(_ switchCell: SwitchCell)
}

public final class SwitchCell: UITableViewCell, Cell {
    static public let identifier = "SwitchCell"
    static public let xibName = "SwitchCell"

    weak var delegate: SwitchCellDelegate?

    @IBOutlet weak var iconView: UIImageView?
    @IBOutlet weak var switchControl: UISwitch?
    @IBOutlet weak var label: UILabel?

    override public func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
        detailTextLabel?.text = nil
        accessoryType = .none
        imageView?.image = nil
    }

    @IBAction func sendChangedNotification() {
        delegate?.switchCellDidChange(self)
    }
}
