//
//  MyManager.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 5/14/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import "MyManager.h"
#import "Constants.h"
@import FirebaseAuth;
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@import FirebaseRemoteConfig;
#import <sys/sysctl.h>
#import "PremiumManager.h"
#import "NSArray+Check.h"

@interface MyManager()

@end

@implementation MyManager {
    NSString *currentMD5;
    FIRDatabaseHandle addNewCommentHandler;
    FIRDatabaseHandle updateCommentHandler;
    FIRDatabaseHandle deleteCommentHandler;
    
    UIImageView *offlineImage;
    NSUserDefaults *defaults;
}

#pragma mark Singleton Methods

+ (id)sharedManager {
    static MyManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        
        [self startMonitoringInternetConnection]; //check internet connection in real time
        self.productsList = [NSMutableArray new];
        self.currentSection = kSectionFeatured;
        
        self.productsSnapshots = [NSMutableArray new];
        self.productsDict = [NSMutableDictionary new];
        self.cachedWebsites = [NSMutableDictionary new];
        self.currentComments = [NSMutableArray new];
        
        self.productsDict[kFavorites] = [NSMutableArray new];
        NSArray *favorites = [[NSUserDefaults standardUserDefaults] objectForKey:kFavorites];
        for (NSData *data in favorites)
        {
            Product *product = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [self.productsDict[kFavorites] addObject:product];
        }
        NSDictionary *cachedDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"cached"];
        self.cachedWebsites = [NSMutableDictionary dictionaryWithDictionary:cachedDict];
        [self fireBaseSetup];
        self.imageCache = [[SDImageCache alloc] initWithNamespace:@"innotech"];
        
        //offline
//        UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];
//        offlineImage = [[UIImageView alloc] initWithFrame:CGRectMake(mainWindow.center.x-50, 100, 100, 100)];
//        UIImage *offlineImg = [UIImage imageNamed:@"offline_1"];
//        offlineImage.image = offlineImg;
//        offlineImage.hidden = true;
//        [mainWindow insertSubview:offlineImage aboveSubview:mainWindow];
        
        defaults = [NSUserDefaults standardUserDefaults];
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        NSArray *localNotifArr = [[UIApplication sharedApplication] scheduledLocalNotifications];
        NSLog(@"%ld notifications are planned", (unsigned long)localNotifArr.count);

        
        if (localNotifArr.count == 0 || localNotifArr == nil) {
            UILocalNotification *localNotif1 = [[UILocalNotification alloc] init];
            localNotif1.alertBody = @"\ue10f Check out what's new today!";
            NSDateComponents *components1 = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitWeekOfMonth) fromDate:[NSDate date]];
            [components1 setHour:20];
            [components1 setMinute:00];
            localNotif1.fireDate = [[NSCalendar currentCalendar] dateFromComponents:components1];
            [localNotif1 setRepeatInterval:NSCalendarUnitDay];
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotif1];
        }
    }
    return self;
}

- (void) startMonitoringInternetConnection {
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"AFNetworkReachabilityStatusNotReachable");
//                offlineImage.hidden = false;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"AFNetworkReachabilityStatusReachableViaWiFi");
//                offlineImage.hidden = true;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"AFNetworkReachabilityStatusReachableViaCellular");
//                offlineImage.hidden = true;
                break;
            default:
                NSLog(@"Unkown network status");
        }
        
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}

