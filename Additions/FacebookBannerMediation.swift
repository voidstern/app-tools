//
//  AdMobNativeExpressBanner.swift
//  Multi Timers 2
//
//  Created by Lukas Burgstaller on 26/10/2016.
//  Copyright © 2016 Lukas Burgstaller. All rights reserved.
//

import Foundation
import GoogleMobileAds
import FBAudienceNetwork

@objc(FacebookBanner)
class FacebookBanner: NSObject, GADCustomEventBanner, FBAdViewDelegate  {

    weak var rootViewController: UIViewController?
    weak var delegate: GADCustomEventBannerDelegate?
    var facebookAd: FBAdView?

    override init() {
        rootViewController = UIApplication.shared.keyWindow?.rootViewController
    }

    func requestAd(_ adSize: GADAdSize, parameter serverParameter: String?, label serverLabel: String?, request: GADCustomEventRequest) {
        facebookAd = FBAdView(placementID: serverParameter ?? "1683092301985920_1683109445317539", adSize: kFBAdSizeHeight50Banner, rootViewController: rootViewController)
        facebookAd?.delegate = self
        facebookAd?.loadAd()
    }

    func adViewDidLoad(_ adView: FBAdView) {
        delegate?.customEventBanner(self, didReceiveAd: adView)
    }

    func adViewDidClick(_ adView: FBAdView) {
        delegate?.customEventBannerWasClicked(self)
    }

    func adViewDidFinishHandlingClick(_ adView: FBAdView) {

    }

    func adView(_ adView: FBAdView, didFailWithError error: Error) {
        delegate?.customEventBanner(self, didFailAd: error)
    }
}
