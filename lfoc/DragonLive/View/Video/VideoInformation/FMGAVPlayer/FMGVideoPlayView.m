//
//  FMGVideoPlayView.m
//  网络视频播放(AVPlayer)
//
//  Created by apple on 15/8/16.
//  Copyright (c) 2015年 FMG. All rights reserved.
//

#import "FMGVideoPlayView.h"
#import "FullViewController.h"
#import "BrightnessVolumeView.h"
#import "PlayEndView.h"
#import "LiveLoadingView.h"
@interface FMGVideoPlayView()

/* 播放器 */
@property (nonatomic, strong) AVPlayer *player;

// 播放器的Layer
@property (weak, nonatomic) AVPlayerLayer *playerLayer;

/* playItem */
@property (nonatomic, weak) AVPlayerItem *currentItem;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


/// 调节音量亮度
@property (nonatomic, strong) BrightnessVolumeView *brightnessVolumeView;
/// 全屏按钮
@property (weak, nonatomic) IBOutlet UIButton *fullBtn;

// 记录当前是否显示了工具栏
@property (assign, nonatomic) BOOL isShowToolView;

/* 定时器 */
@property (nonatomic, strong) NSTimer *progressTimer;

/* 工具栏的显示和隐藏 */
@property (nonatomic, strong) NSTimer *showTimer;

/* 工具栏展示的时间 */
@property (assign, nonatomic) NSTimeInterval showTime;

/* 全屏控制器 */
@property (nonatomic, strong) FullViewController *fullVc;

/// 播放完成显示的view
@property (nonatomic, strong) PlayEndView *playEndView;

/// 加载动画
@property (nonatomic, strong) LiveLoadingView *loadingView;

@property (nonatomic, assign) BOOL isLongShow;

#pragma mark - 监听事件的处理
- (IBAction)playOrPause:(UIButton *)sender;
- (IBAction)switchOrientation:(UIButton *)sender;
- (IBAction)slider;
- (IBAction)startSlider;
- (IBAction)sliderValueChange;

- (IBAction)tapAction:(UITapGestureRecognizer *)sender;
- (IBAction)swipeAction:(UISwipeGestureRecognizer *)sender;
- (IBAction)swipeRight:(UISwipeGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *forwardImageView;

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@end

@implementation FMGVideoPlayView


-(void)setTitleText:(NSString *)titleText{
    _titleText = titleText;
    _titleLabel.text = _titleText;
}

// 快速创建View的方法
+ (instancetype)videoPlayView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"FMGVideoPlayView" owner:nil options:nil] firstObject];
}


-(void)addBadNetWorkViewblock:(void(^)(void))block
{
    if (!self.loadingView) {
        LiveLoadingView * spotView = [LiveLoadingView lvLoadingInstance];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadingViewTap)];
        [spotView addGestureRecognizer:tap];
        [self addSubview:spotView];
        [self bringSubviewToFront: self.topView];
        [self bringSubviewToFront:self.toolView];
        [spotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [spotView setLoadingType:LRNetworkDisconnectType block:^{
            block();
        }];
        
        
        self.loadingView = spotView;
    }
}//增加无网络的界面

-(void)loadingViewFrame:(UIView *)view
{
    if (self.loadingView) {
        [self.loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
   
}

-(void)loadingViewTap{
    [self tapAction:nil];
}//移除无网络的界面的手势.

-(void)removeBadNetWorkView{
    if (self.loadingView) {
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
    }
}


- (AVPlayer *)player
{
    if (!_player) {

        // 初始化Player和Layer
        _player = [[AVPlayer alloc] init];
        if (@available(iOS 10.0, *)) {
            _player.automaticallyWaitsToMinimizeStalling = NO;
        } else {
            // Fallback on earlier versions
        }


    }
    return _player;
}//Player

- (void)awakeFromNib
{
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.imageView.layer addSublayer:self.playerLayer];
    
    // 设置工具栏的状态
    self.toolView.alpha = 0;
    self.topView.alpha = 0;
//    self.isShowToolView = NO;
    
    self.forwardImageView.alpha = 0;
    self.backImageView.alpha = 0;
    
    // 设置进度条的内容
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"thumbImage"] forState:UIControlStateNormal];
    [self.progressSlider setMaximumTrackImage:[UIImage imageNamed:@"MaximumTrackImage"] forState:UIControlStateNormal];
    [self.progressSlider setMinimumTrackImage:[UIImage imageNamed:@"MinimumTrackImage"] forState:UIControlStateNormal];
    
    // 设置按钮的状态
    self.playOrPauseBtn.selected = NO;
    