- (void) performAction: (FireBaseAction) action onSnapshot: (FIRDataSnapshot *) snapshot {
    
    //common
    FireBaseAction tableViewAction = action;
    id productSnapshot = snapshot.value;
    NSArray *categories = productSnapshot[@"categories"];
    
    NSInteger indexOfProduct = -1;
    NSInteger indexOfSnapshot = -1;
    Product *productToUpdate;
    Product *newProduct;
    NSInteger indexOfProductToUpdate = -1;
    
    if (action == Update || action == Delete) {
        indexOfProduct = [self indexOfMessage:snapshot];
        indexOfSnapshot = [self indexOfSnapshot:snapshot];
        productToUpdate = self.productsList[indexOfProduct];
    }
    
    if (action == Add || action == Update) {
        // init new product object
        newProduct = [[Product alloc] initWithName:productSnapshot[pname] description:productSnapshot[pdescr] url:productSnapshot[purl] imageUrl:productSnapshot[pimageUrl]];
        newProduct.key = snapshot.key;
        newProduct.categories = categories;
        
        if (action == Update) {
            for (NSString *category in productToUpdate.categories) {
                
                indexOfProductToUpdate = [self.productsDict[category] indexOfObject:productToUpdate];
                
                if (![newProduct.categories containsObject:category]) {
                    [self.productsDict[category] removeObject:productToUpdate];
                    
                    if ([category isEqualToString:self.currentSection]) {
                        tableViewAction = Delete;
                        [self.delegate tableViewAction:tableViewAction atIndex: indexOfProductToUpdate];
                        
                    }

                }
            }
        }
        
        for (NSString *category in categories) {
            
            if (self.productsDict[category] == nil)
            {
                self.productsDict[category] = [NSMutableArray new];
            }
            
            if (action == Add)
            {
                [self.productsDict[category] insertObject:newProduct atIndex:0];
            } else
                if (action == Update)
                {
                    if ([self.productsDict[category] containsObject:productToUpdate])
                    {
                        indexOfProductToUpdate = [self.productsDict[category] indexOfObject:productToUpdate];
                        self.productsDict[category][indexOfProductToUpdate] = newProduct;
                        tableViewAction = Update;
                    }
                    else
                    {
                        [self.productsDict[category] insertObject:newProduct atIndex:0];
                        indexOfProductToUpdate = 0;
                        tableViewAction = Add;
                    }
                }
            
            if ([category isEqualToString:self.currentSection])
            {
                NSUInteger index = (action == Add) ? 0: indexOfProductToUpdate;
                NSLog(@"Product %@ inserted at index %ld", newProduct.name, (unsigned long)index);

                [self.delegate tableViewAction:tableViewAction atIndex: index];
                
            }
        }
    }
    
    if (action == Delete) { // delete
        for (NSString *category in categories) {
            NSInteger indexOfProductToDelete = [self.productsDict[category] indexOfObject:productToUpdate];
            
            if ([self.productsDict[category] containsObject:productToUpdate]) {
                
                [self.productsDict[category] removeObject:productToUpdate];

                if ([category isEqualToString:self.currentSection]) {
                    [self.delegate tableViewAction:action atIndex:indexOfProductToDelete]; //+1
                }
            }
        }
    }
    
    switch (action) {
        case Add:
        {
            [self.productsSnapshots addObject:snapshot];
            [self.productsList addObject:newProduct];
        }
            break;
        case Delete:
        {
            [self.productsSnapshots removeObjectAtIndex:indexOfSnapshot];
            [self.productsList removeObjectAtIndex:indexOfProduct];
        }
            break;
        case Update:
        {
            self.productsSnapshots[indexOfSnapshot] = snapshot; //only change
            self.productsList[indexOfProduct] = newProduct;
        }
            break;
        default:
            break;
    }

}

- (void) fireBaseSetup {
    
    self.ref = [[[FIRDatabase database] reference] child:kProductsChild];
    self.commentsRef = [[[FIRDatabase database] reference] child:kCommentssChild];
    
    // FIREBASE
    [self.ref
     observeEventType:FIRDataEventTypeChildAdded
     withBlock:^(FIRDataSnapshot *snapshot) {

         NSLog(@"%@", snapshot.value);
         
         [self performAction:Add onSnapshot:snapshot];
         
     }];
    
    // Listen for deleted comments in the Firebase database
    [self.ref
     observeEventType:FIRDataEventTypeChildRemoved
     withBlock:^(FIRDataSnapshot *snapshot) {

         [self performAction:Delete onSnapshot:snapshot];
     }];
    
    [self.ref
     observeEventType:FIRDataEventTypeChildChanged
     withBlock:^(FIRDataSnapshot *snapshot) {

         [self performAction:Update onSnapshot:snapshot];
     }];
}

- (NSInteger) indexOfMessage: (FIRDataSnapshot*)snapshot  {
    NSInteger index = 0;
    for (Product* product in self.productsList) {
        if ([product.key isEqualToString:snapshot.key]) {
            return index;
        }
        index += 1;
    }
    return -1;
}

- (NSInteger) indexOfSnapshot: (FIRDataSnapshot*)snapshot  {
    NSInteger index = 0;
    for (FIRDataSnapshot* snap in self.productsSnapshots) {
        if ([snap.key isEqualToString:snapshot.key]) {
            return index;
        }
        index += 1;
    }
    return -1;
}

- (void) tableViewUpdateAtIndex: (NSUInteger) index {
    [self.delegate updateTableViewAtIndex:index];
}

- (void) disableInteractionsForMain:(BOOL)flag {
    [self.delegate disableInteraction: flag];
}

- (void) publishComment: (NSString *) commentToPublish {
    
    NSString *key = self.currentProduct.key; //[[_ref child:@"comments"] childByAutoId].key;
    NSLog(@"KEY: %@", key);
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:kFacebookName];
    NSString *img = [[NSUserDefaults standardUserDefaults] objectForKey:kFacebookImage];
    NSString *firebaseUserID = [[[FIRAuth auth] currentUser] uid];
    
    PremiumStatus isPremium = [[PremiumManager sharedManager] premiumStatus];
    NSDictionary *comment = @{
                              kCommentName: name,
                              kCommentImage: img,
                              kCommentText: commentToPublish,
                              kCommentUserID: firebaseUserID,
                              kCommentPremiumStatus: @(isPremium),
                              kCommentTimestamp: @([Constants currentTime])
                              };
    
    NSString *to = [NSString stringWithFormat:@"/%@/%lu/", key, (unsigned long)self.currentComments.count];
    NSDictionary *childUpdates = @{to: comment,
                                   };
    [self.commentsRef updateChildValues:childUpdates];
}

