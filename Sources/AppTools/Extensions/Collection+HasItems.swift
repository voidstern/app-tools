//
//  Collection+NotEmpty.swift
//  Dozzzer
//
//  Created by Lukas Burgstaller on 05.08.22.
//  Copyright © 2022 Lukas Burgstaller. All rights reserved.
//

import Foundation

extension Collection {
    var hasItems: Bool {
        return !isEmpty
    }
}
