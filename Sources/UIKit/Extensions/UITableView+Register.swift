//
//  UITableView+Register.swift
//  iTranslateAccountsUI
//
//  Created by Martin Gratzer on 04/07/2017.
//  Copyright © 2017 iTranslate. All rights reserved.
//

import UIKit

public protocol Cell: AnyObject {
    static var identifier: String { get }
    static var xibName: String { get }
    static var bundle: Bundle { get }
}

public extension UITableView {
    func register<T: Cell> (type: T.Type) {
        register(UINib(nibName: T.xibName, bundle: T.bundle), forCellReuseIdentifier: T.identifier)
    }

    func dequeueReusableCell<T: Cell> (for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T
    }
}
