//
//  StaticCell.swift
//  VSCAppTools
//
//  Created by Lukas on 28/06/2017.
//  Copyright © 2017 iTranslate. All rights reserved.
//

import UIKit

public protocol SelectionCellDelegate: AnyObject {
    func selectionCellDidChange(_ switchCell: SelectionCell)
}

public final class SelectionCell: UITableViewCell, Cell {
    static public let identifier = "SelectionCell"
    static public let xibName = "SelectionCell"
    
    public weak var delegate: SelectionCellDelegate?
    
    @IBOutlet public private(set) weak var iconView: UIImageView!
    @IBOutlet public private(set) weak var popupButton: UIButton!
    @IBOutlet public private(set) weak var label: UILabel!
    
    public var options: [String] = [] {
        didSet { updateSelectionMenu() }
    }
    public var selectedOption: Int? {
        didSet { delegate?.selectionCellDidChange(self) }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
        detailTextLabel?.text = nil
        accessoryType = .none
        imageView?.image = nil
    }
    
    func updateSelectionMenu() {
        let optionActions = options.map({ option in
            UIAction(title: option) { action in
                self.selectedOption = self.options.firstIndex(of: option)
            }
        })
        
        popupButton.menu = UIMenu(children: optionActions)
    }
}
