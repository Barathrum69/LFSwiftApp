//
//  RechargeMethodCollectionCell.h
//  DragonLive
//
//  Created by LoaA on 2020/12/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT NSString *const RechargeMethodCollectionCellID;

@class RechargeMethodModel;

@interface RechargeMethodCollectionCell : UICollectionViewCell


/// 赋值
/// @param model 数据模型
-(void)configureCellWithModel:(RechargeMethodModel *)model;


@end

NS_ASSUME_NONNULL_END
