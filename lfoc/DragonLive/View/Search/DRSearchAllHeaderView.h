//
//  DRSearchAllHeaderView.h
//  DragonLive
//
//  Created by 11号 on 2020/12/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MoreClickBlock) (void);

@interface DRSearchAllHeaderView : UICollectionReusableView

@property (nonatomic, copy) MoreClickBlock moreBlock;

- (void)setTitleStr:(NSString *)titleStr;

@end

NS_ASSUME_NONNULL_END
