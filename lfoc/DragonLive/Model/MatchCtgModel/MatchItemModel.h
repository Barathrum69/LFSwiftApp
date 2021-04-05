//
//  MatchItemModel.h
//  DragonLive
//
//  Created by LoaA on 2020/12/22.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MatchItemModel : BaseModel

/// 主队
@property (nonatomic, copy) NSString *teamA;

/// 赛事预告ID
@property (nonatomic, copy) NSString *mnId;

/// 主队的logo
@property (nonatomic, copy) NSString *teamALogo;

/// title
@property (nonatomic, copy) NSString *title;

/// 结束时间
@property (nonatomic, copy) NSString *endTime;

/// 隶属于谁
@property (nonatomic, copy) NSString *ctgId;

/// 客队
@property (nonatomic, copy) NSString *teamB;

/// 客队的logo
@property (nonatomic, copy) NSString *teamBLogo;

/// 房间ID
@property (nonatomic, copy) NSString *roomId;

/// 隶属于的名字
@property (nonatomic, copy) NSString *ctgName;

/// 开始时间
@property (nonatomic, copy) NSString *startTime;

/// 状态
@property (nonatomic, copy) NSString *status;

/// 0-内链，1-外链 如果forward是内链并且hostName非空则展示直播头像  如果forward是外链并且url非空则是跳转连接(url字段)
@property (nonatomic, copy) NSString *forward;

/// 预留字段
@property (nonatomic, copy) NSString *streamUrl;

/// 视频ID
@property (nonatomic, copy) NSString *videoId;

/// 预留字段
@property (nonatomic, copy) NSString *videoUrl;

/// 显示的时间
@property (nonatomic, copy) NSString *time;

/// section展示的时间
@property (nonatomic, copy) NSString *sectionTime;

/// 直播Id
@property (nonatomic, copy) NSString *liveId;

/// 主播名字
@property (nonatomic, copy) NSString *hostName;

/// 主播头像
@property (nonatomic, copy) NSString *hostAvatarUrl;

/// 外链的url
@property (nonatomic, copy) NSString *url;

/// 主播头像数组
@property (nonatomic, strong) NSMutableArray *refHosts;

/// 去除了官方频道的数组
@property (nonatomic, strong) NSMutableArray *liveHosts;


//去除官方频道数组
-(void)setLiveHosts;

//把外部的拼接起来
-(void)coverRefHosts;

@end

NS_ASSUME_NONNULL_END
