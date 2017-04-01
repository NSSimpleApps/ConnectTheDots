//
//  DataTransferProtocol.h
//  ConnectTheDots
//
//  Created by NSSimpleApps on 19.05.15.
//  Copyright (c) 2015 NSSimpleApps. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// This protocol intended to transfer image and result of game between TableViewController and MasterViewController

@protocol DataTransferProtocol <NSObject>

@optional

- (void)gameDidFinishWithIndex:(NSInteger)index
                         image:(nullable UIImage *)image
                    bezierPath:(UIBezierPath *)bezierPath;

@end

NS_ASSUME_NONNULL_END