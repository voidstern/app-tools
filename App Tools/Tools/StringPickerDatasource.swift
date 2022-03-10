//
//  ArrayPickerDatasource.swift
//  Multi Timers 2
//
//  Created by Lukas on 07/06/2017.
//  Copyright © 2017 Lukas Burgstaller. All rights reserved.
//

import Foundation
import UIKit

public protocol StringPickerDataSourceDelegate: AnyObject {
    func stringPickerDidChange(string: String)
}

public class StringPickerDataSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    public weak var delegate: StringPickerDataSourceDelegate?

    private var strings: [String] = []

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return strings.count
    }

    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: String(describing: strings[row]), attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.stringPickerDidChange(string: strings[row])
    }

    public func setString(_ string: String, from strings: [String], on pickerView: UIPickerView) {
        self.strings = strings

        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.reloadAllComponents()

        if let index = strings.firstIndex(of: string) {
            pickerView.selectRow(index, inComponent: 0, animated: false)
        }
    }
}