//    [self showToolView:YES];
    //耳机插入和拔掉通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];
    //中断的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    
}//awakeFromNib

#pragma mark - 观察者对应的方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        [[HCLLoadingWaitBoxManager sharedInstance]hiddenLoadingWaitBox];
//        [STTextHudTool hideSTHud];
        _isLongShow = NO;
        [self showToolView:YES];
        if (AVPlayerItemStatusReadyToPlay == status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeProgressTimer];
                [self addProgressTimer];
            });
        }else if(AVPlayerItemStatusFailed == status){
            NSError *error = [NSError errorWithDomain:@"VideoPlayerErrorDomain" code:100 userInfo:@{NSLocalizedDescriptionKey : @"unknown player error, status == AVPlayerItemStatusFailed"}];
            NSLog(@"%@",error.description);
        }else {
            [self removeProgressTimer];
        }
    }
}//观察者对应的方法

#pragma mark - 重新布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.playerLayer.frame = self.bounds;
}//layoutSubviews

#pragma mark - 设置播放的视频
- (void)setUrlString:(NSString *)urlString
{
    _urlString = urlString;
   
    NSURL *url = [NSURL URLWithString:urlString];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    self.currentItem = item;
    
    [self.player replaceCurrentItemWithPlayerItem:self.currentItem];
//    self.player.currentTime
    [self.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
  
//    [STTextHudTool loading];
    [[HCLLoadingWaitBoxManager sharedInstance] showLoadingWaitBoxWithType:eHCLLoadingWaitBoxTypePoint text:nil view:self];
    [self bringSubviewToFront:_topView];
    _isLongShow = YES;
    [self showToolView:YES];
    [self performSelector:@selector(firstPlay) afterDelay:2.0];
}//设置播放的视频

 - (void)audioRouteChangeListenerCallback:(NSNotification*)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            // 耳机插入
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            
            // 拔掉耳机继续播放
            if (self.isPlaying) {
                
                [self.player play];
            }
            
        }
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            
            break;
    }
}//耳机插入、拔出事件


- (void)handleInterruption:(NSNotification *)notification
{

NSDictionary *info = notification.userInfo;
    //一个中断状态类型
    AVAudioSessionInterruptionType type =[info[AVAudioSessionInterruptionTypeKey] integerValue];

    //判断开始中断还是中断已经结束
    if (type == AVAudioSessionInterruptionTypeBegan) {
        //停止播放
        [self.player pause];

    }else {
        //如果中断结束会附带一个KEY值，表明是否应该恢复音频
        AVAudioSessionInterruptionOptions options =[info[AVAudioSessionInterruptionOptionKey] integerValue];
        if (options == AVAudioSessionInterruptionOptionShouldResume) {
            //恢复播放
            [self.player play];
        }

}

}//中断事件

-(void)firstPlay
{
    self.playOrPauseBtn.selected = YES;
    [self.player play];
    self.isPlaying = YES;
//        [self addShowTimer];
    [self addProgressTimer];
}

// 是否显示工具的View
- (IBAction)tapAction:(UITapGestureRecognizer *)sender
{
    [self showToolView:!self.isShowToolView];
        
    
//    [self removeShowTimer];
//    if (self.isShowToolView) {
//        [self showToolView:YES];
//    }
}

- (IBAction)swipeAction:(UISwipeGestureRecognizer *)sender
{
    [self swipeToRight:YES];
}

- (IBAction)swipeRight:(UISwipeGestureRecognizer *)sender
{
    [self swipeToRight:NO];
}

- (void)swipeToRight:(BOOL)isRight
{
    // 1.获取当前播放的时间
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.currentTime);
    
    if (isRight) {
        [UIView animateWithDuration:1 animations:^{
            self.forwardImageView.alpha = 1;
        } completion:^(BOOL finished) {
            self.forwardImageView.alpha = 0;
        }];
        currentTime += 10;
        
    } else {
        [UIView animateWithDuration:1 animations:^{
            self.backImageView.alpha = 1;
        } completion:^(BOOL finished) {
            self.backImageView.alpha = 0;
        }];
        currentTime -= 10;
        
    }
    
    if (currentTime >= CMTimeGetSeconds(self.player.currentItem.duration)) {
        
        currentTime = CMTimeGetSeconds(self.player.currentItem.duration) - 1;
    } else if (currentTime <= 0) {
        currentTime = 0;
    }
    
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    [self updateProgressInfo];
}//快进


