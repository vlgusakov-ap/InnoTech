//
//  DetailModel.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 7/8/16.
//  Copyright © 2016 NYCAppStudio. All rights reserved.
//

#import "DetailModel.h"
#import "DetailViewController.h"
#import "Reachability.h"
#import "MyManager.h"
#import "MBProgressHUD.h"
#import "PremiumManager.h"

@class DetailViewController;

@interface DetailModel () {
    MyManager *dao;
}

@property (weak, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) NSURL *url;

@end

@implementation DetailModel
{
    NSInteger webViewLoads;
    MBProgressHUD *hud;
}

- (instancetype) initWithViewController: (UIViewController *) viewController {
    self = [super self];
    if (self) {
        self.detailViewController = (DetailViewController *) viewController;
        dao = [MyManager sharedManager];
        self.url = [NSURL URLWithString:self.detailViewController.link];
    }
    
    return self;
}

- (void) webViewDidStartLoad:(UIWebView *)webView {
    webViewLoads += 1;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (hud == nil)
    {
        hud = [MBProgressHUD showHUDAddedTo:self.detailViewController.view animated:YES];
        hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");

    }
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    webViewLoads--;
    
    if (webViewLoads==0)
    {
        [hud hideAnimated:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if ([[PremiumManager sharedManager] premiumStatus] == Active) {
            [self cacheCurrentObject];
        }

    }
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Error: %@", error.localizedDescription);
    [self showNoInternetView];
}

- (void) showNoInternetView {
    
    UIView *view = nil;
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"NoInternetConnectionView"
                                                     owner:self
                                                   options:nil];
    if ([objects.firstObject isKindOfClass:[UIView class]]) {
        view = objects.firstObject;
    }
    
    self.detailViewController.view = view;
}

- (BOOL) reachable {
    
    BOOL _reachable = (BOOL) [[Reachability reachabilityWithHostName:[NSURL URLWithString:self.detailViewController.link].host] currentReachabilityStatus] != NotReachable;
    
    return ((_reachable && dao.useCellular)||
            (dao.currentProduct.cached && [[MyManager sharedManager] premiumStatus] == Active));
}

- (void) cacheCurrentObject {
    if (!dao.currentProduct.cached) {
        
        dao.currentProduct.cached = true; // set current product 'cached' to true
        dao.cachedWebsites[dao.currentProduct.urlString.MD5] = @YES;
        [[NSUserDefaults standardUserDefaults] setObject:dao.cachedWebsites forKey:@"cached"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [dao tableViewUpdateAtIndex: self.detailViewController.selectedRow];
    }
}

- (UIViewController *) moreOptions {
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"More Options" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *openSafariAction = [UIAlertAction actionWithTitle:@"Open in Safari" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL: self.url];
    }];
    
    [controller addAction:openSafariAction];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [controller addAction:cancel];

    return controller;
}

- (void) configureVC {
    
    dao = [MyManager sharedManager];
    self.detailViewController.webView.delegate = self;
    
    NSLog(@"LINK: %@", self.detailViewController.link);
    self.detailViewController.request = [NSURLRequest requestWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval: 5];
//    NSURLRequestReturnCacheDataElseLoad
    
    if ([self reachable]) {
        
        NSLog(@"IS REACHABILE");
        [self.detailViewController.webView loadRequest: self.detailViewController.request];
        
    } else {
        
        NSLog(@"NOT REACHABLE");
        [self showNoInternetView];
    }

}

@end
