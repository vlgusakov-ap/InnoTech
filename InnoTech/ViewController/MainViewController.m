//
//  MainViewController.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 5/3/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import "MainViewController.h"
#import "NoFavoritesView.h"

#import "MainViewModel.h"
#import "MainTableViewDataSource.h"

#import "MyManager.h"
#import "Constants.h"

#import "DetailViewController.h"

@class MainViewModel;

@interface MainViewController ()

@end

@implementation MainViewController {
    MyManager *dao;
    NSArray *productsArray;
    MainViewModel *viewModel;    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureVC];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dao.delegate = self;
}

- (void) configureVC {
    
    //init DAO
    dao = [MyManager sharedManager];
    dao.delegate = self;
    viewModel = [MainViewModel new];
    [viewModel configureVC: self];
    [viewModel configureTableView: self.tableView];
    [viewModel addMenu];
    self.tableViewPublic = self.tableView;
    [[AdMob sharedInstance] configureViewController:self];
    self.tableView.tableHeaderView = [[AdMob sharedInstance] getAd];
//    [self.tableView.tableHeaderView setFrame:CGRectZero];
    //    [self displayAd:false];
}

- (void) displayAd: (BOOL) display {
    GADNativeExpressAdView *adView = (display == YES) ? [[AdMob sharedInstance] getAd] : nil;
    self.tableView.tableHeaderView = adView;
//    self.tableView.tableHeaderView.frame = CGRectZero;
//    self.tableView.tableHeaderView.hidden = !display;
    [self refresh];
}

- (void) refresh {
    [self.tableView reloadData];
}

-(void) tableViewAction: (FireBaseAction) action atIndex: (NSUInteger) index {
    
    viewModel.mainDataSource.products = ((NSArray *) dao.productsDict[dao.currentSection]);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    if (action == Add) { 
        [self.tableView insertRowsAtIndexPaths:@[indexPath]
                              withRowAnimation: UITableViewRowAnimationAutomatic];
    } else
        if (action == Delete) {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
        } else
            if (action == Update) {
                [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
        }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES];
}

- (void) updateTableViewAtIndex: (NSUInteger) index {
    [self.tableView reloadRowsAtIndexPaths: @[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    UIViewController *destinationVC = [segue destinationViewController];
    
    if ([destinationVC isKindOfClass:[DetailViewController class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        [viewModel configureDetailVC:destinationVC withIndexPath:indexPath];
    }
}

- (IBAction)rightButtonAction:(id)sender {
    [viewModel rightButtonAction];
}

- (void) disableInteraction: (BOOL) flag {
    self.tableView.scrollEnabled = flag;
    self.tableView.allowsSelection = flag;
}

@end
