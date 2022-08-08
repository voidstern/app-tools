//
//  InstallAge.swift
//  AppToolsMobile
//
//  Created by Lukas on 02/09/2017.
//  Copyright © 2017 Lukas. All rights reserved.
//

import Foundation
import AppTools

extension UserSettings.Setting {
    public static var installDate: UserSettings.Setting {
        return UserSettings.Setting(identifier: "install_date")
    }
}

extension UserSettings {
    private func setFirstInstallIfNeeded() -> Date {
        let timestamp = self.double(key: .installDate) as TimeInterval

        if timestamp > 0 {
            return Date(timeIntervalSince1970: timestamp)
        }

        let date = Date()
        self.set(value: date.timeIntervalSince1970, key: .installDate)
        return date
    }

    public var installAge: Int {
        let startDate = setFirstInstallIfNeeded()
        let endDate = Date()

        let calendar: Calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        if let day = components.day {
            return day
        }
        return 0
    }
}
