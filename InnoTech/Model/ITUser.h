//
//  ITUser.h
//  InnoTech
//
//  Created by Vladyslav Gusakov on 9/18/16.
//  Copyright © 2016 SwiftSell. All rights reserved.
//

@import UIKit;

@interface ITUser : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) UIImage  *profileImage;
@property (nonatomic) BOOL isLogged;

@end
