//
//  SwitchTableViewCell.swift
//  VSCAppTools
//
//  Created by Lukas on 12/07/2017.
//  Copyright © 2017 iTranslate. All rights reserved.
//

import UIKit

public protocol SwitchCellDelegate: AnyObject {
    func switchCellDidChange(_ switchCell: SwitchCell)
}

public final class SwitchCell: UITableViewCell, Cell {
    static public let identifier = "SwitchCell"
    static public let xibName = "SwitchCell"
    static public let bundle = Bundle.module

    public weak var delegate: SwitchCellDelegate?

    @IBOutlet public weak var iconView: UIImageView?
    @IBOutlet public weak var switchControl: UISwitch?
    @IBOutlet public weak var label: UILabel?

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
