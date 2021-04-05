//
//  VideoModel.h
//  DragonLive
//
//  Created by LoaA on 2020/12/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoModel : NSObject

/// 标记是哪个页面的
@property (nonatomic, assign) VideoListType type;

/// 拼接好model的数组
@property (nonatomic, strong) NSMutableArray *dataArray;


/// 初始化
/// @param type 标记是哪个页面的
/// @param dataArray 拼接好model的数组
-(instancetype)initWithType:(VideoListType)type dataArray:(NSMutableArray *)dataArray;

@end

NS_ASSUME_NONNULL_END
