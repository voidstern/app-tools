//
//  FirebaseLogger.swift
//  Dozzzer
//
//  Created by Lukas on 14/05/2017.
//  Copyright © 2017 Lukas Burgstaller. All rights reserved.
//

import Foundation
import AppToolsMobile
import FBSDKCoreKit

class FacebookLogger: EventLoggerImplementation {

    func startUp() {
        FBSDKAppEvents.activateApp()

        if FBSDKAppEvents.userID() == nil {
            FBSDKAppEvents.setUserID(UUID().uuidString)
        }

        let userID = FBSDKAppEvents.userID()
        print(userID ?? "")
    }

    func log(event: EventLogger.Event, parameters: [String: String]) {
        let eventName = event.eventName + eventParametersToString(parameters)
        FBSDKAppEvents.logEvent(eventName, parameters: parameters)
    }

    func set(userProperty: String, name: EventLogger.UserProperty) {
        FBSDKAppEvents.updateUserProperties([name.propertyName: userProperty], handler: nil)
    }
}