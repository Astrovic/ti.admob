/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2010-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiUIView.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface TiAdmobView : TiUIView <GADBannerViewDelegate, GADFullScreenContentDelegate> {
  GADBannerView *bannerView;
  GADRewardedAd *rewardedAd;
  GADInterstitialAd *interstitialAd;
  GADAppOpenAd *appOpenAd;

  NSString *adUnitId;
}

- (void)initialize;

- (void)showInterstitial;

- (void)showRewardedVideo;

- (void)requestAppOpenAd;

- (void)showAppOpenAd;

- (void)setAdUnitId_:(id)value;

- (void)setKeywords_:(id)value;

- (void)setAdBackgroundColor_:(id)value;

- (void)setTagForChildDirectedTreatment_:(id)value;

- (void)setTagForUnderAgeOfConsent_:(id)value;

- (void)setMaxAdContentRating_:(NSString *)maxAdContentRating;

- (void)setRequestAgent_:(id)value;

- (void)setContentURL_:(id)value;

- (void)setExtras_:(id)args;

- (GADBannerView *)bannerView;

- (void)loadRewardedVideoWithAdUnitID:(NSString *)adUnitID;

#pragma mark Removed APIs

- (void)setPublisherId_:(id)value;

- (void)setTesting_:(id)value;

- (void)setGender_:(id)value;

- (void)setDateOfBirth_:(id)value;

- (void)setTestDevices_:(id)value;

- (void)setLocation_:(id)args;

@end
