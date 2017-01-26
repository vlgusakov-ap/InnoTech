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
@import SafariServices;

NSString *const kTwitterURL = @"";
NSString *const kWWWURL = @"http://nycappstudio.com";
NSString *const kFacebookURL = @"https://www.facebook.com/innotechapp";

@interface AboutViewController () <SFSafariViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation AboutViewController

- (void)viewDidLoad
{
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
    [self addParallaxToBackGroundImage];
}

- (void)setMenuVC
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.menuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (void)addParallaxToBackGroundImage
{
    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-15);
    verticalMotionEffect.maximumRelativeValue = @(15);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-15);
    horizontalMotionEffect.maximumRelativeValue = @(15);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to your view
    [self.backgroundImageView addMotionEffect:group];
}

- (IBAction)openTwitter:(id)sender
{
    [self displaySafariWithURL:[NSURL URLWithString: kTwitterURL]];
}
- (IBAction)openWebsite:(id)sender
{
    [self displaySafariWithURL:[NSURL URLWithString: kWWWURL]];
}
- (IBAction)openFacebook:(id)sender
{
    [self displaySafariWithURL:[NSURL URLWithString: kFacebookURL]];
}


- (void)displaySafariWithURL:(NSURL*)url
{
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url entersReaderIfAvailable:NO];
        safariVC.delegate = self;
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:safariVC];
        [navigationController setNavigationBarHidden:YES animated:NO];
        [self presentViewController:navigationController animated:YES completion:^{
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }];
    }
}

#pragma mark - SFSafariViewControllerDelegate

-(void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully
{
    // Load finished
}

-(void)safariViewControllerDidFinish:(SFSafariViewController *)controller
{
    // Done button pressed
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


@end
