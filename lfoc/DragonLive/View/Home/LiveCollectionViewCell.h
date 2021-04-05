//
//  LiveCollectionViewCell.h
//  DragonLive
//
//  Created by 11号 on 2020/11/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class  LiveItem;

/// 首页直播列表cell
@interface LiveCollectionViewCell : UICollectionViewCell

- (void)setCellItem:(LiveItem *)item;

- (void)setCellItem:(LiveItem *)item searchKey:(NSString *)searchKey;

@end

NS_ASSUME_NONNULL_END
