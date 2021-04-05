//
//  MatchListModel.h
//  DragonLive
//
//  Created by LoaA on 2020/12/22.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MatchListModel : BaseModel

/// section显示的那个字符串。
@property (nonatomic, strong) NSString *sectionString;

@property (nonatomic, strong) NSString *showTimeString;

/// 数据源.
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

NS_ASSUME_NONNULL_END
