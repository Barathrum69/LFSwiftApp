//
//  MatchTableViewCell.h
//  DragonLive
//
//  Created by LoaA on 2020/12/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MatchItemModel;
@class LeftLabel;
@interface MatchTableViewCell : UITableViewCell

/// 时间lab
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

/// 描述的label
@property (weak, nonatomic) IBOutlet LeftLabel *descriptionLabel;

/// 主队前面的那个小黑点
@property (weak, nonatomic) IBOutlet UIImageView *homeImg;

/// 客队前面的那个小黑点
@property (weak, nonatomic) IBOutlet UIImageView *awayImg;

/// 主队名字
@property (weak, nonatomic) IBOutlet UILabel *homeName;

/// 客队名字
@property (weak, nonatomic) IBOutlet UILabel *awayName;

/// 主播头像
@property (weak, nonatomic) IBOutlet UIImageView *hostImg;

/// 主播头像2
@property (weak, nonatomic) IBOutlet UIImageView *hostImg2;

/// 主播头像3
@property (weak, nonatomic) IBOutlet UIImageView *hostImg3;

/// 观战按钮
//@property (weak, nonatomic) IBOutlet UIButton *watchBtn;

@property (nonatomic, strong) MatchItemModel *model;

/// 直播的图像
@property (weak, nonatomic) IBOutlet UIImageView *videoLiveIcon;

/// 直播的title
@property (weak, nonatomic) IBOutlet UILabel *liveLab;
@end

NS_ASSUME_NONNULL_END
