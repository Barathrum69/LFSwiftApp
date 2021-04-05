//
//  VideoCommentTableViewCell.h
//  DragonLive
//
//  Created by LoaA on 2020/12/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LEECoolButton;
@class VideoCommentModel;
//点赞
typedef void(^LikeBtnOnClick)(VideoCommentModel *model);

//删除
typedef void(^DeleteBtnOnClick)(VideoCommentModel *model);


@interface VideoCommentTableViewCell : UITableViewCell

/// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headImg;

/// 名字
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

/// 内容
@property (weak, nonatomic) IBOutlet UILabel *messageLab;

/// 时间
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

/// 删除
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

/// 点赞

@property (nonatomic, strong) LEECoolButton *likeBtn;

/// 评论数量
@property (weak, nonatomic) IBOutlet UILabel *commentNum;

/// 数据模型
@property (nonatomic, strong) VideoCommentModel *model;

/// 点赞blcok
@property (nonatomic, copy) LikeBtnOnClick likeBtnOnClick;
 
/// 删除block
@property (nonatomic, copy) DeleteBtnOnClick deleteBtnOnClick;

@end

NS_ASSUME_NONNULL_END
