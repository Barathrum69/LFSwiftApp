//
//  RechargeMethodModel.h
//  DragonLive
//
//  Created by LoaA on 2020/12/30.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RechargeMethodModel : BaseModel

/// 渠道id
@property (nonatomic, copy) NSString *channelId;

/// 支付id
@property (nonatomic, copy) NSString *payId;

/// 渠道名字
@property (nonatomic, copy) NSString *channelName;

/// 渠道图片icon
@property (nonatomic, copy) NSString *channelImg;

/// 支付金额下限
@property (nonatomic, copy) NSString *minAmount;

/// 支付金额上限
@property (nonatomic, copy) NSString *maxAmount;

/// 固定金额（金额用,分隔）
@property (nonatomic, copy) NSString *validMoney;

/// 星币/人民币比例
@property (nonatomic, copy) NSString *rate;

/// 是否选中
@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
