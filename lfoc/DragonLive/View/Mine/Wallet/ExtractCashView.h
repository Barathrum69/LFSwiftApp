//
//  ExtractCashView.h
//  DragonLive
//
//  Created by LoaA on 2020/12/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RevenueInfoModel;

@interface ExtractCashView : UIView

@property (nonatomic, copy) void (^sendRevenueBlock)(void);


/// 更新提现信息
- (void)setExtractCashViewRevenueModel:(RevenueInfoModel *)rmodel;

@end

NS_ASSUME_NONNULL_END
