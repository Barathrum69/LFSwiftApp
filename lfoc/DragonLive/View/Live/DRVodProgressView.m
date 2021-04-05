//
//  DRVodProgressView.m
//  DragonLive
//
//  Created by 11号 on 2021/2/18.
//

#import "DRVodProgressView.h"

@interface DRVodProgressView ()

@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UILabel *progressTimeLab;         //播放进度时间
@property (nonatomic, strong) NSTimer *progressTimer;
@property (nonatomic, strong) TXVodPlayer *txVodPlayer;

@end

@implementation DRVodProgressView

- (id)initWithFrame:(CGRect)frame vodPlayer:(TXVodPlayer *)vodPlayer;
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.txVodPlayer = vodPlayer;
        
        [self setupUI];
        
        [self play];
    }
    return self;
}

- (void)setupUI
{
    // 初始化
    UISlider *progSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, self.size.width - 82, self.size.height)];
    // 添加到俯视图
    [self addSubview:progSlider];
    // 设置初始值
    progSlider.value = 0;
    progSlider.maximumValue = 1;
    //滑轮图片
    [progSlider setThumbImage:[UIImage imageNamed:@"thumbImage"] forState:UIControlStateNormal];
    //滑轮左边
    [progSlider setMaximumTrackImage:[UIImage imageNamed:@"MaximumTrackImage"] forState:UIControlStateNormal];
    //滑轮右边
    [progSlider setMinimumTrackImage:[UIImage imageNamed:@"MinimumTrackImage"] forState:UIControlStateNormal];
    //针对值变化添加响应方法
    [progSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    progSlider.enabled = NO;
//    [progSlider addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
//    [progSlider addTarget:self action:@selector(sliderTouchUpInSide:) forControlEvents:UIControlEventTouchUpInside];
    self.progressSlider = progSlider;
    
    //时间
    UILabel *progressTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_progressSlider.frame) + 10, (self.size.height - 15) * 0.5, 72, 15)];
    progressTimeLab.textColor = [UIColor whiteColor];
    progressTimeLab.font = [UIFont systemFontOfSize:12];
    progressTimeLab.text = @"00:00/00:00";
    [self addSubview:progressTimeLab];
    self.progressTimeLab = progressTimeLab;
}

- (void)sliderValueChanged:(UISlider *)slider
{
    if (!self.txVodPlayer.isPlaying || self.txVodPlayer.duration == 0) {
        return;
    }
    [self removeProgressTimer];
    float seekTime = slider.value * self.txVodPlayer.duration;
    [self.txVodPlayer seek:seekTime];
    self.progressTimeLab.text = [self stringWithCurrentTime:seekTime duration:self.txVodPlayer.duration];
    
    [self addProgressTimer];
}

- (void)sliderTouchDown:(UISlider *)slider
{
    [self removeProgressTimer];
    if (slider.value == 1) {
        slider.value = 0;
    }
    float seekTime = slider.value * self.txVodPlayer.duration;
    [self.txVodPlayer seek:seekTime];
    self.progressTimeLab.text = [self stringWithCurrentTime:seekTime duration:self.txVodPlayer.duration];
    
    [self addProgressTimer];
}

- (void)sliderTouchUpInSide:(UISlider *)slider
{
//    if (slider.value == 1) {
//        slider.value = 0;
//    }
//    float seekTime = slider.value * self.txVodPlayer.duration;
//    [self.txVodPlayer seek:seekTime];
//    self.progressTimeLab.text = [self stringWithCurrentTime:seekTime duration:self.txVodPlayer.duration];
    
}

/// 播放
-(void)play
{
    [self addProgressTimer];
    self.progressSlider.enabled = YES;
}

/// 暂停
-(void)puase
{
    [self removeProgressTimer];
}

//每秒刷新
- (void)progressSeek
{
    float progressValue = self.txVodPlayer.currentPlaybackTime / self.txVodPlayer.duration;
    if (progressValue == 1) {
        self.progressSlider.value = 0;
        self.progressTimeLab.text = @"00:00/00:00";
        if (self.vodPlayEnd) {
            self.vodPlayEnd();
        }
    }else {
        self.progressSlider.value = progressValue;
        self.progressTimeLab.text = [self stringWithCurrentTime:self.txVodPlayer.currentPlaybackTime duration:self.txVodPlayer.duration];
    }
    
}

//播放进度时间显示
- (NSString *)stringWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration
{
    NSInteger dMin = duration / 60;
    NSInteger dSec = (NSInteger)duration % 60;
    
    NSInteger cMin = currentTime / 60;
    NSInteger cSec = (NSInteger)currentTime % 60;
    
    NSString *durationString = [NSString stringWithFormat:@"%02ld:%02ld", (long)dMin, (long)dSec];
    NSString *currentString = [NSString stringWithFormat:@"%02ld:%02ld", (long)cMin, (long)cSec];
    
    return [NSString stringWithFormat:@"%@/%@", currentString, durationString];
}


- (void)addProgressTimer
{
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(progressSeek) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

@end
