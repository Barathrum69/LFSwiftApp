//
//  WalletRecordModel.h
//  DragonLive
//
//  Created by LoaA on 2020/12/31.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletRecordModel : BaseModel

/// 收支金额
@property (nonatomic, copy) NSString *coinNum;

/// 可用余额
@property (nonatomic, copy) NSString *availableCoins;

/// 订单号
@property (nonatomic, copy) NSString *orderId;

/// 交易时间
@property (nonatomic, copy) NSString *happenTime;

/// 1 - 充值入账,2 - 提现出账,3 - 冻结,4 - 解冻,5 - 礼物支出 ,6 - 礼物收入,7 - 任务收入
@property (nonatomic, copy) NSString *btype;

/// 当前余额
@property (nonatomic, copy) NSString *curCoinsBalance;

/// 行数的数组拼接
@property (nonatomic, strong) NSMutableArray *rowArray;

/// 处理数据
-(void)dealData;

@end

NS_ASSUME_NONNULL_END
