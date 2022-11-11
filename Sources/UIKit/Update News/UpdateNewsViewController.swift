//
//  WhatsNewViewController.swift
//  Dozzzer
//
//  Created by Lukas Burgstaller on 10.11.22.
//  Copyright © 2022 Lukas Burgstaller. All rights reserved.
//

import Foundation
import UIKit

protocol UpdateNewsViewControllerDelegate: AnyObject {
    func whatsNewViewDidPressPrimaryButton(_ whatsNewView: UpdateNewsViewController)
    func whatsNewViewDidPressSecondaryButton(_ whatsNewView: UpdateNewsViewController)
}

class UpdateNewsViewController: UIViewController {
    weak var delegate: UpdateNewsViewControllerDelegate?
    
    var elements: [ListItem] = []
    var colors: Colors = .init(foreground: .label, background: .systemBackground, tint: .systemBlue)
    var configuration: Configuration = .init(viewTitle: "What's new in this app", primaryButtonTitle: "Continue", secondaryButtonTitle: nil)
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var secondaryButton: UIButton!
    
    override func viewDidLoad() {
        tableView.register(type: UpdateNewsTableCell.self)
        
        titleLabel.text = configuration.viewTitle
        titleLabel.textColor = colors.foreground
        
        primaryButton.setTitle(configuration.primaryButtonTitle, for: .normal)
        
        primaryButton.backgroundColor = colors.tint
        primaryButton.setTitleColor(colors.background, for: .normal)
        primaryButton.layer.cornerRadius = 12
        
        secondaryButton.tintColor = colors.tint
        secondaryButton.setTitleColor(colors.foreground, for: .normal)
        
        view.backgroundColor = colors.background
        tableView.backgroundColor = colors.background
        
        if let secondaryButtonTitle = configuration.secondaryButtonTitle {
            secondaryButton.setTitle(secondaryButtonTitle, for: .normal)
        } else {
            secondaryButton.isHidden = true
            secondaryButton.setTitle(nil, for: .normal)
        }
        
        tableView.allowsSelection = false
    }
    
    @IBAction func primaryButtonHit(_ sender: Any) {
        delegate?.whatsNewViewDidPressPrimaryButton(self)
    }
    
    @IBAction func secondaryButtonHit(_ sender: Any) {
        delegate?.whatsNewViewDidPressSecondaryButton(self)
    }
}

extension UpdateNewsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: UpdateNewsTableCell.identifier, for: indexPath) as? UpdateNewsTableCell else {
            return UITableViewCell()
        }
        
        guard let entry = elements.objectOrNil(at: indexPath.row) else {
            return UITableViewCell()
        }
        
        tableViewCell.contentView.backgroundColor = colors.background
        tableViewCell.entryTitleLabel.textColor = colors.foreground
        tableViewCell.entrySubtitleLabel.textColor = colors.foreground
        tableViewCell.selectionStyle = .none
        tableViewCell.entryIcon.tintColor = colors.tint
        
        tableViewCell.entryIcon.image = entry.icon?.withRenderingMode(.alwaysTemplate)
        tableViewCell.entryTitleLabel.text = entry.title
        tableViewCell.entrySubtitleLabel.text = entry.description
        
        return tableViewCell
    }
}

extension UpdateNewsViewController {
    struct ListItem {
        let icon: UIImage?
        let title: String
        let description: String
    }

    struct Colors {
        let foreground: UIColor
        let background: UIColor
        let tint: UIColor
    }

    struct Configuration {
        let viewTitle: String
        let primaryButtonTitle: String
        let secondaryButtonTitle: String?
    }
}
