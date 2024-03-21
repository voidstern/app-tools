//
//  File.swift
//  
//
//  Created by Lukas Burgstaller on 21.03.24.
//

import Foundation
//import UIKit

//public class UpdateNewsManager {
//    private let elements: [UpdateNewsViewController.ListItem]
//    private let colors: UpdateNewsViewController.Colors
//    private let configuration: UpdateNewsViewController.Configuration
//    private let displayBuildVersion: String
//    
//    private let primaryAction: () -> ()
//    private let secondaryAction: () -> ()
//    
//    public init(elements: [UpdateNewsViewController.ListItem], colors: UpdateNewsViewController.Colors, configuration: UpdateNewsViewController.Configuration, displayBuildVersion: String, primaryAction: @escaping () -> Void, secondaryAction: @escaping () -> Void) {
//        self.elements = elements
//        self.colors = colors
//        self.configuration = configuration
//        self.displayBuildVersion = displayBuildVersion
//        self.primaryAction = primaryAction
//        self.secondaryAction = secondaryAction
//    }
//    
//    private var currentBuild: String? {
//        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
//    }
//    
//    private var installAge: Int {
//        return UserSettings.shared.installAge
//    }
//    
//    private var lastBuild: String {
//        get { UserSettings.shared.string(key: .updateNewsVersion) }
//        set { UserSettings.shared.set(value: newValue, key: .updateNewsVersion) }
//    }
//    
//    private var needsDisplay: Bool {
//        return currentBuild != lastBuild && currentBuild == displayBuildVersion && installAge > 0
//    }
//    
//    public func displayIfNeeded(on viewController: UIViewController) {
//        if needsDisplay {
//            let updateNewsView = UpdateNewsViewController()
//            updateNewsView.elements = elements
//            updateNewsView.colors = colors
//            updateNewsView.configuration = configuration
//            updateNewsView.delegate = self
//            viewController.present(updateNewsView, animated: true)
//        }
//        
//        lastBuild = currentBuild ?? ""
//    }
//}
//
//extension UpdateNewsManager: UpdateNewsViewControllerDelegate {
//    public func whatsNewViewDidPressPrimaryButton(_ whatsNewView: UpdateNewsViewController) {
//        primaryAction()
//        whatsNewView.dismiss(animated: true)
//    }
//    
//    public func whatsNewViewDidPressSecondaryButton(_ whatsNewView: UpdateNewsViewController) {
//        secondaryAction()
//        whatsNewView.dismiss(animated: true)
//    }
//}
//
//extension UserSettings.Setting {
//    public static var updateNewsVersion: UserSettings.Setting {
//        return UserSettings.Setting(identifier: "update_news_version")
//    }
//}
//
