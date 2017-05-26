//
//  AdMobNativeExpressBanner.swift
//  Multi Timers 2
//
//  Created by Lukas Burgstaller on 26/10/2016.
//  Copyright © 2016 Lukas Burgstaller. All rights reserved.
//

import Foundation
import GoogleMobileAds

@objc(VSCAdmobNativeExpressBanner)
class VSCAdmobNativeExpressBanner: NSObject, GADCustomEventBanner, GADNativeExpressAdViewDelegate  {

    weak var rootViewController: UIViewController?
    weak var delegate: GADCustomEventBannerDelegate?
    var expressView: GADNativeExpressAdView?

    override init() {
        rootViewController = UIApplication.shared.keyWindow?.rootViewController
    }

    func requestAd(_ adSize: GADAdSize, parameter serverParameter: String?, label serverLabel: String?, request: GADCustomEventRequest) {
        expressView = GADNativeExpressAdView(adSize: adSize)
        expressView?.adUnitID = serverParameter
        expressView?.delegate = self
        expressView?.rootViewController = rootViewController

        let request = GADRequest()
        request.testDevices = ["19626bafc3ae9b22fa2d8775c9e3b075"]
        expressView?.load(request)
    }

    func nativeExpressAdViewDidReceiveAd(_ nativeExpressAdView: GADNativeExpressAdView) {
        if let expressView = expressView {
            delegate?.customEventBanner(self, didReceiveAd: expressView)
        }
    }

    func nativeExpressAdView(_ nativeExpressAdView: GADNativeExpressAdView, didFailToReceiveAdWithError error: GADRequestError) {
        delegate?.customEventBanner(self, didFailAd: error)
    }

    func nativeExpressAdViewWillPresentScreen(_ nativeExpressAdView: GADNativeExpressAdView) {
        delegate?.customEventBannerWasClicked(self)
    }

    func nativeExpressAdViewWillLeaveApplication(_ nativeExpressAdView: GADNativeExpressAdView) {
        delegate?.customEventBannerWasClicked(self)
    }
}
