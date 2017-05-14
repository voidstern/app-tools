//
//  SettingsStorage.swift
//  Multi Timers 2
//
//  Created by Lukas Burgstaller on 02/05/16.
//  Copyright © 2016 Lukas Burgstaller. All rights reserved.
//

import Foundation

class SettingsStorage {
    
    static let sharedInstance = SettingsStorage()
    let saveFilePath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/settings.json"
    lazy var saveFileURL: URL = SettingsStorage.sharedInstance.getSaveFileURL()
    var settings: [String: Any] = [:]

    func getSaveFileURL() -> URL {
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.voidstern.multiTimers")
        if (containerURL != nil) {
            return containerURL!.appendingPathComponent("settings.json")
        }
        return URL(fileURLWithPath: saveFilePath)
    }
    
    func saveToDisk() {
        do {
            try JSONSerialization.data(withJSONObject: settings, options: JSONSerialization.WritingOptions(rawValue: 0)).write(to: saveFileURL, options: [])
        } catch {
            print("Error saving settings file", error.localizedDescription)
        }
    }
    
    func loadFromDisk() {
        do {
            guard let data = try? Data(contentsOf: saveFileURL) else {
                return
            }
            
            if let settingsDict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String : Any] {
                settings = settingsDict
            }
        } catch {
            // Fuck swift
        }
    }
}

// Mark: Accessors
extension SettingsStorage {

    func set(_ value: Bool, forKey: String) {
        if value {
            settings[forKey] = "YES"
        } else {
            settings[forKey] = "NO"
        }
        saveToDisk()
    }

    func bool(forKey: String) -> Bool? {
        loadFromDisk()
        if let bool = settings[forKey] as? String {
            return bool == "YES"
        }
        return nil
    }

    func set(_ value: String, forKey: String) {
        settings[forKey] = value
        saveToDisk()
    }

    func string(forKey: String) -> String? {
        loadFromDisk()
        if let value = settings[forKey] as? String {
            return value
        }
        return nil
    }
    
    func set(_ value: [String], forKey: String) {
        settings[forKey] = value
        saveToDisk()
    }
    
    func strings(forKey: String) -> [String]? {
        loadFromDisk()
        if let value = settings[forKey] as? [String] {
            return value
        }
        return nil
    }

    func set(_ value: Int, forKey: String) {
        settings[forKey] = String(value);
        saveToDisk()
    }

    func integer(forKey: String) -> Int? {
        loadFromDisk()
        if let setting = settings[forKey] as? String {
            if let int : Int = Int(setting) {
                return int
            }
        }
        
        return nil
    }
}
