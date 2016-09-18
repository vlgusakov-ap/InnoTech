//
//  ConfiguredMailComposeVewController.h
//  InnoTech
//
//  Created by Vladyslav Gusakov on 6/24/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import <MessageUI/MessageUI.h>

@interface ConfiguredMailComposeViewController : MFMailComposeViewController

- (BOOL) canOpenMail;

@end
