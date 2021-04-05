//
//  VideoProxy.m
//  DragonLive
//
//  Created by LoaA on 2020/12/19.
//

#import "VideoProxy.h"
#import "VideoItemModel.h"
#import "VideoModel.h"
#import "VideoDetailModel.h"
#import "VideoCommentModel.h"

@implementation VideoProxy

/// 获取视频模块分类下的列表
/// @param ctgName 分类名字
/// @param page 页码
/// @param type 请求的type
/// @param success 成功
/// @param failure 失败
+(void)getCategoryOfVideoListWithCtgName:(NSString *)ctgName page:(NSInteger)page itemType:(VideoListType)type success:(void (^)(VideoModel *obj))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:ctgName forKey:@"findName"];
    [params setObject:@"2" forKey:@"queryType"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(20) forKey:@"size"];
    [HttpRequest requestWithURLType:UrlTypeCategoryOfVideoList parameters:params type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            NSMutableArray *dataArray = [NSMutableArray new];
            NSArray *array = [responseObject objectForKey:@"data"];
            for (NSDictionary *obj in array) {
                VideoItemModel *model = [VideoItemModel modelWithDictionary:obj];
                //这么做数据量大了肯定会卡 但是目前没什么好办法处理这个
                model.watchAndCommentAtt = [UntilTools videoItemWatchNum:model.playNum comment:model.commentNumberOfCurVideo];
                [dataArray addObject:model];
            }
            //组合起来mode传到外面去
            VideoModel *model = [[VideoModel alloc]initWithType:type dataArray:dataArray];
            success(model);
        }else{
            [[HCToast shareInstance]showToast:[responseObject objectForKey:@"message"]];
            failure(nil);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}


/// 根据videoId 获取视频的详情
/// @param videoId videoId
/// @param success 成功
/// @param failure 失败
+(void)getVideoItemDetailsWithVideoId:(NSString *)videoId success:(void (^)(VideoDetailModel *obj))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:videoId forKey:@"videoId"];

    [HttpRequest requestWithURLType:UrlTypeVideoItemDetails parameters:params type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            VideoDetailModel *model = [VideoDetailModel modelWithDictionary:[responseObject objectForKey:@"data"]];
            success(model);
        }else{
            [[HCToast shareInstance]showToast:[UntilTools showErrorMessage:[responseObject objectForKey:@"message"]]];
            failure(nil);
        }
    } failure:^(NSError * _Nonnull error) {
            failure(error);
    }];
    
}

/// 获取推荐列表
/// @param ctgId 分类id
/// @param page 第几页
/// @param success 成
/// @param failure 失败
+(void)getRecommendVideoListWithctgId:(NSNumber *)ctgId page:(NSInteger)page success:(void (^)(NSMutableArray *obj))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:ctgId forKey:@"ctgId"];
    [params setObject:@"2" forKey:@"listType"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@"10" forKey:@"size"];
    
    [HttpRequest requestWithURLType:UrlTypeRecommendVideoList parameters:params type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        NSLog(@"111");
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            NSArray *array = [dict objectForKey:@"items"];
            NSMutableArray *dataArray = [NSMutableArray new];

            for (NSDictionary *obj in array) {
                VideoItemModel *model = [VideoItemModel modelWithDictionary:obj];
                model.recommedwatchCommentAtt = [UntilTools recommedVideoItemWatchNum:model.playNum comment:model.commentNumberOfCurVideo];
                [dataArray addObject:model];
            }
            success(dataArray);
        }else{
            [[HCToast shareInstance]showToast:[UntilTools showErrorMessage:[responseObject objectForKey:@"message"]]];
            failure(nil);
        }
        
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}


/// 获取评论列表
/// @param page 页码
/// @param targetId 目标id
/// @param success 成功
/// @param failure 失败
+(void)getCommentListWithPage:(NSInteger)page targetId:(NSString *)targetId success:(void (^)(NSMutableArray *obj))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:targetId forKey:@"targetId"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@"10" forKey:@"size"];
    [params setObject:@"4" forKey:@"actionType"];
    [params setObject:@"3" forKey:@"contentType"];

    [HttpRequest requestWithURLType:UrlTypeVideoDetailsCommentList parameters:params type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            NSArray *array = [dict objectForKey:@"items"];
            NSMutableArray *dataArray = [NSMutableArray new];
            for (NSDictionary *obj in array) {
                VideoCommentModel *model = [VideoCommentModel modelWithDictionary:obj];
                [dataArray addObject:model];
            }
            success(dataArray);
        }else{
            [[HCToast shareInstance]showToast:[UntilTools showErrorMessage:[responseObject objectForKey:@"message"]]];
            failure(nil);
        }
        
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}


/// 评论点赞接口
/// @param targetId 评论目标ID
/// @param contentType 1-直播,2-主播,3-视频,4-资讯,5-评论
/// @param cType 1-点赞,2-点踩,3-弹幕,4-评论
/// @param content 内容
/// @param success 成功
/// @param failure 失败
+(void)sendCommentLikeWithTargetId:(NSString *)targetId contentType:(NSString *)contentType cType:(NSString *)cType content:(NSString *)content success:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:targetId forKey:@"targetId"];
    [params setObject:contentType forKey:@"contentType"];
    [params setObject:cType forKey:@"cType"];
    [params setObject:content forKey:@"content"];

    [HttpRequest requestWithURLType:UrlTypeSendCommentLike parameters:params type:HttpRequestTypePut success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            success(YES);
        }else{
            [[HCToast shareInstance]showToast:[responseObject objectForKey:@"message"]];
            NSError *error;
            failure(error);        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

/// 删除评论
/// @param commentId 评论的id
/// @param success 成功
/// @param failure 失败
+(void)deleteCommentWithCommentId:(NSString *)commentId success:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:commentId forKey:@"commentId"];
    
    [HttpRequest requestWithURLType:UrlTypeDeleteComment parameters:params type:HttpRequestTypeDelete success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            success(YES);
        }else{
            [[HCToast shareInstance]showToast:[responseObject objectForKey:@"message"]];
            NSError *error;
            failure(error);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);

    }];
    
}



@end
