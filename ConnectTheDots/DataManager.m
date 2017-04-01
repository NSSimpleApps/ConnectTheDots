//
//  DataManager.m
//  ConnectTheDots
//
//  Created by NSSimpleApps on 17.03.16.
//  Copyright (c) 2016 NSSimpleApps. All rights reserved.
//

#import "DataManager.h"
#import "DataObject.h"
#import "NSJSONSerialization+NSDictionaryWithFile.h"


@implementation DataManager

+ (instancetype)shared {
    
    static DataManager *dataManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dataManager = [[self alloc] init];
    });
    
    return dataManager;
}

- (DataObject *)loadDataObjectFromJSON:(NSString *)json {
    
    NSArray<NSString *> *components = [json componentsSeparatedByString:@"."];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:components[0]
                                                     ofType:components[1]];
    
    NSDictionary *d = [NSJSONSerialization dictionaryWithFile:path];
    
    NSAssert(d != nil, @"Could not load json");
    
    return [[DataObject alloc] initWithName:d[@"name"]
                                     points:d[@"points"]];
}
@end