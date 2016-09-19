//
//  MainViewController.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 5/3/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import "MainViewController.h"
#import "NoFavoritesView.h"

#import "MainTableViewDelegate.h"
#import "MainTableViewDataSource.h"

#import "MyManager.h"
#import "Constants.h"

#import "DetailViewController.h"

#import "MyManager.h"
#import "MainTableViewDataSource.h"
#import "AdMob.h"

#import "SWRevealViewController.h"
#import "SettingsViewController.h"

@interface MainViewController () <MyManagerDelegate, UITableViewDataSource, UITableViewDelegate, AdMobDelegate>

@property (strong, nonatomic) MainTableViewDataSource *mainDataSource;
@property (strong, nonatomic) MainTableViewDelegate *mainDelegate;

@end

@implementation MainViewController
{
    MyManager *dao;
    NSArray *productsArray;
    UISegmentedControl *featuredFavoritesSC;
    NoFavoritesView *noFavoritesView;
}

#pragma mark - ViewController LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init DAO
    dao = [MyManager sharedManager];
    dao.delegate = self;
    [self configureVC];
    [self configureTableView];
    [self addMenu];
    [[AdMob sharedInstance] configureViewController:self];
    self.tableView.tableHeaderView = [[AdMob sharedInstance] getAd];
    //    [self.tableView.tableHeaderView setFrame:CGRectZero];
    //    [self displayAd:false];

}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dao.delegate = self;
}

- (void) configureVC {
    
        dao = [MyManager sharedManager];
        
        if ([dao.currentSection isEqualToString:kSectionFeatured])
        {
            [self.rightButton setImage:[UIImage imageNamed:kImageSettings] forState:UIControlStateNormal];
            
            featuredFavoritesSC = [[UISegmentedControl alloc] initWithItems:@[@"Featured", @"Favorites"]];
            featuredFavoritesSC.selectedSegmentIndex = 0;
            [featuredFavoritesSC addTarget:self action:@selector(segmentControlAction:) forControlEvents:UIControlEventValueChanged];
            self.navigationItem.titleView = featuredFavoritesSC;
        }
        //        } else {
        //            [self.mainViewController.rightButton setImage:nil forState:UIControlStateNormal];
        //            [UIImage imageNamed:kImageRefine]
        //            self.mainViewController.navigationItem.title = [dao.currentSection uppercaseString];
        //        }
        self.title = [dao.currentSection uppercaseString];
        NSLog(@"current section: %@", dao.currentSection);
}

- (void) segmentControlAction:(UISegmentedControl *)segment
{
    segment.selectedSegmentIndex == 0 ?
    [self returnToMain] :
    [self openFavorites];
}

- (void) returnToMain
{
    
    [featuredFavoritesSC setSelectedSegmentIndex:0];
    dao.currentSection = kSectionFeatured;
    [noFavoritesView removeFromSuperview];
    self.tableView.scrollEnabled = YES;
    
    self.mainDataSource.products = dao.productsDict[dao.currentSection];
    [self refresh];
}

- (void) openFavorites
{
    dao.currentSection = kFavorites;
    [self createNoFavoritesView];
    
    if ([dao.productsDict[dao.currentSection] count] == 0)
    {
        [self.view addSubview:noFavoritesView];
        noFavoritesView.frame = self.view.bounds;
        [self disableInteraction:YES];
    }
    
    self.mainDataSource.products = dao.productsDict[dao.currentSection];
    [self refresh];
}

- (void) createNoFavoritesView {
    
    if (noFavoritesView != nil) {
        return;
    }
    
    noFavoritesView = nil;
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"NoFavoritesView"
                                                     owner:self
                                                   options:nil];
    if ([objects.firstObject isKindOfClass:[UIView class]]) {
        noFavoritesView = objects.firstObject;
        [noFavoritesView.returnToMainButton addTarget:self action:@selector(returnToMain) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void) addMenu {
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.menuButton addTarget:revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addGestureRecognizer:revealViewController.panGestureRecognizer];
    }
}

- (void) configureTableView {
    
    self.mainDataSource = [[MainTableViewDataSource alloc] initWithTableView: self.tableView andViewController:self];
    self.mainDelegate = [[MainTableViewDelegate alloc] initWithTableView: self.tableView];
    self.mainDataSource.delegate = self;
    self.mainDataSource.products = dao.productsDict[dao.currentSection];
    self.mainDelegate.delegate = self;
    
    self.tableView.dataSource = self.mainDataSource;
    self.tableView.delegate =  self.mainDelegate;
}

- (void) rightButtonAction {
    if ([dao.currentSection isEqualToString:@"featured"] ||
        [dao.currentSection isEqualToString:@"favorites"]) {
        SettingsViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"settingsVC"];
        [self presentViewController:settingsVC animated:YES completion:nil];
    }
    //    else {
    //        RefineViewController *refineVC = [self.mainViewController.storyboard instantiateViewControllerWithIdentifier:@"refineVC"];
    //        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:refineVC];
    //        [self.mainViewController presentViewController:navigationController animated:YES completion:nil];
    //    }
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
    
    self.mainDataSource.products = ((NSArray *) dao.productsDict[dao.currentSection]);
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destinationVC = [segue destinationViewController];
    
    if ([destinationVC isKindOfClass:[DetailViewController class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        dao.currentProduct = dao.productsDict[dao.currentSection][indexPath.row];
        DetailViewController *detailVC = (DetailViewController*)destinationVC;
        detailVC.link = dao.currentProduct.urlString;
        detailVC.title = [dao.currentProduct.name uppercaseString];
        detailVC.selectedRow = indexPath.row;
    }
}

- (IBAction)rightButtonAction:(id)sender {
    [self rightButtonAction];
}

- (void) disableInteraction: (BOOL) flag {
    self.tableView.scrollEnabled = flag;
    self.tableView.allowsSelection = flag;
}

@end
