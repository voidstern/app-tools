//
//  File.swift
//  
//
//  Created by Lukas Burgstaller on 23.08.22.
//

import Foundation

//extension URL: ExpressibleByStringLiteral {
//    public init(stringLiteral value: String) {
//        self = URL(string: value) ?? URL(string: "http://google.com")
//    }
//}

extension URL {
    public func appendingQueryItems(_ queryItems: [URLQueryItem]) -> URL {
        if #available(iOS 16.0, watchOS 9.0, *) {
            return appending(queryItems: queryItems)
        } else {
            var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
            components?.queryItems = queryItems
            return components?.url ?? self
        }
    }
}
