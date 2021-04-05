//
//  RechargeModel.h
//  DragonLive
//
//  Created by LoaA on 2020/12/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RechargeModel : NSObject

/// 龙币id
@property (nonatomic, assign) NSInteger packageId;

/// 人民币
@property (nonatomic, assign) NSInteger amount;

/// 龙币数量
@property (nonatomic, copy) NSString *coinsNum;

/// 支付金额下限
@property (nonatomic, copy) NSString *minAmount;

/// 支付金额上限
@property (nonatomic, copy) NSString *maxAmount;

/// 是否选中
@property (nonatomic, assign) BOOL isSelected;

/// 类型
@property (nonatomic, assign) RechargeStyleType rechargeStyleType;

@end

NS_ASSUME_NONNULL_END
