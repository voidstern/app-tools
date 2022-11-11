//
//  UpdateNewsManager.swift
//  Dozzzer
//
//  Created by Lukas Burgstaller on 11.11.22.
//  Copyright © 2022 Lukas Burgstaller. All rights reserved.
//

import Foundation
import AppTools
import UIKit

public class UpdateNewsManager {
    let elements: [UpdateNewsViewController.ListItem]
    let colors: UpdateNewsViewController.Colors
    let configuration: UpdateNewsViewController.Configuration
    let displayBuildVersion: String
    
    let primaryAction: () -> ()
    let secondaryAction: () -> ()
    
    init(elements: [UpdateNewsViewController.ListItem], colors: UpdateNewsViewController.Colors, configuration: UpdateNewsViewController.Configuration, displayBuildVersion: String, primaryAction: @escaping () -> Void, secondaryAction: @escaping () -> Void) {
        self.elements = elements
        self.colors = colors
        self.configuration = configuration
        self.displayBuildVersion = displayBuildVersion
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
    
    private var currentBuild: String? {
        return Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String
    }
    
    private var installAge: Int {
        return UserSettings.shared.installAge
    }
    
    private var lastBuild: String {
        get { UserSettings.shared.string(key: .updateNewsVersion) }
        set { UserSettings.shared.set(value: newValue, key: .updateNewsVersion) }
    }
    
    private var needsDisplay: Bool {
        return currentBuild != lastBuild && currentBuild == displayBuildVersion && installAge > 0
    }
    
    public func displayIfNeeded(on viewController: UIViewController) {
        if needsDisplay {
            let updateNewsView = UpdateNewsViewController()
            updateNewsView.elements = elements
            updateNewsView.colors = colors
            updateNewsView.configuration = configuration
            updateNewsView.delegate = self
            viewController.present(updateNewsView, animated: true)
        }
        
        lastBuild = currentBuild ?? ""
    }
}

extension UpdateNewsManager: UpdateNewsViewControllerDelegate {
    public func whatsNewViewDidPressPrimaryButton(_ whatsNewView: UpdateNewsViewController) {
        primaryAction()
        whatsNewView.dismiss(animated: true)
    }
    
    public func whatsNewViewDidPressSecondaryButton(_ whatsNewView: UpdateNewsViewController) {
        secondaryAction()
        whatsNewView.dismiss(animated: true)
    }
}

extension UserSettings.Setting {
    public static var updateNewsVersion: UserSettings.Setting {
        return UserSettings.Setting(identifier: "update_news_version")
    }
}
