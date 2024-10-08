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
  /// A news reader for power users
  internal static let aNewsReaderForPowerUsers = L10n.tr("Localizable", "A news reader for power users", fallback: "A news reader for power users")
  /// About
  internal static let about = L10n.tr("Localizable", "About", fallback: "About")
  /// Bi-Monthly
  internal static let biMonthly = L10n.tr("Localizable", "Bi-Monthly", fallback: "Bi-Monthly")
  /// Cancel
  internal static let cancel = L10n.tr("Localizable", "Cancel", fallback: "Cancel")
  /// Changelog
  internal static let changelog = L10n.tr("Localizable", "Changelog", fallback: "Changelog")
  /// Contact
  internal static let contact = L10n.tr("Localizable", "Contact", fallback: "Contact")
  /// Continue
  internal static let `continue` = L10n.tr("Localizable", "Continue", fallback: "Continue")
  /// Continue without Upgrade
  internal static let continueWithoutUpgrade = L10n.tr("Localizable", "Continue without Upgrade", fallback: "Continue without Upgrade")
  /// Copy
  internal static let copy = L10n.tr("Localizable", "Copy", fallback: "Copy")
  /// Developer
  internal static let developer = L10n.tr("Localizable", "Developer", fallback: "Developer")
  /// Done
  internal static let done = L10n.tr("Localizable", "Done", fallback: "Done")
  /// Dozzzer: Sleep Sounds
  internal static let dozzzerSleepSounds = L10n.tr("Localizable", "Dozzzer: Sleep Sounds", fallback: "Dozzzer: Sleep Sounds")
  /// Email
  internal static let email = L10n.tr("Localizable", "Email", fallback: "Email")
  /// End Date
  internal static let endDate = L10n.tr("Localizable", "End Date", fallback: "End Date")
  /// Fall asleep to music & sounds
  internal static let fallAsleepToMusicSounds = L10n.tr("Localizable", "Fall asleep to music & sounds", fallback: "Fall asleep to music & sounds")
  /// Fiery Feeds: RSS Reader
  internal static let fieryFeedsRSSReader = L10n.tr("Localizable", "Fiery Feeds: RSS Reader", fallback: "Fiery Feeds: RSS Reader")
  /// Focused: Task Planner
  internal static let focusedTaskPlanner = L10n.tr("Localizable", "Focused: Task Planner", fallback: "Focused: Task Planner")
  /// Friday
  internal static let friday = L10n.tr("Localizable", "Friday", fallback: "Friday")
  /// Fri
  internal static let fridayShort = L10n.tr("Localizable", "Friday Short", fallback: "Fri")
  /// HIIT, Pomodoro and more
  internal static let hiitPomodoroAndMore = L10n.tr("Localizable", "HIIT, Pomodoro and more", fallback: "HIIT, Pomodoro and more")
  /// Manage Subscription
  internal static let manageSubscription = L10n.tr("Localizable", "Manage Subscription", fallback: "Manage Subscription")
  /// Monday
  internal static let monday = L10n.tr("Localizable", "Monday", fallback: "Monday")
  /// Mon
  internal static let mondayShort = L10n.tr("Localizable", "Monday Short", fallback: "Mon")
  /// Monthly
  internal static let monthly = L10n.tr("Localizable", "Monthly", fallback: "Monthly")
  /// News
  internal static let news = L10n.tr("Localizable", "News", fallback: "News")
  /// No Subscription
  internal static let noSubscription = L10n.tr("Localizable", "No Subscription", fallback: "No Subscription")
  /// None
  internal static let `none` = L10n.tr("Localizable", "None", fallback: "None")
  /// One Step at a Time
  internal static let oneStepAtATime = L10n.tr("Localizable", "One Step at a Time", fallback: "One Step at a Time")
  /// Other
  internal static let other = L10n.tr("Localizable", "Other", fallback: "Other")
  /// Other Apps
  internal static let otherApps = L10n.tr("Localizable", "Other Apps", fallback: "Other Apps")
  /// Permanent
  internal static let permanent = L10n.tr("Localizable", "Permanent", fallback: "Permanent")
  /// Privacy Policy
  internal static let privacyPolicy = L10n.tr("Localizable", "Privacy Policy", fallback: "Privacy Policy")
  /// Productivity
  internal static let productivity = L10n.tr("Localizable", "Productivity", fallback: "Productivity")
  /// Quarterly
  internal static let quarterly = L10n.tr("Localizable", "Quarterly", fallback: "Quarterly")
  /// RC Dash
  internal static let rcDash = L10n.tr("Localizable", "RC Dash", fallback: "RC Dash")
  /// Remove Symbol
  internal static let removeSymbol = L10n.tr("Localizable", "Remove Symbol", fallback: "Remove Symbol")
  /// Restore
  internal static let restore = L10n.tr("Localizable", "Restore", fallback: "Restore")
  /// Restore Purchases
  internal static let restorePurchases = L10n.tr("Localizable", "Restore Purchases", fallback: "Restore Purchases")
  /// Review %@
  internal static func review(_ p1: Any) -> String {
    return L10n.tr("Localizable", "Review %@", String(describing: p1), fallback: "Review %@")
  }
  /// Saturday
  internal static let saturday = L10n.tr("Localizable", "Saturday", fallback: "Saturday")
  /// Sat
  internal static let saturdayShort = L10n.tr("Localizable", "Saturday Short", fallback: "Sat")
  /// Search
  internal static let search = L10n.tr("Localizable", "Search", fallback: "Search")
  /// See your RevenueCat stats on the go
  internal static let seeYourRevenueCatStatsOnTheGo = L10n.tr("Localizable", "See your RevenueCat stats on the go", fallback: "See your RevenueCat stats on the go")
  /// Settings
  internal static let settings = L10n.tr("Localizable", "Settings", fallback: "Settings")
  /// Sleep
  internal static let sleep = L10n.tr("Localizable", "Sleep", fallback: "Sleep")
  /// Subscription Status
  internal static let subscriptionStatus = L10n.tr("Localizable", "Subscription Status", fallback: "Subscription Status")
  /// Subscription Terms
  internal static let subscriptionTerms = L10n.tr("Localizable", "Subscription Terms", fallback: "Subscription Terms")
  /// Sunday
  internal static let sunday = L10n.tr("Localizable", "Sunday", fallback: "Sunday")
  /// Sun
  internal static let sundayShort = L10n.tr("Localizable", "Sunday Short", fallback: "Sun")
  /// Support
  internal static let support = L10n.tr("Localizable", "Support", fallback: "Support")
  /// Symbol
  internal static let symbol = L10n.tr("Localizable", "Symbol", fallback: "Symbol")
  /// Terms of Service
  internal static let termsOfService = L10n.tr("Localizable", "Terms of Service", fallback: "Terms of Service")
  /// TestFlight
  internal static let testFlight = L10n.tr("Localizable", "TestFlight", fallback: "TestFlight")
  /// TestFlight subscriptions are not charged to your card.
  internal static let testFlightSubscriptionsAreNotChargedToYourCard = L10n.tr("Localizable", "TestFlight subscriptions are not charged to your card.", fallback: "TestFlight subscriptions are not charged to your card.")
  /// Thanks for your support
  internal static let thanksForYourSupport = L10n.tr("Localizable", "Thanks for your support", fallback: "Thanks for your support")
  /// Thursday
  internal static let thursday = L10n.tr("Localizable", "Thursday", fallback: "Thursday")
  /// Thu
  internal static let thursdayShort = L10n.tr("Localizable", "Thursday Short", fallback: "Thu")
  /// Tidur: Multiple Timers
  internal static let tidurMultipleTimers = L10n.tr("Localizable", "Tidur: Multiple Timers", fallback: "Tidur: Multiple Timers")
  /// Try Now
  internal static let tryNow = L10n.tr("Localizable", "Try Now", fallback: "Try Now")
  /// Tuesday
  internal static let tuesday = L10n.tr("Localizable", "Tuesday", fallback: "Tuesday")
  /// Tue
  internal static let tuesdayShort = L10n.tr("Localizable", "Tuesday Short", fallback: "Tue")
  /// Unknown
  internal static let unknown = L10n.tr("Localizable", "Unknown", fallback: "Unknown")
  /// Upgrade Now
  internal static let upgradeNow = L10n.tr("Localizable", "Upgrade Now", fallback: "Upgrade Now")
  /// User Guide
  internal static let userGuide = L10n.tr("Localizable", "User Guide", fallback: "User Guide")
  /// Version
  internal static let version = L10n.tr("Localizable", "Version", fallback: "Version")
  /// Wednesday
  internal static let wednesday = L10n.tr("Localizable", "Wednesday", fallback: "Wednesday")
  /// Wed
  internal static let wednesdayShort = L10n.tr("Localizable", "Wednesday Short", fallback: "Wed")
  /// What's New in %@
  internal static func whatSNewIn(_ p1: Any) -> String {
    return L10n.tr("Localizable", "What's New in %@", String(describing: p1), fallback: "What's New in %@")
  }
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
