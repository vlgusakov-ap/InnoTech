//
//  MainTableViewDelegate.h
//  DiscoverTech
//
//  Created by Vladyslav Gusakov on 7/3/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

@import UIKit;
#import "MyManager.h"

@interface MainTableViewDelegate : NSObject <UITableViewDelegate>

@property (nonatomic, strong) id <MyManagerDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;
- (instancetype) initWithTableView: (UITableView *) tableView;

@end
