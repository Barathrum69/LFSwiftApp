//
//  MatchView.h
//  DragonLive
//
//  Created by LoaA on 2020/12/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MatchItemModel;
@class MatchTableView;
//头部尾部刷新
typedef void(^MatchHeaderRefreshBlock)(NSInteger page,NSInteger selectedSegmentIndex);
typedef void(^MatchFooterRefreshBlock)(NSInteger page,NSInteger selectedSegmentIndex);

typedef void(^MatchItemDidSelected)(MatchItemModel *model);


@interface MatchView : UIView

/// tableView
@property (nonatomic, strong) MatchTableView *matchTableView;

/// Segment的title数组
@property (nonatomic, strong) NSMutableArray *sectionTitles;

/// 数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

//头部刷新
@property (nonatomic, copy) MatchHeaderRefreshBlock matchHeaderRefreshBlock;

//尾部刷新
@property (nonatomic, copy) MatchFooterRefreshBlock matchFooterRefreshBlock;

/// match点击事件
@property (nonatomic, copy) MatchItemDidSelected matchItemDidSelected;

/// 停止刷新
-(void)headerFooterEnd;

@end

NS_ASSUME_NONNULL_END
