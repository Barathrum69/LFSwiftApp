//
//  MatchProxy.h
//  DragonLive
//
//  Created by LoaA on 2020/12/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MatchProxy : NSObject



/// 请求赛事足球篮球电竞的分类
/// @param type 类型1  体育  2电竞   3  综合   4  足球   5  篮球
/// @param success 成功
/// @param failure 失败
+(void)getGameTypeListWithType:(NSInteger)type success:(void (^)(NSMutableArray *obj))success failure:(void (^)(NSError *error))failure;


/// 请求赛事的列表
/// @param page 页码
/// @param ctgId ctgId description
/// @param success 成功
/// @param failure 失败
+(void)getMatchListWithPage:(NSInteger)page ctgId:(NSString *)ctgId success:(void (^)(NSMutableArray *obj))success failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
