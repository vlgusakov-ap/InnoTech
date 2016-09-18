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
@property (nonatomic) BOOL useCellular;
@property (nonatomic) BOOL menuOpened;

@property (nonatomic) PremiumStatus premiumStatus;

+ (id) sharedManager;

- (void) fireBaseSetup;
- (void) tableViewUpdateAtIndex: (NSUInteger) index;
- (void) disableInteractionsForMain: (BOOL) flag;
- (void) publishComment: (NSString *) commentToPublish;
- (void) addListenerToProductWithKey: (NSString *) productKey;
- (void) removeListenersForProduct: (NSString *) productKey;

- (BOOL) isIphone5Screen;
- (void) enablePremium: (BOOL) enable;
- (void) initIAP;

@end
