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
    
    static public let shared = UserSettings()
    private var settingsStorage = SettingsStorage()
    
    public func update(appGroupIdentifier: String?, migrateIfNeeded: Bool = false) {
        if migrateIfNeeded {
            try? settingsStorage.migrate(appGroupIdentifier: appGroupIdentifier)
        }
        
        settingsStorage.update(appGroupIdentifier: appGroupIdentifier)
    }
    
    // MARK: Boolean

    public func bool(key: Setting, defaultValue: Bool = false) -> Bool {
        guard let value = settingsStorage.bool(forKey: key.identifier) else {
            return key.defaultValue as? Bool ?? key.defaultValue as? Bool ?? defaultValue
        }
		return value
    }

    public func set(value: Bool, key: Setting) {
        guard settingsStorage.bool(forKey: key.identifier) != value else {
            return
        }
        
        settingsStorage.set(value, forKey: key.identifier)
        
        DispatchQueue.onMainQueue {
            self.objectWillChange.send()
            NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self)
        }
    }

    @discardableResult
    public func toggle(_ key: Setting) -> Bool {
        if let value = settingsStorage.bool(forKey: key.identifier) {
            settingsStorage.set(!value, forKey: key.identifier)
            
            DispatchQueue.onMainQueue {
                self.objectWillChange.send()
                NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self)
            }
            
            return (!value)
        } else {
            settingsStorage.set(true, forKey: key.identifier)
            
            DispatchQueue.onMainQueue {
                self.objectWillChange.send()
                NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self)
            }
            
            return true
        }
    }
    
    // MARK: Double
    
    public func double(key: Setting, defaultValue: Double = 0.0) -> Double {
        guard let value = settingsStorage.double(forKey: key.identifier) else {
            return key.defaultValue as? Double ?? key.defaultValue as? Double ?? defaultValue
        }

        return value
    }

    public func set(value: Double, key: Setting) {
        guard settingsStorage.double(forKey: key.identifier) != value else {
            return
        }
        
        settingsStorage.set(value, forKey: key.identifier)
        
        DispatchQueue.onMainQueue {
            self.objectWillChange.send()
            NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self)
        }
    }
    
    @discardableResult
    public func increment(_ key: Setting) -> Double {
        if let value = settingsStorage.double(forKey: key.identifier) {
            settingsStorage.set((value + 1), forKey: key.identifier)
            
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
        guard let value = settingsStorage.integer(forKey: key.identifier) else {
            return key.defaultValue as? Int ?? key.defaultValue as? Int ?? defaultValue
        }
        
        return value
    }

    public func set(value: Int, key: Setting) {
        guard settingsStorage.integer(forKey: key.identifier) != value else {
            return
        }
        
        settingsStorage.set(value, forKey: key.identifier)
        
        DispatchQueue.onMainQueue {
            self.objectWillChange.send()
            NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self)
        }
    }
    
    @discardableResult
    public func increment(_ key: Setting) -> Int {
        let value = settingsStorage.integer(forKey: key.identifier) ?? 0
        settingsStorage.set((value + 1), forKey: key.identifier)
        
        DispatchQueue.onMainQueue {
            self.objectWillChange.send()
            NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self)
        }
        
        return (value + 1)
    }
    
    // MARK: String
    
    public func string(key: Setting, defaultValue: String = "") -> String {
        guard let value = settingsStorage.string(forKey: key.identifier) else {
            return key.defaultValue as? String ?? key.defaultValue as? String ?? defaultValue
        }
        return value
    }
    
    public func set(value: String, key: Setting) {
        guard settingsStorage.string(forKey: key.identifier) != value else {
            return
        }
        
        settingsStorage.set(value, forKey: key.identifier)
        
        DispatchQueue.onMainQueue {
            self.objectWillChange.send()
            NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self)
        }
    }
    
    public func strings(key: Setting, defaultValue: [String] = []) -> [String] {
        guard let value = settingsStorage.strings(forKey: key.identifier) else {
            return []
        }
        
        return value ?? key.defaultValue as? [String] ?? defaultValue
    }
    
    public func set(strings: [String], key: Setting) {
        guard settingsStorage.strings(forKey: key.identifier) != strings else {
            return
        }
        
        settingsStorage.set(strings, forKey: key.identifier)
        
        DispatchQueue.onMainQueue {
            self.objectWillChange.send()
            NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self)
        }
    }
}
