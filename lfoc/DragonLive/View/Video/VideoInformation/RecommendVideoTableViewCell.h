//
//  RecommendVideoTableViewCell.h
//  DragonLive
//
//  Created by LoaA on 2020/12/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LeftLabel;
@class VideoItemModel;
@interface RecommendVideoTableViewCell : UITableViewCell

/// 图片
@property (weak, nonatomic) IBOutlet UIImageView *video_img;

/// 时长
@property (weak, nonatomic) IBOutlet UILabel *duration_lab;

/// title
@property (weak, nonatomic) IBOutlet LeftLabel *title_lab;

/// 观看量 评论量
@property (weak, nonatomic) IBOutlet UILabel *watch_lab;

/// 名字
@property (weak, nonatomic) IBOutlet UILabel *name_lab;


/// 数据模型
@property (nonatomic, strong) VideoItemModel *model;

@end

NS_ASSUME_NONNULL_END
