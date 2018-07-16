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
        
        //self.bezierPath = [UIBezierPath bezierPath];
        //self.bezierPath.lineWidth = 1;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.multipleTouchEnabled = NO;
        
        //self.bezierPath = [UIBezierPath bezierPath];
        //self.bezierPath.lineWidth = 3;
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
    
    if (self.delegate == nil) {
        
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    UIView *view = [self hitTest:point withEvent:event];
    
    self.previousView = view;
    
    if ([view isEqual:self]) {
        
        if ([self.delegate respondsToSelector:@selector(touchBeganOnMasterView:withPoint:)]) {
            
            [self.delegate touchBeganOnMasterView:self withPoint:point];
        }
        
    } else {
        
        if ([self.delegate respondsToSelector:@selector(touchBeganOnSubview:withPoint:inMasterView:)]) {
            
            [self.delegate touchBeganOnSubview:view withPoint:point inMasterView:self];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.delegate == nil) {
        
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    UIView *nextView = [self hitTest:point withEvent:event];
    
    if ([self.previousView isEqual:self] && [nextView isEqual:self]) {
        
        if ([self.delegate respondsToSelector:@selector(touchMovedOnMasterView:withPoint:)]) {
            
            [self.delegate touchMovedOnMasterView:self withPoint:point];
        }
        
    } else if (![self.previousView isEqual:self] && [nextView isEqual:self]) {
        
        if ([self.delegate respondsToSelector:@selector(touchDidExitFromSubview:withPoint:inMasterView:)]) {
            
            [self.delegate touchDidExitFromSubview:self.previousView withPoint:point inMasterView:self];
        }
        
    } else if ([self.previousView isEqual:self] && ![nextView isEqual:self]) {
        
        if ([self.delegate respondsToSelector:@selector(touchDidEnterToSubview:withPoint:inMasterView:)]) {
            
            [self.delegate touchDidEnterToSubview:nextView withPoint:point inMasterView:self];
        }
    }
    
    self.previousView = nextView;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.delegate == nil) {
        
        return;
    }
    
    self.previousView = nil;
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    UIView *view = [self hitTest:point withEvent:event];
    
    if ([view isEqual:self]) {
        
        if ([self.delegate respondsToSelector:@selector(touchEndedOnMasterView:withPoint:)]) {
            
            [self.delegate touchEndedOnMasterView:self withPoint:point];
        }
        
    } else {
        
        if ([self.delegate respondsToSelector:@selector(touchEndedOnSubview:withPoint:inMasterView:)]) {
            
            [self.delegate touchEndedOnSubview:view withPoint:point inMasterView:self];
        }
    }
}

- (void)reloadData {
    
    for (UIView *v in self.subviews) {
        
        [v removeFromSuperview];
    }
    
    [self.bezierPath removeAllPoints];
    
    if (self.dataSource != nil) {
        
        self.bezierPath = [self.dataSource bezierPathForMasterView:self];
        
        NSInteger numberOfSubviews = [self.dataSource numberOfSubviewsForMasterView:self];
        
        for (NSInteger index = 0; index < numberOfSubviews; index++) {
            
            UIView *subview = [self.dataSource subviewForMasterView:self atIndex:index];
            
            [self addSubview:subview];
        }
    }
    
    [self setNeedsDisplay];
}

@end
