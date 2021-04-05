//
//  TaskTableViewCell.h
//  DragonLive
//
//  Created by LoaA on 2020/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TaskModel;

typedef void(^ReceiveBtnBlock)(TaskModel *model);

@interface TaskTableViewCell : UITableViewCell

/// 图像
@property (weak, nonatomic) IBOutlet UIImageView *img;
//名称
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

/// 内容
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

/// 奖励
@property (weak, nonatomic) IBOutlet UILabel *rewardLab;

/// 领取按钮
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;

/// 数据模型
@property (nonatomic, strong) TaskModel *model;

/// 领取block
@property (nonatomic, strong) ReceiveBtnBlock receiveBtnBlock;

@end



NS_ASSUME_NONNULL_END
