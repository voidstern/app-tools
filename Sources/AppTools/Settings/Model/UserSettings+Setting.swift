//
//  File.swift
//  
//
//  Created by Lukas Burgstaller on 30.03.24.
//

import Foundation

extension UserSettings {
    open class Setting: Equatable, Hashable {
        public let identifier: String
        public let defaultValue: Any?
        public let options: [Option]?
        
        public init(identifier: String, defaultValue: Any? = nil, options: [Option]? = nil) {
            self.identifier = identifier
            self.defaultValue = defaultValue
            self.options = options
        }

        public static func == (lhs: Setting, rhs: Setting) -> Bool {
            return lhs.identifier == rhs.identifier
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        
        public struct Option {
            let title: String
            let value: Int
            
            public init(_ title: String, value: Int) {
                self.title = title
                self.value = value
            }
        }
    }
}
