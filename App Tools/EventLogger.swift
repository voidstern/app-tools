//
//  EventLogger.swift
//  Multi Timers 2
//
//  Created by Lukas Burgstaller on 26/10/2016.
//  Copyright © 2016 Lukas Burgstaller. All rights reserved.
//

import Foundation

public protocol EventLoggerImplementation {
    func log(event: EventLogger.Event, parameters: [String: String])
    func set(userProperty: String, name: EventLogger.UserProperty)
    func startUp()
}

public func eventParametersToString(_ parameters: [String: String]) -> String {
    var parameterString = ""
    for key in parameters.keys {
        parameterString += "__\(key)_\(parameters[key] ?? "nil")"
    }
    return parameterString.replacingOccurrences(of: "-", with: "_").replacingOccurrences(of: " ", with: "_")
}

public class EventLogger {
	static public let shared = EventLogger()
    private var loggers: [EventLoggerImplementation] = []

    open class Event {
        public let eventName: String
        public init(eventName: String) {
            self.eventName = eventName
        }

        static var purchasedProduct: EventLogger.Event {
            return EventLogger.Event(eventName: "purchased")
        }

        static var restoredProduct: EventLogger.Event {
            return EventLogger.Event(eventName: "restored")
        }
        
        public static var ratingDialogPresented: EventLogger.Event {
            return EventLogger.Event(eventName: "presented_dialog")
        }
    }

    open class UserProperty {
        public let propertyName: String
        public init(propertyName: String) {
            self.propertyName = propertyName
        }
        
        public static var installAge: EventLogger.UserProperty {
            return EventLogger.UserProperty(propertyName: "install_age")
        }
    }

    public func addLogger(logger: EventLoggerImplementation) {
        loggers.append(logger)
        logger.startUp()
    }

    public func log(event: Event, parameters: [String: String]? = nil) {
        loggers.forEach({ $0.log(event: event, parameters: parameters ?? [:]) })
    }

    public func set(userProperty: String, name: UserProperty) {
        loggers.forEach({ $0.set(userProperty: userProperty, name: name) })
    }
}

extension EventLogger {
    public func updateInstallAge() {
        set(userProperty: String(UserSettings.shared.installAge), name: .installAge)
    }
}
