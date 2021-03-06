//
//  HCLLoadingWaitBoxManager.m
//  HCLLoadingWaitBox
//
//  Created by 贺灿林 on 2020/9/21.
//  Copyright © 2020 贺灿林. All rights reserved.
//

#import "HCLLoadingWaitBoxManager.h"
#import "HCLActivityView.h"
#import "HCLPointView.h"
#import "HCLColorRotaionView.h"

@interface HCLLoadingWaitBoxManager ()

@property (strong, nonatomic) UIView *currentShowView;

@end

@implementation HCLLoadingWaitBoxManager

static HCLLoadingWaitBoxManager *shareLoadingWaitManager;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareLoadingWaitManager = [[HCLLoadingWaitBoxManager alloc] init];
    });
    return shareLoadingWaitManager;
}

- (void)showLoadingWaitBoxWithType:(enumHCLLoadingWaitBoxType)type text:(NSString *)text view:(UIView *)superView
{
    if (_currentShowView != nil) {
        [self hiddenLoadingWaitBox];
        return;
    }
    if (type == eHCLLoadingWaitBoxTypeActivityBottomText ||
        type == eHCLLoadingWaitBoxTypeActivityTopText ||
        type == eHCLLoadingWaitBoxTypeActivity) {
        HCLActivityView *view = [[HCLActivityView alloc] initWithFrame:superView.bounds];
        [view showActivityType:type text:text];
        [superView addSubview:view];
        _currentShowView = view;
    } else if (type == eHCLLoadingWaitBoxTypePointTopText ||
               type == eHCLLoadingWaitBoxTypePoint) {
        HCLPointView *view = [[HCLPointView alloc] initWithFrame:superView.bounds];
        [view showPointType:type text:text];
        [superView addSubview:view];
        _currentShowView = view;
    } else if (type == eHCLLoadingWaitBoxTypeColorRotation) {
        HCLColorRotaionView *view = [[HCLColorRotaionView alloc] initWithFrame:superView.bounds];
        [view showColorRotationView];
        [superView addSubview:view];
        _currentShowView = view;
    }
}

- (void)hiddenLoadingWaitBox
{
    if ([_currentShowView isKindOfClass:[HCLActivityView class]]) {
        [((HCLActivityView *)_currentShowView) hiddenActivity];
    } else if ([_currentShowView isKindOfClass:[HCLPointView class]]) {
        [((HCLPointView *)_currentShowView) hiddenPoint];
    } else if ([_currentShowView isKindOfClass:[HCLColorRotaionView class]]) {
        [((HCLColorRotaionView *)_currentShowView) hiddenColorRotationView];
    }
    _currentShowView = nil;
}

@end
