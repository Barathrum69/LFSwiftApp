//
//  DRSmallDragView.m
//  DragonLive
//
//  Created by 11号 on 2021/1/5.
//

#import "DRSmallDragView.h"
#import "UIView+drag.h"
#import "LiveRoomViewController.h"

@interface DRSmallDragView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) LiveItem *liveItem;                       //直播列表model
@property (nonatomic, strong) HostModel *hostModel;                     //赛事model
@property (nonatomic, strong) TXLivePlayer *livePlayer;                 //直播播放器
@property (nonatomic, strong) TXVodPlayer *vodPlayer;                   //录播播放器
@property (nonatomic, assign) BOOL isSmallShow;                         //是否正在小窗播放
@property (nonatomic, assign) BOOL isLive;                              //是否是直播小窗

@end

@implementation DRSmallDragView

+ (DRSmallDragView *)smallDragViewManager
{
    static DRSmallDragView *manager =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat ratio = 16.0/9.0;       //宽高比
        CGFloat width = kkScreenWidth/3.0 * 2.0;
        CGFloat height = width / ratio;
        manager = [[DRSmallDragView alloc] initWithFrame:CGRectMake(10, 88, width, height)];
    });
    
    return manager;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.fl_canSlide = YES;
        self.fl_isAdsorb = NO;
        
        self.backgroundColor = [UIColor blackColor];
        // 阴影颜色
       self.layer.shadowColor = [UIColor blackColor].CGColor;
       // 阴影偏移，默认(0, -3)
        self.layer.shadowOffset = CGSizeMake(0,0);
       // 阴影透明度，默认0
        self.layer.shadowOpacity = 0.5;
       // 阴影半径，默认3
        self.layer.shadowRadius = 5;
        
        //给UITableView添加点击手势
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
        
        UIButton *cancelBut = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 27, -3, 30, 30)];
        [cancelBut setImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
        [cancelBut addTarget:self action:@selector(closeButAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBut];
    }
    return self;
}

/// 显示小窗播放模式
/// @param livePlayer 播放器
/// @param liveItem 直播列表item
- (void)showWindowWithPlayer:(TXLivePlayer *)livePlayer liveItem:(LiveItem *)liveItem
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    _isLive = YES;
    _isSmallShow = YES;
    _livePlayer = livePlayer;
    _liveItem = liveItem;
    [_livePlayer setupVideoWidget:CGRectZero containView:self insertIndex:0];
}

/// 赛事小窗播放
/// @param livePlayer 播放器
/// @param hostModel 赛事模型
- (void)showWindowWithPlayer:(TXLivePlayer *)livePlayer hostModel:(HostModel *)hostModel
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    _isLive = YES;
    _isSmallShow = YES;
    _livePlayer = livePlayer;
    _hostModel = hostModel;
    [_livePlayer setupVideoWidget:CGRectZero containView:self insertIndex:0];
}

/// 录播小窗播放
/// @param vodPlayer 录播播放器
/// @param liveItem 赛事模型
- (void)showWindowWithVodPlayer:(TXVodPlayer *)vodPlayer liveItem:(LiveItem *)liveItem
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    _isLive = NO;
    _isSmallShow = YES;
    _vodPlayer = vodPlayer;
    _liveItem = liveItem;
    [_vodPlayer setupVideoWidget:self insertIndex:0];
}

/// 关闭小窗播放
- (void)closeSmallView
{
    [self stopPlay];
    _isSmallShow = NO;
    [self removeFromSuperview];
}

- (void)closeButAction
{
    [self closeSmallView];
}

- (void)stopPlay
{
    if (self.isLive) {
        if (_livePlayer) {
            [_livePlayer setDelegate:nil];
            [_livePlayer removeVideoWidget];
            [_livePlayer stopPlay];
        }
    }else {
        if (_vodPlayer) {
            [_vodPlayer setVodDelegate:nil];
            [_vodPlayer removeVideoWidget];
            [_vodPlayer stopPlay];
        }
    }
}

/// 暂停播放
- (void)pause
{
    if (self.isLive) {
        [_livePlayer pause];
    }else {
        [_vodPlayer pause];
    }
}

/// 继续播放
- (void)resume
{
    if (self.isLive) {
        [_livePlayer resume];
    }else {
        [_vodPlayer resume];
    }
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender{

    [self removeFromSuperview];
    
    LiveRoomViewController *controller = [[LiveRoomViewController alloc] init];
    controller.liveItem = _liveItem;
    controller.livePlayer = _livePlayer;
    controller.matchItem = _hostModel;
    [[self topViewController].navigationController pushViewController:controller animated:YES];
}


- (UIViewController * )topViewController
{
    UIViewController *resultVC;
    resultVC = [self recursiveTopViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self recursiveTopViewController:resultVC.presentedViewController];
    }
    return resultVC;
}
 
- (UIViewController * )recursiveTopViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self recursiveTopViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self recursiveTopViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end
