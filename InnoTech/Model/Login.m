//
//  FacebookUtils.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 6/24/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import "Login.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@import FirebaseAuth;
#import "HelpShiftCore.h"
#import "HelpshiftSupport.h"

@implementation Login {
    NSUserDefaults *defaults;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void) loginWithFacebook {
    NSString *isLoggedIn = [defaults objectForKey:@"fbLogged"];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    if ([isLoggedIn isEqualToString:@"YES"]) {
        [self facebookSignOut];
        
    } else {
        [login
         logInWithReadPermissions: @[@"public_profile", @"email"]
         fromViewController:self.delegate
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             if (error) {
                 NSLog(@"Process error");
             } else if (result.isCancelled) {
                 NSLog(@"Cancelled");
             } else {
                 NSLog(@"Logged in");
                 NSLog(@"%@", result.token);

                 [self loginWithFirebase];
             }
         }];
    }
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
             [defaults setObject:@"YES" forKey:@"fbLogged"];
             
             [defaults synchronize];
             
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
                                      
                                      [self.delegate presentViewController:alertController animated:YES completion:nil];
                                      
                                      
                                      if (!error) {
                                          NSLog(@"signed out");
                                      }
                                      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                          [self facebookConnected:false];
                                      }];
                                      
                                  } else {
                                      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                          [self facebookConnected:true];
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
                
                [self.delegate presentViewController:alertController animated:YES completion:nil];
                
                
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

- (void) facebookSignOut {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    [defaults setObject:@"NO" forKey:@"fbLogged"];
    NSLog(@"logged out");
    
    [defaults setObject:nil forKey:@"fbImage"];
    [defaults setObject:nil forKey:@"fbName"];
    [defaults setObject:nil forKey:@"fbEmail"];
    
    [defaults synchronize];
    
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    
    if (!error) {
        NSLog(@"signed out");
    }
    
    [self facebookConnected:false];
}

- (void) facebookConnected: (BOOL)logged {
    
    if (logged) {
        [self.facebookButton setTitle:@"Connected" forState:UIControlStateNormal];
        [self.facebookButton setBackgroundImage:[UIImage imageNamed:@"green1"] forState:UIControlStateNormal];
    } else {
        [self.facebookButton setTitle:@"Disconnected" forState:UIControlStateNormal];
        [self.facebookButton setBackgroundImage:[UIImage imageNamed:@"red1"] forState:UIControlStateNormal];
    }
}

- (void) checkStatus {
    
    NSString *facebookLogged = @"fbLogged";
    
    if ([[defaults objectForKey:facebookLogged] isEqualToString:@"YES"]) {
        [self.facebookButton setTitle:@"Connected" forState:UIControlStateNormal];
        [self.facebookButton setBackgroundImage:[UIImage imageNamed:@"green1"] forState:UIControlStateNormal];
    } else {
        [self.facebookButton setTitle:@"Disconnected" forState:UIControlStateNormal];
        [self.facebookButton setBackgroundImage:[UIImage imageNamed:@"red1"] forState:UIControlStateNormal];
    }

}

@end
