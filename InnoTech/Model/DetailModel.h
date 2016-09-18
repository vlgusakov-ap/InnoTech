//
//  DetailModel.h
//  InnoTech
//
//  Created by Vladyslav Gusakov on 7/8/16.
//  Copyright © 2016 NYCAppStudio. All rights reserved.
//

@import UIKit;

@interface DetailModel : NSObject <UIWebViewDelegate>

- (instancetype) initWithViewController: (UIViewController *) viewController;

- (void) configureVC;

- (BOOL) reachable;
- (void) showNoInternetView;
- (void) cacheCurrentObject;

- (UIViewController *) moreOptions;
@end
