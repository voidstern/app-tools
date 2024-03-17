// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
internal enum L10n {
  /// %@ days free, then %@/month
  internal static func daysFreeThenMonth(_ p1: Any, _ p2: Any) -> String {
    return L10n.tr("Localizable", "%@ days free, then %@/month", String(describing: p1), String(describing: p2), fallback: "%@ days free, then %@/month")
  }
  /// %@ days free, then %@/year
  internal static func daysFreeThenYear(_ p1: Any, _ p2: Any) -> String {
    return L10n.tr("Localizable", "%@ days free, then %@/year", String(describing: p1), String(describing: p2), fallback: "%@ days free, then %@/year")
  }
  /// %@ days free, then %@/year. Cancel anytime.
  internal static func daysFreeThenYearCancelAnytime(_ p1: Any, _ p2: Any) -> String {
    return L10n.tr("Localizable", "%@ days free, then %@/year Cancel anytime", String(describing: p1), String(describing: p2), fallback: "%@ days free, then %@/year. Cancel anytime.")
  }
  /// %@/month
  internal static func month(_ p1: Any) -> String {
    return L10n.tr("Localizable", "%@/month", String(describing: p1), fallback: "%@/month")
  }
  /// %@/year
  internal static func year(_ p1: Any) -> String {
    return L10n.tr("Localizable", "%@/year", String(describing: p1), fallback: "%@/year")
  }
  /// Bi-Monthly
  internal static let biMonthly = L10n.tr("Localizable", "Bi-Monthly", fallback: "Bi-Monthly")
  /// Cancel
  internal static let cancel = L10n.tr("Localizable", "Cancel", fallback: "Cancel")
  /// Continue
  internal static let `continue` = L10n.tr("Localizable", "Continue", fallback: "Continue")
  /// Done
  internal static let done = L10n.tr("Localizable", "Done", fallback: "Done")
  /// Dozzzer: Sleep Sounds
  internal static let dozzzerSleepSounds = L10n.tr("Localizable", "Dozzzer: Sleep Sounds", fallback: "Dozzzer: Sleep Sounds")
  /// End Date
  internal static let endDate = L10n.tr("Localizable", "End Date", fallback: "End Date")
  /// Fall asleep to music & sounds
  internal static let fallAsleepToMusicSounds = L10n.tr("Localizable", "Fall asleep to music & sounds", fallback: "Fall asleep to music & sounds")
  /// HIIT, Pomodoro and more
  internal static let hiitPomodoroAndMore = L10n.tr("Localizable", "HIIT, Pomodoro and more", fallback: "HIIT, Pomodoro and more")
  /// Manage Subscription
  internal static let manageSubscription = L10n.tr("Localizable", "Manage Subscription", fallback: "Manage Subscription")
  /// Monthly
  internal static let monthly = L10n.tr("Localizable", "Monthly", fallback: "Monthly")
  /// No Subscription
  internal static let noSubscription = L10n.tr("Localizable", "No Subscription", fallback: "No Subscription")
  /// Other
  internal static let other = L10n.tr("Localizable", "Other", fallback: "Other")
  /// Other Apps
  internal static let otherApps = L10n.tr("Localizable", "Other Apps", fallback: "Other Apps")
  /// Permanent
  internal static let permanent = L10n.tr("Localizable", "Permanent", fallback: "Permanent")
  /// Privacy Policy
  internal static let privacyPolicy = L10n.tr("Localizable", "Privacy Policy", fallback: "Privacy Policy")
  /// Quarterly
  internal static let quarterly = L10n.tr("Localizable", "Quarterly", fallback: "Quarterly")
  /// Restore
  internal static let restore = L10n.tr("Localizable", "Restore", fallback: "Restore")
  /// Restore Purchases
  internal static let restorePurchases = L10n.tr("Localizable", "Restore Purchases", fallback: "Restore Purchases")
  /// Settings
  internal static let settings = L10n.tr("Localizable", "Settings", fallback: "Settings")
  /// Subscription Terms
  internal static let subscriptionTerms = L10n.tr("Localizable", "Subscription Terms", fallback: "Subscription Terms")
  /// Terms of Service
  internal static let termsOfService = L10n.tr("Localizable", "Terms of Service", fallback: "Terms of Service")
  /// TestFlight
  internal static let testFlight = L10n.tr("Localizable", "TestFlight", fallback: "TestFlight")
  /// TestFlight subscriptions are not charged to your card.
  internal static let testFlightSubscriptionsAreNotChargedToYourCard = L10n.tr("Localizable", "TestFlight subscriptions are not charged to your card.", fallback: "TestFlight subscriptions are not charged to your card.")
  /// Thanks for your support
  internal static let thanksForYourSupport = L10n.tr("Localizable", "Thanks for your support", fallback: "Thanks for your support")
  /// Tidur: Multiple Timers
  internal static let tidurMultipleTimers = L10n.tr("Localizable", "Tidur: Multiple Timers", fallback: "Tidur: Multiple Timers")
  /// Try Now
  internal static let tryNow = L10n.tr("Localizable", "Try Now", fallback: "Try Now")
  /// Unknown
  internal static let unknown = L10n.tr("Localizable", "Unknown", fallback: "Unknown")
  /// Upgrade Now
  internal static let upgradeNow = L10n.tr("Localizable", "Upgrade Now", fallback: "Upgrade Now")
  /// Yearly
  internal static let yearly = L10n.tr("Localizable", "Yearly", fallback: "Yearly")
  /// Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period. Payment will be charged to iTunes Account at confirmation of purchase. Account will be charged for renewal within 24-hours prior to the end of the current period for the full price. Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase.
  internal static let subscriptionAutomaticallyRenewsUnlessAutoRenewIsTurnedOffAtLeast24HoursBeforeTheEndOfTheCurrentPeriodPaymentWillBeChargedToITunesAccountAtConfirmationOfPurchaseAccountWillBeChargedForRenewalWithin24HoursPriorToTheEndOfTheCurrentPeriodForTheFullPriceSubscriptionsMayBeManagedByTheUserAndAutoRenewalMayBeTurnedOffByGoingToTheUserSAccountSettingsAfterPurchase = L10n.tr("Localizable", "Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period. Payment will be charged to iTunes Account at confirmation of purchase. Account will be charged for renewal within 24-hours prior to the end of the current period for the full price. Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase.", fallback: "Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period. Payment will be charged to iTunes Account at confirmation of purchase. Account will be charged for renewal within 24-hours prior to the end of the current period for the full price. Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase.")
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
