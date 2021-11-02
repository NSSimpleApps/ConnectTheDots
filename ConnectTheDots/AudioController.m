//
//  AudioController.m
//  ConnectTheDots
//
//  Created by NSSimpleApps on 19.05.15.
//  Copyright (c) 2015 NSSimpleApps. All rights reserved.
//

#import "AudioController.h"
@import AVFoundation;

@interface AudioController ()

@property (assign, nonatomic) SystemSoundID captureSoundID;

@end

@implementation AudioController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"capture"
                                                  withExtension:@"aif"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &_captureSoundID);
    }
    return self;
}

- (void)playCaptureSound {
    AudioServicesPlaySystemSound(self.captureSoundID);
}

- (void)dealloc {
    AudioServicesDisposeSystemSoundID(self.captureSoundID);
}


@end
