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
    var nativeAd: GADUnifiedNativeAd?
    var containerView: UIView!
    var nativeAdView: GADUnifiedNativeAdView?
    var bannerContainerView: UIView!
    var adLoader: GADAdLoader?
    var gadBannerView: GADBannerView?
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        super.init()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    func loadAdvert(containerView: UIView) {
        self.containerView = containerView
        adLoader = GADAdLoader(adUnitID: "ca-app-pub-3940256099942544/3986624511", rootViewController: rootViewController, adTypes: [.unifiedNative], options: nil)
        adLoader?.delegate = self
        adLoader?.load(GADRequest())
    }
    
    func closeAdvert() {
        self.nativeAdView?.removeFromSuperview()
        self.nativeAdView = nil
        self.adLoader = nil
    }
    
    func addBanner(bannerContainerView: UIView) {
        self.bannerContainerView = bannerContainerView
        gadBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        gadBannerView?.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        gadBannerView?.rootViewController = self.rootViewController
        gadBannerView?.delegate = self
        gadBannerView?.load(GADRequest())
    }
    
    func imageOfStars(starRating: NSDecimalNumber?) -> UIImage? {
      guard let rating = starRating?.doubleValue else {
        return nil
      }
      if rating >= 5 {
        return UIImage(named: "stars_5")
      } else if rating >= 4.5 {
        return UIImage(named: "stars_4_5")
      } else if rating >= 4 {
        return UIImage(named: "stars_4")
      } else if rating >= 3.5 {
        return UIImage(named: "stars_3_5")
      } else {
        return nil
      }
    }
}

extension AdMob: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.bannerContainerView.addSubview(bannerView)
        bannerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      print("adViewWillLeaveApplication")
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
        (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(starRating: nativeAd.starRating)
        nativeAdView.starRatingView?.isHidden = nativeAd.starRating == nil
        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
        nativeAdView.storeView?.isHidden = nativeAd.store == nil
        (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
        nativeAdView.priceView?.isHidden = nativeAd.price == nil
        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
        nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
        containerView.addSubview(nativeAdView)
        nativeAdView.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        self.nativeAdView = nativeAdView
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
