//
//  MatchCtgModel.h
//  DragonLive
//
//  Created by LoaA on 2020/12/22.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MatchCtgModel : BaseModel

/// 分类Id
@property (nonatomic, copy) NSString *ctgId;

/// 分类的名字
@property (nonatomic, copy) NSString *ctgName;

@end

NS_ASSUME_NONNULL_END
