//
//  UserTaskInstance.h
//  DragonLive
//
//  Created by 11号 on 2021/1/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserTaskInstance : NSObject

/// 当前状态 1 去完成(未完成) 2 领取(完成未领取奖励) 3 已领取(完成已领取奖励) 4特殊情况
@property (nonatomic, assign) NSInteger shareStatus;

/// 分享房间（分享直播间一次即完成任务）
@property (nonatomic, assign) NSInteger shareCount;

/// 当前状态 1 去完成(未完成) 2 领取(完成未领取奖励) 3 已领取(完成已领取奖励) 4特殊情况
@property (nonatomic, assign) NSInteger livePlayStatus;

/// 直播视频累计观看时间记录（达到5分钟即完成任务）
/// atomic 保证多线程安全
@property (nonatomic, assign) NSInteger livePlayTime;

/// 当前状态 1 去完成(未完成) 2 领取(完成未领取奖励) 3 已领取(完成已领取奖励) 4特殊情况
@property (nonatomic, assign) NSInteger barrageStatus;

/// 发送弹幕累计次数记录（发送两次即完成任务）
@property (nonatomic, assign) NSInteger barrageCount;

/// 礼物打赏当前状态 1 去完成(未完成) 2 领取(完成未领取奖励) 3 已领取(完成已领取奖励) 4特殊情况
@property (nonatomic, assign) NSInteger giftStatus;

@property (nonatomic, assign) NSInteger fireCount;

@property (nonatomic, assign) NSInteger snowCount;

+(instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
