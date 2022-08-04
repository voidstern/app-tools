//
//  StaticCell.swift
//  VSCAppTools
//
//  Created by Lukas on 28/06/2017.
//  Copyright © 2017 iTranslate. All rights reserved.
//

import UIKit

@available(iOS 15.0, *)
public protocol SelectionCellDelegate: AnyObject {
    func selectionCellDidChange(_ switchCell: SelectionCell)
}

@available(iOS 15.0, *)
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
        didSet { updateSelectionMenu() }
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
        if let selectedOption = selectedOption, let title = options.objectOrNil(at: selectedOption) {
            popupButton.setTitle(title, for: .normal)
        }
        
        let optionActions = options.map({ option in
            let isActive = selectedOption != nil && selectedOption == options.firstIndex(of: option)
            return UIAction(title: option, state: isActive ? .on : .off) { action in
                self.selectedOption = self.options.firstIndex(of: option)
                self.delegate?.selectionCellDidChange(self)
            }
        })
        
        popupButton.menu = UIMenu(children: optionActions)
    }
}
