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
//#import "Reachability.h"
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

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.model = [[DetailModel alloc] initWithViewController:self];

    [self.model configureVC];
    dao = [MyManager sharedManager];
}

- (void) viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO];
    
    NSLog(@"current product: %@", dao.currentProduct.name);
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
    [self.navigationController setToolbarHidden:YES];
}

- (void) viewDidLayoutSubviews {
    self.webView.frame = self.view.bounds;
}

- (IBAction)moreOptions:(id)sender {
    
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
