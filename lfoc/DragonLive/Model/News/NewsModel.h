//
//  NewsModel.h
//  DragonLive
//
//  Created by LoaA on 2021/2/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsModel : NSObject
/// 标记是哪个页面的
@property (nonatomic, assign) NewsListType type;

/// 拼接好model的数组
@property (nonatomic, strong) NSMutableArray *dataArray;


/// 初始化
/// @param type 标记是哪个页面的
/// @param dataArray 拼接好model的数组
-(instancetype)initWithType:(NewsListType)type dataArray:(NSMutableArray *)dataArray;

@end

NS_ASSUME_NONNULL_END
