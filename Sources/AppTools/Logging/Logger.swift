//
//  Logger.swift
//  AppTools
//
//  Created by Lukas Burgstaller on 10.10.24.
//

import Foundation

public protocol LogReceiver {
    func log(tag: String?, message: String, date: String)
}

public class Logger {
    public static let shared = Logger()
    
    private var receivers: [LogReceiver] = []
    public let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
    }
    
    public func log(tag: String? = nil, _ message: String) {
        let dateString = dateFormatter.string(from: Date())
        
        for receiver in receivers {
            receiver.log(tag: tag, message: message, date: dateString)
        }
    }
    
    public func register(_ receiver: LogReceiver) {
        receivers.append(receiver)
    }
}

public func log(tag: String? = nil, _ message: String) {
    Logger.shared.log(tag: tag, message)
}
