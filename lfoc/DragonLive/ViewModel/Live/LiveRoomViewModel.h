//
//  LiveRoomViewModel.h
//  DragonLive
//
//  Created by 11号 on 2020/12/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RoomInfo;

@protocol LiveRoomViewModelDelegate <NSObject>

@optional //非必实现的方法

/// 直播间详情结果回掉
/// @param error 异常信息（如果成功则为nil）
- (void)requestRoomInfoFinish:(nullable NSError *)error;

/// 直播间系统消息结果回掉
/// @param error 异常信息（如果成功则为nil）
- (void)requestSystemNoticeFinish:(nullable NSError *)error;

/// 礼物道具结果回掉
/// @param error 异常信息（如果成功则为nil）
- (void)requestLiveGiftFinish:(nullable NSError *)error;

/// 礼物打赏结果回掉
/// @param error 异常信息（如果成功则为nil）
- (void)requestLiveGiftRewardFinish:(nullable NSError *)error;

/// 查询用户是否被禁言回调
/// @param error 异常信息（如果成功则为nil）
- (void)requestForbiduserStatusFinish:(nullable NSError *)error;


/// 直播间关注/取关结果回掉
/// @param error 异常信息（如果成功则为nil）
- (void)requestAttentionUserFinish:(nullable NSError *)error;


/// 直播间禁言结果回掉
/// @param error 异常信息（如果成功则为nil）
- (void)requestUserDisableSpeakFinish:(nullable NSError *)error;

/// 获取服务器时间差结果回掉
/// @param error 异常信息（如果成功则为nil）
- (void)requestTimeIntervalFinish:(nullable NSError *)error;

@end

/// 直播间view model
@interface LiveRoomViewModel : NSObject

@property (nonatomic, strong, readonly)RoomInfo *roomInfoModel;           //房间信息
@property (nonatomic, copy, readonly)NSString *liveHot;                   //实时热度
@property (nonatomic, copy, readonly)NSString *systemNotice;              //系统公告
@property (nonatomic, copy, readonly)NSString *systemTimeInterval;        //时间差
@property (nonatomic, strong, readonly)NSMutableArray *giftArray;         //礼物道具数据集合

@property (nonatomic, weak) id<LiveRoomViewModelDelegate> delegate;

/// 初始化
/// @param delegate 代理
/// @param roomId 房间id
- (id)initWithDelegate:(id<LiveRoomViewModelDelegate>)delegate roomId:(NSString *)roomId;

/// 直播间详情接口请求：（获取热度 ，头像 ，礼物列表 房间表信息 直播表信息 可用余额，分类）
- (void)requestRoomInfo:(NSString *)roomId;

/// 关注/取关
- (void)requestAttentionUser;

/// 查询用户是否被禁言
- (void)requestForbiduser;

/// 直播间禁言
/// @param userId 被禁言的用户id
- (void)requestUserDisableSpeak:(NSString *)userId;


/// 直播礼物打赏
/// @param giftId 礼物id
/// @param giftNum 打赏礼物数量
- (void)requestGiftReward:(NSString *)giftId giftNum:(NSString *)giftNum liveId:(NSString *)liveId;

/// 获取服务器时间和fromDate的时间差
/// @param fromDate 开始时间
- (void)requestTimeInterval:(NSString *)fromDate;

@end

NS_ASSUME_NONNULL_END
