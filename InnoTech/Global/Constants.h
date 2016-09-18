//
//  Constants.h
//  InnoTech
//
//  Created by Vladyslav Gusakov on 6/15/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

@import UIKit;
@import SDWebImage;

typedef NS_ENUM(NSInteger, PremiumStatus) {
    Inactive = 0,
    Active = 1
};

static NSInteger kAdHeight = 100;
static NSInteger kProductHeight = 160;

//itunes connect
static NSString *kiTunesPremiumProductID = @"innotech_one_month_premium";
static NSString *kiTunesPremiumSharedSecret = @"295f09dde82b43998a22ea6a8f6c7042";

static NSString *kHelpShiftApiKey = @"b282651e95bddabb072b6005cdd101b7";
static NSString *kHelpShiftDomainName = @"innotech.helpshift.com";
static NSString *kHelpShiftAppID = @"innotech_platform_20160515071736818-9f828d5b71f9536";
// admob
static NSString *kAdUnitID = @"ca-app-pub-1112303285099080/8454796052";
static NSString *kTestNewiPhone6SPlus = @"64662f20d905a8f4f061633f71be54a2";

static NSString *pname = @"name";
static NSString *pdescr = @"descr";
static NSString *pimageUrl = @"image_url";
static NSString *purl = @"url";
static NSString *pcat = @"categories";

static NSString *kFacebookName = @"fbName";
static NSString *kFacebookImage = @"fbImage";
static NSString *kFacebookEmail = @"fbEmail";

static NSString *kCommentName = @"name";
static NSString *kCommentImage = @"img";
static NSString *kCommentText = @"comment";
static NSString *kCommentUserID = @"userID";

static NSString *kProductsChild = @"products";
static NSString *kCommentssChild = @"comments";

static NSString *kSectionFeatured = @"featured";

static NSString *kImageSettings = @"settings";
static NSString *kImageRefine = @"refine";

static NSString *kFavorites = @"favorites";

static NSString *kPremiumStatus = @"premiumStatus";
