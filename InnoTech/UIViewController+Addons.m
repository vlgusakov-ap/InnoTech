//
//  UIViewController+Addons.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 10/3/16.
//  Copyright © 2016 SwiftSell. All rights reserved.
//

#import "UIViewController+Addons.h"

@implementation UIViewController (Addons)

- (void) showAlertWithTitle:(NSString *)title description:(NSString *)description
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:description preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:true completion:nil];
}

@end
