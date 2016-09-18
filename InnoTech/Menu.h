//
//  Menu.h
//  InnoTech
//
//  Created by Vladyslav Gusakov on 7/16/16.
//  Copyright © 2016 SwiftSell. All rights reserved.
//

@import UIKit;

static NSString *kMenuItemMain = @"innotech";
static NSString *kMenuItemDigital = @"digital";
static NSString *kMenuItemAccessories = @"accessories";
static NSString *kMenuItemVehicle = @"vehicle";
static NSString *kMenuItemHome = @"home";
static NSString *kMenuItemSport = @"sport";
static NSString *kMenuItemPersonal = @"personal";
static NSString *kMenuItemScience = @"science";
static NSString *kMenuItemPets = @"pets";
static NSString *kMenuItemTravel = @"travel";
static NSString *kMenuItemHealthCare = @"healthcare";
static NSString *kMenuItemBeauty = @"beauty";
static NSString *kMenuItemOther = @"other";

@interface Menu : NSObject

@property (nonatomic, strong, readonly) NSArray *menuItems;
@property (nonatomic, readonly) NSUInteger categories_count;

@end
