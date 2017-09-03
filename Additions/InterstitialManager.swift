//
//  InterstitialManager.swift
//  Tidur
//
//  Created by Lukas on 02/09/2017.
//  Copyright © 2017 Lukas Burgstaller. All rights reserved.
//

import Foundation
import AppToolsMobile

extension UserSettings.Setting {
    public static var lastInterstitialDate: UserSettings.Setting {
        return UserSettings.Setting(identifier: "last_interstital_date")
    }
}

protocol InterstitialManagerDelegate: class {
    func shouldDisplayDialog(interstitialManager: InterstitialManager) -> Bool
    func upgradeButtonHit(interstitialManager: InterstitialManager)
    func shouldDisplayAds(interstitialManager: InterstitialManager) -> Bool
}

public class InterstitialManager: NSObject {
    let requiredDays: Int
    let viewController: UIViewController
    let interval: TimeInterval

    var interstitial: GADInterstitial?
    var triggered: Bool = false

    weak var delegate: InterstitialManagerDelegate? {
        didSet {
            loadInterstitial()
        }
    }

    public init(requiredDays: Int, interval: TimeInterval, viewController: UIViewController) {
        self.requiredDays = requiredDays
        self.viewController = viewController
        self.interval = interval

        super.init()

        loadInterstitial()
    }

    public func triggerEvent() {
        let days = UserSettings.shared.installAge

        let lastInterstitial = UserSettings.shared.double(key: .lastInterstitialDate) as TimeInterval
        let timePassed = Date().timeIntervalSince1970 - lastInterstitial

        if days > requiredDays && timePassed > interval  {
            showInterstitialDialog()
        }
    }

    private func loadInterstitial() {
        guard delegate?.shouldDisplayAds(interstitialManager: self) ?? false else {
            return
        }

        if let interstitial = interstitial, interstitial.isReady {
            return
        }
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-8521069083698731/4573539917")
        interstitial?.delegate = self

        let request = GADRequest()
        request.testDevices = ["113c95c37d11ce0b3418c6908f3d6418"];
        interstitial?.load(request)
    }

    private func showInterstitialDialog() {
        guard delegate?.shouldDisplayAds(interstitialManager: self) ?? false else {
            return
        }

        guard interstitial?.isReady ?? false else {
            triggered = true
            return
        }

        triggered = false

        let alert = UIAlertController(title: "Upgrade", message: "Ads help to provide a free version of this app.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Upgrade", style: .default, handler: { (_) in
            self.delegate?.upgradeButtonHit(interstitialManager: self)
        }))

        alert.addAction(UIAlertAction(title: "Not now", style: .default, handler: { (_) in
            self.showInterstitial()
        }))

        viewController.present(alert, animated: true, completion: nil)
    }

    private func showInterstitial() {
        guard delegate?.shouldDisplayAds(interstitialManager: self) ?? false else {
            return
        }

        UserSettings.shared.set(value: Date().timeIntervalSince1970, key: .lastInterstitialDate)
        interstitial?.present(fromRootViewController: viewController)
    }
}

extension InterstitialManager: GADInterstitialDelegate {
    public func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        if triggered {
            showInterstitialDialog()
        }
    }

    public func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        loadInterstitial()
    }

    public func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("Interstitial failed to present")
    }

    public func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("Interstitial failed to load")
    }
}
