//
//  NewsTableViewCell.h
//  DragonLive
//
//  Created by LoaA on 2021/2/17.
//

#import <UIKit/UIKit.h>
@class LeftLabel,NewsItemModel;
NS_ASSUME_NONNULL_BEGIN

@interface NewsTableViewCell : UITableViewCell


/// 标题
@property (weak, nonatomic) IBOutlet LeftLabel *titleLab;

/// 时间
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

/// 图像
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

/// 数据模型
@property (nonatomic, strong) NewsItemModel *model;

@end

NS_ASSUME_NONNULL_END
