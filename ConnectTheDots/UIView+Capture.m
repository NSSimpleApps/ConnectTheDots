//
//  UIView+Capture.m
//  ConnectTheDots
//
//  Created by NSSimpleApps on 20.03.16.
//  Copyright (c) 2016 NSSimpleApps. All rights reserved.
//

#import "UIView+Capture.h"

@implementation UIView (Capture)

- (UIImage *)captureWithSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
