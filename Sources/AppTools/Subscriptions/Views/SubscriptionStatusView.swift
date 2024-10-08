//
//  SubscriptionStatusView.swift
//  Focused
//
//  Created by Lukas Burgstaller on 02.03.24.
//

import Foundation
import SwiftUI

public struct SubscriptionStatusView: View {
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @State var presentedURL: URL?
    
    let upgradeContext: UpgradeContext
    let splitView: Bool
    
    public init(upgradeContext: UpgradeContext, splitView: Bool = false) {
        self.upgradeContext = upgradeContext
        self.splitView = splitView
    }
    
    public var body: some View {
        List {
            if !splitView {
                VStack(alignment: .center, content: {
                    upgradeContext.proLogo
                })
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
            }
            
            Section {
                HStack {
                    Text(upgradeContext.title)
                    
                    Spacer()
                    
                    Text(subscriptionManager.subscription?.type.string ?? L10n.unknown)
                        .font(.system(size: 15))
                        .opacity(0.7)
                }
                
                HStack {
                    Text(L10n.endDate)
                    
                    Spacer()
                    
                    Text(subscriptionManager.endDate?.shortDateString ?? L10n.unknown)
                        .font(.system(size: 15))
                        .opacity(0.7)
                }
            }
            
            Section {
#if os(macOS)
                HStack {
                    Spacer()
                    
                    Button(L10n.manageSubscription, action: manageSubscription)
                        .tint(.primary)
                    Button(L10n.termsOfService, action: showTermsOfService)
                        .tint(.primary)
                    Button(L10n.privacyPolicy, action: showPrivacyPolicy)
                        .tint(.primary)
                    
                    Spacer()
                }
                .padding(.top, 12)
#else
                Button(L10n.manageSubscription, action: manageSubscription)
                    .tint(.primary)
                Button(L10n.termsOfService, action: showTermsOfService)
                    .tint(.primary)
                Button(L10n.privacyPolicy, action: showPrivacyPolicy)
                    .tint(.primary)
#endif
            } footer: {
                VStack(alignment: .leading) {
                    Text(L10n.subscriptionTerms)
                        .bold()
                    Text(L10n.subscriptionAutomaticallyRenewsUnlessAutoRenewIsTurnedOffAtLeast24HoursBeforeTheEndOfTheCurrentPeriodPaymentWillBeChargedToITunesAccountAtConfirmationOfPurchaseAccountWillBeChargedForRenewalWithin24HoursPriorToTheEndOfTheCurrentPeriodForTheFullPriceSubscriptionsMayBeManagedByTheUserAndAutoRenewalMayBeTurnedOffByGoingToTheUserSAccountSettingsAfterPurchase)
                        .lineLimit(6, reservesSpace: true)
                }
                .frame(maxWidth: .infinity)
                .ignoresSafeArea()
                .padding(.top, 12)
            }
        }
        .navigationTitle(L10n.subscriptionStatus)
    }
    
    private func manageSubscription() {
        URL(string: "https://apps.apple.com/account/subscriptions")?.open()
    }
    
    private func showTermsOfService() {
        presentedURL = URL(string: "https://voidstern.net/terms-of-use")!
    }
    
    private func showPrivacyPolicy() {
        presentedURL = URL(string: "https://voidstern.net/privacy-policy")!
    }
}
