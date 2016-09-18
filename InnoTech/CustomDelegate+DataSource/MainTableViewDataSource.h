//
//  MainTableViewDataSource.h
//  DiscoverTech
//
//  Created by Vladyslav Gusakov on 7/3/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

@import UIKit;
#import "MyManager.h"

@interface MainTableViewDataSource : NSObject <UITableViewDataSource>

- (instancetype) initWithTableView:(UITableView *)tableView
                 andViewController: (UIViewController *) viewController;

- (NSArray *) getEditActionsForIndexPath: (NSIndexPath *) indexPath;

@property (nonatomic, strong) id <MyManagerDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *products;


@end
