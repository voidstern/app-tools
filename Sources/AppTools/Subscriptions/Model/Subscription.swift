//
//  File.swift
//  
//
//  Created by Lukas Burgstaller on 17.03.24.
//

import Foundation

extension SubscriptionManager {
    open class Subscription: Codable, Equatable, Hashable {
        public let identifier: String
        public let trialDuration: Int
        public let type: SubscriptionType
        public let level: SubscriptionLevel
        
        public init(identifier: String, level: SubscriptionLevel, type: SubscriptionType, trialDuration: Int) {
            self.identifier = identifier
            self.trialDuration = trialDuration
            self.level = level
            self.type = type
        }
        
        public static func == (lhs: Subscription, rhs: Subscription) -> Bool {
            return lhs.identifier == rhs.identifier
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        
        public var hasTrial: Bool {
            return trialDuration != 0
        }
        
        public var isAnnual: Bool {
            return type == .yearly
        }
        
        public var isFree: Bool {
            return type == .free
        }
    }
}


extension SubscriptionManager {
    public enum SubscriptionType: Codable {
        case monthly, bimonthly, quarterly, yearly
        case testflight, legacy, free, other
        
        var string: String {
            switch self {
            case .monthly: return L10n.monthly
            case .bimonthly: return L10n.biMonthly
            case .quarterly: return L10n.quarterly
            case .yearly: return L10n.yearly
            case .testflight: return L10n.testFlight
            case .legacy: return L10n.permanent
            case .free: return L10n.noSubscription
            case .other: return L10n.other
            }
        }
    }
}


extension SubscriptionManager {
    public class SubscriptionLevel: Codable, Equatable, Hashable, Comparable {
        public static let free = SubscriptionManager.SubscriptionLevel(identifier: "free", entitlement: nil, value: 0)

        public let identifier: String
        public let entitlement: String?
        public let value: Int
        
        public init(identifier: String, entitlement: String?, value: Int) {
            self.identifier = identifier
            self.entitlement = entitlement
            self.value = value
        }
        
        public static func == (lhs: SubscriptionLevel, rhs: SubscriptionLevel) -> Bool {
            return lhs.identifier == rhs.identifier
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        
        public func equalOrHigher(than otherLevel: SubscriptionLevel) -> Bool {
            return self.value >= otherLevel.value
        }
        
        public static func < (lhs: SubscriptionManager.SubscriptionLevel, rhs: SubscriptionManager.SubscriptionLevel) -> Bool {
            return lhs.value < rhs.value
        }
    }
}


