//
//  VideoCollectionView.h
//  DragonLive
//
//  Created by LoaA on 2020/12/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class VideoItemModel;
typedef void(^CollectionViewItemDidSelectBlock) (VideoItemModel *model);

//头部 尾部刷新
typedef void(^VideoCollectionViewHeaderBlock)(NSInteger page);
typedef void(^VideoCollectionViewFooterBlock)(NSInteger page);


@interface VideoCollectionView : UIView

/// collectionView
@property (nonatomic, strong) UICollectionView  *collectionView;

/**
 点击的block
 */
@property (nonatomic,copy) CollectionViewItemDidSelectBlock collectionViewItemDidSelectBlock;

/**
 头部刷新
 */
@property (nonatomic,copy) VideoCollectionViewHeaderBlock videoCollectionViewHeaderBlock;

/**
 尾部刷新
 */
@property (nonatomic,copy) VideoCollectionViewFooterBlock videoCollectionViewFooterBlock;

/**
 数据源
 */
@property (nonatomic,strong) NSMutableArray *dataArray;

/// 停止刷新
-(void)headerFooterEnd;

@end

NS_ASSUME_NONNULL_END
