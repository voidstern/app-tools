//
//  StaticCell.swift
//  VSCAppTools
//
//  Created by Lukas on 28/06/2017.
//  Copyright © 2017 iTranslate. All rights reserved.
//

import UIKit
import AppTools

public protocol SelectionCellDelegate: AnyObject {
    func selectionCellDidChange(_ switchCell: SelectionCell)
}

public class SelectionCell: UITableViewCell, Cell {
    static public let identifier = "SelectionCell"
    static public let xibName = "SelectionCell"
    static public let bundle = Bundle.module
    
    public weak var delegate: SelectionCellDelegate?
    
    @IBOutlet weak var popupButtonLeading: NSLayoutConstraint!
    @IBOutlet weak var popupButtonTrailing: NSLayoutConstraint!
    
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
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
#if targetEnvironment(macCatalyst)
        popupButtonLeading.constant = label.frame.maxX + 8
        popupButtonTrailing.constant = 8
#endif
    }
    
    func updateSelectionMenu() {
        if let selectedOption = selectedOption, let title = options.objectOrNil(at: selectedOption) {
            popupButton.setTitle(title, for: .normal)
        }
        
        let optionActions = options.map({ option -> UIAction in
            let isActive = selectedOption != nil && selectedOption == options.firstIndex(of: option)
            return UIAction(title: option, state: isActive ? .on : .off) { action in
                self.selectedOption = self.options.firstIndex(of: option)
                self.delegate?.selectionCellDidChange(self)
            }
        })
        
        if #available(iOS 14.0, *) {
            popupButton.menu = UIMenu(children: optionActions)
        }
    }
}
