//
//  SupportMailController.swift
//  VSCAppTools
//
//  Created by Lukas on 14/05/2017.
//  Copyright © 2017 Lukas. All rights reserved.
//

import Foundation
import MessageUI
import AppTools

public final class SupportMailController: MFMailComposeViewController, MFMailComposeViewControllerDelegate {
    static let supportMailContent = SupportMailContent()

    public static func create(mailAdress: String, rcid: String?) -> UIViewController {
        guard MFMailComposeViewController.canSendMail() else {
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Please add an email account in the settings app", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: .default, handler: nil))
            return alert
        }

        let supportMailController = SupportMailController()
        supportMailController.setSubject(supportMailContent.subject())
        supportMailController.setMessageBody(supportMailContent.messageBody(rcid: rcid), isHTML: false)
        supportMailController.setToRecipients([mailAdress])
        supportMailController.mailComposeDelegate = supportMailController

        return supportMailController
    }

    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}
