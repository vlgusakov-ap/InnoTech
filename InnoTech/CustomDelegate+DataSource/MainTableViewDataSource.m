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

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
    
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *addToFavorites;
    
    if (![dao.productsDict[kFavorites] containsObject:[self products][indexPath.row]]) { //-1
        addToFavorites = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:AddToFavoritesTitle handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {

            [self commitAction:AddToFavorites forRowAtIndexPath:indexPath];
        }];
        addToFavorites.backgroundColor = [UIColor colorWithRed: 1 green: 0.792 blue: 0.157 alpha: 1];
    } else {
        addToFavorites = [UITableViewRowAction rowActionWithStyle: UITableViewRowActionStyleNormal title: DeleteFromFavoritesTitle handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {

            [self commitAction:DeleteFromFavorites forRowAtIndexPath:indexPath];
        }];
        addToFavorites.backgroundColor = [UIColor redColor];
    }
    
    return @[addToFavorites];
}

- (void) commitAction: (EditAction) action forRowAtIndexPath: (NSIndexPath *) indexPath {
    
    if (action == AddToFavorites) {
        [dao.productsDict[kFavorites] addObject:[self products][indexPath.row]]; //-1
    } else
        if (action == DeleteFromFavorites) {
            [dao.productsDict[kFavorites] removeObject:[self products][indexPath.row]]; //-1
            if ([dao.currentSection isEqualToString:kFavorites]) {
                [self.delegate tableViewAction:Delete atIndex:indexPath.row];
            }
        }
    
    NSArray *favorites = [dao.productsDict[kFavorites] copy];
    NSMutableArray *archiveArray = [NSMutableArray arrayWithCapacity:favorites.count];
    
    for (Product *product in favorites) {
        NSData *productEncodedObj = [NSKeyedArchiver archivedDataWithRootObject:product];
        [archiveArray addObject:productEncodedObj];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:archiveArray forKey:kFavorites];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView setEditing:false animated:true];
    if (![dao.currentSection isEqualToString:kFavorites]) {
        [self.delegate updateTableViewAtIndex:indexPath.row];
    }
}

- (NSArray *) getEditActionsForIndexPath: (NSIndexPath *) indexPath {
    
    UITableViewRowAction *addToFavorites;
    
    if (![dao.productsDict[kFavorites] containsObject:[self products][indexPath.row]]) { //-1
        addToFavorites = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"\u2606\nAdd to\nFavorites" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [self commitAction:AddToFavorites forRowAtIndexPath:indexPath];
        }];
        addToFavorites.backgroundColor = [UIColor colorWithRed: 1 green: 0.792 blue: 0.157 alpha: 1];
    } else {
        addToFavorites = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"\u267A\nDelete\nfrom\nFavorites" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [self commitAction:DeleteFromFavorites forRowAtIndexPath:indexPath];
        }];
        addToFavorites.backgroundColor = [UIColor redColor];
    }
    
    return @[addToFavorites];
}

@end
