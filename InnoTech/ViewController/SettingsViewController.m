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
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "ConfiguredMailComposeViewController.h"
#import "Login.h"
#import "Constants.h"
#import "IAPShare.h"
#import "PremiumViewController.h"
#import "PremiumButton.h"

@import AFNetworking;
@import MessageUI;
@import FirebaseAuth;

@interface SettingsViewController () <MFMailComposeViewControllerDelegate, MyManagerDelegate> {
    NSUserDefaults *defaults;
    NSString *facebookLogged;
    NSData *appleOffline;
    MyManager *dao;
    Login *login;
}

@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet PremiumButton *premiumButton;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UISwitch *cellularSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *facebookLogo;

- (IBAction)closeSettings:(id)sender;
- (IBAction)helpAndSupport:(id)sender;
- (IBAction)contact:(id)sender;
- (IBAction)facebookLogin:(id)sender;
- (IBAction)triggerInfoLabel:(id)sender;
- (IBAction)activatePremium:(id)sender;
- (IBAction)switchCellular:(UISwitch *)sender;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dao = [MyManager sharedManager];
    defaults = [NSUserDefaults standardUserDefaults];
    
    login = [Login new];
    login.facebookButton = self.facebookButton;
    login.delegate = self;
    [login checkStatus];
    
    [self.cellularSwitch setOn:dao.useCellular];
    dao.delegate = self;
    self.infoLabel.hidden = true;
    
    self.facebookLogo.hidden = [dao isIphone5Screen];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.premiumButton.active = [dao premiumStatus];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    dao.toNewMsg = false;
}

- (IBAction)closeSettings:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)helpAndSupport:(id)sender {
    
    NSString *identifier = [[[FIRAuth auth] currentUser] uid];
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:kFacebookName];
    NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:kFacebookEmail];
    
    [HelpshiftSupport setUserIdentifier:identifier];
    [HelpshiftCore setName:name andEmail:email];
    [HelpshiftSupport showFAQs:self withOptions:nil];
}

- (IBAction)contact:(id)sender {
    
    ConfiguredMailComposeViewController *mailVC = [ConfiguredMailComposeViewController new];

    if ([mailVC canOpenMail]) {
        [self presentViewController:mailVC animated:YES completion:nil];
    }
}

- (IBAction)facebookLogin:(id)sender {
    [login loginWithFacebook];
}

- (IBAction)triggerInfoLabel:(id)sender {
    self.infoLabel.hidden = !self.infoLabel.hidden;
}

- (IBAction)activatePremium:(id)sender {
        
    if ([defaults integerForKey:kPremiumStatus] == Inactive) {
        PremiumViewController *premiumVC = [self.storyboard instantiateViewControllerWithIdentifier:@"premiumVC"];
        premiumVC.presentedModally = YES;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:premiumVC];
        [self presentViewController:navController animated:YES completion:nil];
    }
}

- (IBAction)switchCellular:(UISwitch *)sender {
    if ([sender isOn]) {
        dao.useCellular = true;
        [defaults setObject:@YES forKey:@"useCellular"];
    }
    else {
        dao.useCellular = false;
        [defaults setObject:@NO forKey:@"useCellular"];
    }
    [defaults synchronize];
}

@end
