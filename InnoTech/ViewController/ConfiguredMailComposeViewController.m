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
        NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"fbName"];
        NSString *subject = [NSString stringWithFormat:@"Innotech Support | %@", name != nil ? name : @"Hello!"];
        [self setSubject:subject];
        [self setMessageBody:@"Hello InnoTech,\n\n" isHTML:NO];
    }
    return self;
}

- (BOOL) canOpenMail {
    
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


@end
