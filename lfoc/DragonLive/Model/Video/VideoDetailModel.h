//
//  VideoDetailModel.h
//  DragonLive
//
//  Created by LoaA on 2020/12/21.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoDetailModel : BaseModel

/// 视频Id
@property (nonatomic, copy) NSString *videoId;

/// 直播ID
@property (nonatomic, copy) NSString *liveId;

/// 主播ID
@property (nonatomic, copy) NSString *hostId;

/// 分类ID集，《一级、二级、三级》
@property (nonatomic, strong) NSMutableArray *ctgIdList;

/// 分类名称集，《一级、二级、三级》
@property (nonatomic, strong) NSMutableArray *ctgNameList;

/// 视频URL
@property (nonatomic, copy) NSString *url;

/// 主播昵称
@property (nonatomic, copy) NSString *hostNickName;

/// 封面图
@property (nonatomic, copy) NSString *coverImg;

/// 视频时长
@property (nonatomic, copy) NSString *videoDuration;

/// 视频标题
@property (nonatomic, copy) NSString *title;

/// 播放量
@property (nonatomic, copy) NSString *playNum;

/// 发布人
@property (nonatomic, copy) NSString *issuer;

/// 发布时间
@property (nonatomic, copy) NSString *issueTime;

/// 头像
@property (nonatomic, copy) NSString *hostAvatar;

/// 视频数
@property (nonatomic, copy) NSString *videoNumberOfCurUser;

/// 粉丝数
@property (nonatomic, copy) NSString *fansNumberOfCurUser;

/// 点赞数
@property (nonatomic, copy) NSString *likeNumberOfCurVideo;

/// 分享数
@property (nonatomic, copy) NSString *shareNumberOfCurVideo;

/// 评论数
@property (nonatomic, copy) NSString *commentNumberOfCurVideo;
@end

NS_ASSUME_NONNULL_END
