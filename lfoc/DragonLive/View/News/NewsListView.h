//
//  NewsListView.h
//  DragonLive
//
//  Created by LoaA on 2021/2/17.
//

#import <UIKit/UIKit.h>
#import "NewsTableView.h"
NS_ASSUME_NONNULL_BEGIN

@class NewsModel;
@class NewsItemModel;
//头部 尾部刷新
typedef void(^TableViewHeaderBlock)(NSInteger page,NSInteger selectedSegmentIndex);
typedef void(^TableViewFooterBlock)(NSInteger page,NSInteger selectedSegmentIndex);
//点击
typedef void(^TableViewDidSelected)(NewsItemModel *model);

//第一次加载
typedef void(^TableViewFirstRequest)(NSInteger page, NSInteger selectedSegmentIndex);

@interface NewsListView : UIView
/// Segment的title数组
@property (nonatomic, strong) NSMutableArray *sectionTitles;

/**
 头部刷新
 */
@property (nonatomic, copy) TableViewHeaderBlock tableViewHeaderBlock;

/**
 尾部刷新
 */
@property (nonatomic, copy) TableViewFooterBlock tableViewFooterBlock;

/// view第一次加载的block
@property (nonatomic, copy) TableViewFirstRequest tableViewFirstRequest;

/// 点击
@property (nonatomic, copy) TableViewDidSelected tableViewDidSelected;


/// 数据源Model
@property (nonatomic, strong) NewsModel *itemModel;


/// header footer end
-(void)headerFooterEnd;
/// 获取当前View
-(NewsTableView *)getCurrtView;

/// 获取当前页是否有数据
-(NSMutableArray *)getCurrtDataArray;
/// 当前页 刷新点击
-(void)currtPageRefrash;
@end

NS_ASSUME_NONNULL_END
