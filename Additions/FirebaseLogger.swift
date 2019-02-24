//
//  FirebaseLogger.swift
//  Dozzzer
//
//  Created by Lukas on 14/05/2017.
//  Copyright © 2017 Lukas Burgstaller. All rights reserved.
//

import Foundation
import AppToolsMobile
import FirebaseCore
import FirebaseAnalytics

class FirebaseLogger: EventLoggerImplementation {
    func startUp() {
        FirebaseApp.configure()
    }

    func log(event: EventLogger.Event, parameters: [String: String]) {
        let eventName = event.eventName + eventParametersToString(parameters)
        Analytics.logEvent(eventName, parameters: parameters as [String: NSObject]?)
    }

    func set(userProperty: String, name: EventLogger.UserProperty) {
        Analytics.setUserProperty(userProperty, forName: name.propertyName)
    }
}
