//
//  NSArray+Check.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 5/14/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import "NSArray+Check.h"

@implementation NSArray (Check)

- (BOOL)containsProduct:(Product*)product {
    
    for (Product *prod in self) {
        if ([prod.key isEqualToString:product.key]) {
            return true;
        }
    }
    
    return false;
    
}

- (NSInteger)commentIndex:(ProductComment*)updatedComment
{
    NSInteger index = -1;
    
    for (ProductComment *currentComment in self)
    {
        if (currentComment.commentTime == updatedComment.commentTime &&
            [currentComment.userId isEqualToString:updatedComment.userId])
        {
            index = [self indexOfObject:currentComment];
            break;
        }
    }
    
    return index;
}


@end
