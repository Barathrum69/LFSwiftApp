//
//  TaskModel.h
//  DragonLive
//
//  Created by LoaA on 2020/12/25.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskModel : BaseModel

/// 任务Id
@property (nonatomic, copy) NSString *taskId;

/// 任务描述
@property (nonatomic, copy) NSString *remark;

///任务类型 1 - 分享,2 - 观看,3 - 评论,4 - 消费
@property (nonatomic, copy) NSString *taskType;

/// 任务目标 1 - 直播间,2 - 直播,3 - 主播, 4 - 弹幕,5 - 礼物
@property (nonatomic, copy) NSString *taskTarget;

/// 当前状态 1 去完成(未完成) 2 领取(完成未领取奖励) 3 已领取(完成已领取奖励) 4特殊情况
@property (nonatomic, copy) NSString *currentType;

/// 任务名称
@property (nonatomic, copy) NSString *taskName;

/// 任务图标
@property (nonatomic, copy) NSString *taskIcon;

/// 经验值
@property (nonatomic, copy) NSString *experience;

/// 任务数量(需要完成几次)
@property (nonatomic, copy) NSString *targetCount;

/// 今天任务状态 (0 未完成 1已完成)
@property (nonatomic, copy) NSString *taskStatus;

@end

NS_ASSUME_NONNULL_END
