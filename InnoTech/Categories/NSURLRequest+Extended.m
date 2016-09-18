//
//  NSURLRequest+Extended.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 6/23/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import "NSURLRequest+Extended.h"
//#import <objc/runtime.h>

NSString const *key = @"my.very.unique.key";
//static char *EventToKey = "EventToKey";

@implementation NSURLRequest (Extended)

- (NSArray *) blackListedURLs {
    
    return @[@"googleads.g.doubleclick.net",
             @"graph.facebook.com",
             @"itunes.apple.com",
             @"googlesyndication.com",
             @"helpshift.com",
             @"googleusercontent.com",
             @"googleadservices.com",
             @"googleapis.com",
             @"csi.gstatic.com",
             @"startapp",
             @"trackimpression",
             @"gstatic.com"];
    
}

- (BOOL) isBlackListed {
    NSString *requestStr = self.URL.absoluteString;
    
    for (NSString *str in [self blackListedURLs]) {
        if ([requestStr containsString:str]) {
//            NSLog(@"--- Request %@ is BLACKLISTED", requestStr);
            return true;
        }
    }
    
    return false;
}

@end

