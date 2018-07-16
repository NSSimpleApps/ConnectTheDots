//
//  DotView.m
//  ConnectTheDots
//
//  Created by NSSimpleApps on 15.05.15.
//  Copyright (c) 2015 NSSimpleApps. All rights reserved.
//

#import "DotView.h"

@implementation DotView

- (instancetype)initWithNumber:(NSInteger)number center:(CGPoint)center diameter:(CGFloat)diameter {
    
    self = [super initWithFrame:CGRectMake(center.x - diameter/2, center.y - diameter/2, diameter, diameter)];
    
    if (self) {
        
        self.clipsToBounds = YES;
        self.layer.cornerRadius = diameter/2;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1;
        
        self.text = [NSString stringWithFormat:@"%ld", (long)number];
        self.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        self.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = YES;
    }
    return self;
}

@end