// firebase
- (void) addListenerToProductWithKey: (NSString *) productKey {
    
    addNewCommentHandler = [[self.commentsRef child:productKey]
     observeEventType:FIRDataEventTypeChildAdded
     withBlock:^(FIRDataSnapshot *snapshot) {
         NSDictionary *commentDict = snapshot.value;
         ProductComment *comment = [ProductComment commentWithDictionary:commentDict];
         [self.currentComments insertObject:comment atIndex:0];
         [self.commentsDelegate tableViewAction:Add atIndex:0];
     }];
    
    updateCommentHandler = [[self.commentsRef child:productKey]
                            observeEventType:FIRDataEventTypeChildChanged
                            withBlock:^(FIRDataSnapshot *snapshot) {
                                NSDictionary *dict = snapshot.value;
                                ProductComment *comment = [ProductComment commentWithDictionary:dict];
                                NSInteger commentIndex = [self.currentComments commentIndex:comment];
                                self.currentComments[commentIndex] = comment;
                                [self.commentsDelegate tableViewAction:Update atIndex:commentIndex];
                            }];
    deleteCommentHandler = [[self.commentsRef child:productKey]
                            observeEventType:FIRDataEventTypeChildRemoved
                            withBlock:^(FIRDataSnapshot *snapshot) {
                                NSDictionary *dict = snapshot.value;
                                ProductComment *comment = [ProductComment commentWithDictionary:dict];
                                NSInteger commentIndex = [self.currentComments commentIndex:comment];
                                [self.currentComments removeObjectAtIndex:commentIndex];
                                [self.commentsDelegate tableViewAction:Delete atIndex:commentIndex];
                            }];
}

// firebase
- (void) removeListenersForProduct: (NSString *) productKey {
    [_currentComments removeAllObjects];
    [[self.commentsRef child:productKey] removeObserverWithHandle:addNewCommentHandler];
    [[self.commentsRef child:productKey] removeObserverWithHandle:updateCommentHandler];
    [[self.commentsRef child:productKey] removeObserverWithHandle:deleteCommentHandler];
}

- (BOOL) isIphone5Screen {
    
    if ([UIScreen mainScreen].bounds.size.height <= 640) {
        return true;
    }
    return false;
}

+ (NSString *)chatTimeFormat:(long long)epoch
{
    NSDate *now = [NSDate date];
    NSDate *timestamp = [NSDate dateWithTimeIntervalSince1970:epoch];
    
    NSString *dateText = nil;
    int diff = [now timeIntervalSinceDate:timestamp];
    
    if (diff < 0)
    {
        diff = 0;
    }
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange days = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:now];
    NSInteger secondsInMonth = 0;
    switch (days.length)
    {
        case 28:
            secondsInMonth = SECONDS_PER_28MONTH;
            break;
        case 30:
            secondsInMonth = SECONDS_PER_30MONTH;
            break;
        case 31:
            secondsInMonth = SECONDS_PER_31MONTH;
            break;
        default:
            break;
    }
    
    BOOL justNow = diff < SECONDS_PER_MINUTE;
    BOOL minutesAgo = !justNow && diff < SECONDS_PER_HOUR;
    BOOL hoursAgo = !minutesAgo && diff < SECONDS_PER_DAY;
    BOOL daysAgo = !hoursAgo && (diff > SECONDS_PER_DAY && diff < SECONDS_PER_WEEK);
    BOOL weeksAgo = !daysAgo && (diff > SECONDS_PER_WEEK && diff < secondsInMonth);
    
    if (justNow)
    {
        dateText = @"JUST NOW";
    }
    else if (minutesAgo)
    {
        NSInteger minutes = diff / SECONDS_PER_MINUTE;
        NSString *minString = (minutes == 1) ? @"minute" : @"minutes";
        dateText = [NSString stringWithFormat:@"%ld %@ ago", (long)minutes, minString];
    }
    else if (hoursAgo)
    {
        NSInteger hours = diff / SECONDS_PER_HOUR;
        NSString *hoursString = (hours == 1) ? @"hour" : @"hours";
        dateText = [NSString stringWithFormat:@"%ld %@ ago", (long)hours, hoursString];
    }
    else if (daysAgo)
    {
        NSInteger days = diff / SECONDS_PER_DAY;
        NSString *daysString = (days == 1) ? @"day" : @"days";
        dateText = [NSString stringWithFormat:@"%ld %@ ago", (long)days, daysString];
    }
    else if (weeksAgo)
    {
        NSInteger weeks = diff / SECONDS_PER_WEEK;
        NSString *weeksString = (weeks == 1) ? @"week" : @"weeks";
        dateText = [NSString stringWithFormat:@"%ld %@ ago", (long)weeks, weeksString];
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
        
        dateText = [dateFormatter stringFromDate:timestamp];
    }
    
    return [dateText uppercaseString];
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
