//
//  DRChatRoomView.h
//  DragonLive
//
//  Created by 11号 on 2021/2/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DRChatRoomViewDelegate <NSObject>

@optional //非必实现的方法

/// 送礼view充值事件
- (void)giftViewWithRechargeEvent;


/// 主播关播
- (void)hostLivingTurnOff;

/// 发送弹幕
/// @param message 弹幕内容
- (void)addBarrageWithMessage:(NSString *)message;

@end

@class LiveRoomViewModel;
/// 聊天室view
@interface DRChatRoomView : UIView

@property (nonatomic, strong) LiveRoomViewModel *roomViewModel;
@property (nonatomic, weak) id<DRChatRoomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
