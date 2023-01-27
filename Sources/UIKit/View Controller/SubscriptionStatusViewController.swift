//
//  VSCSubscriptionStatusViewController.swift
//  Dozzzer
//
//  Created by Lukas Burgstaller on 07.08.22.
//  Copyright © 2022 Lukas Burgstaller. All rights reserved.
//

import Foundation
import SafariServices
import StoreKit
import UIKit

@available(iOS 14.0, *)
public class SubscriptionStatusViewController: UIViewController {
    
    public struct SubscriptionStatus {
        let title: String
        let endDate: Date?
        let type: SubscriptionType
        
        public init(title: String, endDate: Date?, type: SubscriptionType) {
            self.title = title
            self.endDate = endDate
            self.type = type
        }
    }
    
    public struct Configuration {
        let foregroundColor: UIColor
        let backgroundColor: UIColor
        let backgroundAccentColor: UIColor
        let titleColor: UIColor
        let tintColor: UIColor
        
        public init(foregroundColor: UIColor = .label, backgroundColor: UIColor = .systemBackground, backgroundAccentColor: UIColor = .secondarySystemBackground, tintColor: UIColor = .systemBlue, titleColor: UIColor? = nil) {
            self.foregroundColor = foregroundColor
            self.backgroundColor = backgroundColor
            self.backgroundAccentColor = backgroundAccentColor
            self.titleColor = titleColor ?? foregroundColor
            self.tintColor = tintColor
        }
    }
    
    public struct AdditionalEntry {
        let title: String
        let action: (() -> ())
        
        public init(title: String, action: @escaping () -> Void) {
            self.title = title
            self.action = action
        }
    }
    
    public enum SubscriptionType {
        case monthly, bimonthly, quarterly, yearly
        case testflight, legacy, free, other
        
        var string: String {
            switch self {
            case .monthly: return "Monthly"
            case .bimonthly: return "Bi-Monthly"
            case .quarterly: return "Quarterly"
            case .yearly: return "Yearly"
            case .testflight: return "TestFlight"
            case .legacy: return "Permanent"
            case .free: return "No Subscription"
            case .other: return "Other"
            }
        }
    }
    
    private enum TableContent {
        case subscriptionType(title: String, type: SubscriptionType)
        case subscriptionEndDate(date: Date?)
        case additionalEntry(entry: AdditionalEntry)
        case manageSubscription
        case termsOfUse
        case privacy
    }
    
    @IBOutlet var footerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var termsTextView: UILabel!
    @IBOutlet weak var termsTitle: UILabel!
    
    public var additionalEntries: [AdditionalEntry]? {
        didSet { updateTableContent() }
    }
    
    public var configuration: Configuration? {
        didSet { updateTableContent() }
    }
    
    public var status: SubscriptionStatus? {
        didSet { updateTableContent() }
    }
    
    private var tableContent: [[TableContent]] = []
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil ?? .module)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTableContent()
        tableView.tableFooterView = footerView
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .done, primaryAction: UIAction(handler: { action in
            self.dismiss(animated: true)
        }))
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateTableContent()
    }
    
    private func updateTableContent() {
        guard let status = status else {
            return
        }
        
        var content: [[TableContent]] = []
        content.append([.subscriptionType(title: status.title, type: status.type), .subscriptionEndDate(date: status.endDate)])
        
        if let additionalEntries = additionalEntries {
            content.append(additionalEntries.map({ TableContent.additionalEntry(entry: $0) }))
        }
        
        content.append([.manageSubscription, .termsOfUse, .privacy])
        
        self.tableContent = content
        self.title = status.title
        
        if self.isViewLoaded {
            tableView.reloadData()
        }
        
        if let configuration = configuration {
            view.tintColor = configuration.tintColor
            navigationItem.titleView?.tintColor = configuration.tintColor
            tableView.backgroundColor = configuration.backgroundAccentColor
            termsTextView.textColor = configuration.foregroundColor
            termsTitle.textColor = configuration.foregroundColor
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: configuration.titleColor]
        }
    }
}

@available(iOS 14.0, *)
extension SubscriptionStatusViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return tableContent.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableContent.objectOrNil(at: section)?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let content = tableContent.objectOrNil(at: indexPath.section)?.objectOrNil(at: indexPath.row) else {
            return UITableViewCell()
        }
        
        switch content {
        case .subscriptionType(let title, let status):
            let tableCell = UITableViewCell(style: .value1, reuseIdentifier: "subscriptionType")
            tableCell.textLabel?.text = title
            tableCell.detailTextLabel?.text = status.string
            tableCell.backgroundColor = configuration?.backgroundColor
            tableCell.textLabel?.textColor = configuration?.foregroundColor
            tableCell.detailTextLabel?.textColor = configuration?.foregroundColor
            tableCell.selectionStyle = .none
            return tableCell
            
        case .subscriptionEndDate(let date):
            let tableCell = UITableViewCell(style: .value1, reuseIdentifier: "subscriptionEndDate")
            tableCell.textLabel?.text = "End Date"
            tableCell.detailTextLabel?.text = date?.shortDateString ?? "Unknown"
            tableCell.selectionStyle = .none
            tableCell.backgroundColor = configuration?.backgroundColor
            tableCell.textLabel?.textColor = configuration?.foregroundColor
            tableCell.detailTextLabel?.textColor = configuration?.foregroundColor
            return tableCell
            
        case .additionalEntry(let entry):
            let tableCell = UITableViewCell(style: .default, reuseIdentifier: "additionalEntry")
            tableCell.textLabel?.text = entry.title
            tableCell.backgroundColor = configuration?.backgroundColor
            tableCell.textLabel?.textColor = configuration?.foregroundColor
            return tableCell
            
        case .manageSubscription:
            let tableCell = UITableViewCell(style: .default, reuseIdentifier: "manageSubscription")
            tableCell.textLabel?.text = "Manage Subscription"
            tableCell.backgroundColor = configuration?.backgroundColor
            tableCell.textLabel?.textColor = configuration?.foregroundColor
            return tableCell
            
        case .termsOfUse:
            let tableCell = UITableViewCell(style: .default, reuseIdentifier: "termsOfUse")
            tableCell.textLabel?.text = "Terms of Use"
            tableCell.backgroundColor = configuration?.backgroundColor
            tableCell.textLabel?.textColor = configuration?.foregroundColor
            return tableCell
            
        case .privacy:
            let tableCell = UITableViewCell(style: .default, reuseIdentifier: "privacy")
            tableCell.textLabel?.text = "Privacy"
            tableCell.backgroundColor = configuration?.backgroundColor
            tableCell.textLabel?.textColor = configuration?.foregroundColor
            return tableCell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let content = tableContent.objectOrNil(at: indexPath.section)?.objectOrNil(at: indexPath.row) else {
            return
        }
        
        switch content {
        case .additionalEntry(let entry):
            entry.action()
            
        case .manageSubscription:
            if let scene = view.window?.windowScene, #available(iOS 15.0, *) {
                Task.init {
                    try await AppStore.showManageSubscriptions(in: scene)
                }
            } else if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
                UIApplication.shared.open(url)
            }
            
        case .termsOfUse:
            let safariView = SFSafariViewController(url: URL(string: "http://blog.cocoacake.net/terms-of-use")!)
            present(safariView, animated: true)
            
        case .privacy:
            let safariView = SFSafariViewController(url: URL(string: "http://blog.cocoacake.net/privacy-policy")!)
            present(safariView, animated: true)
            
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}




