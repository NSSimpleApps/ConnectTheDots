//
//  MasterView.h
//  ConnectTheDots
//
//  Created by NSSimpleApps on 16.05.15.
//  Copyright (c) 2015 NSSimpleApps. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MasterView;

@protocol MasterViewDataSource <NSObject>

- (NSInteger)numberOfSubviewsForMasterView:(MasterView *)masterView;

- (UIView *)subviewForMasterView:(MasterView *)masterView atIndex:(NSInteger)index;

- (UIBezierPath *)bezierPathForMasterView:(MasterView *)masterView;

@end

@protocol MasterViewDelegate <NSObject>

@optional

- (void)touchBeganOnMasterView:(MasterView *)masterView withPoint:(CGPoint)point;
- (void)touchBeganOnSubview:(nullable UIView *)subview withPoint:(CGPoint)point inMasterView:(MasterView *)masterView;

- (void)touchMovedOnMasterView:(MasterView *)masterView withPoint:(CGPoint)point;

- (void)touchDidEnterToSubview:(nullable UIView *)subview withPoint:(CGPoint)point inMasterView:(MasterView *)masterView;

- (void)touchDidExitFromSubview:(nullable UIView *)subview withPoint:(CGPoint)point inMasterView:(MasterView *)masterView;


- (void)touchEndedOnMasterView:(MasterView *)masterView withPoint:(CGPoint)point;
- (void)touchEndedOnSubview:(nullable UIView *)subview withPoint:(CGPoint)point inMasterView:(MasterView *)masterView;

@end


@interface MasterView : UIView

@property (nonatomic, weak, nullable) id<MasterViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id<MasterViewDelegate> delegate;

@property (nonatomic, copy) UIBezierPath *bezierPath;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END