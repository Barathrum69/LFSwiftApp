//
//  RechargeMethodCollection.h
//  DragonLive
//
//  Created by LoaA on 2020/12/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RechargeMethodModel;
typedef void(^RechargeMethodViewDidSelectBlock) (RechargeMethodModel *model);
@interface RechargeMethodCollectionView : UIView

/// 数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

/// 点击
@property (nonatomic, copy) RechargeMethodViewDidSelectBlock collectionViewDidSelectBlock;

@end

NS_ASSUME_NONNULL_END