- (void)showToolView:(BOOL)isShow
{
    
    
    if (self.progressSlider.tag == 100) {
        
//            [self showToolView:YES];
//        [self removeShowTimer];
        self.progressSlider.tag = 20;
        return;
    
    }
    [UIView animateWithDuration:1.0 animations:^{
        self.toolView.alpha = !self.isShowToolView;
        self.topView.alpha = !self.isShowToolView;
        self.isShowToolView = !self.isShowToolView;
        if (isShow == YES) {
            if (!self->_isLongShow) {
            self.showTime = 0;
            [self  addShowTimer];
            }
        }
    }];
}//显示工具栏

- (IBAction)playOrPause:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender == nil) {
        self.playOrPauseBtn.selected = NO;
    }
    if (sender.selected) {
        [self.player play];
        self.isPlaying = YES;
//        [self addShowTimer];
        [self addProgressTimer];
    } else {
        [self.player pause];
        self.isPlaying = NO;

//        [self removeShowTimer];
        [self removeProgressTimer];
    }
}// 暂停按钮的监听

#pragma mark - 定时器操作
- (void)addProgressTimer
{
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}//增加定时器

- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}//移除定时器

- (void)updateProgressInfo
{
    // 1.更新时间
    self.timeLabel.text = [self timeString];
    
    self.progressSlider.value = CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
    
    if (self.progressSlider.value != 0) {
        if (_playEndView) {
            [self.playEndView removeFromSuperview];
            self.playEndView = nil;
        }
    }
    
    
    if(self.progressSlider.value == 1)
    {
        self.progressSlider.value = 0;
        self.progressSlider.tag = 100;
//        [self playOrPause:nil];
//        [self sliderValueChange];
//        self.player = nil;
        self.playOrPauseBtn.selected = NO;
        self.toolView.alpha = 1;
        self.topView.alpha = 1;
        [self removeProgressTimer];
//        [self removeShowTimer];
        self.timeLabel.text = @"00:00/00:00";
        [self.currentItem removeObserver:self forKeyPath:@"status" context:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        self.currentItem = nil;
        self.urlString = @"";
       
        [self creatPlayEndView];
        
        return;

    }

}//更新


-(void)creatPlayEndView
{
    kWeakSelf(self);

    if (!_playEndView) {
        _playEndView = [[PlayEndView alloc]initWithFrame:CGRectMake(0, self.topView.bottom, self.width, self.height-self.topView.height)];
        [self addSubview:_playEndView];
        //手势响应方法
        _playEndView.tapShow = ^{
            [weakself tapAction:nil];
        };
        
        //点击重播按钮执行方法
        _playEndView.replayBtnBlock = ^{
            weakself.playEndView.hidden = YES;
            if (weakself.videoPlayEnd) {
                weakself.videoPlayEnd();
            }
        };
    }
}

- (NSString *)timeString
{
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
//    if (self.player == nil) {
//        return @"00:00/00:00";
//    }
    return [self stringWithCurrentTime:currentTime duration:duration];
}//计算时间

- (void)addShowTimer
{
    if (self.showTimer) {
        [self removeShowTimer];
    }
     
        self.showTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateShowTime) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.showTimer forMode:NSRunLoopCommonModes];
   
}//添加定时器

- (void)removeShowTimer
{
    [self.showTimer invalidate];
    self.showTimer = nil;
}//移除

- (void)updateShowTime
{
    self.showTime += 1;
    
    if (self.showTime > 5.0) {
        [UIView animateWithDuration:1.0 animations:^{
            self.toolView.alpha = 0;
            self.topView.alpha = 0;
            self.isShowToolView = NO;
        }];
        self.showTime = 0;
        [self removeShowTimer];
    }
}//更新时间

#pragma mark - 切换屏幕的方向
- (IBAction)switchOrientation:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    [self videoplayViewSwitchOrientation:sender.selected];
}//切换屏幕的方向

- (IBAction)goback:(UIButton *)sender
{
    if (_fullBtn.selected == YES) {
        //全屏幕 就退出全屏
        _fullBtn.selected = !_fullBtn.selected;
        self.fullVc.isPortrait = NO;
        [self.fullVc dismissViewControllerAnimated:NO completion:^{
            [self.contrainerViewController.view addSubview:self];
            self.brightnessVolumeView.hidden = YES;
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.frame = CGRectMake(0, kStatusBarHeight, self.contrainerViewController.view.bounds.size.width, self.contrainerViewController.view.bounds.size.width * 9 / 16);
                [self loadingViewFrame:self];
                if (self.playEndView) {
                    
                    [self.playEndView removeFromSuperview];
                    self.playEndView = nil;
                    
                    [self creatPlayEndView];
                }
                
            } completion:nil];
            
        }];
        }else{
            //退出本页
            [self stop];
            NSLog(@"退出本页啦啦啦");
            if (self.goBack) {
                self.goBack();
            }
        }
}//点击返回按钮

