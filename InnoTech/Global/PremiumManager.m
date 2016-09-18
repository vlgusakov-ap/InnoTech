//
//  PremiumManager.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 9/17/16.
//  Copyright © 2016 SwiftSell. All rights reserved.
//

#import "PremiumManager.h"
#import "IAPShare.h"

NSString* const kPremiumStatus = @"premiumStatus";

@interface PremiumManager ()

@end

@implementation PremiumManager

+ (id)sharedManager {
    static PremiumManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        [self initIAP];
        self.premiumStatus = [[NSUserDefaults standardUserDefaults] integerForKey:kPremiumStatus];
    }
    return self;
}

- (void) enablePremium: (BOOL) enable {
    [[NSUserDefaults standardUserDefaults] setBool:enable forKey:kPremiumStatus];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) initIAP
{
    //init iap
    if (![IAPShare sharedHelper].iap) {
        NSSet* dataSet = [[NSSet alloc] initWithObjects:kiTunesPremiumProductID, nil];
        
        [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    }
    
#warning Change to production
    [IAPShare sharedHelper].iap.production = NO;
    
    if ([[IAPShare sharedHelper].iap isPurchasedProductsIdentifier:kiTunesPremiumProductID])
    {
        [self enablePremium:YES];
    }
    else
    {
        [self enablePremium:NO];
    }
    
}

@end
