//
//  DRVodProgressView.h
//  DragonLive
//
//  Created by 11号 on 2021/2/18.
//

#import <UIKit/UIKit.h>
#import "TXVodPlayer.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DRVodProgressDelegate <NSObject>

@optional //非必实现的方法

- (void)vodProgressSeekTime:(float)seektime;

@end

//播放结束
typedef void(^VodPlayEnd)(void);

/// 点播播放器播放进度条view
@interface DRVodProgressView : UIView

@property (nonatomic, weak) id<DRVodProgressDelegate> delegate;
/// 结束播放的block
@property (nonatomic, copy) VodPlayEnd vodPlayEnd;

/// 进度条初始化
/// @param frame 位置
/// @param vodPlayer 点播播放器
- (id)initWithFrame:(CGRect)frame vodPlayer:(TXVodPlayer *)vodPlayer;

/// 播放
-(void)play;

/// 暂停
-(void)puase;

@end

NS_ASSUME_NONNULL_END
