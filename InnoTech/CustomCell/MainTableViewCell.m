//
//  MainTableViewCell.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 5/3/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import "MainTableViewCell.h"
#import "Product.h"
#import "NSString+MD5.h"
#import "Constants.h"
#import "MyManager.h"
@import SDWebImage;

@interface MainTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *titleDesctiptionView;
@end

@implementation MainTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    self.mainView.layer.cornerRadius = 15;
}

- (void) prepareForReuse
{
    [super prepareForReuse];
    self.backgroundImageView.image = NULL;
    self.backgroundImageView.clipsToBounds = true;
    [self.backgroundImageView sd_cancelCurrentImageLoad];
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

- (void)configureForProduct:(Product *) product {
    
    MyManager *dao = [MyManager sharedManager];
    NSString *cacheKey = [NSURL URLWithString:product.imageURL].absoluteString.MD5;
    SDImageCache *imageCache = [dao imageCache];
    [imageCache queryDiskCacheForKey:cacheKey done:^(UIImage *image, SDImageCacheType cacheType) {
        
        if (image != nil) {
            dispatch_async(dispatch_get_main_queue(), ^(){
                self.backgroundImageView.image = image;
            });
        }
        else {
            [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:product.imageURL]
                                        placeholderImage:[UIImage imageNamed:@"loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                            [imageCache storeImage:image forKey:cacheKey];
                                        }];
        }
        
    }];

    self.backgroundImageView.clipsToBounds = true;

    self.title.text = [product.name uppercaseString];
    
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentJustified;
    style.firstLineHeadIndent = 5.0f;
    style.headIndent = 5.0f;
    style.tailIndent = -5.0f;
    
    NSDictionary *typingAttributes = @{
                                       NSFontAttributeName: [UIFont fontWithName:@"AvenirNextCondensed-Bold" size:14.0f],
                                       NSForegroundColorAttributeName : [UIColor whiteColor],
                                       NSStrokeColorAttributeName : [UIColor blackColor],
                                       NSStrokeWidthAttributeName : [NSNumber numberWithFloat:-2.0],
                                       NSParagraphStyleAttributeName : style
                                       };
    
    NSAttributedString *str = [[NSAttributedString alloc]
                               initWithString:product.shortDescr
                               attributes:typingAttributes];
    self.descr.attributedText = str;
    self.descr.layer.masksToBounds = YES;
    self.titleDesctiptionView.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.4];

    if ([dao.cachedWebsites[product.urlString.MD5] isEqual: @YES])
    {
        product.cached = true;
        self.cachedIcon.hidden = false;
    }
    else {
        self.cachedIcon.hidden = true;
    }
    
    if ([dao.productsDict[kFavorites] containsObject:product]) {
        self.favoritesIcon.hidden = false;
    }
    else {
        self.favoritesIcon.hidden = true;
    }
    
}

@end
