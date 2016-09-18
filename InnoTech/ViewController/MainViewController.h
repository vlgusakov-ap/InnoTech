//
//  MainViewController.h
//  InnoTech
//
//  Created by Vladyslav Gusakov on 5/3/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyManager.h"
#import "MainTableViewDataSource.h"
#import "AdMob.h"

@interface MainViewController : UITableViewController <MyManagerDelegate, UITableViewDataSource, UITableViewDelegate,
 AdMobDelegate>

@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

- (IBAction)rightButtonAction:(id)sender;

@property (nonatomic, strong) id <UITableViewDataSource> dataSource;
@property (nonatomic, strong) id <UITableViewDelegate> delegate;

@property (nonatomic, strong) UITableView *tableViewPublic;

- (void) refresh;
- (void) displayAd: (BOOL) display;


@end
