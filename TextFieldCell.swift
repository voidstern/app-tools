//
//  TextFieldCell.swift
//  VSCAppTools
//
//  Created by Lukas on 26/06/2017.
//  Copyright © 2017 iTranslate. All rights reserved.
//

import UIKit

public protocol TextFieldCellDelegate: class {
    func textFieldTextDidFocus(_ textFieldCell: TextFieldCell)
    func textFieldTextDidChange(_ textFieldCell: TextFieldCell)
    func textFieldHidDoneButton(_ textFieldCell: TextFieldCell)
    func textFieldDidEndEditing(_ textFieldCell: TextFieldCell)
}

public final class TextFieldCell: UITableViewCell, Cell {
    static public let identifier = "TextFieldCell"
    static public let xibName = "TextFieldCell"

    @IBOutlet weak public var textField: UITextField?

    weak public var delegate: TextFieldCellDelegate?

    weak public var nextTextField: UITextField? {
        didSet { updateTextField() }
    }

    public var placeholder: String? {
        didSet { updateTextField() }
    }

    public var secureEntry: Bool = false {
        didSet { updateTextField() }
    }

    public var textFieldColor: UIColor? {
        didSet { updateTextField() }
    }

    public var keyboardType: UIKeyboardType = .default {
        didSet { updateTextField() }
    }

    public var autocapitalizationType: UITextAutocapitalizationType = .none {
        didSet { updateTextField() }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        textField?.addTarget(self, action: #selector(sendTextChanged), for: .editingChanged)
        updateTextField()
    }

    func updateTextField() {
        textField?.placeholder = placeholder
        textField?.isSecureTextEntry = secureEntry
        textField?.textColor = textFieldColor
        textField?.delegate = self
        textField?.keyboardType = keyboardType
        textField?.autocapitalizationType = autocapitalizationType

        selectionStyle = .none

        if nextTextField == nil {
            textField?.returnKeyType = .done
        } else {
            textField?.returnKeyType = .next
        }
    }

    func sendTextChanged() {
        delegate?.textFieldTextDidChange(self)
    }
}

extension TextFieldCell: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldTextDidFocus(self)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        delegate?.textFieldHidDoneButton(self)

        if nextTextField == nil {
            textField.resignFirstResponder()
        } else {
            nextTextField?.becomeFirstResponder()
        }
        return false
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(self)
    }
}
