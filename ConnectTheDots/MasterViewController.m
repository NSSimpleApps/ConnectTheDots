//
//  MasterViewController.m
//  ConnectTheDots
//
//  Created by NSSimpleApps on 15.05.15.
//  Copyright (c) 2015 NSSimpleApps. All rights reserved.
//

#import "MasterViewController.h"
#import "DotView.h"
#import "MasterView.h"
#import "DataTransferProtocol.h"
#import "AudioController.h"
#import "UIView+Capture.h"
#import "SettingsManager.h"


@interface MasterViewController () <MasterViewDataSource, MasterViewDelegate>

@property (assign, nonatomic) BOOL flag;
@property (strong, nonatomic) AudioController *audioController;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //self.index = 0;
    self.flag = NO;
    MasterView *masterView = [[MasterView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    masterView.userInteractionEnabled = YES;
    masterView.delegate = self;
    masterView.dataSource = self;
    masterView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:masterView];
    
    [[masterView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor] setActive:YES];
    [[masterView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:YES];
    [[masterView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor] setActive:YES];
    [[masterView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor] setActive:YES];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                          target:self
                                                                                          action:@selector(saveAndDismiss:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                           target:self
                                                                                           action:@selector(nextAction:)];
    
    self.audioController = [AudioController new];
}

- (UIBezierPath *)bezierPath {
    if (_bezierPath == nil) {
        _bezierPath = [UIBezierPath bezierPath];
        _bezierPath.lineWidth = 1;
    }
    
    return _bezierPath;
}

- (void)saveAndDismiss:(UIBarButtonItem *)sender {
    CGSize size = CGSizeMake(120 * self.view.frame.size.width/self.view.frame.size.height, 120);
    
    UIImage *image = [self.view captureWithSize:size];
        
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate gameDidFinishWithIndex:self.index
                                        image:image
                                   bezierPath:self.bezierPath];
    }];
}

- (void)nextAction:(UIBarButtonItem *)sender {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Start again"
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController setModalPresentationStyle:UIModalPresentationCurrentContext];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    UIAlertAction *startAgainAction = [UIAlertAction actionWithTitle:@"Start again"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action) {
        self.index = 0;
        self.flag = NO;
        self->_bezierPath = nil;
        
        MasterView *masterView = (MasterView *)self.view.subviews.firstObject;
        //masterView.bezierPath = self.bezierPath;
        [masterView reloadData];
    }];
    [alertController addAction:startAgainAction];
    alertController.popoverPresentationController.barButtonItem = sender;
    alertController.popoverPresentationController.sourceView = self.view;
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - MasterViewDataSource

- (NSInteger)numberOfSubviewsForMasterView:(MasterView *)masterView {
    return self.points.count;
}

- (UIView *)subviewForMasterView:(MasterView *)masterView atIndex:(NSInteger)index {
    DotView *dotView = [[DotView alloc] initWithNumber:index + 1
                                                center:self.points[index].CGPointValue
                                              diameter:20];
    dotView.tag = index;
    
    if (index < self.index) {
        dotView.backgroundColor = [UIColor greenColor];
        
    } else {
        dotView.backgroundColor = [UIColor redColor];
    }
    
    return dotView;
}

- (UIBezierPath *)bezierPathForMasterView:(MasterView *)masterView {
    return self.bezierPath;
}

#pragma mark - MasterViewDelegate

- (void)touchBeganOnMasterView:(MasterView *)masterView withPoint:(CGPoint)point {
    self.flag = NO;
    
    [masterView.bezierPath moveToPoint:point];
}

- (void)touchBeganOnSubview:(UIView *)subview withPoint:(CGPoint)point inMasterView:(MasterView *)masterView {
    if ([subview isKindOfClass:[DotView class]]) {
        
        if (self.index == subview.tag) {
            subview.backgroundColor = [UIColor greenColor];
            
            self.index++;
            self.flag = YES;
            [self.audioController playCaptureSound];
            
        } else if (self.index - 1 == subview.tag) {
            subview.backgroundColor = [UIColor greenColor];
            
            self.flag = YES;
            
        } else {
            self.flag = NO;
        }
    }
}

- (void)touchMovedOnMasterView:(MasterView *)masterView withPoint:(CGPoint)point {
    [masterView.bezierPath addLineToPoint:point];
    [masterView setNeedsDisplay];
}

- (void)touchDidEnterToSubview:(UIView *)subview withPoint:(CGPoint)point inMasterView:(MasterView *)masterView {
    if ([subview isKindOfClass:[DotView class]]) {
        
        if (self.index == subview.tag && self.flag) {
            self.index++;
            [self.audioController playCaptureSound];
            
            subview.backgroundColor = [UIColor greenColor];
            
            [self.bezierPath appendPath:masterView.bezierPath];
            
        } else {
            masterView.bezierPath = self.bezierPath;
        }
        [masterView setNeedsDisplay];
    }
}

- (void)touchDidExitFromSubview:(UIView *)subview withPoint:(CGPoint)point inMasterView:(MasterView *)masterView {
    if ([subview isKindOfClass:[DotView class]]) {
        [masterView.bezierPath moveToPoint:point];
    }
}

- (void)touchEndedOnMasterView:(MasterView *)masterView withPoint:(CGPoint)point {
    self.flag = NO;
    
    masterView.bezierPath = self.bezierPath;
    [masterView setNeedsDisplay];
}

- (void)touchEndedOnSubview:(UIView *)subview withPoint:(CGPoint)point inMasterView:(MasterView *)masterView {
    /*if ([subview isKindOfClass:[DotView class]]) {
        
        if (self.index == subview.tag) {
            
            
        }
    }*/
}

@end
