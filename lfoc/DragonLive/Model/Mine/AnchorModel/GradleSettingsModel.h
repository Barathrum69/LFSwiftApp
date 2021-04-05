//
//  GradleSettingsModel.h
//  DragonLive
//
//  Created by LoaA on 2020/12/28.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GradleSettingsModel : BaseModel

/// 审核人
@property (nonatomic,copy) NSString *approver;

/// 背景
@property (nonatomic,copy) NSString *backgroud;

/// 审核时间
@property (nonatomic,copy) NSString *approveTime;

/// 等级特权ID
@property (nonatomic,copy) NSString *prerogativeId;

/// 等级设置ID
@property (nonatomic,copy) NSString *gsId;

/// title
@property (nonatomic,copy) NSString *title;

/// 名字颜色
@property (nonatomic,copy) NSString *nicknameColor;

/// 图片
@property (nonatomic,copy) NSString *image;

/// 头像角标
@property (nonatomic,copy) NSString *headCorner;

/// 设置人
@property (nonatomic,copy) NSString *creator;

/// 指标等级
@property (nonatomic,copy) NSString *targetGradle;

/// 等级名称
@property (nonatomic,copy) NSString *gradleName;

/// createTime
@property (nonatomic,copy) NSString *createTime;

/// 指标经验阀值
@property (nonatomic,copy) NSString *experienceLimit;

/// 状态 ：0 - 启用,1 - 作废
@property (nonatomic,copy) NSString *status;

/// 指标ID：11 - 消费等级,21 - 用户等级,31 - 主播等级
@property (nonatomic,copy) NSString *targetId;





@end

NS_ASSUME_NONNULL_END
