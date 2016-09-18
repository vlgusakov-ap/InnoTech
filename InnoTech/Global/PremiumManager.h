//
//  PremiumManager.h
//  InnoTech
//
//  Created by Vladyslav Gusakov on 9/17/16.
//  Copyright © 2016 SwiftSell. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSInteger, PremiumStatus) {
    Inactive = 0,
    Active = 1
};

//itunes connect
static NSString* const kiTunesPremiumProductID = @"innotech_one_month_premium";
static NSString* const kiTunesPremiumSharedSecret = @"295f09dde82b43998a22ea6a8f6c7042";

@interface PremiumManager : NSObject

//properties
@property (nonatomic) PremiumStatus premiumStatus;

//func
+ (id) sharedManager;
- (void) enablePremium: (BOOL) enable;

@end
