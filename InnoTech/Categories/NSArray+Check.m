//
//  NSArray+Check.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 5/14/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import "NSArray+Check.h"

@implementation NSArray (Check)

- (BOOL) containsProduct: (Product *) product {
    
    for (Product *prod in self) {
        if ([prod.key isEqualToString:product.key]) {
            return true;
        }
    }
    
    return false;
    
}


@end
