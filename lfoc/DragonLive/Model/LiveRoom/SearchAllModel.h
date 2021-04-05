//
//  SearchAllModel.h
//  DragonLive
//
//  Created by 11号 on 2021/1/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchAllModel : NSObject

/// 搜索结果标题
@property (nonatomic, copy) NSString *resultTitle;

/// 数据集合
@property (nonatomic, strong) NSMutableArray *resultArray;

@end

NS_ASSUME_NONNULL_END
