//
//  VideoItemModel.h
//  DragonLive
//
//  Created by LoaA on 2020/12/19.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoItemModel : BaseModel

/// video的id
@property (nonatomic, copy) NSString *videoId;

/// 直播的id
@property (nonatomic, copy) NSString *liveId;

/// 分类id数组
@property (nonatomic, strong) NSMutableArray *ctgIdList;

/// 分类名字的数组
@property (nonatomic, strong) NSMutableArray *ctgNameList;

@property (nonatomic, copy) NSString *hot;

/// 分类Id
@property (nonatomic, copy) NSString *ctgId;

/// 主播ID
@property (nonatomic, copy) NSString *hostId;

/// 主播名字
@property (nonatomic, copy) NSString *hostNickName;

/// 图片url
@property (nonatomic, copy) NSString *coverImg;

/// 视频时长
@property (nonatomic, copy) NSString *videoDuration;

/// 名称
@property (nonatomic, copy) NSString *title;


/// 播放量
@property (nonatomic, copy) NSString *playNum;

/// 评论量
@property (nonatomic, copy) NSString *commentNumberOfCurVideo;

/// 直播title
@property (nonatomic, copy) NSString *liveTitle;

/// 视频的Url
@property (nonatomic, copy) NSString *url;

/// 首页的根据播放量  评论量  组合起来的数据
@property (nonatomic, strong) NSMutableAttributedString *watchAndCommentAtt;

/// 评论页面的根据播放量  评论量  组合起来的数据
@property (nonatomic, strong) NSMutableAttributedString *recommedwatchCommentAtt;

@end

NS_ASSUME_NONNULL_END
