//
//  AboutViewController.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 6/22/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import "AboutViewController.h"
#import "SWRevealViewController.h"
#import "NSURLRequest+Extended.h"
@import GoogleMobileAds;
@import FirebaseRemoteConfig;

NSString *const kTwitterURL = @"";
NSString *const kWWWURL = @"http://nycappstudio.com";
NSString *const kFacebookURL = @"https://www.facebook.com/innotechapp";

@interface AboutViewController ()

@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setMenuVC];
    
    NSString *version =[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    
    self.versionLabel.text = [NSString stringWithFormat:@"Version %@", version];
    
    //1
//    FIRRemoteConfig *remoteConfig = [FIRRemoteConfig remoteConfig];
//    FIRRemoteConfigSettings *remoteConfigSettings = [[FIRRemoteConfigSettings alloc] initWithDeveloperModeEnabled:YES];
//    remoteConfig.configSettings = remoteConfigSettings;
//    [remoteConfig setDefaultsFromPlistFileName:@"RemoteConfigDefaults"];
    
    //2
    
//    [remoteConfig fetchWithExpirationDuration:5 completionHandler:^(FIRRemoteConfigFetchStatus status, NSError *error) {
//        if (status == FIRRemoteConfigFetchStatusSuccess) {
//            NSLog(@"Config fetched!");
//            [remoteConfig activateFetched];
////            [self displayPrice];
//            NSString *experiment1_variant = [remoteConfig[@"localNotificationText"] stringValue];
//            NSLog(@"RANDOM NOTIFICATION: %@", experiment1_variant);
//            
//        } else {
//            NSLog(@"Config not fetched");
//            NSLog(@"Error %@", error);
//        }
//    }];
//    
}

-(void) setMenuVC {
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.menuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (IBAction)openTwitter:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: kTwitterURL]];
}
- (IBAction)openWebsite:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: kWWWURL]];
}
- (IBAction)openFacebook:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: kFacebookURL]];
}


@end
