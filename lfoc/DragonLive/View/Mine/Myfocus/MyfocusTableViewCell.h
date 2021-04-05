//
//  MyfocusTableViewCell.h
//  DragonLive
//
//  Created by LoaA on 2020/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MyFocusModel;
// 点击取消按钮的block
typedef void(^FocusBtnClickBlock)(MyFocusModel *model);

@interface MyfocusTableViewCell : UITableViewCell

/// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headImg;

/// 姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

/// 粉丝数
@property (weak, nonatomic) IBOutlet UILabel *fansLab;

/// 关注按钮
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;
/// 是否在直播
@property (weak, nonatomic) IBOutlet UIImageView *hasLive;

/// 模型
@property (strong, nonatomic) MyFocusModel *model;

/// 点击取消按钮的block
@property (copy, nonatomic) FocusBtnClickBlock focusBtnClickBlock;

@end

NS_ASSUME_NONNULL_END
