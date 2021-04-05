//
//  MyFocusModel.h
//  DragonLive
//
//  Created by LoaA on 2020/12/26.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyFocusModel : BaseModel

/// 用户Id
@property (nonatomic, copy) NSString *userId;

/// 是否在直播中 0 否 ；1 是
@property (nonatomic, copy) NSString *hasLive;

/// 粉丝数量
@property (nonatomic, copy) NSString *fansNum;

/// 房间Id
@property (nonatomic, copy) NSString *roomId;

/// 关注人的ID
@property (nonatomic, copy) NSString *attentionUser;

/// <#Description#>
@property (nonatomic, copy) NSString *atype;

/// <#Description#>
@property (nonatomic, copy) NSString *ftype;

/// 关注人用户类型：1 - 普通用户,2 - 主播,3 - 房管
@property (nonatomic, copy) NSString *userType;

/// 名字
@property (nonatomic, copy) NSString *nickName;

/// 头像
@property (nonatomic, copy) NSString *headIcon;

@end

NS_ASSUME_NONNULL_END
