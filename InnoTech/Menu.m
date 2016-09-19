//
//  Menu.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 7/16/16.
//  Copyright © 2016 SwiftSell. All rights reserved.
//

#import "Menu.h"

#import "MyManager.h"

@interface Menu()

@property (nonatomic, strong) NSMutableArray *menuItemsPrivate;

@end

@implementation Menu {
    MyManager *dao;
    NSArray *categories;
}

-(instancetype) init
{
    self = [super init];
    if (self)
    {
        
        NSString *main = kMenuItemMain;
        categories = @[
                       kMenuItemDigital,
                       kMenuItemAccessories,
                       kMenuItemVehicle,
                       kMenuItemHome,
                       kMenuItemSport,
                       kMenuItemPersonal,
                       kMenuItemScience,
                       kMenuItemPets,
                       kMenuItemTravel,
                       kMenuItemHealthCare,
                       kMenuItemBeauty,
                       kMenuItemOther];
        
        self.menuItemsPrivate = [NSMutableArray new];
        [self.menuItemsPrivate addObject:main];
        [self.menuItemsPrivate addObjectsFromArray:categories];
        [self.menuItemsPrivate addObjectsFromArray:@[@"premium",
                                                     @"about",
                                                     @"contact us"]];
    }
    return self;
}

- (NSArray *) menuItems {
    return [self.menuItemsPrivate copy];
}

- (NSUInteger) categories_count {
    return categories.count;
}

@end
