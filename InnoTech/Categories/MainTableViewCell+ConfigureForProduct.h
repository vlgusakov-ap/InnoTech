//
//  MainTableViewCell+ConfigureForProduct.h
//  InnoTech
//
//  Created by Vladyslav Gusakov on 6/16/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainTableViewCell.h"

@class Product;

@interface MainTableViewCell (ConfigureForProduct)

- (void)configureForProduct:(Product *) product;

@end
