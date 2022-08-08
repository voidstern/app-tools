//
//  TimePickerDatasource.swift
//  Multi Timers 2
//
//  Created by Lukas on 07/06/2017.
//  Copyright © 2017 Lukas Burgstaller. All rights reserved.
//

import Foundation
import UIKit

public protocol TimerPickerDataSourceDelegate: AnyObject {
    func timePickerDidChange(duration: TimeInterval)
}

public class TimerPickerDataSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    public weak var delegate: TimerPickerDataSourceDelegate?

    var smallMode: Bool {
        return UIScreen.main.bounds.width < 350
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 365
        }
        if component == 1 {
            return 24
        }
        if component == 2 {
            return 60
        }
        if component == 3 {
            return 60
        }
        return 0
    }

    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {

        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]

        if component == 0 {
            return NSAttributedString(string: "\(row)\(smallMode ? "" : " ")\((row < 100 && smallMode) ? "d" : "")", attributes: attributes)
        }

        if component == 1 {
            return NSAttributedString(string: "\(row)\(smallMode ? "h" : " hr")", attributes: attributes)
        }

        if component == 2 {
            return NSAttributedString(string: "\(row)\(smallMode ? "m" : " min")", attributes: attributes)
        }

        if component == 3 {
            return NSAttributedString(string: "\(row)\(smallMode ? "s" : " sec")", attributes: attributes)
        }

        return NSAttributedString(string: "", attributes: attributes)
    }

    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        if component == 0 {
            return smallMode ? 55 : 65
        }

        if component == 1 {
            return smallMode ? 55 : 70
        }

        if component == 2 {
            return smallMode ? 60 : 85
        }

        if component == 3 {
            return smallMode ? 55 : 85
        }

        return 0
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let duration = TimeInterval(pickerView.selectedRow(inComponent: 3) + pickerView.selectedRow(inComponent: 2) * 60 + pickerView.selectedRow(inComponent: 1) * 60 * 60 + pickerView.selectedRow(inComponent: 0) * 60 * 60 * 24)
        delegate?.timePickerDidChange(duration: duration)
    }

    public func setDuration(_ duration: TimeInterval, on pickerView: UIPickerView) {

        pickerView.dataSource = self
        pickerView.delegate = self

        let totalSeconds = Int(duration)

        let d = (totalSeconds/86400)
        let hr = (totalSeconds/3600)%24
        let min = (totalSeconds/60)%60
        let sec = (totalSeconds%60)

        pickerView.reloadAllComponents()

        pickerView.selectRow(d,   inComponent: 0, animated: false)
        pickerView.selectRow(hr,  inComponent: 1, animated: false)
        pickerView.selectRow(min, inComponent: 2, animated: false)
        pickerView.selectRow(sec, inComponent: 3, animated: false)        
    }
}
