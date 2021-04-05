//
//  LiveCategory.h
//  DragonLive
//
//  Created by 11号 on 2020/12/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 直播子级分类模型
@interface LiveCategory : NSObject

/// 分类id
@property (nonatomic, copy) NSString *ctgId;

/// 分类名称
@property (nonatomic, copy) NSString *ctgName;

/// 是否选中该分类
@property (nonatomic, assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
