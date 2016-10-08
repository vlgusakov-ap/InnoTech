//
//  SizeUtils.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 9/25/16.
//  Copyright © 2016 SwiftSell. All rights reserved.
//

#import "SizeUtils.h"

@implementation SizeUtils

+ (BOOL) isIphone5
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f)
        {
            return NO;
        }
    }
    
    return YES;
}

@end
