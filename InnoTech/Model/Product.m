//
//  Product.m
//  InnoTech
//
//  Created by Vladyslav Gusakov on 5/3/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import "Product.h"

@implementation Product

-(instancetype) initWithName:(NSString *)name description:(NSString*) descr url:(NSString *)url imageUrl:(NSString *)imageUrl {
    self = [super init];
    if (self) {
        self.name = name;
        self.shortDescr = descr;
        self.urlString = url;
        self.imageURL = imageUrl;
        self.cached = false;
//        self.categories = [NSMutableArray new];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.shortDescr forKey:@"shortDescr"];
    [aCoder encodeObject:self.urlString forKey:@"urlString"];
    [aCoder encodeObject:self.imageURL forKey:@"imageURL"];
    [aCoder encodeBool:self.cached forKey:@"cached"];
    [aCoder encodeObject:self.key forKey:@"key"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:self.imageData forKey:@"imageData"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.shortDescr = [aDecoder decodeObjectForKey:@"shortDescr"];
        self.urlString = [aDecoder decodeObjectForKey:@"urlString"];
        self.imageURL = [aDecoder decodeObjectForKey:@"imageURL"];
        self.cached = [aDecoder decodeBoolForKey:@"cached"];
        self.image = [aDecoder decodeObjectForKey:@"image"];
        self.key = [aDecoder decodeObjectForKey:@"key"];
        self.imageData = [aDecoder decodeObjectForKey:@"imageData"];
    }
    return self;
}


@end
