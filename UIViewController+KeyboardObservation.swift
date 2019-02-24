//
//  UIViewController+KeyboardObservation.swift
//  iTranslateAccountsUI
//
//  Created by Lukas on 27/06/2017.
//  Copyright © 2017 iTranslate. All rights reserved.
//

import Foundation
import UIKit

protocol KeyboardOverlapObserver {
    func keyboardOverlapChanged(size: CGSize)
}

extension UIViewController {

    func setupKeyboardObservation() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeShown(notification: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification: )), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func tearDownKeyboardObservation() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillBeShown(notification: NSNotification) {
        //get the end position keyboard frame
        guard let keyInfo = notification.userInfo else {
            return
        }

        guard let keyboardFrame: CGRect = (keyInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        //convert it to the same view coords as the tableView it might be occluding
        guard let offsetKeyboardFrame = self.view?.convert(keyboardFrame, to: nil) else {
            return
        }

        guard let view = view else {
            return
        }

        guard let keyboardObserver = self as? KeyboardOverlapObserver else {
            return
        }

        //calculate if the rects intersect
        let intersect = offsetKeyboardFrame.intersection(view.bounds)

        if !intersect.isNull {
            let duration: TimeInterval = (keyInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            //change the table insets to match - animated to the same duration of the keyboard appearance

            UIView.animate(withDuration: duration, animations: {
                keyboardObserver.keyboardOverlapChanged(size: CGSize(width: self.view.frame.width, height: keyboardFrame.size.height))
            })
        }
    }

    @objc func keyboardWillBeHidden(notification: NSNotification) {

        guard let keyboardObserver = self as? KeyboardOverlapObserver else {
            return
        }

        let keyInfo = notification.userInfo
        let duration: TimeInterval = (keyInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0

        UIView.animate(withDuration: duration) {
            keyboardObserver.keyboardOverlapChanged(size: CGSize(width: self.view.frame.width, height: 0))
        }
    }
}
