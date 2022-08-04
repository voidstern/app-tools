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
    private var settings: [String: Any] = [:]

    private lazy var saveFileURL: URL = SettingsStorage.shared.getSaveFileURL()
    public var appGroupIdentifier: String? {
        didSet {
            saveFileURL = getSaveFileURL()
            loadFromDisk()
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
        do {
            try JSONSerialization.data(withJSONObject: settings, options: JSONSerialization.WritingOptions(rawValue: 0)).write(to: saveFileURL, options: [])
        } catch {
            print("Error saving settings file", error.localizedDescription)
        }
    }
    
    private func loadFromDisk() {
        guard let data = try? Data(contentsOf: saveFileURL) else {
            return
        }

        if let settingsDict = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String : Any] ?? [:] {
            settings = settingsDict
        }
    }

    // Mark: Accessors

    public func set(_ value: Bool, forKey: String) {
        if value {
            settings[forKey] = "YES"
        } else {
            settings[forKey] = "NO"
        }
        saveToDisk()
    }

    public func bool(forKey: String) -> Bool? {
        loadFromDisk()
        if let bool = settings[forKey] as? String {
            return bool == "YES"
        }
        return nil
    }

    public func set(_ value: String, forKey: String) {
        settings[forKey] = value
        saveToDisk()
    }

    public func string(forKey: String) -> String? {
        loadFromDisk()
        if let value = settings[forKey] as? String {
            return value
        }
        return nil
    }
    
    public func set(_ value: [String], forKey: String) {
        settings[forKey] = value
        saveToDisk()
    }
    
    public func strings(forKey: String) -> [String]? {
        loadFromDisk()
        if let value = settings[forKey] as? [String] {
            return value
        }
        return nil
    }

    public func set(_ value: Int, forKey: String) {
        settings[forKey] = String(value);
        saveToDisk()
    }

    public func integer(forKey: String) -> Int? {
        loadFromDisk()
        if let setting = settings[forKey] as? String {
            if let int : Int = Int(setting) {
                return int
            }
        }
        
        return nil
    }

    public func set(_ value: Double, forKey: String) {
        settings[forKey] = String(value);
        saveToDisk()
    }

    public func double(forKey: String) -> Double? {
        loadFromDisk()
        if let setting = settings[forKey] as? String {
            if let double: Double = Double(setting) {
                return double
            }
        }

        return nil
    }
}
