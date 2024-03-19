//
//  URL+QueryDictionary.swift
//  VSCAppTools
//
//  Created by Lukas on 15/05/2017.
//  Copyright © 2017 Lukas. All rights reserved.
//

import Foundation

public extension URL {
     var queryDictionary: [String: [String]]? {
        guard let query = self.query else {
            return nil
        }

        var dictionary = [String: [String]]()

        for keyValueString in query.components(separatedBy: "&") {
            let parts = keyValueString.components(separatedBy: "=")
            if parts.count < 2 {
                continue;
            }

            let key = parts[0].removingPercentEncoding!
            let value = parts[1].removingPercentEncoding!

            var values = dictionary[key] ?? [String]()

            values.append(value)
            dictionary[key] = values
        }
        
        return dictionary
    }
}
