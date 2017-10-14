//
//  FirebaseLogger.swift
//  Dozzzer
//
//  Created by Lukas on 14/05/2017.
//  Copyright © 2017 Lukas Burgstaller. All rights reserved.
//

import Foundation
import AppToolsMobile
import Crashlytics
import Fabric

class FabricLogger: EventLoggerImplementation {
    func startUp() {
        Fabric.with([Crashlytics.self])
    }

    func log(event: EventLogger.Event, parameters: [String: String]) {
        let eventName = event.eventName + eventParametersToString(parameters)
        Answers.logCustomEvent(withName: eventName, customAttributes: parameters as [String: NSObject]?)
    }

    func set(userProperty: String, name: EventLogger.UserProperty) {
        // Not supported
    }
}
