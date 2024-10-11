//
//  Logger.swift
//  AppTools
//
//  Created by Lukas Burgstaller on 10.10.24.
//

import Foundation

public protocol LogReceiver {
    func log(tag: String?, message: String, date: String, level: LogLevel)
}

public enum LogLevel: Int {
    case critical = 4, error = 3, warning = 2, info = 1, debug = 0
}

public class Logger {
    public static let shared = Logger()
    
    private var receivers: [LogReceiver] = []
    public let dateFormatter = DateFormatter()
    public var level: LogLevel = .info
    
    init() {
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
    }
    
    public func log(tag: String? = nil, level: LogLevel = .info, _ message: String) {
        guard level.rawValue >= self.level.rawValue else { return }
        
        let dateString = dateFormatter.string(from: Date())
        
        for receiver in receivers {
            receiver.log(tag: tag, message: message, date: dateString, level: level)
        }
    }
    
    public func register(_ receiver: LogReceiver) {
        receivers.append(receiver)
    }
}

public func log(tag: String? = nil, level: LogLevel = .info, _ message: String) {
    Logger.shared.log(tag: tag, message)
}
