//
//  AdMob.h
//  DiscoverTech
//
//  Created by Vladyslav Gusakov on 7/3/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
@import GoogleMobileAds;

@class MainViewController;

@protocol AdMobDelegate <NSObject>
- (void) displayAd: (BOOL) display;
@end

@interface AdMob : NSObject <GADNativeExpressAdViewDelegate>

@property (nonatomic, assign) BOOL receivedAd;
+ (id) sharedInstance;

- (void) configureViewController: (UIViewController*) viewController;
- (GADNativeExpressAdView *) getAd;

@end
