//
//  AnchorModel.h
//  DragonLive
//
//  Created by LoaA on 2020/12/28.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class GradleModel;
@interface AnchorModel : BaseModel

/// 等级实体
@property (nonatomic,strong) NSDictionary *gradle;

/// 等级实体的模型。
@property (nonatomic,strong) GradleModel *gradleModel;

/// 粉丝数量
@property (nonatomic,copy) NSString *fansNumber;

/// 用户名
@property (nonatomic,copy) NSString *nickname;

/// 用户id
@property (nonatomic,copy) NSString *userId;

/// 直播房间号
@property (nonatomic,copy) NSString *liveBoardcastRoomNum;

/// 登录的用户名
@property (nonatomic,copy) NSString *userName;

@end

NS_ASSUME_NONNULL_END
