//
//  SupportMailController.swift
//  VSCAppTools
//
//  Created by Lukas on 14/05/2017.
//  Copyright © 2017 Lukas. All rights reserved.
//

import Foundation
import MessageUI

extension UIDevice {
    var machine: String {

        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }

        return modelCode ?? UIDevice.current.model
    }
}

public final class SupportMailController: MFMailComposeViewController, MFMailComposeViewControllerDelegate {

    private static var messageBody: String {
        let system = "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
        let machine = UIDevice.current.machine

        return "\n\n\nSystem: \(system)\nDevice: \(machine)"
    }

    static public func create(mailAdress: String) -> UIViewController? {
        guard MFMailComposeViewController.canSendMail() else {
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Please add an email account in the settings app", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: .default, handler: nil))
            return alert
        }

        let name = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? ""
        let version = Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String ?? ""

        let supportMailController = SupportMailController()
        supportMailController.setSubject("\(name) (Build \(version))")
        supportMailController.setMessageBody(messageBody, isHTML: false)
        supportMailController.setToRecipients([mailAdress])
        supportMailController.mailComposeDelegate = supportMailController

        return supportMailController
    }


    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}

