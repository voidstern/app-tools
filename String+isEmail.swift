//
//  String+isEmail.swift
//  AppTools
//
//  Created by Lukas on 22/08/2017.
//  Copyright © 2017 Lukas. All rights reserved.
//

import Foundation

extension String {
    public var isEmail: Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
}
