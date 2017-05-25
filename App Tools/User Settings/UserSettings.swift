//
//  UserSettings.swift
//  Multi Timers 2
//
//  Created by Lukas Burgstaller on 26/10/2016.
//  Copyright © 2016 Lukas Burgstaller. All rights reserved.
//

import Foundation

public class UserSettings {

    open class Setting: Equatable {
        public let identifier: String
        public init(identifier: String) {
            self.identifier = identifier
        }

        public static func == (lhs: Setting, rhs: Setting) -> Bool {
            return lhs.identifier == rhs.identifier
        }
    }

    static public let shared = UserSettings()
	private var userDefaults = SettingsStorage.shared

    public func bool(key: Setting) -> Bool {
        if let value = userDefaults.bool(forKey: key.identifier) {
            return value
        }
		return false
    }

    public func set(value: Bool, key: Setting) {
        userDefaults.set(value, forKey: key.identifier)
    }

    public func toggle(_ key: Setting) {
        if let value = userDefaults.bool(forKey: key.identifier) {
            userDefaults.set(!value, forKey: key.identifier)
        } else {
            userDefaults.set(true, forKey: key.identifier)
        }
    }

    public func integer(key: Setting) -> Int {
        guard let value = userDefaults.integer(forKey: key.identifier) else {
            return 0
        }
        
        return value
    }

    public func set(value: Int, key: Setting) {
        userDefaults.set(value, forKey: key.identifier)
    }
    
    public func string(key: Setting) -> String {
        if let value = userDefaults.string(forKey: key.identifier) {
            return value
        }
        return ""
    }
    
    public func set(value: String, key: Setting) {
        userDefaults.set(value, forKey: key.identifier)
    }
    
    public func strings(key: Setting) -> [String]? {
        guard let value = userDefaults.strings(forKey: key.identifier) else {
            return []
        }
        
        return value
    }
    
    public func set(strings: [String], key: Setting) {
        userDefaults.set(strings, forKey: key.identifier)
    }
}
