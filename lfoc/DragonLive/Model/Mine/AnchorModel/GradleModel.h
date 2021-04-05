//
//  GradleModel.h
//  DragonLive
//
//  Created by LoaA on 2020/12/28.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class GradleSettingsModel;

@interface GradleModel : BaseModel

/// 用户id
@property (nonatomic,copy) NSString *userId;

/// 房间号
@property (nonatomic,copy) NSString *roomId;

/// 指标ID
@property (nonatomic,copy) NSString *targetId;

/// 等级ID
@property (nonatomic,copy) NSString *gradleId;

/// 等级
@property (nonatomic,copy) NSString *gradle;

/// 修改时间
@property (nonatomic,copy) NSString *modifyTime;

/// 等级特权ID
@property (nonatomic,copy) NSString *prerogativeId;

/// 经验
@property (nonatomic,copy) NSString *experience;

/// 图片
@property (nonatomic,copy) NSString *image;

/// 等级配置ID
@property (nonatomic,copy) NSString *gsId;

/// 等级设置实体
@property (nonatomic,strong) NSDictionary *gradleSettings;

/// 等级设置模型
@property (nonatomic,strong) GradleSettingsModel *gradleSettingsModel;
 
@end

NS_ASSUME_NONNULL_END
