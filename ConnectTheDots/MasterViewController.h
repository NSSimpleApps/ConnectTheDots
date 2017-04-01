//
//  MasterViewController.h
//  ConnectTheDots
//
//  Created by NSSimpleApps on 15.05.15.
//  Copyright (c) 2015 NSSimpleApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DataTransferProtocol;

NS_ASSUME_NONNULL_BEGIN

@interface MasterViewController : UIViewController

@property (assign, nonatomic) NSInteger index;

@property (strong, nonatomic) UIBezierPath *bezierPath;

@property (copy, nonatomic) NSArray<NSValue *> *points;

@property (weak, nonatomic) id<DataTransferProtocol> delegate;

@end


NS_ASSUME_NONNULL_END