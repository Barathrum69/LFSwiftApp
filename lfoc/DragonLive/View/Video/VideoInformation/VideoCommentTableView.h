//
//  VideoCommentTableView.h
//  DragonLive
//
//  Created by LoaA on 2020/12/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VideoCommentModel;
// 滑动收起键盘
typedef void(^ScrollViewWillBegin)(void);

// cell点赞的按钮
typedef void(^CellLikeBtnBlock)(VideoCommentModel *model);
// cell删除的按钮
typedef void(^CellDeleteBtnBlock)(VideoCommentModel *model);


@interface VideoCommentTableView : UITableView<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
/// 总数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 页码
@property (nonatomic, assign) NSInteger page;

// 滑动收起键盘
@property (nonatomic, copy) ScrollViewWillBegin scrollViewWillBegin;

/// cell点赞的按钮
@property (nonatomic, copy) CellLikeBtnBlock cellLikeBtnBlock;

/// cell删除的按钮
@property (nonatomic, copy) CellDeleteBtnBlock cellDeleteBtnBlock;

@end

NS_ASSUME_NONNULL_END
