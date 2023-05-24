//
//  Interstitial.swift
//  News
//
//  Created by Asil Arslan on 22.12.2020.
//

import SwiftUI
import GoogleMobileAds
import UIKit


    
final class Interstitial:NSObject, GADFullScreenContentDelegate{
    var interstitial:GADInterstitialAd?
    
    override init() {
        super.init()
        LoadInterstitial()
    }
    
    func LoadInterstitial(){
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:INTERSTITIAL_AD_ID,
                                    request: request,
                          completionHandler: { [self] ad, error in
                            if let error = error {
                              print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                              return
                            }
                            interstitial = ad
                            interstitial?.fullScreenContentDelegate = self
                          }
        )
        
//        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [TEST_DEVICE];
    }
    
    func showAd(){

        
        if interstitial != nil {
            let root = UIApplication.shared.windows.first?.rootViewController

            interstitial?.present(fromRootViewController: root!)
            LoadInterstitial()
         } else {
           print("Ad wasn't ready")
         }
    }

    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
      print("Ad did fail to present full screen content.")
    }

    /// Tells the delegate that the ad presented full screen content.
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      print("Ad did present full screen content.")
    }

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      print("Ad did dismiss full screen content.")
    }
}


