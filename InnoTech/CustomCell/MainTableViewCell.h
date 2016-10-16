//
//  MainTableViewCell.h
//  InnoTech
//
//  Created by Vladyslav Gusakov on 5/3/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Product;

@interface MainTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *descr;
@property (weak, nonatomic) UILabel *link;
@property (weak, nonatomic) IBOutlet UIImageView *cachedIcon;
@property (weak, nonatomic) IBOutlet UIImageView *favoritesIcon;

- (void)configureForProduct:(Product *) product;

@end
