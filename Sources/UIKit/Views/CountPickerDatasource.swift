//
//  CountPickerDatasource.swift
//  Multi Timers 2
//
//  Created by Lukas on 07/06/2017.
//  Copyright © 2017 Lukas Burgstaller. All rights reserved.
//

import Foundation
import UIKit

public protocol CountPickerDataSourceDelegate: AnyObject {
    func countPickerDidChange(count: Int)
}

public class CountPickerDataSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    public weak var delegate: CountPickerDataSourceDelegate?

    public var count: Int = 999
    public var offset: Int = 0

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return count
        }
        return 0
    }

    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: String(describing: row + offset), attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.countPickerDidChange(count: row + offset)
    }

    public func setCount(_ count: Int, on pickerView: UIPickerView) {
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.reloadAllComponents()

        pickerView.selectRow(count - offset, inComponent: 0, animated: false)
    }
}
