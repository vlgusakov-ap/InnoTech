//
//  NSArray+Check.h
//  InnoTech
//
//  Created by Vladyslav Gusakov on 5/14/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface NSArray (Check)

- (BOOL) containsProduct: (Product *) product;

@end
