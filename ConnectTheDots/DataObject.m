//
//  DataObject.m
//  ConnectTheDots
//
//  Created by NSSimpleApps on 17.03.16.
//  Copyright (c) 2016 NSSimpleApps. All rights reserved.
//

#import "DataObject.h"
#import <UIKit/UIGeometry.h>


@implementation DataObject

- (instancetype)initWithName:(NSString *)name points:(NSArray<NSArray<NSNumber *> *> *)pairs {
    
    self = [super init];
    
    if (self) {
        
        self.name = name;
        
        NSMutableArray<NSValue *> *temp = [NSMutableArray array];
        
        for (NSArray<NSNumber *> *pair in pairs) {
            
            [temp addObject:[NSValue valueWithCGPoint:CGPointMake(pair[0].floatValue, pair[1].floatValue)]];
        }
        
        self.points = temp;
    }
    return self;
}

@end