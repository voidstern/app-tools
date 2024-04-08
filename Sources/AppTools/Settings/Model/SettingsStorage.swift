//
//  SettingsStorage.swift
//  Multi Timers 2
//
//  Created by Lukas Burgstaller on 02/05/16.
//  Copyright © 2016 Lukas Burgstaller. All rights reserved.
//

import Foundation

public class SettingsStorage: ObservableObject {
    @Published private var settings: [String: Any]?
    
    private let savingQueue = DispatchQueue(label: "net.voidstern.app-tools.settings-storage")
    private let accessQueue = DispatchQueue(label: "net.voidstern.app-tools.access")

    private lazy var saveFileURL: URL = getSaveFileURL()
    private var appGroupIdentifier: String?
    
    public func update(appGroupIdentifier: String?) {
        if self.appGroupIdentifier != appGroupIdentifier {
            self.appGroupIdentifier = appGroupIdentifier
            saveFileURL = getSaveFileURL()
            loadFromDisk()
        }
    }
    
    public func migrate(appGroupIdentifier: String?) throws {
        if self.appGroupIdentifier != appGroupIdentifier {
            let saveFileURL = self.getSaveFileURL()
            let newSaveFileURL = self.getSaveFileURL(appGroupIdentifier: appGroupIdentifier)
            
            if !FileManager.default.fileExists(atPath: newSaveFileURL.path()) {
                try FileManager.default.copyItem(at: saveFileURL, to: newSaveFileURL)
            }
        }
    }

    private func getSaveFileURL(appGroupIdentifier: String? = nil) -> URL {
        guard let appGroupIdentifier = appGroupIdentifier ?? self.appGroupIdentifier, let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier) else {
            print("WARN: appGroupIdentifier not set on SettingsStorage")
            return URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/settings.json")
        }

        return containerURL.appendingPathComponent("settings.json")
    }
    
    private func saveToDisk() {
        let settingsCount = accessQueue.sync {
            return settings?.count ?? 0
        }
        
        guard settingsCount > 0 else {
            return
        }
        
        let jsonData = accessQueue.sync {
            guard let settings = self.settings else {
                return Optional<Data>.none
            }
            
            return try? JSONSerialization
                .data(withJSONObject: settings, options: [.fragmentsAllowed])
        }
        
        guard let jsonData else {
            return
        }
        
        savingQueue.async {
            try? jsonData.write(to: self.saveFileURL, options: [])
        }
    }
    
    private func loadFromDisk() {
        guard let data = try? Data(contentsOf: saveFileURL) else {
            return
        }

        if let settingsDict = try? JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed]) as? [String : Any] ?? [:] {
            settings = settingsDict
        }
    }
    
    private func loadFromDiskIfNeeded() {
        if settings == nil {
            loadFromDisk()
        }
        
        if settings == nil {
            settings = [:]
        }
    }

    // Mark: Bool

    public func set(_ value: Bool, forKey: String) {
        accessQueue.sync {
            loadFromDiskIfNeeded()
            
            if value {
                settings?[forKey] = "YES"
            } else {
                settings?[forKey] = "NO"
            }
            
            savingQueue.async {
                self.saveToDisk()
            }
        }
    }

    public func bool(forKey: String) -> Bool? {
        return accessQueue.sync {
            loadFromDiskIfNeeded()
            
            if let bool = settings?[forKey] as? String {
                return bool == "YES"
            }
            
            return nil
        }
    }
    
    // MARK: String
    
    public func set(_ value: String, forKey: String) {
        accessQueue.sync {
            loadFromDiskIfNeeded()
            settings?[forKey] = value
            
            savingQueue.async {
                self.saveToDisk()
            }
        }
    }

    public func string(forKey: String) -> String? {
        return accessQueue.sync {
            loadFromDiskIfNeeded()
            if let value = settings?[forKey] as? String {
                return value
            }
            return nil
        }
    }
    
    // MARK: Integer

    public func set(_ value: Int, forKey: String) {
        accessQueue.sync {
            loadFromDiskIfNeeded()
            settings?[forKey] = String(value)
            
            savingQueue.async {
                self.saveToDisk()
            }
        }
    }

    public func integer(forKey: String) -> Int? {
        return accessQueue.sync {
            loadFromDiskIfNeeded()
            if let setting = settings?[forKey] as? String {
                if let int : Int = Int(setting) {
                    return int
                }
            }
            
            return nil
        }
    }
    
    // MARK: Double

    public func set(_ value: Double, forKey: String) {
        accessQueue.sync {
            loadFromDiskIfNeeded()
            settings?[forKey] = String(value)
            
            savingQueue.async {
                self.saveToDisk()
            }
        }
    }

    public func double(forKey: String) -> Double? {
        return accessQueue.sync {
            loadFromDiskIfNeeded()
            if let setting = settings?[forKey] as? String {
                if let double: Double = Double(setting) {
                    return double
                }
            }
            
            return nil
        }
    }
    
    // MARK: Data
    
    public func set(_ value: Data, forKey: String) {
        accessQueue.sync {
            loadFromDiskIfNeeded()
            settings?[forKey] = value.base64EncodedString()
            
            savingQueue.async {
                self.saveToDisk()
            }
        }
    }

    public func data(forKey: String) -> Data? {
        return accessQueue.sync {
            loadFromDiskIfNeeded()
            if let setting = settings?[forKey] as? String {
                return Data(base64Encoded: setting)
            }
            
            return nil
        }
    }
    
    // MARK: Integers
    
    public func set(_ value: [Int], forKey: String) {
        accessQueue.sync {
            loadFromDiskIfNeeded()
            settings?[forKey] = value
            
            savingQueue.async {
                self.saveToDisk()
            }
        }
    }
    
    public func integers(forKey: String) -> [Int]? {
        return accessQueue.sync {
            loadFromDiskIfNeeded()
            if let value = settings?[forKey] as? [Int] {
                return value
            }
            return nil
        }
    }
    
    // MARK: Strings
    
    public func set(_ value: [String], forKey: String) {
        accessQueue.sync {
            loadFromDiskIfNeeded()
            settings?[forKey] = value
            
            savingQueue.async {
                self.saveToDisk()
            }
        }
    }
    
    public func strings(forKey: String) -> [String]? {
        return accessQueue.sync {
            loadFromDiskIfNeeded()
            if let value = settings?[forKey] as? [String] {
                return value
            }
            return nil
        }
    }
}
