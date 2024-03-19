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
    
    public init() {
        
    }
    
    public var body: some View {
        List {
            VStack(alignment: .center, content: {
                Image("FocusedPro")
            })
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)
            
            Section {
                HStack {
                    Text("Focused Pro")
                    
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
                Button(L10n.manageSubscription, action: manageSubscription)
                    .tint(.primary)
                Button(L10n.termsOfService, action: showTermsOfService)
                    .tint(.primary)
                Button(L10n.privacyPolicy, action: showPrivacyPolicy)
                    .tint(.primary)
            } footer: {
                VStack(alignment: .leading) {
                    Text(L10n.subscriptionTerms)
                        .bold()
                    Text(L10n.subscriptionAutomaticallyRenewsUnlessAutoRenewIsTurnedOffAtLeast24HoursBeforeTheEndOfTheCurrentPeriodPaymentWillBeChargedToITunesAccountAtConfirmationOfPurchaseAccountWillBeChargedForRenewalWithin24HoursPriorToTheEndOfTheCurrentPeriodForTheFullPriceSubscriptionsMayBeManagedByTheUserAndAutoRenewalMayBeTurnedOffByGoingToTheUserSAccountSettingsAfterPurchase)
                }
                .frame(maxWidth: .infinity)
                .ignoresSafeArea()
                .padding(.top, 12)
            }
        }
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
