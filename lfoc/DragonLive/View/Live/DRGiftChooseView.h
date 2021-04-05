//
//  DRGiftChooseView.h
//  DragonLive
//
//  Created by 11号 on 2020/12/25.
//

#import <UIKit/UIKit.h>
#import "RoomGift.h"

NS_ASSUME_NONNULL_BEGIN

@interface GiftCollectionViewCell : UICollectionViewCell

@property (nonatomic, readonly, strong) UIImageView *giftImgView;
@property (nonatomic, readonly, strong) UILabel *titleLabel;
@property (nonatomic, readonly, strong) UILabel *priceLabel;

@end;

/// 礼物选择view
@interface DRGiftChooseView : UIView

@property (nonatomic, copy) void (^loadMoneyBlock)(void);       //充值
@property (nonatomic, assign) NSUInteger selectedIndex;

+ (DRGiftChooseView *)showGiftViewInWindow:(NSArray *)dataArray changeItem:(void (^)(RoomGift *giftModel))changeItem;

- (void)hiddenGiftView;

- (void)changeItemWithTargetIndex:(NSUInteger)targetIndex;


@end

NS_ASSUME_NONNULL_END
