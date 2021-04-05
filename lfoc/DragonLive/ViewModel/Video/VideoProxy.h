//
//  VideoProxy.h
//  DragonLive
//
//  Created by LoaA on 2020/12/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class VideoModel;
@class VideoDetailModel;
@interface VideoProxy : NSObject



/// 获取视频模块分类下的列表
/// @param ctgName 分类名字
/// @param page 页码
/// @param type 请求的type
/// @param success 成功
/// @param failure 失败
+(void)getCategoryOfVideoListWithCtgName:(NSString *)ctgName page:(NSInteger)page itemType:(VideoListType)type success:(void (^)(VideoModel *obj))success failure:(void (^)(NSError *error))failure;


/// 根据videoId 获取视频的详情
/// @param videoId videoId
/// @param success 成功
/// @param failure 失败
+(void)getVideoItemDetailsWithVideoId:(NSString *)videoId success:(void (^)(VideoDetailModel *obj))success failure:(void (^)(NSError *error))failure;


/// 获取推荐列表
/// @param ctgId 分类id
/// @param page 第几页
/// @param success 成
/// @param failure 失败
+(void)getRecommendVideoListWithctgId:(NSNumber *)ctgId page:(NSInteger)page success:(void (^)(NSMutableArray *obj))success failure:(void (^)(NSError *error))failure;


/// 获取评论列表
/// @param page 页码
/// @param targetId 目标id
/// @param success 成功
/// @param failure 失败
+(void)getCommentListWithPage:(NSInteger)page targetId:(NSString *)targetId success:(void (^)(NSMutableArray *obj))success failure:(void (^)(NSError *error))failure;


/// 评论点赞接口
/// @param targetId 评论目标ID
/// @param contentType 1-直播,2-主播,3-视频,4-资讯,5-评论
/// @param cType 1-点赞,2-点踩,3-弹幕,4-评论
/// @param content 内容
/// @param success 成功
/// @param failure 失败
+(void)sendCommentLikeWithTargetId:(NSString *)targetId contentType:(NSString *)contentType cType:(NSString *)cType content:(NSString *)content success:(void (^)(BOOL isSuccess))success failure:(void (^)(NSError *error))failure;


/// 删除评论
/// @param commentId 评论的id
/// @param success 成功
/// @param failure 失败
+(void)deleteCommentWithCommentId:(NSString *)commentId success:(void (^)(BOOL isSuccess))success failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
