//
//  FacebookUtils.h
//  InnoTech
//
//  Created by Vladyslav Gusakov on 6/24/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

//@protocol FacebookUtilsDelegate <NSObject>
//
//- (void) facebookSignOut;
//
//@end

@interface Login : NSObject

- (void) loginWithFacebook;
- (void) loginWithFirebase;

- (void) reauthWithFirebase;

@property (nonatomic, strong) UIButton *facebookButton;
@property (nonatomic, strong) id delegate;

- (void) checkStatus;

@end
