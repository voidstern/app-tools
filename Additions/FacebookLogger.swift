//
//  FirebaseLogger.swift
//  Dozzzer
//
//  Created by Lukas on 14/05/2017.
//  Copyright © 2017 Lukas Burgstaller. All rights reserved.
//

import Foundation
import AppTools
import FBSDKCoreKit

class FacebookLogger: EventLoggerImplementation {

    func startUp() {
    }

    func log(event: EventLogger.Event, parameters: [String: String]) {
        FBSDKAppEvents.logEvent(event.eventName, parameters: parameters)
    }

    func set(userProperty: String, name: EventLogger.UserProperty) {
        // FBSDKAppEvents.updateUserProperties(<#T##properties: [AnyHashable : Any]!##[AnyHashable : Any]!#>, handler: <#T##FBSDKGraphRequestHandler!##FBSDKGraphRequestHandler!##(FBSDKGraphRequestConnection?, Any?, Error?) -> Void#>)
    }
}
