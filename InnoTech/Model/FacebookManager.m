//
//  FacebookLogin.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 9/18/16.
//  Copyright © 2016 SwiftSell. All rights reserved.
//

#import "FacebookManager.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface FacebookManager ()
@property (nonatomic, weak) UIViewController<FacebookManagerDelegate>* delegate;
@property (nonatomic, weak) UIViewController* fromViewController;

@end

@implementation FacebookManager

#pragma mark - Public

- (instancetype) initWithDelegate:(id) delegate fromViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        _delegate = delegate;
        _fromViewController = viewController;
    }
    return self;
}




- (void) login
{
    NSString *isLoggedIn = [[NSUserDefaults standardUserDefaults] objectForKey:kFacebookLogged];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    if ([isLoggedIn isEqualToString:@"YES"])
    {
        [self logout];
        
    } else {
        [login
         logInWithReadPermissions: @[@"public_profile", @"email"]
         fromViewController:self.fromViewController
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
        {
            [self.delegate facebookManagerDidLoginWithResult:result error:error];
        }];
    }
    
}

- (void) logout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    [defaults setObject:@"NO" forKey:kFacebookLogged];
    NSLog(@"logged out");
    
    [defaults setObject:nil forKey:@"fbImage"];
    [defaults setObject:nil forKey:@"fbName"];
    [defaults setObject:nil forKey:@"fbEmail"];
    
    [defaults synchronize];
    
    [self.delegate facebookManagerDidLogOut];
    
    
}

#pragma mark - Private



@end
