//
//  Product.h
//  InnoTech
//
//  Created by Vladyslav Gusakov on 5/3/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface Product : NSObject

/**
 * The key of the location that generated this Product based on FIRDataSnapshot.
 *
 * @return An NSString containing the key for the location of this FIRDataSnapshot.
 */
@property (retain, nonatomic) NSString *key;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *shortDescr;
@property (retain, nonatomic) NSString *imageURL;
@property (retain, nonatomic) NSString *image;
@property (retain, nonatomic) NSString *urlString;
@property (retain, nonatomic) NSData *imageData;
@property (retain, nonatomic) NSArray *categories;

@property (nonatomic) BOOL cached;

-(instancetype) initWithName:(NSString *)name description:(NSString*) descr url: (NSString *) url imageUrl: (NSString*) imageUrl;

@end
