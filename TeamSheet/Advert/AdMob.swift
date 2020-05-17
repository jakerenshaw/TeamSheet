//
//  AdMob.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 16/05/2020.
//  Copyright © 2020 Jake Renshaw. All rights reserved.
//

import Foundation
import GoogleMobileAds

class AdMob: NSObject {

    let rootViewController: UIViewController
    var nativeAdView: GADUnifiedNativeAdView?
    var adLoader: GADAdLoader?
    var bannerView: GADBannerView?
    var loadedBannerView: GADBannerView?
    var nativeAdvertCompletion: ((GADUnifiedNativeAdView) -> Void)?
    var bannerAdvertCompletion: ((GADBannerView) -> Void)?
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        super.init()
        GADMobileAds.sharedInstance().start { (_) in
            self.loadNativeAdvert()
            self.loadBannerAdvert()
        }
    }
    
    func loadNativeAdvert() {
        adLoader = GADAdLoader(adUnitID: "ca-app-pub-3940256099942544/3986624511", rootViewController: rootViewController, adTypes: [.unifiedNative], options: nil)
        adLoader?.delegate = self
        adLoader?.load(GADRequest())
    }
    
    func loadBannerAdvert() {
        self.bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        self.bannerView?.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        self.bannerView?.rootViewController = self.rootViewController
        self.bannerView?.delegate = self
        self.bannerView?.load(GADRequest())
    }
    
    func displayNativeAdvert(containerView: UIView) {
        let nativeAdvertCompletion = { (unifiedNativeAdView: GADUnifiedNativeAdView) in
            containerView.addSubview(unifiedNativeAdView)
            unifiedNativeAdView.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        }
        if let nativeAdView = self.nativeAdView {
            nativeAdvertCompletion(nativeAdView)
        } else {
            self.nativeAdvertCompletion = nativeAdvertCompletion
        }
    }
    
    func closeNativeAdvert() {
        self.nativeAdView?.removeFromSuperview()
        self.nativeAdView = nil
        self.adLoader = nil
    }
    
    func displayBannerAdvert(bannerContainerView: UIView) {
        let bannerAdvertCompletion = { (loadedBannerAdView: GADBannerView) in
            bannerContainerView.addSubview(loadedBannerAdView)
            loadedBannerAdView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        if let loadedBannerView = self.loadedBannerView {
            bannerAdvertCompletion(loadedBannerView)
        } else {
            self.bannerAdvertCompletion = bannerAdvertCompletion
        }
    }
}

extension AdMob: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.loadedBannerView = bannerView
        if let bannerAdvertCompletion = self.bannerAdvertCompletion {
            bannerAdvertCompletion(bannerView)
            self.bannerAdvertCompletion = nil
        }
    }
}

extension AdMob: GADUnifiedNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        nativeAd.delegate = self
        let nibView = Bundle.main.loadNibNamed("NativeAdView", owner: nil, options: nil)?.first
        guard let nativeAdView = nibView as? GADUnifiedNativeAdView else {
          return
        }
        nativeAdView.nativeAd = nativeAd
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        nativeAdView.bodyView?.isHidden = nativeAd.body == nil
        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil
        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil
        (nativeAdView.starRatingView as? UIImageView)?.image = StarRatingImages.imageOfStars(starRating: nativeAd.starRating)
        nativeAdView.starRatingView?.isHidden = nativeAd.starRating == nil
        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
        nativeAdView.storeView?.isHidden = nativeAd.store == nil
        (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
        nativeAdView.priceView?.isHidden = nativeAd.price == nil
        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
        nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
        self.nativeAdView = nativeAdView
        if let nativeAdvertCompletion = self.nativeAdvertCompletion {
            nativeAdvertCompletion(nativeAdView)
            self.nativeAdvertCompletion = nil
        }
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        //
    }
}

extension AdMob: GADUnifiedNativeAdDelegate {
    func nativeAdDidRecordImpression(_ nativeAd: GADUnifiedNativeAd) {
      // The native ad was shown.
    }

    func nativeAdDidRecordClick(_ nativeAd: GADUnifiedNativeAd) {
      // The native ad was clicked on.
    }

    func nativeAdWillPresentScreen(_ nativeAd: GADUnifiedNativeAd) {
      // The native ad will present a full screen view.
    }

    func nativeAdWillDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
      // The native ad will dismiss a full screen view.
    }

    func nativeAdDidDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
      // The native ad did dismiss a full screen view.
    }

    func nativeAdWillLeaveApplication(_ nativeAd: GADUnifiedNativeAd) {
      // The native ad will cause the application to become inactive and
      // open a new application.
    }
}
