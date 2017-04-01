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
@import Social;


@interface MasterViewController () <MasterViewDataSource, MasterViewDelegate>

@property (assign, nonatomic) BOOL flag;

@property (strong, nonatomic) AudioController *audioController;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //self.index = 0;
    self.flag = NO;
    
    MasterView *masterView = (MasterView *)self.view;
    masterView.delegate = self;
    masterView.dataSource = self;
    //masterView.bezierPath = self.bezierPath;
    
    self.audioController = [AudioController new];
}

- (UIBezierPath *)bezierPath {
    
    if (_bezierPath == nil) {
        
        _bezierPath = [UIBezierPath bezierPath];
        _bezierPath.lineWidth = 1;
    }
    
    return _bezierPath;
}

- (IBAction)saveAndDismiss:(UIBarButtonItem *)sender {
    
    CGSize size = CGSizeMake(120 * self.view.frame.size.width/self.view.frame.size.height, 120);
    
    UIImage *image = [self.view captureWithSize:size];
        
    [self dismissViewControllerAnimated:YES completion:^{
        
        [self.delegate gameDidFinishWithIndex:self.index
                                        image:image
                                   bezierPath:self.bezierPath];
    }];
}

- (IBAction)nextAction:(UIBarButtonItem *)sender {
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Start again or share with..."
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController setModalPresentationStyle:UIModalPresentationCurrentContext];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    UIAlertAction *startAgainAction = [UIAlertAction actionWithTitle:@"Start again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        self.index = 0;
        self.flag = NO;
        _bezierPath = nil;
        
        MasterView *masterView = (MasterView *)self.view;
        //masterView.bezierPath = self.bezierPath;
        [masterView reloadData];
    }];
    [alertController addAction:startAgainAction];
    
    UIAlertAction *shareWithFBAction = [UIAlertAction actionWithTitle:@"Share with FB" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
            SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [composeViewController setInitialText:@"Connect the dots"];
            [composeViewController addImage:[self.view captureWithSize:CGSizeMake(160 * self.view.frame.size.width/self.view.frame.size.height, 160)]];
            [self presentViewController:composeViewController animated:YES completion:nil];
        } else {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Facebook is not available" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [alertController addAction:alertAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
    [alertController addAction:shareWithFBAction];
    
    UIAlertAction *shareWithTwitterAction = [UIAlertAction actionWithTitle:@"Share with Twitter" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            
            
            SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [composeViewController setInitialText:@"Connect the dots"];
            [composeViewController addImage:[self.view captureWithSize:CGSizeMake(160 * self.view.frame.size.width/self.view.frame.size.height, 160)]];
            [self presentViewController:composeViewController animated:YES completion:nil];
        } else {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Twitter is not available" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:alertAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
    [alertController addAction:shareWithTwitterAction];
    
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
