//
//  MainTableViewDataSource.m
//  DiscoverTech
//
//  Created by Vladyslav Gusakov on 7/3/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import "MainTableViewDataSource.h"
#import "MainTableViewCell+ConfigureForProduct.h"
#import "AdMob.h"
//#import <StartApp/StartApp.h> // new ads
//#import "MoPubAd.h"

static NSString *AddToFavoritesTitle = @"\u2606\nAdd to\nFavorites";
static NSString *DeleteFromFavoritesTitle = @"\u267A\nDelete\nfrom\nFavorites";

typedef NS_ENUM (NSUInteger, EditAction) {
    AddToFavorites = 0,
    DeleteFromFavorites,
};

@interface MainTableViewDataSource () { //
    MyManager   *dao;
}

@property (strong, nonatomic) AdMob *ad; // mobile ads
//@property (strong, nonatomic) STABannerView *basicAd;
//@property (strong, nonatomic) MoPubAd *mobileAd; // mobile ads


@end

@implementation MainTableViewDataSource

- (instancetype) initWithTableView:(UITableView *)tableView
                 andViewController: (UIViewController *) viewController {
    self = [super init];
    if (self) {
        dao = [MyManager sharedManager];
        self.tableView = tableView;        
    }
    return self;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self products].count;// + 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MainTableViewCell *cell = (MainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Product *currCellProduct = dao.productsDict[dao.currentSection][indexPath.row];
    [cell configureForProduct:currCellProduct];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.preservesSuperviewLayoutMargins  = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    return cell;
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
