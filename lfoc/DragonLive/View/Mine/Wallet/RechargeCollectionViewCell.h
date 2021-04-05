//
//  RechargeCollectionViewCell.h
//  DragonLive
//
//  Created by LoaA on 2020/12/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT NSString *const RechargeCollectionViewCellID;
@class RechargeModel;
@interface RechargeCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) RechargeModel *itemModel;

-(void)configureCellWithModel:(RechargeModel *)model;


@end

NS_ASSUME_NONNULL_END
