//
//  NewsProxy.h
//  DragonLive
//
//  Created by LoaA on 2021/2/19.
//

#import <Foundation/Foundation.h>
@class NewsModel;
NS_ASSUME_NONNULL_BEGIN

@interface NewsProxy : NSObject



/// 获取新闻列表
/// @param page 页码
/// @param type 类型 NewsListType
/// @param success 成功
/// @param failure 失败
+(void)getNewsListWithPage:(NSInteger)page itemType:(NewsListType)type success:(void (^)(NewsModel *obj))success failure:(void (^)(NSError *error))failure;


@end

NS_ASSUME_NONNULL_END
