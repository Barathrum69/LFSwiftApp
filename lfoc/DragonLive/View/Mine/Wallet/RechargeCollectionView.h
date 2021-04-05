//
//  RechargeCollectionView.h
//  DragonLive
//
//  Created by LoaA on 2020/12/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RechargeModel;
typedef void(^CollectionViewDidSelectBlock) (RechargeModel *model);
@interface RechargeCollectionView : UIView

/// 数据源
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic, copy) CollectionViewDidSelectBlock collectionViewDidSelectBlock;

@end

NS_ASSUME_NONNULL_END
