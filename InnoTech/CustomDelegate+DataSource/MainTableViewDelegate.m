//
//  MainTableViewDelegate.m
//  DiscoverTech
//
//  Created by Vladyslav Gusakov on 7/3/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import "MainTableViewDelegate.h"
#import "Constants.h"
#import "MyManager.h"

typedef NS_ENUM (NSUInteger, EditAction) {
    AddToFavorites = 0,
    DeleteFromFavorites,
};

@implementation MainTableViewDelegate {
    MyManager   *dao;
}

- (instancetype) initWithTableView: (UITableView *) tableView {
    self = [super init];
    if (self) {
        dao = [MyManager sharedManager];
        self.tableView = tableView;
        
    }
    return self;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.row == 0) {
//        return kAdHeight;
//    }
    return kProductHeight;
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.row == 0) {
//        return NO;
//    }
    return YES;
    
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.row == 0) {
//        return @[];
//    }
    
    return [self getEditActionsForIndexPath:indexPath];
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
        //        [self.delegate tableViewAction:Update atIndex:indexPath.row];
    }
    
}

- (NSArray *) products {
    
    return dao.productsDict[dao.currentSection];
}



@end
