//
//  FacebookLogin.h
//  InnoTech
//
//  Created by Vladyslav Gusakov on 9/18/16.
//  Copyright © 2016 SwiftSell. All rights reserved.
//

@import UIKit;
@class FBSDKLoginManagerLoginResult;

static NSString* const kFacebookLogged = @"fbLogged";

@protocol FacebookManagerDelegate <NSObject>
- (void) facebookManagerDidLoginWithResult: (FBSDKLoginManagerLoginResult *)result error:(NSError*)error;
- (void) facebookManagerDidLogOut;
@end

@interface FacebookManager : NSObject
- (instancetype) initWithDelegate:(id) delegate fromViewController:(UIViewController*)viewController;
- (void) login;
- (void) logout;
@end
