//
//  FirebaseLogger.swift
//  Dozzzer
//
//  Created by Lukas on 14/05/2017.
//  Copyright © 2017 Lukas Burgstaller. All rights reserved.
//

import Foundation
import AppTools
import Firebase

class FirebaseLogger: EventLoggerImplementation {
    func startUp() {
        FirebaseApp.configure()
    }

    func log(event: EventLogger.Event, parameters: [String: String]) {
        Analytics.logEvent(event.eventName, parameters: parameters as [String: NSObject]?)
    }

    func set(userProperty: String, name: EventLogger.UserProperty) {
        Analytics.setUserProperty(userProperty, forName: name.propertyName)
    }
}
