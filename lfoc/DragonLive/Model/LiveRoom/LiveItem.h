//
//  LiveItem.h
//  DragonLive
//
//  Created by 11号 on 2020/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 首页直播列表模型
@interface LiveItem : NSObject

/// 房间ID
@property (nonatomic, copy) NSString *roomId;

/// 主播ID
@property (nonatomic, copy) NSString *belongHost;

/// 主播昵称
@property (nonatomic, copy) NSString *belongHostName;

/// 主播头像
@property (nonatomic, copy) NSString *avatar;

/// 房间地址
@property (nonatomic, copy) NSString *roomUrl;

/// 房间名称
@property (nonatomic, copy) NSString *roomName;

/// 分类ID
@property (nonatomic, copy) NSString *ctgId;

/// 分类名称
@property (nonatomic, copy) NSString *ctgName;

///// 讲话人数
//@property (nonatomic, copy) NSString *speaking;

/// 通知
//@property (nonatomic, copy) NSString *notice;

/// 直播ID
@property (nonatomic, copy) NSString *liveId;

/// 直播状态(1 - 直播中,2 - 已结束)
@property (nonatomic, copy) NSString *liveStatus;

/// 主播ID
@property (nonatomic, copy) NSString *hostId;
//@property (nonatomic, copy) NSString *stream;

/// 直播标题
@property (nonatomic, copy) NSString *liveTitle;

/// 封面图
@property (nonatomic, copy) NSString *coverImg;
//@property (nonatomic, copy) NSString *startTime;
//@property (nonatomic, copy) NSString *endTime;

/// 直播状态
//@property (nonatomic, copy) NSString *status;

/// 热度
@property (nonatomic, copy) NSString *hot;
//@property (nonatomic, copy) NSString *remark;

@end

NS_ASSUME_NONNULL_END
