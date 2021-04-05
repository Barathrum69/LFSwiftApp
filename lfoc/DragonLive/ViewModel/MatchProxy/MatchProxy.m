//
//  MatchProxy.m
//  DragonLive
//
//  Created by LoaA on 2020/12/22.
//

#import "MatchProxy.h"
#import "MatchCtgModel.h"
#import "MatchItemModel.h"

@implementation MatchProxy

/// 请求赛事足球篮球电竞的分类
/// @param type 类型1  体育  2电竞   3  综合   4  足球   5  篮球
/// @param success 成功
/// @param failure 失败
+(void)getGameTypeListWithType:(NSInteger)type success:(void (^)(NSMutableArray * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@(type) forKey:@"id"];
    
    [HttpRequest requestWithURLType:UrlTypeVideoGetGameTypeList parameters:params type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            NSMutableArray *dataArray = [NSMutableArray new];
            MatchCtgModel *model = [MatchCtgModel new];
            model.ctgId = [NSString stringWithFormat:@"%ld",type];
            model.ctgName = @"全部";             [dataArray addObject:model];
            NSArray *array = [responseObject objectForKey:@"data"];
            for (NSDictionary *obj in array) {
                MatchCtgModel *model = [MatchCtgModel modelWithDictionary:obj];
                [dataArray addObject:model];
            }
            success(dataArray);
        }else{
            [[HCToast shareInstance]showToast:[responseObject objectForKey:@"message"]];
            failure(nil);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}


/// 请求赛事的列表
/// @param page 页码
/// @param ctgId ctgId description
/// @param success 成功
/// @param failure 失败
+(void)getMatchListWithPage:(NSInteger)page ctgId:(NSString *)ctgId success:(void (^)(NSMutableArray *obj))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:ctgId forKey:@"ctgId"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@"15" forKey:@"size"];

    [HttpRequest requestWithURLType:UrlTypeVideoGetMatchList parameters:params type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            NSArray *array = [dict objectForKey:@"items"];
            NSMutableArray *dataArray = [NSMutableArray new];
            for (NSDictionary *obj in array) {
                MatchItemModel *model = [MatchItemModel modelWithDictionary:obj];
                [model coverRefHosts];
                [model setLiveHosts];
                [dataArray addObject:model];
            }
            success(dataArray);
        }else{
            [[HCToast shareInstance]showToast:[responseObject objectForKey:@"message"]];
            failure(nil);
        }
        
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
