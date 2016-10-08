//
//  RefineViewController.h
//  InnoTech
//
//  Created by Vladyslav Gusakov on 5/15/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RefineViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end
