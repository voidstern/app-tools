//
//  ButtonCell.swift
//  VSCAppTools
//
//  Created by Lukas on 26/06/2017.
//  Copyright © 2017 iTranslate. All rights reserved.
//

import UIKit

public final class ButtonCell: UITableViewCell, Cell {
    static public let identifier = "ButtonCell"
    static public let xibName = "ButtonCell"
    static public let bundle = Bundle.module
    
    @IBOutlet weak var buttonLabel: UILabel?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!


    public var title: String? {
        didSet { buttonLabel?.text = title }
    }

    public var indicatorColor: UIColor? {
        didSet { activityIndicator.color = indicatorColor }
    }

    public var disabledColor: UIColor?

    public var buttonColor: UIColor? {
        didSet { buttonLabel?.textColor = buttonColor }
    }

    public var enabled: Bool = true {
        didSet {
            buttonLabel?.alpha = enabled ? 1.0 : 0.3
            buttonLabel?.textColor = enabled ? buttonColor : (disabledColor ?? buttonColor)
            selectionStyle = enabled ? .default : .none
        }
    }

    public var showIndicator: Bool = false {
        didSet {
            if showIndicator {
                activityIndicator.startAnimating()
                buttonLabel?.isHidden = true
            } else {
                activityIndicator.stopAnimating()
                buttonLabel?.isHidden = false
            }
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        buttonLabel?.text = title
        buttonLabel?.textColor = enabled ? buttonColor : (disabledColor ?? buttonColor)
        activityIndicator.color = indicatorColor
        buttonLabel?.alpha = enabled ? 1.0 : 0.5
        selectionStyle = enabled ? .default : .none
    }
}
