//
//  MainViewModel.h
//  DiscoverTech
//
//  Created by Vladyslav Gusakov on 7/3/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

@import UIKit;
#import "MainTableViewDataSource.h"
#import "MainTableViewDelegate.h"

@interface MainViewModel : NSObject

- (void) configureVC: (UIViewController *) viewController;
- (void) addMenu;
- (void) configureTableView: (UITableView *) tableView;
- (void) rightButtonAction;
- (void) configureDetailVC: (UIViewController *) viewController withIndexPath: (NSIndexPath *) indexPath;

@property (strong, nonatomic) MainTableViewDataSource *mainDataSource;
@property (strong, nonatomic) MainTableViewDelegate *mainDelegate;


@end
