//
//  File.swift
//  
//
//  Created by Lukas Burgstaller on 23.03.24.
//

import Foundation

extension CGFloat {
    static public func platform(_ value: CGFloat, macOS: CGFloat? = nil, iOS: CGFloat? = nil, watchOS: CGFloat? = nil, visionOS: CGFloat? = nil) -> CGFloat {
#if os(macOS) || targetEnvironment(macCatalyst)
        if let macOS {
            return macOS
        }
#endif
        
#if os(iOS)
        if let iOS {
            return iOS
        }
#endif
        
#if os(watchOS)
        if let watchOS {
            return watchOS
        }
#endif
        
#if os(visionOS)
        if let visionOS {
            return visionOS
        }
#endif
        
        return value
    }
}

extension Bool {
    static public func platform(_ value: Bool, macOS: Bool? = nil, iOS: Bool? = nil, watchOS: Bool? = nil, visionOS: Bool? = nil) -> Bool {
#if os(macOS) || targetEnvironment(macCatalyst)
        if let macOS {
            return macOS
        }
#endif
        
#if os(iOS)
        if let iOS {
            return iOS
        }
#endif
        
#if os(watchOS)
        if let watchOS {
            return watchOS
        }
#endif
        
#if os(visionOS)
        if let visionOS {
            return visionOS
        }
#endif
        
        return value
    }
}

extension Optional where Wrapped == CGFloat {
    static public func platform(_ value: CGFloat, macOS: CGFloat? = nil, iOS: CGFloat? = nil, watchOS: CGFloat? = nil, visionOS: CGFloat? = nil) -> CGFloat {
        return CGFloat.platform(value, macOS: macOS, iOS: iOS, watchOS: watchOS, visionOS: visionOS)
    }
}

extension Double {
    static public func platform(_ value: CGFloat, macOS: CGFloat? = nil, iOS: CGFloat? = nil, watchOS: CGFloat? = nil, visionOS: CGFloat? = nil) -> Double {
        return CGFloat.platform(value, macOS: macOS, iOS: iOS, watchOS: watchOS, visionOS: visionOS)
    }
}

extension Int {
    static public func platform(_ value: CGFloat, macOS: CGFloat? = nil, iOS: CGFloat? = nil, watchOS: CGFloat? = nil, visionOS: CGFloat? = nil) -> Int {
        return Int(CGFloat.platform(value, macOS: macOS, iOS: iOS, watchOS: watchOS, visionOS: visionOS))
    }
}
