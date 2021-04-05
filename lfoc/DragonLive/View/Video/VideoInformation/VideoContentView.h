//
//  VideoContentView.h
//  DragonLive
//
//  Created by LoaA on 2020/12/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VideoDetailModel;
@class VideoItemModel;
@class RecommendVideoTableView;
@class RecommendHeader;
@class VideoCommentTableView;
@class VideoCommentModel;
// 这个视频的点赞
typedef void(^RecommedLikeedBlock)(VideoDetailModel *model);

//推荐视频点击事件
typedef void(^RecommedTableViewDidSelected)(VideoItemModel *model);

//头部尾部刷新
typedef void(^CommentHeaderRefreshBlock)(NSInteger page);
typedef void(^CommentFooterRefreshBlock)(NSInteger page);

//发送的文案
typedef void(^TextViewContentText)(NSString *string);

//评论点赞的block
typedef void(^CommentLikeBlock)(VideoCommentModel *model);
//评论删除的block
typedef void(^CommentDeleteBlock)(VideoCommentModel *model);
//分享
typedef void(^RecommedShareBlock)(void);

@interface VideoContentView : UIView

/// 推荐更多的列表
@property (nonatomic, strong) RecommendVideoTableView *recommendVideoTableView;

/// 更多的列表的header
@property (nonatomic, strong) RecommendHeader *recommendHeader;

/// 评论列表
@property (nonatomic, strong) VideoCommentTableView *videoCommentTableView;


/// Segment的title数组
@property (nonatomic, strong) NSMutableArray *sectionTitles;

@property (nonatomic, strong) VideoDetailModel *itemModel;

/// 推荐视频的列表
@property (nonatomic, strong) NSMutableArray *recommedArray;

/// 评论列表
@property (nonatomic, strong) NSMutableArray *commentArray;

/// 推荐视频点击事件
@property (nonatomic, copy) RecommedTableViewDidSelected recommedTableViewDidSelected;

///头部刷新
@property (nonatomic, copy) CommentHeaderRefreshBlock commentHeaderRefreshBlock;

/// 尾部刷新
@property (nonatomic, copy) CommentFooterRefreshBlock commentFooterRefreshBlock;

/// 发送
@property (nonatomic, copy) TextViewContentText textViewContentText;


/// 评论点赞的block
@property (nonatomic, copy) CommentLikeBlock commentLikeBlock;

/// 评论删除的block
@property (nonatomic, copy) CommentDeleteBlock commentDeleteBlock;

/// 分享的block
@property (nonatomic, copy) RecommedShareBlock recommedShareBlock;

/// 这个视频的点赞
@property (nonatomic, copy) RecommedLikeedBlock recommedLikeedBlock;

/// 停止刷新
-(void)headerFooterEnd;



@end

NS_ASSUME_NONNULL_END
