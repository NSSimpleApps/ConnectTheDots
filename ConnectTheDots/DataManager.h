//
//  DataManager.h
//  ConnectTheDots
//
//  Created by NSSimpleApps on 17.03.16.
//  Copyright (c) 2016 NSSimpleApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataObject;

NS_ASSUME_NONNULL_BEGIN

@interface DataManager: NSObject

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)shared;

- (DataObject *)loadDataObjectFromJSON:(NSString *)json;

@end

NS_ASSUME_NONNULL_END