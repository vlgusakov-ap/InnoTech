//
//  NSObject+Constants_m.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 10/3/16.
//  Copyright © 2016 SwiftSell. All rights reserved.
//

#import "Constants.h"

@implementation Constants : NSObject 

+ (NSTimeInterval) currentTime
{
   return [[NSDate date] timeIntervalSince1970];
}

@end
