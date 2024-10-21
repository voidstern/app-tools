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

    public func bool(for key: Setting, defaultValue: Bool = false) -> Bool {
        guard let value = settingsStorage.bool(forKey: key.identifier) else {
            return key.defaultValue as? Bool ?? key.defaultValue as? Bool ?? defaultValue
        }
		return value
    }

    public func set(value: Bool, for key: Setting) {
        guard settingsStorage.bool(forKey: key.identifier) != value else {
            return
        }
        
        settingsStorage.set(value, forKey: key.identifier)
        
        DispatchQueue.onMainQueue {
            self.objectWillChange.send()
            NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self, userInfo: ["key": key])
        }
    }

    @discardableResult
    public func toggle(_ key: Setting) -> Bool {
        let value: Bool = self.bool(for: key)
        settingsStorage.set(!value, forKey: key.identifier)
        
        DispatchQueue.onMainQueue {
            self.objectWillChange.send()
            NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self, userInfo: ["key": key])
        }
        
        return (!value)
    }
    
    // MARK: Double
    
    public func double(for key: Setting, defaultValue: Double = 0.0) -> Double {
        guard let value = settingsStorage.double(forKey: key.identifier) else {
            return key.defaultValue as? Double ?? key.defaultValue as? Double ?? defaultValue
        }

        return value
    }

    public func set(value: Double, for key: Setting) {
        guard settingsStorage.double(forKey: key.identifier) != value else {
            return
        }
        
        settingsStorage.set(value, forKey: key.identifier)
        
        DispatchQueue.onMainQueue {
            self.objectWillChange.send()
            NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self, userInfo: ["key": key])
        }
    }
    
    @discardableResult
    public func increment(_ key: Setting) -> Double {
        if let value = settingsStorage.double(forKey: key.identifier) {
            settingsStorage.set((value + 1), forKey: key.identifier)
            
            DispatchQueue.onMainQueue {
                self.objectWillChange.send()
                NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self, userInfo: ["key": key])
            }
            
            return (value + 1)
        }

        return 0.0
    }
    
    // MARK: Integer
    
    public func integer(for key: Setting, defaultValue: Int = 0) -> Int {
        guard let value = settingsStorage.integer(forKey: key.identifier) else {
            return key.defaultValue as? Int ?? key.defaultValue as? Int ?? defaultValue
        }
        
        return value
    }

    public func set(value: Int, for key: Setting) {
        guard settingsStorage.integer(forKey: key.identifier) != value else {
            return
        }
        
        settingsStorage.set(value, forKey: key.identifier)
        
        DispatchQueue.onMainQueue {
            self.objectWillChange.send()
            NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self, userInfo: ["key": key])
        }
    }
    
    @discardableResult
    public func increment(_ key: Setting) -> Int {
        let value = settingsStorage.integer(forKey: key.identifier) ?? 0
        settingsStorage.set((value + 1), forKey: key.identifier)
        
        DispatchQueue.onMainQueue {
            self.objectWillChange.send()
            NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self, userInfo: ["key": key])
        }
        
        return (value + 1)
    }
    
    // MARK: String
    
    public func string(for key: Setting, defaultValue: String = "") -> String {
        guard let value = settingsStorage.string(forKey: key.identifier) else {
            return key.defaultValue as? String ?? key.defaultValue as? String ?? defaultValue
        }
        return value
    }
    
    public func set(value: String, for key: Setting) {
        guard settingsStorage.string(forKey: key.identifier) != value else {
            return
        }
        
        settingsStorage.set(value, forKey: key.identifier)
        
        DispatchQueue.onMainQueue {
            self.objectWillChange.send()
            NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self, userInfo: ["key": key])
        }
    }
    
    // MARK: Strings Array
    
    public func strings(for key: Setting, defaultValue: [String] = []) -> [String] {
        let value = settingsStorage.strings(forKey: key.identifier)
        return value ?? key.defaultValue as? [String] ?? defaultValue
    }
    
    public func set(strings: [String], for key: Setting) {
        guard settingsStorage.strings(forKey: key.identifier) != strings else {
            return
        }
        
        settingsStorage.set(strings, forKey: key.identifier)
        
        DispatchQueue.onMainQueue {
            self.objectWillChange.send()
            NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self, userInfo: ["key": key])
        }
    }
    
    // MARK: Integer Array
    
    public func integers(for key: Setting, defaultValue: [Int] = []) -> [Int] {
        let value = settingsStorage.integers(forKey: key.identifier)
        return value ?? key.defaultValue as? [Int] ?? defaultValue
    }
    
    public func set(integers: [Int], for key: Setting) {
        guard settingsStorage.integers(forKey: key.identifier) != integers else {
            return
        }
        
        settingsStorage.set(integers, forKey: key.identifier)
        
        DispatchQueue.onMainQueue {
            self.objectWillChange.send()
            NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self, userInfo: ["key": key])
        }
    }
    
    // MARK: Any Codable
    
    public func codable<T: Codable>(for key: Setting, of type: T.Type, defaultValue: T? = nil) -> T? {
        guard let data = settingsStorage.data(forKey: key.identifier) else {
            return key.defaultValue as? T ?? defaultValue
        }
        
        guard let decoded = try? JSONDecoder().decode(type, from: data) else {
            return key.defaultValue as? T ?? defaultValue
        }
        
        return decoded ?? key.defaultValue as? T ?? defaultValue
    }
    
    public func set(codable: Codable, for key: Setting) {
        guard let data = try? JSONEncoder().encode(codable) else {
            return
        }
        
        guard settingsStorage.data(forKey: key.identifier) != data else {
            return
        }
        
        settingsStorage.set(data, forKey: key.identifier)
        
        DispatchQueue.onMainQueue {
            self.objectWillChange.send()
            NotificationCenter.default.post(name: UserSettings.userSettingsChangedNotificationName, object: self, userInfo: ["key": key])
        }
    }
}
