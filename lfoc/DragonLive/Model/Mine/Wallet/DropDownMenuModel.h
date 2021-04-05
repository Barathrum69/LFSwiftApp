//
//  DropDownMenuModel.h
//  DragonLive
//
//  Created by LoaA on 2020/12/31.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DropDownMenuModel : BaseModel
/// id
@property (nonatomic, copy) NSString *item_id;

/// name
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
