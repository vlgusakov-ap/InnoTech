//
//  DescriptionViewController.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 5/3/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import "DetailViewController.h"
#import "MyManager.h"
#import "RNCachingURLProtocol.h"
#import "NSString+Sha1.h"
#import "DetailModel.h"
@import Social;

@class DetailModel;

@interface DetailViewController () {
    MyManager *dao;
    NSURL *url;
}
- (IBAction)moreOptions:(id)sender;
- (IBAction)reload:(id)sender;
- (IBAction)share:(id)sender;

@property (strong, nonatomic) DetailModel *model;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *moreOptionsButton;

@end

@implementation DetailViewController

#pragma mark - ViewController Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.model = [[DetailModel alloc] initWithViewController:self];

    [self configureVC];
    dao = [MyManager sharedManager];
}

- (void) viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO];
    
    NSLog(@"current product: %@", dao.currentProduct.name);
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [self.webView stopLoading];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) viewDidLayoutSubviews {
    self.webView.frame = self.view.bounds;
}

- (void) configureVC {
    
    dao = [MyManager sharedManager];
    self.webView.delegate = self.model;
    
    NSLog(@"LINK: %@", self.link);
    
    NSString *encodedString= [self.link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    url = [NSURL URLWithString:encodedString];
//    self.request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval: 5];
    self.request = [NSURLRequest requestWithURL:url];
    //    NSURLRequestReturnCacheDataElseLoad
    
    if ([self.model reachable]) {
        
        NSLog(@"IS REACHABILE");
        [self.webView loadRequest: self.request];
        
    } else {
        NSLog(@"NOT REACHABLE");
        [self.model showNoInternetView];
    }
    
}
- (IBAction)moreOptions:(id)sender
{
    [self.model moreOptions].popoverPresentationController.barButtonItem = self.moreOptionsButton;
    [self presentViewController:[self.model moreOptions] animated:true completion:nil];
}

- (IBAction)reload:(id)sender {
    dao.currentProduct.cached = false;
    [self.webView reload];
}

- (IBAction)share:(id)sender {
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.webView.request.URL.absoluteString] applicationActivities:nil];
    [self presentViewController:activityViewController animated:true completion:nil];
}

@end
