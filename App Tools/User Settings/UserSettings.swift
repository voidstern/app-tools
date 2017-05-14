//
//  UserSettings.swift
//  Multi Timers 2
//
//  Created by Lukas Burgstaller on 26/10/2016.
//  Copyright © 2016 Lukas Burgstaller. All rights reserved.
//

import Foundation

public enum UserSettingKeys: String {
    case purchasedPro = "has_bought_ad_free"
    case adRequests = "ad_requests"
    
    case shuffle = "shuffle"
    case repeating = "repeat"
    case shortFade = "shortFade"
    
    case selectedMode = "selectedMode"
    case selectedSongs = "selectedSongs"
    
    case dismissedMusicNoteView = "dismissedMusicNoteView"
    case dismissedSoundscapeNoteView = "dismissedSoundscapeNoteView"

    case selectedSoundscape = "selectedSoundscape"
}

public class UserSettings {

    static public let shared = UserSettings()
	private var userDefaults = SettingsStorage.sharedInstance

    public func bool(key: UserSettingKeys) -> Bool {
        if let value = userDefaults.bool(forKey: key.rawValue) {
            return value
        }
		return false
    }

    public func set(value: Bool, key: UserSettingKeys) {
        userDefaults.set(value, forKey: key.rawValue)
    }

    public func toggle(_ key: UserSettingKeys) {
        if let value = userDefaults.bool(forKey: key.rawValue) {
            userDefaults.set(!value, forKey: key.rawValue)
        } else {
            userDefaults.set(true, forKey: key.rawValue)
        }
    }

    public func integer(key: UserSettingKeys) -> Int {
        guard let value = userDefaults.integer(forKey: key.rawValue) else {
            return 0
        }
        
        return value
    }

    public func set(value: Int, key: UserSettingKeys) {
        userDefaults.set(value, forKey: key.rawValue)
    }
    
    public func string(key: UserSettingKeys) -> String {
        if let value = userDefaults.string(forKey: key.rawValue) {
            return value
        }
        return ""
    }
    
    public func set(value: String, key: UserSettingKeys) {
        userDefaults.set(value, forKey: key.rawValue)
    }
    
    public func strings(key: UserSettingKeys) -> [String]? {
        guard let value = userDefaults.strings(forKey: key.rawValue) else {
            return []
        }
        
        return value
    }
    
    public func set(strings: [String], key: UserSettingKeys) {
        userDefaults.set(strings, forKey: key.rawValue)
    }
}
