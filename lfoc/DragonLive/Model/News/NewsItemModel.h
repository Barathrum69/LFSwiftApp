//
//  NewsItemModel.h
//  DragonLive
//
//  Created by LoaA on 2021/2/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsItemModel : NSObject

/// title
@property (nonatomic, copy) NSString *articleTitle;

/// 文章的URL
@property (nonatomic, copy) NSString *contentUrl;

/// 图片的url
@property (nonatomic, copy) NSString *coverUrl;

/// 发布时间
@property (nonatomic, copy) NSString *mobileIssueTime;

@property (nonatomic, copy) NSString *atype;

@end

NS_ASSUME_NONNULL_END
