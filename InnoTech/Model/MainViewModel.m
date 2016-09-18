//
//  MainViewModel.m
//  DiscoverTech
//
//  Created by Vladyslav Gusakov on 7/3/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import "MainViewModel.h"

#import "MyManager.h"
#import "Constants.h"

#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "SettingsViewController.h"
#import "RefineViewController.h"
#import "DetailViewController.h"

#import "NoFavoritesView.h"

@class MainViewController;

@interface MainViewModel() {
    MyManager *dao;
    UISegmentedControl *featuredFavoritesSC;
    NoFavoritesView *noFavoritesView;
}

@property (nonatomic, weak) MainViewController *mainViewController;
@end

@implementation MainViewModel

- (void) configureVC: (UIViewController *) viewController {
    
    if ([viewController isKindOfClass:[MainViewController class]]) {
        self.mainViewController = (MainViewController *) viewController;
        dao = [MyManager sharedManager];
        
        if ([dao.currentSection isEqualToString:kSectionFeatured]) {
            [self.mainViewController.rightButton setImage:[UIImage imageNamed:kImageSettings] forState:UIControlStateNormal];
            
            featuredFavoritesSC = [[UISegmentedControl alloc] initWithItems:@[@"Featured", @"Favorites"]];
            featuredFavoritesSC.selectedSegmentIndex = 0;
            [featuredFavoritesSC addTarget:self action:@selector(segmentControlAction:) forControlEvents:UIControlEventValueChanged];
            self.mainViewController.navigationItem.titleView = featuredFavoritesSC;
        }
//        } else {
//            [self.mainViewController.rightButton setImage:nil forState:UIControlStateNormal];
//            [UIImage imageNamed:kImageRefine]
//            self.mainViewController.navigationItem.title = [dao.currentSection uppercaseString];
//        }
        self.mainViewController.title = [dao.currentSection uppercaseString];
        NSLog(@"current section: %@", dao.currentSection);

    } else {
        NSLog(@"Error: wrong ViewController passed as parameter!");
    }
    
}

- (void) segmentControlAction:(UISegmentedControl *)segment {
    segment.selectedSegmentIndex == 0 ?
    [self returnToMain] :
    [self openFavorites];
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

- (void) returnToMain {
    
    [featuredFavoritesSC setSelectedSegmentIndex:0];
    dao.currentSection = kSectionFeatured;
    
    self.mainViewController.view = self.mainViewController.tableViewPublic;
    self.mainDataSource.products = dao.productsDict[dao.currentSection];
    [self.mainViewController refresh];
}

- (void) openFavorites {
    dao.currentSection = kFavorites;
    [self createNoFavoritesView];
    
    if ([dao.productsDict[dao.currentSection] count] == 0) {
        self.mainViewController.view = noFavoritesView;
    } else {
        self.mainViewController.view = self.mainViewController.tableViewPublic;
    }
    self.mainDataSource.products = dao.productsDict[dao.currentSection];
    [self.mainViewController refresh];
}

- (void) addMenu {
    
    SWRevealViewController *revealViewController = self.mainViewController.revealViewController;
    if (revealViewController)
    {
        [self.mainViewController.menuButton addTarget:revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.mainViewController.view addGestureRecognizer:revealViewController.panGestureRecognizer];
    }
}

- (void) configureTableView: (UITableView *)tableView {
    
    self.mainDataSource = [[MainTableViewDataSource alloc] initWithTableView: tableView andViewController:self.mainViewController];
    self.mainDelegate = [[MainTableViewDelegate alloc] initWithTableView: tableView];
    self.mainDataSource.delegate = self.mainViewController;
    self.mainDataSource.products = dao.productsDict[dao.currentSection];
    self.mainDelegate.delegate = self.mainViewController;
    
    tableView.dataSource = self.mainDataSource;
    tableView.delegate =  self.mainDelegate;
    
}

- (void) rightButtonAction {
    if ([dao.currentSection isEqualToString:@"featured"]) {
        SettingsViewController *settingsVC = [self.mainViewController.storyboard instantiateViewControllerWithIdentifier:@"settingsVC"];
        [self.mainViewController.navigationController presentViewController:settingsVC animated:YES completion:nil];
    }
//    else {
//        RefineViewController *refineVC = [self.mainViewController.storyboard instantiateViewControllerWithIdentifier:@"refineVC"];
//        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:refineVC];
//        [self.mainViewController presentViewController:navigationController animated:YES completion:nil];
//    }
}

- (void) configureDetailVC: (UIViewController *) viewController withIndexPath: (NSIndexPath *) indexPath {
    
    dao.currentProduct = dao.productsDict[dao.currentSection][indexPath.row];
    DetailViewController *destinationVC = (DetailViewController*) viewController;
    destinationVC.link = dao.currentProduct.urlString;
    destinationVC.title = [dao.currentProduct.name uppercaseString];
    destinationVC.selectedRow = indexPath.row;
}


@end
