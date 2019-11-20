//
//  URL+FilePath.swift
//  AppToolsMobile
//
//  Created by Lukas on 20.11.19.
//  Copyright © 2019 Lukas. All rights reserved.
//

import Foundation

public extension URL {
    var filePath: String? {
        guard isFileURL else {
            return nil
        }
        
        return path
    }
}
