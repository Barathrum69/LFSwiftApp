//
//  LiveStreamerView.h
//  DragonLive
//
//  Created by 11号 on 2020/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RoomInfo;

typedef void(^FollowBlock) (void);

/// 直播间主播view
@interface LiveStreamerView : UIView

/// 关注按钮点击
@property (nonatomic, copy) FollowBlock followBlock;

- (id)initWithFrame:(CGRect)frame;

- (void)setRoomInfo:(RoomInfo *)roomInfo;

@end

NS_ASSUME_NONNULL_END
