//
//  TapticFeedback.swift
//  AppToolsMobile
//
//  Created by Lukas on 20.12.17.
//  Copyright © 2017 Lukas. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

@available(iOS 10.0, *)
public class TapticFeedback {
    public static let shared = TapticFeedback()
    
    var enabled: Bool = true
    
#if os(iOS)
    private let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    private let impactMedium = UIImpactFeedbackGenerator(style: .medium)
    private let impactLight = UIImpactFeedbackGenerator(style: .light)
    private let selection = UISelectionFeedbackGenerator()
    private let notification = UINotificationFeedbackGenerator()
#endif
    
    public enum TapticFeedbackType {
        case impactHeavy
        case impactMedium
        case impactLight
        case selection
        case notificationError
        case notificationWarning
        case notificationSuccess
    }
    
    public func prepare(type: TapticFeedbackType) {
        guard enabled else {
            return
        }
        
#if os(iOS)
        switch type {
        case .impactHeavy:
            impactHeavy.prepare()
            
        case .impactMedium:
            impactMedium.prepare()
            
        case .impactLight:
            impactLight.prepare()
            
        case .selection:
            selection.prepare()
            
        case .notificationError, .notificationWarning, .notificationSuccess:
            notification.prepare()
        }
#endif
    }
    
    public func trigger(type: TapticFeedbackType) {
        guard enabled else {
            return
        }
        
#if os(iOS)
        switch type {
        case .impactHeavy:
            impactHeavy.impactOccurred()
            
        case .impactMedium:
            impactMedium.impactOccurred()
            
        case .impactLight:
            impactLight.impactOccurred()
            
        case .selection:
            selection.selectionChanged()
            
        case .notificationError:
            notification.notificationOccurred(.error)
            
        case .notificationWarning:
            notification.notificationOccurred(.warning)
            
        case .notificationSuccess:
            notification.notificationOccurred(.success)
            
        }
#endif
    }
}
