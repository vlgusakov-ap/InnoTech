//
//  NSURLRequest+Extended.h
//  InnoTech
//
//  Created by Vladyslav Gusakov on 6/23/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (Extended)

//@property (nonatomic, strong) NSString *type;

- (BOOL) isBlackListed;
@end
