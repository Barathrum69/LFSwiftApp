//
//  RevenueInfoModel.h
//  DragonLive
//
//  Created by 11号 on 2021/1/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RevenueInfoModel : NSObject

/// 当前可兑换星币
@property (nonatomic, copy) NSString *availablestar;

/// 当前星币余额
@property (nonatomic, copy) NSString *allstar;

/// 可兑换人民币
@property (nonatomic, copy) NSString *money;

/// 比例
@property (nonatomic, copy) NSString *cosRate;

@end

NS_ASSUME_NONNULL_END
