//
//  HostModel.h
//  DragonLive
//
//  Created by LoaA on 2021/1/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HostModel : NSObject

/// 主播id
@property (nonatomic, copy) NSString *uid;


/// 名字
@property (nonatomic, copy) NSString *name;

/// 头像地址.
@property (nonatomic, copy) NSString *avatar;

/// 粉丝数
@property (nonatomic, copy) NSString *hot;

/// 是否直播。
@property (nonatomic, assign) BOOL statusOfLive;

/// 房间ID
@property (nonatomic, copy) NSString *roomId;

/// 拼接好的富文本粉丝数
@property (nonatomic, strong) NSMutableAttributedString *hotAtt;

/// 主播类型 2为官方直播
@property (nonatomic, copy) NSString *hostType;

/// 跳转的url
@property (nonatomic, copy) NSString *jumpUrl;

/// 开始时间
@property (nonatomic, copy) NSString *startTime;

/// 推流的URL
@property (nonatomic, copy) NSString *url;

/// 客队
@property (nonatomic, copy) NSString *teamB;

/// 主队
@property (nonatomic, copy) NSString *teamA;


/// 开赛状态：0：未开赛 1：已开赛
@property (nonatomic, copy) NSString *status;

@end

NS_ASSUME_NONNULL_END
