//
//  SettingsManager.h
//  ConnectTheDots
//
//  Created by NSSimpleApps on 17.03.16.
//  Copyright (c) 2016 NSSimpleApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage, UIBezierPath;

NS_ASSUME_NONNULL_BEGIN

@interface SettingsManager: NSObject

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)shared;

- (NSInteger)indexForKey:(NSString *)key;
- (void)setIndex:(NSInteger)index forKey:(NSString *)key;

- (nullable UIImage *)imageForKey:(NSString *)key;
- (void)setImage:(nullable UIImage *)image forKey:(NSString *)key;

- (nullable UIBezierPath *)bezierPathForKey:(NSString *)key;
- (void)setBezierPath:(nullable UIBezierPath *)bezierPath forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END