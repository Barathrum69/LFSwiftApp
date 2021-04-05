//
//  VideoCollectionViewCell.h
//  DragonLive
//
//  Created by LoaA on 2020/12/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT NSString *const VideoCollectionViewCellID;
@class VideoItemModel;
@interface VideoCollectionViewCell : UICollectionViewCell

/// 赋值
/// @param model 模型
-(void)configureCellWithModel:(VideoItemModel *)model;

-(void)configureCellWithModel:(VideoItemModel *)model searchKey:(NSString *)searchKey;

@end

NS_ASSUME_NONNULL_END
