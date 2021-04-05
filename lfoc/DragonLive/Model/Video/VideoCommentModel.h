//
//  VideoCommentModel.h
//  DragonLive
//
//  Created by LoaA on 2020/12/21.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoCommentModel : BaseModel

/// 评论目标ID
@property (nonatomic, copy) NSString *targetId;

/// 评论点赞数
@property (nonatomic, copy) NSString *likeNum;

/// 评论ID
@property (nonatomic, copy) NSString *commentId;

/// 评论用户头像
@property (nonatomic, copy) NSString *userHeadPicUrl;

/// 操作类型， 后台返回的 ， 目前没有用
@property (nonatomic, copy) NSString *ctype;

/// 子集评论数量
@property (nonatomic, copy) NSString *childCommentNumber;

/// 评论点踩数
@property (nonatomic, copy) NSString *disLikeNum;

/// 评论目标 1 - 直播,2 - 主播,3 - 视频,4 - 资讯, 5 - 评论
@property (nonatomic, copy) NSString *contentType;

/// 评论用户ID
@property (nonatomic, copy) NSString *userId;

/// 当前查看用户是否点踩 1-已经点踩 2-未点踩（未登录为2）
@property (nonatomic, copy) NSString *dislikeStatus;

/// 评论用户昵称
@property (nonatomic, copy) NSString *nickname;

/// 当前查看用户是否点赞 1-已经点赞 2-未点赞（未登录为2）
@property (nonatomic, copy) NSString *likeStatus;

/// Date类型，格式“yyyy-MM-dd HH:mm:ss”，评论时间（排序字段）
@property (nonatomic, copy) NSString *commentTime;

/// 评论内容
@property (nonatomic, copy) NSString *content;

/// cell的高度
@property (nonatomic, assign) CGFloat cellHeight;

/// messageLabel的height
@property (nonatomic, assign) CGFloat messageHeight;

@end

NS_ASSUME_NONNULL_END
