//
//  InterstitialManager.swift
//  Tidur
//
//  Created by Lukas on 02/09/2017.
//  Copyright © 2017 Lukas Burgstaller. All rights reserved.
//

import Foundation
import AppToolsMobile
import GoogleMobileAds
import FBAudienceNetwork

@objc(FacebookInterstitial)
class FacebookInterstitial: NSObject, GADCustomEventInterstitial, FBInterstitialAdDelegate  {
    weak var delegate: GADCustomEventInterstitialDelegate?
    var facebookAd: FBInterstitialAd?

    func requestAd(withParameter serverParameter: String?, label serverLabel: String?, request: GADCustomEventRequest) {
        FBAdSettings.addTestDevice(FBAdSettings.testDeviceHash())

        facebookAd = FBInterstitialAd(placementID: serverParameter ?? "216834628835716_261798537672658")
        facebookAd?.delegate = self
        facebookAd?.load()
    }

    func present(fromRootViewController rootViewController: UIViewController) {
        facebookAd?.show(fromRootViewController: rootViewController)
    }

    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        delegate?.customEventInterstitialDidReceiveAd(self)
    }

    func interstitialAdDidClick(_ interstitialAd: FBInterstitialAd) {
        delegate?.customEventInterstitialWasClicked(self)
    }

    func interstitialAdDidClose(_ interstitialAd: FBInterstitialAd) {
        delegate?.customEventInterstitialDidDismiss(self)
    }

    func interstitialAdWillClose(_ interstitialAd: FBInterstitialAd) {
        delegate?.customEventInterstitialWillDismiss(self)
    }

    func interstitialAd(_ interstitialAd: FBInterstitialAd, didFailWithError error: Error) {
        delegate?.customEventInterstitial(self, didFailAd: error)
    }
}



