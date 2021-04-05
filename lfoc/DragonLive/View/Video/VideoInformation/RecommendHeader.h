//
//  RecommendHeader.h
//  DragonLive
//
//  Created by LoaA on 2020/12/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class VideoDetailModel;
/// 分享按钮block
typedef void(^ShareBtnBlock)(void);
/// 点赞的blcok
typedef void(^LikeBtnClickBlock)(VideoDetailModel *model);
/// 评论的block
typedef void(^ReCommentBtnClickBlock)(void);

@interface RecommendHeader : UIView

@property (nonatomic,strong) VideoDetailModel *model;

/// 分享按钮block
@property (nonatomic, copy) ShareBtnBlock shareBtnBlock;

/// 点赞的blcok
@property (nonatomic, copy) LikeBtnClickBlock likeBtnClickBlock;

/// 评论的block
@property (nonatomic, copy) ReCommentBtnClickBlock reCommentBtnClickBlock;

@end

NS_ASSUME_NONNULL_END
