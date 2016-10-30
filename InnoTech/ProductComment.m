//
//  ProductComment.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 10/29/16.
//  Copyright © 2016 SwiftSell. All rights reserved.
//

#import "ProductComment.h"

@implementation ProductComment

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self)
    {
        self.commentText = dict[@"comment"];
        self.commentTime = dict[@"commentTime"];
        self.imageUrl = dict[@"img"];
        self.isPremium = [dict[@"isPremium"] boolValue];
        self.userName = dict[@"name"];
        self.userId = dict[@"userID"];
    }
    return self;
}

+ (instancetype)commentWithDictionary:(NSDictionary*)dict
{
    return [[self alloc] initWithDictionary:dict];
}

@end
