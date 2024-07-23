//
//  ConsoleLogger.swift
//  AppToolsMobile
//
//  Created by Lukas Burgstaller on 22.06.22.
//  Copyright © 2022 Lukas. All rights reserved.
//

import Foundation

public class ConsoleLogger: EventLoggerImplementation {
    public init() {
        
    }
    
    public func startUp() {
        
    }
    
    public func log(event: EventLogger.Event, parameters: [String : String], floatValue: Float?) {
        print("[ConsoleLogger] Event: \(event.eventName) - \(parameters)".replacingOccurrences(of: "\n", with: ""))
    }
    
    public func set(userProperty: String, name: EventLogger.UserProperty) {
        print("[ConsoleLogger] Property \(name.propertyName) - \(userProperty)".replacingOccurrences(of: "\n", with: ""))
    }
}
