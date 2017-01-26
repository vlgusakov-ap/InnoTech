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

#import "PremiumManager.h"


@interface MainViewController () <MyManagerDelegate, UITableViewDataSource, UITableViewDelegate, AdMobDelegate, UIViewControllerPreviewingDelegate>

@property (strong, nonatomic) MainTableViewDataSource *mainDataSource;
@property (strong, nonatomic) MainTableViewDelegate *mainDelegate;
@property (strong, nonatomic) UIImageView *logo;

@property (nonatomic, strong) id previewingContext;

@end

@implementation MainViewController
{
    MyManager *dao;
    NSArray *productsArray;
    UISegmentedControl *featuredFavoritesSC;
    NoFavoritesView *noFavoritesView;
}

#pragma mark - ViewController LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //init DAO
    dao = [MyManager sharedManager];
    dao.delegate = self;
    [self configureVC];
    [self configureTableView];
    [self addMenu];
    
    NSDictionary* env = [[NSProcessInfo processInfo] environment];
    BOOL debugger = [[env valueForKey:@"debugger"] isEqual:@"true"];
    
    if (![[PremiumManager sharedManager] premiumStatus] || debugger)
    {
        [[AdMob sharedInstance] configureViewController:self];
        self.tableView.tableHeaderView = [[AdMob sharedInstance] getAd];
        self.logo = [[UIImageView alloc] initWithFrame:self.tableView.tableHeaderView.bounds];
        self.logo.image = [UIImage imageNamed:@"logo"];
        
        if(![[AdMob sharedInstance] receivedAd])
        {
            // The childView is contained in the parentView.
            [self.tableView.tableHeaderView addSubview:self.logo];
        }
        else
        {
            self.logo.hidden = YES;
        }
        
    }
    else
    {
        self.tableView.tableHeaderView = nil;
    }
    UIImage *backgroundImage = [UIImage imageNamed:@"background0125"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundImage];
    self.tableView.backgroundView = imageView;
    
    if ([self isForceTouchAvailable])
    {
        self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.logo removeFromSuperview];
    self.logo = nil;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dao.delegate = self;
}

- (void) configureVC
{
    dao = [MyManager sharedManager];
    
    [self.rightButton setImage:[UIImage imageNamed:kImageSettings] forState:UIControlStateNormal];
    
    if ([dao.currentSection isEqualToString:kSectionFeatured])
    {
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
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) rightButtonAction {
//    if ([dao.currentSection isEqualToString:@"featured"] ||
//        [dao.currentSection isEqualToString:@"favorites"]) {
        SettingsViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"settingsVC"];
        [self presentViewController:settingsVC animated:YES completion:nil];
//    }
    //    else {
    //        RefineViewController *refineVC = [self.mainViewController.storyboard instantiateViewControllerWithIdentifier:@"refineVC"];
    //        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:refineVC];
    //        [self.mainViewController presentViewController:navigationController animated:YES completion:nil];
    //    }
}

- (void) displayAd: (BOOL)display {
    [self.logo removeFromSuperview];
    self.logo = nil;
    GADNativeExpressAdView *adView = (display == YES) ? [[AdMob sharedInstance] getAd] : nil;
    self.tableView.tableHeaderView = adView;
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
    
#warning todo
    if ([destinationVC isKindOfClass:[DetailViewController class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSArray *currentProducts = dao.productsDict[dao.currentSection]; //dataArray[[dataArray count] - 1 - indexPath.row]
        NSUInteger productIndex = indexPath.row;
        dao.currentProduct = currentProducts[productIndex];
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 3D Touch

- (BOOL)isForceTouchAvailable
{
    BOOL isForceTouchAvailable = NO;
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)])
    {
        isForceTouchAvailable = self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
    }
    return isForceTouchAvailable;
}

- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    // check if we're not already displaying a preview controller (WebViewController is my preview controller)
    if ([self.presentedViewController isKindOfClass:[DetailViewController class]])
    {
        return nil;
    }
    
    CGPoint cellPostion = [self.tableView convertPoint:location fromView:self.view];
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:cellPostion];
    
    if (path)
    {
        UITableViewCell *tableCell = [self.tableView cellForRowAtIndexPath:path];
        
        // get your UIStoryboard
        
        // set the view controller by initializing it form the storyboard
        DetailViewController *previewController = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"detailVC"];
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tableCell];
        NSArray *currentProducts = dao.productsDict[dao.currentSection];
        NSUInteger productIndex = indexPath.row;
        dao.currentProduct = currentProducts[productIndex];
        DetailViewController *detailVC = (DetailViewController*)previewController;
        detailVC.link = dao.currentProduct.urlString;
        detailVC.title = [dao.currentProduct.name uppercaseString];
        detailVC.selectedRow = indexPath.row;
        
        previewingContext.sourceRect = [self.view convertRect:tableCell.frame fromView:self.tableView];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:previewController];
        previewController.commentsButton.hidden = YES;
        
        return navVC;
    }
    return nil;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    DetailViewController *viewController;
    if ([viewControllerToCommit isKindOfClass:[UINavigationController class]])
    {
        viewController = (DetailViewController*)((UINavigationController*)viewControllerToCommit).topViewController;
    }
    else
    {
        viewController = (DetailViewController*)viewControllerToCommit;
    }
    viewController.commentsButton.hidden = NO;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];
    if ([self isForceTouchAvailable])
    {
        if (!self.previewingContext)
        {
            self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
        }
    }
    else
    {
        if (self.previewingContext)
        {
            [self unregisterForPreviewingWithContext:self.previewingContext];
            self.previewingContext = nil;
        }
    }
}

@end
