//
//  UIView+Capture.h
//  ConnectTheDots
//
//  Created by NSSimpleApps on 20.03.16.
//  Copyright (c) 2016 NSSimpleApps. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Capture)

- (UIImage *)captureWithSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END