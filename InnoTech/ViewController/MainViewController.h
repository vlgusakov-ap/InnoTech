//
//  MainViewController.h
//  InnoTech
//
//  Created by Vladyslav Gusakov on 5/3/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@interface MainViewController : BaseTableViewController

@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

- (IBAction)rightButtonAction:(id)sender;

- (void) refresh;
- (void) displayAd: (BOOL) display;

@end
