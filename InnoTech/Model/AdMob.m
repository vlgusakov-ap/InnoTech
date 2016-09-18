//
//  AdMob.m
//  DiscoverTech
//
//  Created by Vladyslav Gusakov on 7/3/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import "AdMob.h"

@interface AdMob() 

@property (strong, nonatomic) GADNativeExpressAdView *nativeExpressAdView; // mobile ads
@property (strong, nonatomic) GADRequest *request;
@property (nonatomic, strong) id<AdMobDelegate> delegate;

@end

@implementation AdMob

+ (id) sharedInstance {
    static AdMob *sharedAdMob = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAdMob = [[self alloc] init];
    });
    return sharedAdMob;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.nativeExpressAdView = [[GADNativeExpressAdView alloc] initWithAdSize:GADAdSizeFromCGSize(CGSizeMake(0, 100))];
        self.nativeExpressAdView.adUnitID = kAdUnitID;
        self.nativeExpressAdView.delegate = self;
        
        self.request = [GADRequest request];
        self.request.testDevices = @[ kGADSimulatorID, kTestNewiPhone6SPlus];
    }
    
    return self;
}

- (void) configureViewController: (UIViewController*) viewController {
    self.delegate = (id) viewController;
    
    if (self.nativeExpressAdView.rootViewController == nil) {
        self.nativeExpressAdView.rootViewController = viewController;
    }
    
    [self.nativeExpressAdView loadRequest:self.request];
}

- (GADNativeExpressAdView *) getAd {
    return self.nativeExpressAdView;
}

- (void) nativeExpressAdViewDidReceiveAd:(GADNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"AD RECEIVED");
    [self.delegate displayAd:true];
}
- (void)nativeExpressAdView:(GADNativeExpressAdView *)nativeExpressAdView
                didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"ERROR: %@", error.localizedDescription);
}

@end
