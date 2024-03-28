//
//  AppIconPickerButton.swift
//  Dozzzer
//
//  Created by Lukas Burgstaller on 18.08.23.
//  Copyright © 2023 Lukas Burgstaller. All rights reserved.
//

import Foundation
import SwiftUI

struct AppIconPickerButton: View {
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Binding var showingPurchaseView: Bool
    
    let appIcon: AppIconPickerView.AppIcon
    let subscriptionLevel: SubscriptionManager.SubscriptionLevel
    
    var body: some View {
        Button(action: pickIcon) {
            Image(appIcon.preview, bundle: nil)
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private func pickIcon() {
        if subscriptionManager.subscriptionLevel >= subscriptionLevel {
#if os(iOS)
            UIApplication.shared.setAlternateIconName(appIcon.name)
#endif
        } else {
            showingPurchaseView = true
        }
    }
}
