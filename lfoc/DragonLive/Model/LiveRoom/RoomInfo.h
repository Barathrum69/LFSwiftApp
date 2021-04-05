//
//  RoomInfo.h
//  DragonLive
//
//  Created by 11号 on 2020/12/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 直播房间详情模型
@interface RoomInfo : NSObject

/// 直播id
@property (nonatomic, copy) NSString *liveId;

/// 分类ID
@property (nonatomic, copy) NSString *ctgId;

/// 房间ID
@property (nonatomic, copy) NSString *roomId;

/// 主播id
@property (nonatomic, copy) NSString *hostId;

/// 播流地址
@property (nonatomic, copy) NSString *stream;

/// 直播标题
@property (nonatomic, copy) NSString *liveTitle;

/// 封面图
@property (nonatomic, copy) NSString *coverImg;

/// 直播热度
@property (nonatomic, copy) NSString *hot;

/// 描述
@property (nonatomic, copy) NSString *remark;

/// 主播昵称
@property (nonatomic, copy) NSString *hostNickName;

/// 主播头像
@property (nonatomic, copy) NSString *hostHeadPicUrl;

/// 主播账户
@property (nonatomic, copy) NSString *hostAccount;

/// 主播公告
@property (nonatomic, copy) NSString *notice;

/// 第三方聊天设置 0-主播端显示 1-主播端隐藏
@property (nonatomic, copy) NSString *chatHideStatus;

/// 主播等级
@property (nonatomic, copy) NSString *hostGradle;

/// 主播等级图标
@property (nonatomic, copy) NSString *hostGradleImg;

/// 主播粉丝数量
@property (nonatomic, copy) NSString *hostFansNum;

/// 主播是否被关注(1:已关注 2:未关注)
@property (nonatomic, copy) NSString *hostFollow;

/// 是否直播中     false:已结束直播 true:直播中
@property (nonatomic, copy) NSString *living;

/// 是否禁播中     false:已禁播   true：未禁播 正常
@property (nonatomic, copy) NSString *forbid;

/// 管理员角色集合
@property (nonatomic, strong) NSArray *manageList;

/// 直播拉流地址
@property (nonatomic, copy) NSString *pullUrl;

/// 录播地址
@property (nonatomic, copy) NSString *recordedUrl;

@end

NS_ASSUME_NONNULL_END
