//
//  VideoListView.h
//  DragonLive
//
//  Created by LoaA on 2020/12/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VideoModel;
@class VideoItemModel;
@class VideoCollectionView;
//点击
typedef void(^VideoListItemDidSelectBlock) (VideoItemModel *model);
//第一次加载
typedef void(^VideoListFirstRequest)(NSInteger page, NSInteger selectedSegmentIndex);

//头部尾部刷新
typedef void(^HeaderRefreshBlock)(NSInteger page, NSInteger selectedSegmentIndex);
typedef void(^FooterRefreshBlock)(NSInteger page, NSInteger selectedSegmentIndex);


@interface VideoListView : UIView

/// Segment的title数组
@property (nonatomic, strong) NSMutableArray *sectionTitles;

/// item 点击
@property (nonatomic, copy) VideoListItemDidSelectBlock videoListItemDidSelectBlock;


/// view第一次加载的block
@property (nonatomic, copy) VideoListFirstRequest videoListFirstRequest;


/// 头部刷新
@property (nonatomic, copy) HeaderRefreshBlock headerRefreshBlock;

/// 尾部刷新
@property (nonatomic, copy) FooterRefreshBlock footerRefreshBlock;


/// 数据源Model
@property (nonatomic, strong) VideoModel *itemModel;
/// 头部 尾部刷新
-(void)headerFooterEnd;

/// 当前页刷新.
-(void)currtPageRefrash;
/// 当前页数组
-(NSMutableArray *)getCurrtDataArray;

/// 获取当前页
-(UICollectionView *)getCurrtView;

@end

NS_ASSUME_NONNULL_END
