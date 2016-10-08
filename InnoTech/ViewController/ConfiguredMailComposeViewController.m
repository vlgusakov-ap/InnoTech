//
//  ConfiguredMailComposeVewController.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 6/24/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import "ConfiguredMailComposeViewController.h"

@interface ConfiguredMailComposeViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation ConfiguredMailComposeViewController

- (instancetype) init {
    self = [super init];
    if (self) {
        [self setToRecipients:@[@"InnoTech Support<support@nycappstudio.com>"]];
        
        NSDate *now = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
        NSLog(@"%@",[formatter stringFromDate:now]); //--> 9/9/11 11:54 PM
        
        NSString *subject = [NSString stringWithFormat:@"InnoTech Support"];
        [self setSubject:subject];
        [self setMessageBody:@"Hello InnoTech,\n\n" isHTML:NO];
        
        self.navigationBar.tintColor = [UIColor whiteColor];
    }
    return self;
}

- (BOOL)canOpenMail {
    
    if (![MFMailComposeViewController canSendMail]) {
        NSLog(@"Mail services are not available.");
        return false;
    }
    
    self.mailComposeDelegate = self;
    return true;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // Check the result or perform other tasks.
    
    // Dismiss the mail compose view controller.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
