//
//  HostTableViewCell.h
//  DragonLive
//
//  Created by LoaA on 2021/1/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HostModel;
@interface HostTableViewCell : UITableViewCell

/// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headImg;

/// 名字
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

/// 粉丝
@property (weak, nonatomic) IBOutlet UILabel *fansLab;

/// 直播的动态图
@property (weak, nonatomic) IBOutlet UIImageView *hasLiveImage;

/// 直播的状态
@property (weak, nonatomic) IBOutlet UILabel *liveMessageLab;

@property (nonatomic, strong) HostModel *model;
@end

NS_ASSUME_NONNULL_END
