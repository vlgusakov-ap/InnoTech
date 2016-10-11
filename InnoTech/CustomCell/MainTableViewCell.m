//
//  MainTableViewCell.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 5/3/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import "MainTableViewCell.h"
#import "Product.h"

@implementation MainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void) prepareForReuse {
    [super prepareForReuse];
    self.backgroundImageView.hidden = YES;
    self.backgroundImageView.image = nil;
    self.title.text = @"";
    self.descr.text = @"";
    self.cachedIcon.hidden = true;
    self.favoritesIcon.hidden = true;
    self.link.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
