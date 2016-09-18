//
//  PremiumButton.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 9/5/16.
//  Copyright © 2016 SwiftSell. All rights reserved.
//

#import "PremiumButton.h"

@implementation PremiumButton

- (void)setActive:(BOOL)active
{
    if (active) {
        [self setBackgroundImage:[UIImage imageNamed:@"green1"] forState:UIControlStateNormal];
        [self setTitle:@"Active" forState:UIControlStateNormal];
    }
    else
    {
        [self setBackgroundImage:[UIImage imageNamed:@"red1"] forState:UIControlStateNormal];
        [self setTitle:@"Inactive" forState:UIControlStateNormal];
    }
}

@end
