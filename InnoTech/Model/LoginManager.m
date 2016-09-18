//
//  FacebookUtils.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 6/24/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import "LoginManager.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@import FirebaseAuth;
#import "HelpShiftCore.h"
#import "HelpshiftSupport.h"
#import "FacebookManager.h"
#import "ITUser.h"

@interface LoginManager () <FacebookManagerDelegate>

@end

@implementation LoginManager
{
    NSUserDefaults *defaults;
}

+ (id)sharedManager
{
    static LoginManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype) init
{
    self = [super init];
    if (self) {
        defaults = [NSUserDefaults standardUserDefaults];
        self.currentUser = [[ITUser alloc] init];
    }
    return self;
}

- (void) loginWithFacebook:(id)delegate
{
    self.delegate = delegate;
    FacebookManager *facebookManager = [[FacebookManager alloc] initWithDelegate:self fromViewController:delegate];
    
    if (!self.currentUser.isLogged)
    {
        [facebookManager login];
    }
    else
    {
        [facebookManager logout];
    }
}

#pragma mark - FacebookManagerDelegate

- (void) facebookManagerDidLoginWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    if (error) {
         NSLog(@"Process error");
     } else if (result.isCancelled) {
         NSLog(@"Cancelled");
     } else {
         NSLog(@"Logged in");
         NSLog(@"%@", result.token);
         self.currentUser.isLogged = true;
         [self loginWithFirebase];
     }
}

- (void)facebookManagerDidLogOut
{
    self.currentUser.isLogged = false;
    [self.delegate loginManagerDidPerformFacebookAction:LoggedOut];
    
    NSError *error;
    [[FIRAuth auth] signOut:&error];
}

-(void) getUserData {
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"name,email,picture.type(large)" forKey:@"fields"];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                  id result, NSError *error) {
         
         if (!error) {
             NSLog(@"fetched user:%@", result);
             NSString *name = [result valueForKey:@"name"];
//             NSString *email = [NSString stringWithFormat:@"email: %@", [result valueForKey:@"email"]];
             NSString *email = [result valueForKey:@"email"];
             NSString *imageUrl = [result valueForKeyPath:@"picture.data.url"];
             
             [defaults setObject:imageUrl forKey:@"fbImage"];
             [defaults setObject:name forKey:@"fbName"];
             [defaults setObject:email forKey:@"fbEmail"];
             [defaults setObject:@"YES" forKey:kFacebookLogged];
             [defaults synchronize];

             self.currentUser.name = name;
             self.currentUser.email = email;
             self.currentUser.imageURL = imageUrl;
             
             
//             [HelpshiftCore setName:name andEmail:email];
//             [HelpshiftSupport setUserIdentifier:[FIRAuth auth].currentUser.uid];
             [HelpshiftCore loginWithIdentifier:[FIRAuth auth].currentUser.uid withName:name andEmail:email];

            
             NSLog(@"Data saved");
             
         }
         
     }];
    
}

- (void) reauthWithFirebase {
    
}

- (void) loginWithFirebase {
    FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                     credentialWithAccessToken:
                                     [FBSDKAccessToken currentAccessToken].tokenString
                                     ];
    
    NSLog(@"%@", [FBSDKAccessToken currentAccessToken].tokenString);

    
    [[FIRAuth auth] signInWithCredential:credential
                              completion:^(FIRUser *user, NSError *error) {
                                  NSLog(@"user signed in");
                                  NSString *title = [error.localizedDescription copy];
                                  
                                  NSLog(@"%@", error);
                                  
                                  if (error.code == FIRAuthErrorCodeUserNotFound) {
                                      // to do
                                  }
                                  
                                  if (error.code == FIRAuthErrorCodeUserDisabled) {
                                      NSError *error;
                                      [[FIRAuth auth] signOut:&error];
                                      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:@"Contact administration" preferredStyle:UIAlertControllerStyleAlert];
                                      
                                      UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                                      [alertController addAction:ok];
                                      
//                                      [self.delegate presentViewController:alertController animated:YES completion:nil];
                                      
                                      
                                      if (!error) {
                                          NSLog(@"signed out");
                                      }
                                      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                          [self.delegate loginManagerDidPerformFacebookAction:LoggedOut];
                                      }];
                                      
                                  } else {
                                      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                          [self.delegate loginManagerDidPerformFacebookAction:LoggedIn];
                                      }];
                                      [self getUserData];
                                      
                                  }
                              }];
    
    //    FIRUser *user = [FIRAuth auth].currentUser;
    
}

- (BOOL) fireBaseReAuth { //for newcomments  /// ??????/
    
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    if (currentUser) { // not signed to firebase, signed to fb already
        [currentUser reloadWithCompletion:^(NSError * _Nullable error) {
            if (error.code == FIRAuthErrorCodeUserDisabled) {
                NSError *error;
                [[FIRAuth auth] signOut:&error];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:error.localizedDescription message:@"Contact administration" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                
//                [self.delegate presentViewController:alertController animated:YES completion:nil];
                
                
                if (!error) {
                    NSLog(@"signed out");
                }
//                [self facebookConnected:false];
                
            }
        }];
    }
    
//    [self fireBaseLogin];
    
    return false;
}
- (void) checkFacebookLoginStatus {
    
    if ([[defaults objectForKey:kFacebookLogged] isEqualToString:@"YES"])
    {
        [self.delegate loginManagerDidPerformFacebookAction:LoggedIn];
    } else
    {
        [self.delegate loginManagerDidPerformFacebookAction:LoggedOut];
    }
}

@end
