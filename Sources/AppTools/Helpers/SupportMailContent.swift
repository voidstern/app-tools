//
//  File.swift
//  
//
//  Created by Lukas Burgstaller on 13.03.24.
//

import Foundation

#if canImport(WatchKit)
import WatchKit
#endif

#if canImport(UIKit) && !os(watchOS)
import UIKit

extension UIDevice {
    public var machine: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }

        return modelCode ?? UIDevice.current.model
    }
}
#endif

#if canImport(IOKit)
import IOKit
private func getMacModel() -> String? {
    let service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
    var modelIdentifier: String?

    if let modelData = IORegistryEntryCreateCFProperty(service, "model" as CFString, kCFAllocatorDefault, 0).takeRetainedValue() as? Data {
        if let modelIdentifierCString = String(data: modelData, encoding: .utf8)?.cString(using: .utf8) {
            modelIdentifier = String(cString: modelIdentifierCString)
        }
    }

    IOObjectRelease(service)
    return modelIdentifier
}
#else
private func getMacModel() -> String? {
    return nil
}
#endif


public class SupportMailContent {
    public init() {
        
    }
    
    public func messageBody(rcid: String?, sentryID: String?) -> String {
#if os(macOS)
        let system = ProcessInfo.processInfo.operatingSystemVersion
        var body = "\n\n\nSystem: \(system.majorVersion).\(system.minorVersion).\(system.patchVersion)"
        
        if let machine = getMacModel() {
            body.append(contentsOf: "\nDevice: \(machine)")
        }
        
        if let rcid = rcid {
            body.append(contentsOf: "\nRCID: \(rcid)")
        }
        
        if let sentryID = sentryID, !sentryID.isEmpty {
            body.append(contentsOf: "\nSentry: \(sentryID)")
        }
        
        return body
#elseif os(watchOS)
        let system = "\(WKInterfaceDevice.current().systemName) \(WKInterfaceDevice.current().systemVersion)"
        let machine = WKInterfaceDevice.current().model
        
        var body = "\n\n\nSystem: \(system)\nDevice: \(machine)"
        
        if let rcid = rcid {
            body.append(contentsOf: "\nRCID: \(rcid)")
        }
        
        if let sentryID = sentryID, !sentryID.isEmpty {
            body.append(contentsOf: "\nSentry: \(sentryID)")
        }
        
        return body
#else
        let system = "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
        let machine = UIDevice.current.machine
        
        var body = "\n\n\nSystem: \(system)\nDevice: \(machine)"
        
        if let rcid = rcid {
            body.append(contentsOf: "\nRCID: \(rcid)")
        }
        
        if let sentryID = sentryID, !sentryID.isEmpty {
            body.append(contentsOf: "\nSentry: \(sentryID)")
        }
        
        return body
#endif
    }
    
    public func version() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let build = Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String ?? ""
        return "\(version) (Build \(build))"
    }
    
    public func subject() -> String {
        let name = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? ""
        return "\(name) \(version)"
    }
    
    public func emailURL(email: String, rcid: String?) -> URL? {
        let sentryID = UserSettings.shared.string(key: .sentryUserID)
        let fullMailString =  "mailto:\(email)?subject=\(subject().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&body=\(messageBody(rcid: rcid, sentryID: sentryID).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        let justEmailString = "mailto:\(email)"
        
        return URL(string: fullMailString) ?? URL(string: justEmailString)
    }
}
