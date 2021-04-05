//
//  RechargeView.h
//  DragonLive
//
//  Created by LoaA on 2020/12/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RechargeModel;
@class RechargeMethodModel;
/// 充值金额选择点击block
typedef void(^RechargeItemDidSelectBlock) (RechargeModel *model);

/// 充值方式选择点击block
typedef void(^RechargeMethodItemDidSelectBlock) (RechargeMethodModel *model);

@interface RechargeView : UIView

/// 充值数据源
@property (nonatomic, strong) NSMutableArray *rechargeArray;

/// 充值方式数据源
@property (nonatomic, strong) NSMutableArray *rechargeMethodArray;

@property (nonatomic, strong, readonly) UIButton *submitBtn;

/// 立即充值点击block
@property (nonatomic, copy) void (^submitBlock)(void);

/// 充值金额选择点击block
@property (nonatomic, copy) RechargeItemDidSelectBlock rechargeItemDidSelectBlock;

/// 充值方式选择点击block
@property (nonatomic, copy) RechargeMethodItemDidSelectBlock rechargeMethodItemDidSelectBlock;

@end

NS_ASSUME_NONNULL_END
