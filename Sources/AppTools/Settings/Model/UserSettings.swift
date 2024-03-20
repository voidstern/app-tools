//
//  UserSettings.swift
//  Multi Timers 2
//
//  Created by Lukas Burgstaller on 26/10/2016.
//  Copyright © 2016 Lukas Burgstaller. All rights reserved.
//

import Foundation

public class UserSettings: ObservableObject {

    public static let userSettingsChangedNotificationName = NSNotification.Name(rawValue: "net.voidstern.usersettings.changed")

    open class Setting: Equatable, Hashable {
        public let identifier: String
        public let defaultValue: Any?
        
        public init(identifier: String, defaultValue: Any? = nil) {
            self.identifier = identifier
            self.defaultValue = defaultValue
        }

        public static func == (lhs: Setting, rhs: Setting) -> Bool {
            return lhs.identifier == rhs.identifier
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }
    
    // MARK: Boolean

    static public let shared = UserSettings()
    private var userDefaults = SettingsStorage.shared

    public func bool(key: Setting, defaultValue: Bool = false) -> Bool {
        guard let value = userDefaults.bool(forKey: key.identifier) else {
            return key.defaultValue as? Bool ?? key.defaultValue as? Bool ?? defaultValue
        }
		return value
    }

    public func set(value: Bool, key: Setting) {
        userDefaults.set(value, forKey: key.identifier)
        
        DispatchQueue.onMainQueue {
            self.objectWillChange.send()
            NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self)
        }
    }

    @discardableResult
    public func toggle(_ key: Setting) -> Bool {
        if let value = userDefaults.bool(forKey: key.identifier) {
            userDefaults.set(!value, forKey: key.identifier)
            
            DispatchQueue.onMainQueue {
                self.objectWillChange.send()
                NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self)
            }
            
            return (!value)
        } else {
            userDefaults.set(true, forKey: key.identifier)
            
            DispatchQueue.onMainQueue {
                self.objectWillChange.send()
                NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self)
            }
            
            return true
        }
    }
    
    // MARK: Double
    
    public func double(key: Setting, defaultValue: Double = 0.0) -> Double {
        guard let value = userDefaults.double(forKey: key.identifier) else {
            return key.defaultValue as? Double ?? key.defaultValue as? Double ?? defaultValue
        }

        return value
    }

    public func set(value: Double, key: Setting) {
        userDefaults.set(value, forKey: key.identifier)
        
        DispatchQueue.onMainQueue {
            self.objectWillChange.send()
            NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self)
        }
    }
    
    @discardableResult
    public func increment(_ key: Setting) -> Double {
        if let value = userDefaults.double(forKey: key.identifier) {
            userDefaults.set((value + 1), forKey: key.identifier)
            
            DispatchQueue.onMainQueue {
                self.objectWillChange.send()
                NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self)
            }
            
            return (value + 1)
        }

        return 0.0
    }
    
    // MARK: Integer
    
    public func integer(key: Setting, defaultValue: Int = 0) -> Int {
        guard let value = userDefaults.integer(forKey: key.identifier) else {
            return key.defaultValue as? Int ?? key.defaultValue as? Int ?? defaultValue
        }
        
        return value
    }

    public func set(value: Int, key: Setting) {
        userDefaults.set(value, forKey: key.identifier)
        
        DispatchQueue.onMainQueue {
            self.objectWillChange.send()
            NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self)
        }
    }
    
    @discardableResult
    public func increment(_ key: Setting) -> Int {
        let value = userDefaults.integer(forKey: key.identifier) ?? 0
        userDefaults.set((value + 1), forKey: key.identifier)
        
        DispatchQueue.onMainQueue {
            self.objectWillChange.send()
            NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self)
        }
        
        return (value + 1)
    }
    
    // MARK: String
    
    public func string(key: Setting, defaultValue: String = "") -> String {
        guard let value = userDefaults.string(forKey: key.identifier) else {
            return key.defaultValue as? String ?? key.defaultValue as? String ?? defaultValue
        }
        return value
    }
    
    public func set(value: String, key: Setting) {
        userDefaults.set(value, forKey: key.identifier)
        
        DispatchQueue.onMainQueue {
            self.objectWillChange.send()
            NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self)
        }
    }
    
    public func strings(key: Setting, defaultValue: [String] = []) -> [String] {
        guard let value = userDefaults.strings(forKey: key.identifier) else {
            return []
        }
        
        return value ?? key.defaultValue as? [String] ?? defaultValue
    }
    
    public func set(strings: [String], key: Setting) {
        userDefaults.set(strings, forKey: key.identifier)
        
        DispatchQueue.onMainQueue {
            self.objectWillChange.send()
            NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self)
        }
    }
}
