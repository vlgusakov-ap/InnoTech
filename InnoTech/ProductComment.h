//
//  ProductComment.h
//  InnoTech
//
//  Created by Vladyslav Gusakov on 10/29/16.
//  Copyright © 2016 SwiftSell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductComment : NSObject

@property (nonatomic, strong) NSString *commentText;
@property (nonatomic) NSInteger commentTime;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic) BOOL isPremium;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userId;

+ (instancetype)commentWithDictionary:(NSDictionary*)dict;

@end
