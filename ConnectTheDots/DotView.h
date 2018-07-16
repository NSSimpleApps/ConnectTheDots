//
//  DotView.h
//  ConnectTheDots
//
//  Created by NSSimpleApps on 15.05.15.
//  Copyright (c) 2015 NSSimpleApps. All rights reserved.
//

#import <UIKit/UIKit.h>

// Round label with certain center

@interface DotView : UILabel

- (instancetype)initWithNumber:(NSInteger)number center:(CGPoint)center diameter:(CGFloat)diameter;

@end
