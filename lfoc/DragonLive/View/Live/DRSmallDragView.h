//
//  DRSmallDragView.h
//  DragonLive
//
//  Created by 11号 on 2021/1/5.
//

#import <UIKit/UIKit.h>
#import "TXLivePlayer.h"
#import "TXVodPlayer.h"
#import "LiveItem.h"
#import "HostModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 小窗播放view
@interface DRSmallDragView : UIView

@property (nonatomic, assign, readonly) BOOL isSmallShow;

+ (DRSmallDragView *)smallDragViewManager;

/// 显示小窗播放模式
/// @param livePlayer 播放器
/// @param liveItem 直播列表item
- (void)showWindowWithPlayer:(TXLivePlayer *)livePlayer liveItem:(LiveItem *)liveItem;

/// 赛事小窗播放
/// @param livePlayer 播放器
/// @param hostModel 赛事模型
- (void)showWindowWithPlayer:(TXLivePlayer *)livePlayer hostModel:(HostModel *)hostModel;

/// 录播小窗播放
/// @param vodPlayer 录播播放器
/// @param liveItem 赛事模型
- (void)showWindowWithVodPlayer:(TXVodPlayer *)vodPlayer liveItem:(LiveItem *)liveItem;

/// 关闭小窗播放
- (void)closeSmallView;

/// 暂停播放
- (void)pause;

/// 继续播放
- (void)resume;

@end

NS_ASSUME_NONNULL_END
