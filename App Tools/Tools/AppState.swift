//
//  AppState.swift
//  Dozzzer
//
//  Created by Lukas on 4/30/17.
//  Copyright © 2017 Lukas Burgstaller. All rights reserved.
//

import Foundation

public final class AppStateManager {

    static public private(set) var shared = AppStateManager()
    private var activeCount: Int = 0
    private let notificationCenter = NotificationCenter.default

    public func startReceivingEvents() {
        if activeCount == 0 {
            notificationCenter.addObserver(self, selector: #selector(enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
            notificationCenter.addObserver(self, selector: #selector(exitForeground), name: UIApplication.didEnterBackgroundNotification, object: nil)

            notificationCenter.addObserver(self, selector: #selector(enterForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
            notificationCenter.addObserver(self, selector: #selector(exitForeground), name: UIApplication.willResignActiveNotification, object: nil)
        }
        activeCount += 1
    }

    public func stopReceivingEvents() {
        if activeCount > 0 {
            activeCount -= 1
            notificationCenter.removeObserver(self)
        }
    }


    public private(set) var isInForeground = true
    @objc func enterForeground() {
        isInForeground = true
    }

    @objc func exitForeground() {
        isInForeground = false
    }

}
