//
//  BannerModel.h
//  DragonLive
//
//  Created by 11号 on 2021/1/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BannerModel : NSObject

/// 图片id
@property (nonatomic, copy) NSString *psdId;

/// 图片标题
@property (nonatomic, copy) NSString *contentTitle;

/// 图片url
@property (nonatomic, copy) NSString *contentUrl;

/// 普通跳转链接
@property (nonatomic, copy) NSString *linkUrl;

/// 资讯详情跳转链接
@property (nonatomic, copy) NSString *mobileLinkUrl;

/// 打开链接的方式（1：默认浏览器打开 2：app内部web打开）
@property (nonatomic, copy) NSString *openWay;

/// 跳转类型（1：直播 2：视频 3：主播 4：资讯 5：web链接跳转）
@property (nonatomic, copy) NSString *contentType;

/// 跳转参数
@property (nonatomic, copy) NSString *contentId;

/// 资讯跳转类型：1-公告，2-活动，3-新闻
@property (nonatomic, copy) NSString *atype;

@end

NS_ASSUME_NONNULL_END
