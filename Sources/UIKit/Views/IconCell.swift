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
    static public let bundle = Bundle.module
    
    @IBOutlet public private(set) weak var iconView: UIImageView!
    @IBOutlet public private(set) weak var leftLabel: UILabel!
    @IBOutlet public private(set) weak var rightLabel: UILabel!
    @IBOutlet public private(set) weak var activityIndicator: UIActivityIndicatorView!
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        leftLabel?.text = nil
        rightLabel?.text = nil
        detailTextLabel?.text = nil
        accessoryType = .none
        imageView?.image = nil
        
#if targetEnvironment(macCatalyst)
        leftLabel.font = .systemFont(ofSize: 13)
        rightLabel.font = .systemFont(ofSize: 13)
#endif
    }
}
