//
//  AppIconPickerView.swift
//  Dozzzer
//
//  Created by Lukas Burgstaller on 18.08.23.
//  Copyright © 2023 Lukas Burgstaller. All rights reserved.
//

import Foundation
import AppTools
import SwiftUI

public struct AppIconPickerView: View {
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @State var showingPurchaseView: Bool = false
    
    let appIconContext: AppIconPickerContext
    let upgradeContext: UpgradeContext
    
    public init(appIconContext: AppIconPickerContext, upgradeContext: UpgradeContext) {
        self.appIconContext = appIconContext
        self.upgradeContext = upgradeContext
    }
    
    public var body: some View {
        content
            .sheet(isPresented: $showingPurchaseView, content: {
                PurchaseView(upgradeContext)
            })
    }
    
    var content: some View {
        List {
            ForEach(appIconContext.sections) { section in
                self.section(for: section)
            }
        }
#if os(iOS)
        .listStyle(.insetGrouped)
        .listSectionSeparatorTint(.primary)
#endif
    }
    
    private func section(for section: AppIconSection) -> some View {
        Section {
            ScrollView(.horizontal) {
                ForEach(section.icons) { iconRow in
                    HStack(spacing: 12) {
                        ForEach(iconRow.icons) { icon in
                            AppIconPickerButton(showingPurchaseView: $showingPurchaseView, appIcon: icon, subscriptionLevel: appIconContext.level)
                        }
                    }
                    .padding(.horizontal, 12)
                }
            }
            .padding(.vertical, 12)
            .listRowInsets(EdgeInsets())
            .scrollContentBackground(.hidden)
        } header: {
            Text(section.title)
                .foregroundColor(.primary)
        } footer: {
            EmptyView()
        }
    }
}
