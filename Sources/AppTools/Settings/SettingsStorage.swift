//
//  SettingsStorage.swift
//  Multi Timers 2
//
//  Created by Lukas Burgstaller on 02/05/16.
//  Copyright © 2016 Lukas Burgstaller. All rights reserved.
//

import Foundation

public class SettingsStorage {
    
    public static let shared = SettingsStorage()
    
    private var settings: [String: Any]?
    
    private let savingQueue = DispatchQueue(label: "net.voidstern.app-tools.settings-storage")
    private let accessQueue = DispatchQueue(label: "net.voidstern.app-tools.access")

    private lazy var saveFileURL: URL = SettingsStorage.shared.getSaveFileURL()
    public var appGroupIdentifier: String? {
        didSet {
            if appGroupIdentifier != oldValue {
                saveFileURL = getSaveFileURL()
                loadFromDisk()
            }
        }
    }

    func getSaveFileURL() -> URL {
        guard let appGroupIdentifier = appGroupIdentifier, let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier) else {
            print("WARN: appGroupIdentifier not set on SettingsStorage")
            return URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/settings.json")
        }

        return containerURL.appendingPathComponent("settings.json")
    }
    
    private func saveToDisk() {
        guard let settings else {
            return
        }
        
        savingQueue.async {
            do {
                try JSONSerialization
                    .data(withJSONObject: settings, options: [.fragmentsAllowed])
                    .write(to: self.saveFileURL, options: [])
            } catch {
                print("Error saving settings file", error.localizedDescription)
            }
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

    // Mark: Accessors

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
}
