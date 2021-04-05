//
//  FullViewController.m
//  网络视频播放(AVPlayer)
//
//  Created by apple on 15/8/16.
//  Copyright (c) 2015年 FMG. All rights reserved.
//

#import "FullViewController.h"
#import "FullView.h"
#import "BrightnessVolumeView.h"

@interface FullViewController ()

@end

@implementation FullViewController

- (void)loadView
{
    FullView *fullView = [[FullView alloc] init];
    self.view = fullView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (_isPortrait == YES) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (_isPortrait == YES) {
        return YES;

    }
    return NO;
}

@end
