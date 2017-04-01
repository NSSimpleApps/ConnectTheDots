//
//  SettingsManager.m
//  ConnectTheDots
//
//  Created by NSSimpleApps on 17.03.16.
//  Copyright (c) 2016 NSSimpleApps. All rights reserved.
//

#import "SettingsManager.h"
#import <UIKit/UIImage.h>
#import <UIKit/UIBezierPath.h>

@interface SettingsManager ()

@property (strong, nonatomic) NSUserDefaults *userDefaults;

@end

@implementation SettingsManager

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

+ (instancetype)shared {
    
    static SettingsManager *settingsManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        settingsManager = [[self alloc] init];
    });
    
    return settingsManager;
}

- (NSInteger)indexForKey:(NSString *)key {
    
    return [self.userDefaults integerForKey:[@"index_" stringByAppendingString:key]];
}

- (void)setIndex:(NSInteger)index forKey:(NSString *)key {
    
    [self.userDefaults setInteger:index forKey:[@"index_" stringByAppendingString:key]];
}

- (UIImage *)imageForKey:(NSString *)key {
    
    NSData *data = [self.userDefaults dataForKey:[@"image_" stringByAppendingString:key]];
    
    if (data) {
        
        return [[UIImage alloc] initWithData:data];
    }
    return nil;
}

- (void)setImage:(nullable UIImage *)image forKey:(NSString *)key {
    
    if (image == nil) {
        
        [self.userDefaults removeObjectForKey:[@"image_" stringByAppendingString:key]];
        
    } else {
        
        NSData *data = UIImagePNGRepresentation(image);
        
        [self.userDefaults setObject:data forKey:[@"image_" stringByAppendingString:key]];
    }
}

- (UIBezierPath *)bezierPathForKey:(NSString *)key {
    
    NSData *data = [self.userDefaults objectForKey:[@"bezierPath_" stringByAppendingString:key]];
    
    if (data != nil) {
        
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

- (void)setBezierPath:(nullable UIBezierPath *)bezierPath forKey:(NSString *)key {
    
    if (bezierPath == nil) {
        
        [self.userDefaults removeObjectForKey:[@"bezierPath_" stringByAppendingString:key]];
        
    } else {
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:bezierPath];
        
        [self.userDefaults setObject:data forKey:[@"bezierPath_" stringByAppendingString:key]];
    }
}

@end