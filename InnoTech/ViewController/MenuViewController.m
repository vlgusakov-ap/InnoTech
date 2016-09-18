//
//  MenuViewController.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 5/2/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import "MenuViewController.h"
#import "SWRevealViewController.h"
#import "MyManager.h"

#import "Menu.h"

@interface MenuViewController ()

@end

@implementation MenuViewController {
    NSArray *menuImages;
    MyManager *dao;
    
    NSString *main;
    NSArray *categories;
    Menu *menu;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dao = [MyManager sharedManager];
    menu = [Menu new];
    
    self.tableView.rowHeight = 40;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [dao disableInteractionsForMain:false];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [dao disableInteractionsForMain:true];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return menu.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier;
    if (indexPath.row < menu.categories_count) {
        identifier = @"categoriesViewCell";
    }
    else if ([menu.menuItems[indexPath.row] isEqualToString:@"about"]){
        identifier = @"aboutCell";
    }
    else if ([menu.menuItems[indexPath.row] isEqualToString:@"premium"]) {
        identifier = @"viewCell";
    }
    else {
        identifier = @"viewCell";
    }
    
    NSLog(@"identifier: %@", identifier);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.textLabel.text = [menu.menuItems[indexPath.row] uppercaseString];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir Next" size: 15];
    
    if ([cell.textLabel.text isEqualToString:@"INNOTECH"]) {
        cell.textLabel.font = [UIFont fontWithName:@"Avenir Next Bold" size: 15];
    }
    
    if ([cell.textLabel.text isEqualToString:@"PREMIUM"]) {
        cell.textLabel.textColor = [UIColor colorWithRed: 1 green: 0.524 blue: 0.005 alpha: 1];
        cell.textLabel.font = [UIFont fontWithName:@"Avenir Next Bold" size: 15];

    }
    
    cell.imageView.image = [UIImage imageNamed:menu.menuItems[indexPath.row]];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (indexPath.row == 0) {
        dao.currentSection = @"featured";
    } else {
        dao.currentSection = menu.menuItems[indexPath.row];
    }
    NSLog(@"%@", dao.currentSection);
}

@end
