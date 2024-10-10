//
//  ConsoleLogReceiver.swift
//  AppTools
//
//  Created by Lukas Burgstaller on 10.10.24.
//

public class ConsoleLogReceiver: LogReceiver {
    public init() {
        
    }
    
    public func log(tag: String? = nil, message: String, date: String) {
        print("[\(date)] \(tag == nil ? "" : "[\(tag ?? "")]") \(message)")
    }
}
