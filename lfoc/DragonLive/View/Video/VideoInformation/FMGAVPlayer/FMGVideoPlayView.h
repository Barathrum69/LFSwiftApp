//
//  FMGVideoPlayView.h
//  网络视频播放(AVPlayer)
//
//  Created by apple on 15/8/16.
//  Copyright (c) 2015年 FMG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


//已经结束播放
typedef void(^VideoPlayEnd)(void);

//退出
typedef void(^GoBack)(void);

@interface FMGVideoPlayView : UIView

+ (instancetype)videoPlayView;

//@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, copy) NSString *urlString;

//播放时为YES 暂停时为NO
@property (nonatomic, assign) BOOL isPlaying;

/// titleText
@property (nonatomic, copy) NSString *titleText;

/* 包含在哪一个控制器中 */
@property (nonatomic, weak) UIViewController *contrainerViewController;

/// 结束播放的block
@property (nonatomic, copy) VideoPlayEnd videoPlayEnd;

/// 退出
@property (nonatomic, copy) GoBack goBack;

/// 移除
-(void)removeObject;

/// 暂停
-(void)puase;

/// 播放
-(void)play;

/// 停止
-(void)stop;
/// 增加无网络的界面
-(void)addBadNetWorkViewblock:(void(^)(void))block;

/// 移除无网络的界面
-(void)removeBadNetWorkView;
@end
