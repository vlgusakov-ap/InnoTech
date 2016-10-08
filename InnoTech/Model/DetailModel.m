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
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    webViewLoads--;
    
    if (webViewLoads==0)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if ([[PremiumManager sharedManager] premiumStatus] == Active) {
            [self cacheCurrentObject];
        }

    }
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Error: %@", error.localizedDescription);
    if (error.code == NSURLErrorCancelled) return; // this is Error -999
    if (error.code == NSURLErrorTimedOut) {
        [self showNoInternetView];
    }
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
    
    BOOL isOnline =  ([[Reachability reachabilityWithHostName:[NSURL URLWithString:self.detailViewController.link].host] currentReachabilityStatus] != NotReachable);
    BOOL isPremiumActive = ([[PremiumManager sharedManager] premiumStatus] == Active);
    BOOL isCurrentProductCached = dao.currentProduct.cached;
    return (isOnline || (isPremiumActive && isCurrentProductCached));
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
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:@"More Options" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *openSafariAction = [UIAlertAction actionWithTitle:@"Open in Safari" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL: self.url];
    }];
    
    [controller addAction:openSafariAction];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [controller addAction:cancel];

    return controller;
}



@end
