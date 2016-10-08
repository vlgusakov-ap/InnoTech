//
//  MyManager.h
//  InnoTech
//
//  Created by Vladyslav Gusakov on 5/14/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
#import "NSString+MD5.h"
#import "NSArray+Check.h"
#import "Product.h"
#import "Constants.h"
@import AFNetworking;
@import Firebase;
@import SDWebImage;

typedef NS_ENUM(NSUInteger, FireBaseAction) {
    Add = 0,
    Delete,
    Update
};

/***************** Time **********************/
#define SECONDS_PER_MINUTE 60
#define SECONDS_PER_HOUR 3600
#define SECONDS_PER_DAY 86400
#define SECONDS_PER_WEEK 604800
#define MINUTES_PER_HOUR 60
#define HOURS_PER_DAY 24
#define DAYS_PER_WEEK 7
#define SECONDS_PER_28MONTH 2419200
#define SECONDS_PER_30MONTH 2592000
#define SECONDS_PER_31MONTH 2678400

@protocol MyManagerDelegate <NSObject>

@optional
-(void) updateTableView;
- (void) updateTableViewAtIndex: (NSUInteger) index;
-(void) tableViewAction: (FireBaseAction) action atIndex: (NSUInteger) index;
- (void) disableInteraction: (BOOL) flag;
- (void) facebook: (BOOL) logged;

- (BOOL) fireBaseReAuth;

@end

@interface MyManager : NSObject 

@property (nonatomic, strong) NSMutableArray *productsList;
@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) id commentsDelegate;
@property (nonatomic, strong) NSString *currentSection;
@property (nonatomic, strong) NSArray *menuProductCategories;
@property (nonatomic, strong) Product *currentProduct;

@property (nonatomic, strong) FIRDatabaseReference *ref;
@property (nonatomic, strong) FIRDatabaseReference *commentsRef;

@property (nonatomic, strong) NSMutableArray *productsSnapshots;
@property (nonatomic, strong) NSMutableDictionary *cachedWebsites;
@property (nonatomic, strong) NSMutableDictionary *productsDict;
@property (nonatomic, strong) NSMutableArray <NSDictionary*> *currentComments;
@property (nonatomic) BOOL toNewMsg;
@property (strong, nonatomic) SDImageCache *imageCache;
@property (nonatomic) BOOL menuOpened;

+ (id) sharedManager;

- (void) fireBaseSetup;
- (void) tableViewUpdateAtIndex: (NSUInteger) index;
- (void) disableInteractionsForMain: (BOOL) flag;
- (void) publishComment: (NSString *) commentToPublish;
- (void) addListenerToProductWithKey: (NSString *) productKey;
- (void) removeListenersForProduct: (NSString *) productKey;

- (BOOL) isIphone5Screen;
+ (NSString *)chatTimeFormat:(long long)epoch;

@end
