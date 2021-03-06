//
//  CommentTableViewCell.h
//  InnoTech
//
//  Created by Vladyslav Gusakov on 6/9/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *personPicture;
@property (weak, nonatomic) IBOutlet UILabel *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *crownImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentTime;

@end
