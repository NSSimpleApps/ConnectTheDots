//
//  MasterView.m
//  ConnectTheDots
//
//  Created by NSSimpleApps on 16.05.15.
//  Copyright (c) 2015 NSSimpleApps. All rights reserved.
//

#import "MasterView.h"

@interface MasterView ()

@property (nullable, weak, nonatomic) UIView *previousView;

@end

@implementation MasterView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.multipleTouchEnabled = NO;
        self.opaque = NO;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.multipleTouchEnabled = NO;
        self.opaque = NO;
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview != nil) {
        [self reloadData];
    }
}

- (void)drawRect:(CGRect)rect {
    [[UIColor blackColor] setStroke];
    
    [self.bezierPath stroke];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    id<MasterViewDelegate> delegate = self.delegate;
    
    if (delegate == nil) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    UIView *view = [self hitTest:point withEvent:event];
    
    self.previousView = view;
    
    if ([view isEqual:self]) {
        if ([delegate respondsToSelector:@selector(touchBeganOnMasterView:withPoint:)]) {
            [delegate touchBeganOnMasterView:self withPoint:point];
        }
        
    } else {
        if ([delegate respondsToSelector:@selector(touchBeganOnSubview:withPoint:inMasterView:)]) {
            [delegate touchBeganOnSubview:view withPoint:point inMasterView:self];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    id<MasterViewDelegate> delegate = self.delegate;
    
    if (delegate == nil) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    UIView *nextView = [self hitTest:point withEvent:event];
    
    if ([self.previousView isEqual:self] && [nextView isEqual:self]) {
        if ([delegate respondsToSelector:@selector(touchMovedOnMasterView:withPoint:)]) {
            [delegate touchMovedOnMasterView:self withPoint:point];
        }
        
    } else if (![self.previousView isEqual:self] && [nextView isEqual:self]) {
        if ([delegate respondsToSelector:@selector(touchDidExitFromSubview:withPoint:inMasterView:)]) {
            [delegate touchDidExitFromSubview:self.previousView withPoint:point inMasterView:self];
        }
        
    } else if ([self.previousView isEqual:self] && ![nextView isEqual:self]) {
        if ([delegate respondsToSelector:@selector(touchDidEnterToSubview:withPoint:inMasterView:)]) {
            [delegate touchDidEnterToSubview:nextView withPoint:point inMasterView:self];
        }
    }
    self.previousView = nextView;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    id<MasterViewDelegate> delegate = self.delegate;
    
    if (delegate == nil) {
        return;
    }
    self.previousView = nil;
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    UIView *view = [self hitTest:point withEvent:event];
    
    if ([view isEqual:self]) {
        if ([delegate respondsToSelector:@selector(touchEndedOnMasterView:withPoint:)]) {
            [delegate touchEndedOnMasterView:self withPoint:point];
        }
    } else {
        if ([delegate respondsToSelector:@selector(touchEndedOnSubview:withPoint:inMasterView:)]) {
            [delegate touchEndedOnSubview:view withPoint:point inMasterView:self];
        }
    }
}

- (void)reloadData {
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    [self.bezierPath removeAllPoints];
    
    id<MasterViewDataSource> dataSource = self.dataSource;
    
    if (dataSource != nil) {
        self.bezierPath = [dataSource bezierPathForMasterView:self];
        
        NSInteger numberOfSubviews = [dataSource numberOfSubviewsForMasterView:self];
        
        for (NSInteger index = 0; index < numberOfSubviews; index++) {
            UIView *subview = [dataSource subviewForMasterView:self atIndex:index];
            [self addSubview:subview];
        }
    }
    [self setNeedsDisplay];
}

@end
