//
//  FacebookButton.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 9/18/16.
//  Copyright © 2016 SwiftSell. All rights reserved.
//

#import "FacebookButton.h"

@implementation FacebookButton

- (void) setConnected:(BOOL)connected
{
    if (connected)
    {
        [self setTitle:@"Connected" forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"green1"] forState:UIControlStateNormal];
    }
    else
    {
        [self setTitle:@"Disconnected" forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"red1"] forState:UIControlStateNormal];
    }
}

@end