- (void)videoplayViewSwitchOrientation:(BOOL)isFull
{
    if (isFull) {
        self.fullVc.isPortrait = YES;
        [self.contrainerViewController presentViewController:self.fullVc animated:NO completion:^{
            [self.fullVc.view addSubview:self];
            self.center = self.fullVc.view.center;
            
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.frame = self.fullVc.view.bounds;
                [self loadingViewFrame:self.fullVc.view];
            //增加音量 亮度调整
                [self initBrightnessVolumeView];
            } completion:nil];
        }];
    } else {
        self.fullVc.isPortrait = NO;

        [self.fullVc dismissViewControllerAnimated:NO completion:^{
            [self.contrainerViewController.view addSubview:self];
            self.brightnessVolumeView.hidden = YES;
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                
                self.frame = CGRectMake(0, kStatusBarHeight, self.contrainerViewController.view.bounds.size.width, self.contrainerViewController.view.bounds.size.width * 9 / 16);
                [self loadingViewFrame:self];

            } completion:nil];
        }];
    }
}//是否全屏幕

-(void)initBrightnessVolumeView
{
    
    if (_brightnessVolumeView) {
        _brightnessVolumeView.hidden = NO;
        [self bringSubviewToFront:_brightnessVolumeView];
        return;
    }
    
    _brightnessVolumeView = [[BrightnessVolumeView alloc] initWithFrame:CGRectMake(0, 40, self.width, self.height-90)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [_brightnessVolumeView addGestureRecognizer:tap];
    [self addSubview:_brightnessVolumeView];
}//亮度 音量


- (IBAction)slider
{
//    [self addProgressTimer];
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressSlider.value;
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}//滑动

- (IBAction)startSlider
{
    [self removeProgressTimer];

}//开始滑动

- (IBAction)sliderValueChange
{
    [self removeProgressTimer];
//    [self removeShowTimer];
    if (self.progressSlider.value == 1) {
        self.progressSlider.value = 0;
        [self.currentItem removeObserver:self forKeyPath:@"status" context:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        self.currentItem = nil;
        if (self.videoPlayEnd) {
            self.videoPlayEnd();
        }
    }
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressSlider.value;
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    self.timeLabel.text = [self stringWithCurrentTime:currentTime duration:duration];
//    [self addShowTimer];
    [self addProgressTimer];
}//选择器滑动了以后

- (NSString *)stringWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration
{
//    if (currentTime == duration) {
//        currentTime = 0;
//
////        self.player.currentTime = currentTime;
////        [self updateProgressInfo];
////        [self sliderValueChange];
////        self.progressSlider.value = 0;
//        self.playOrPauseBtn.selected = NO;
//        self.toolView.alpha = 1;
//        
//        [self removeProgressTimer];
//        [self removeShowTimer];
//        self.player = nil;
//        
//    }
    NSInteger dMin = duration / 60;
    NSInteger dSec = (NSInteger)duration % 60;
    
    NSInteger cMin = currentTime / 60;
    NSInteger cSec = (NSInteger)currentTime % 60;
    
    NSString *durationString = [NSString stringWithFormat:@"%02ld:%02ld", (long)dMin, dSec];
    NSString *currentString = [NSString stringWithFormat:@"%02ld:%02ld", (long)cMin, cSec];
    
    return [NSString stringWithFormat:@"%@/%@", currentString, durationString];
}

#pragma mark - 懒加载代码
- (FullViewController *)fullVc
{
    if (_fullVc == nil) {
        _fullVc = [[FullViewController alloc] init];
        self.fullVc.isPortrait = YES;
        _fullVc.modalPresentationStyle = UIModalPresentationFullScreen;

    }
    return _fullVc;
}

-(void)removeObject
{
    [self stop];
}//移除


-(void)puase
{
    [self.player pause];
//    [self removeShowTimer];
    [self removeProgressTimer];
}//暂停


-(void)play
{
    [self.player play];
//    [self addShowTimer];
    [self addProgressTimer];
}//播放


-(void)stop
{
    [self.currentItem removeObserver:self forKeyPath:@"status" context:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.player pause];
    self.currentItem = nil;
    self.player = nil;
    self.isPlaying = NO;

//    self.playOrPauseBtn.selected = NO;
//    self.toolView.alpha = 1;
    
    [self removeProgressTimer];
//    [self removeShowTimer];
    self.timeLabel.text = @"00:00/00:00";
}//停止

-(void)dealloc
{
 
}//释放

@end
