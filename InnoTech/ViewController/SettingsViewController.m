//
//  SettingsViewController.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 5/2/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import "SettingsViewController.h"
#import "HelpshiftSupport.h"
#import "HelpshiftCore.h"
#import "MyManager.h"
#import "ConfiguredMailComposeViewController.h"
#import "LoginManager.h"
//#import "Constants.h"
#import "PremiumViewController.h"
#import "PremiumButton.h"
#import "PremiumManager.h"
#import "FacebookButton.h"

@import AFNetworking;
@import MessageUI;
@import FirebaseAuth;

@interface SettingsViewController () <MFMailComposeViewControllerDelegate, MyManagerDelegate, LoginManagerDelegate> {
    NSUserDefaults *defaults;
    MyManager *dao;
}

@property (weak, nonatomic) IBOutlet FacebookButton *facebookButton;
@property (weak, nonatomic) IBOutlet PremiumButton *premiumButton;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *facebookLogo;
@property (weak, nonatomic) IBOutlet UIView *pushNotificationsView;

- (IBAction)closeSettings:(id)sender;
- (IBAction)helpAndSupport:(id)sender;
- (IBAction)contact:(id)sender;
- (IBAction)facebookLogin:(id)sender;
- (IBAction)triggerInfoLabel:(id)sender;
- (IBAction)activatePremium:(id)sender;
- (IBAction)allowPushNotifications:(id)sender;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dao = [MyManager sharedManager];
    defaults = [NSUserDefaults standardUserDefaults];
    
    [[LoginManager sharedManager] setDelegate:self];
    [[LoginManager sharedManager] checkFacebookLoginStatus];
    
    dao.delegate = self;
    self.infoLabel.hidden = true;
    
    self.facebookLogo.hidden = [dao isIphone5Screen];
    
    //notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActive:)
                                                 name:@"applicationDidBecomeActive"
                                               object:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.premiumButton.active = [[PremiumManager sharedManager] premiumStatus];
    
    //post a notification that the app became active
    UIUserNotificationSettings *grantedSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (grantedSettings.types != UIUserNotificationTypeNone)
    {
        self.pushNotificationsView.hidden = true;
    }
    else
    {
        self.pushNotificationsView.hidden = false;
    }
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    dao.toNewMsg = false;
}

- (IBAction)closeSettings:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)helpAndSupport:(id)sender
{
    
    NSString *identifier = [[[FIRAuth auth] currentUser] uid];
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:kFacebookName];
    NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:kFacebookEmail];
    
    if (identifier)
    {
        [HelpshiftSupport setUserIdentifier:identifier];
        [HelpshiftCore setName:name andEmail:email];
    }

    [HelpshiftSupport showFAQs:self withOptions:nil];
}

- (IBAction)contact:(id)sender
{
    
    ConfiguredMailComposeViewController *mailVC = [ConfiguredMailComposeViewController new];

    if ([mailVC canOpenMail])
    {
        [self presentViewController:mailVC animated:YES completion:nil];
    }
}

- (IBAction)facebookLogin:(id)sender
{
    [[LoginManager sharedManager] loginWithFacebook:self];
}

- (IBAction)triggerInfoLabel:(id)sender {
    self.infoLabel.hidden = !self.infoLabel.hidden;
}

- (IBAction)activatePremium:(id)sender {
        
    if ([[PremiumManager sharedManager] premiumStatus] == Inactive) {
        PremiumViewController *premiumVC = [self.storyboard instantiateViewControllerWithIdentifier:@"premiumVC"];
        premiumVC.presentedModally = YES;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:premiumVC];
        [self presentViewController:navController animated:YES completion:nil];
    }
}

- (IBAction)allowPushNotifications:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (void) appDidBecomeActive:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"applicationDidBecomeActive"])
    {
        UIUserNotificationSettings *grantedSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (grantedSettings.types != UIUserNotificationTypeNone)
        {
            self.pushNotificationsView.hidden = true;
        }
        else
        {
            self.pushNotificationsView.hidden = false;
        }
    }
}

#pragma mark - LoginManagerDelegate

- (void) loginManagerDidPerformFacebookAction:(FacebookAction)action
{
    self.facebookButton.connected = action;
}


- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
