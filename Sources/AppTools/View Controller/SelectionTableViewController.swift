//
//  SelectionTableViewController.swift
//  AppToolsMobile
//
//  Created by Lukas on 13.03.20.
//  Copyright © 2020 Lukas. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
public protocol SelectionTableViewControllerDelegate: AnyObject {
    func itemsForSelectionTableViewController(_ controller: SelectionTableViewController) -> [String]
    func selectionTableViewController(_ controller: SelectionTableViewController, didSelect index: Int)
    func selectedItemInSelectionTableViewController(_ controller: SelectionTableViewController) -> Int?
    func headerTitleForSelectionTableViewController(_ controller: SelectionTableViewController) -> String?
}

@available(iOS 13.0, *)
open class SelectionTableViewController: UITableViewController {
    public weak var delegate: SelectionTableViewControllerDelegate?
    
    private var selectionItems: [String] = []
    private let identifier = "UITableViewCell"
    
    public init() {
        super.init(style: .insetGrouped)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        reloadData()
    }
    
    open func reloadData() {
        title = delegate?.headerTitleForSelectionTableViewController(self)
        selectionItems = delegate?.itemsForSelectionTableViewController(self) ?? []
        tableView.reloadData()
    }
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectionItems.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = selectionItems.objectOrNil(at: indexPath.row)
        
        if indexPath.row == delegate?.selectedItemInSelectionTableViewController(self) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return delegate?.headerTitleForSelectionTableViewController(self)
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectionTableViewController(self, didSelect: indexPath.row)
    }
}
