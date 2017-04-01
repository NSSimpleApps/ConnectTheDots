//
//  NSJSONSerialization+NSDictionaryWithFile.h
//  JSONToCoreData
//
//  Created by NSSimpleApps on 06.02.15.
//  Copyright (c) 2015 NSSimpleApps. All rights reserved.
//

#import <Foundation/Foundation.h>

// JSON serialization from file

NS_ASSUME_NONNULL_BEGIN

@interface NSJSONSerialization (NSDictionaryWithFile)

+ (NSDictionary *)dictionaryWithFile:(NSString *)pathForResource;

@end

NS_ASSUME_NONNULL_END