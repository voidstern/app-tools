//
//  UserSettings.swift
//  Multi Timers 2
//
//  Created by Lukas Burgstaller on 26/10/2016.
//  Copyright © 2016 Lukas Burgstaller. All rights reserved.
//

import Foundation

public class UserSettings {

    public static let userSettingsChangedNotificationName = NSNotification.Name(rawValue: "net.voidstern.usersettings.changed")

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
        NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self)
    }

    @discardableResult
    public func toggle(_ key: Setting) -> Bool {
        if let value = userDefaults.bool(forKey: key.identifier) {
            userDefaults.set(!value, forKey: key.identifier)
            NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self)
            return (!value)
        } else {
            userDefaults.set(true, forKey: key.identifier)
            NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self)
            return true
        }
    }

    @discardableResult
    public func increment(_ key: Setting) -> Double {
        if let value = userDefaults.double(forKey: key.identifier) {
            userDefaults.set((value + 1), forKey: key.identifier)
            NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self)
            return (value + 1)
        }

        return 0.0
    }

    @discardableResult
    public func increment(_ key: Setting) -> Int {
        let value = userDefaults.integer(forKey: key.identifier) ?? 0
        userDefaults.set((value + 1), forKey: key.identifier)
        NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self)
        return (value + 1)
    }

    public func integer(key: Setting) -> Int {
        guard let value = userDefaults.integer(forKey: key.identifier) else {
            return 0
        }
        
        return value
    }

    public func set(value: Int, key: Setting) {
        userDefaults.set(value, forKey: key.identifier)
        NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self)
    }

    public func double(key: Setting) -> Double {
        guard let value = userDefaults.double(forKey: key.identifier) else {
            return 0.0
        }

        return value
    }

    public func set(value: Double, key: Setting) {
        userDefaults.set(value, forKey: key.identifier)
        NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self)
    }
    
    public func string(key: Setting) -> String {
        if let value = userDefaults.string(forKey: key.identifier) {
            return value
        }
        return ""
    }
    
    public func set(value: String, key: Setting) {
        userDefaults.set(value, forKey: key.identifier)
        NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self)
    }
    
    public func strings(key: Setting) -> [String]? {
        guard let value = userDefaults.strings(forKey: key.identifier) else {
            return []
        }
        
        return value
    }
    
    public func set(strings: [String], key: Setting) {
        userDefaults.set(strings, forKey: key.identifier)
        NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self)
    }
}