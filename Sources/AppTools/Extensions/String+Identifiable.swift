//
//  String+Identifiable.swift
//  Tidur Timers
//
//  Created by Lukas Burgstaller on 23.10.23.
//  Copyright © 2023 Lukas Burgstaller. All rights reserved.
//

import Foundation

extension String: Identifiable {
    public var id: String {
        return self
    }
}
