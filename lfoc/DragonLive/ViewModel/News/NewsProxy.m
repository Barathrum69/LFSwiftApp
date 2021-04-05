//
//  NewsProxy.m
//  DragonLive
//
//  Created by LoaA on 2021/2/19.
//

#import "NewsProxy.h"
#import "NewsItemModel.h"
#import "NewsModel.h"
@implementation NewsProxy

/// 获取新闻列表
/// @param page 页码
/// @param type 类型 NewsListType
/// @param success 成功
/// @param failure 失败
+(void)getNewsListWithPage:(NSInteger)page itemType:(NewsListType)type success:(void (^)(NewsModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(20) forKey:@"size"];
//    [params setObject:taskId forKey:@"taskId"];
    if (type == NewsListTypeNews) {
        //新闻
        [params setObject:@"3" forKey:@"atype"];
    }else if(type == NewsListTypeActivity){
        //活动
        [params setObject:@"2" forKey:@"atype"];
    }else if(type == NewsListTypeAnnouncement){
        //公告
        [params setObject:@"1" forKey:@"atype"];
    }
    
    [HttpRequest requestWithURLType:UTTypeGetNewsList parameters:params type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            NSDictionary *data = responseObject[@"data"];
            NSArray *items = data[@"list"];
            NSMutableArray *array = [NSMutableArray new];
            for (NSDictionary *obj in items) {
                NewsItemModel *model = [NewsItemModel modelWithDictionary:obj];
                [array addObject:model];
            }
            NewsModel *model = [[NewsModel alloc]initWithType:type dataArray:array];
            success(model);
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
