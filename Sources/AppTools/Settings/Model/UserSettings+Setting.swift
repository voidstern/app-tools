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
        public let options: [Option]?
        
        public let defaultValue: Any?
        public let minValue: Int?
        public let maxValue: Int?
        public let stepValue: Int?
        public let labels: [Int: String]
        
        public init(identifier: String, defaultValue: Any? = nil, minValue: Int? = nil, maxValue: Int? = nil, stepValue: Int? = nil, options: [Option]? = nil, labels: [Int: String] = [:]) {
            self.identifier = identifier
            self.options = options
            
            self.defaultValue = defaultValue
            self.stepValue = stepValue
            self.minValue = minValue
            self.maxValue = maxValue
            self.labels = labels
        }

        public static func == (lhs: Setting, rhs: Setting) -> Bool {
            return lhs.identifier == rhs.identifier
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        
        public struct Option: Hashable, Identifiable {
            public let title: String
            public let value: Int
            
            public init(_ title: String, value: Int) {
                self.title = title
                self.value = value
            }
            
            public var id: Int {
                self.value
            }

            public func hash(into hasher: inout Hasher) {
                hasher.combine(value)
            }
        }
    }
}
