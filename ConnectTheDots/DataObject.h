//
//  DataObject.h
//  ConnectTheDots
//
//  Created by NSSimpleApps on 17.03.16.
//  Copyright (c) 2016 NSSimpleApps. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataObject: NSObject

- (instancetype)initWithName:(NSString *)name points:(NSArray<NSArray<NSNumber *> *> *)pairs;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSArray<NSValue *> *points;

@end

NS_ASSUME_NONNULL_END