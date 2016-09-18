//
//  FacebookUtils.h
//  InnoTech
//
//  Created by Vladyslav Gusakov on 6/24/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

@import UIKit;
@class ITUser;

typedef NS_ENUM(NSInteger, FacebookAction) {
    LoggedOut = 0,
    LoggedIn = 1
};

@protocol LoginManagerDelegate <NSObject>
- (void) loginManagerDidPerformFacebookAction:(FacebookAction)action;
@end

@interface LoginManager : NSObject
+ (id) sharedManager;

//facebook login
- (void) loginWithFacebook:(id) delegate;
- (void) checkFacebookLoginStatus;

//firebase login
- (void) loginWithFirebase;
- (void) reauthWithFirebase;

@property (nonatomic, strong) id<LoginManagerDelegate> delegate;
@property (nonatomic, strong) ITUser *currentUser;

@end
