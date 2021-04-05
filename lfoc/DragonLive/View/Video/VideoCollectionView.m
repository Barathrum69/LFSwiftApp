//
//  VideoCollectionView.m
//  DragonLive
//
//  Created by LoaA on 2020/12/3.
//

#import "VideoCollectionView.h"
#import "VideoCollectionViewCell.h"
#import "VideoItemModel.h"
@interface VideoCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>

/// 没有更多数据.
@property (nonatomic, strong) NoMoreView *noMoreView;

/// 页码
@property (nonatomic, assign) NSInteger page;

@end

@implementation VideoCollectionView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = The_MainColor;
        _page = 1;
        [self initCollectionView];
    }
    return self;
}//init

-(void)initCollectionView
{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake((kScreenWidth-kWidth(10))/2, kWidth(133));
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = kWidth(6);
    layout.minimumInteritemSpacing = kWidth(3);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(kWidth(3), 0, kScreenWidth-kWidth(6), kMainViewHeight-50)collectionViewLayout:layout];
        _collectionView.backgroundColor = The_MainColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = YES;
    _collectionView.showsVerticalScrollIndicator = YES;//垂直
    _collectionView.showsHorizontalScrollIndicator = NO;//水平
    [_collectionView registerClass:[VideoCollectionViewCell class] forCellWithReuseIdentifier:VideoCollectionViewCellID];
    [self addSubview:_collectionView];
    
    
    kWeakSelf(self);
    //头部尾部刷新 加载更多
    _collectionView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        weakself.page = 1;
        if (weakself.videoCollectionViewHeaderBlock) {
            weakself.videoCollectionViewHeaderBlock(weakself.page);
        }
     }];
    
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        weakself.page ++;
        if (weakself.videoCollectionViewFooterBlock) {
            weakself.videoCollectionViewFooterBlock(weakself.page);
        }
     }];
}//初始化加载CollectionView

-(void)headerFooterEnd
{
    if (_collectionView.mj_header.isRefreshing) {
        [_collectionView.mj_header endRefreshing];

    }
    if (_collectionView.mj_footer.isRefreshing) {
        [_collectionView.mj_footer endRefreshing];
    }
}//结束头部尾部的刷新


-(void)setDataArray:(NSMutableArray *)dataArray
{
    if (_page == 1&&dataArray.count == 0) {
        if (!_noMoreView) {
            _noMoreView = [[NoMoreView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
            [self.collectionView addSubview:_noMoreView];
        }
    }else{
        if (dataArray.count != 0) {
            if (_noMoreView) {
                [_noMoreView removeFromSuperview];
                _noMoreView = nil;
            }
        }
    }
    
    
    if (dataArray.count < 10) {
        if (_page != 1&&_dataArray.count>0) {
            self.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
        }
    }
    if (_dataArray != dataArray) {
        if (_dataArray.count != 0) {
            if (_page == 1) {
                self.collectionView.mj_footer.state = MJRefreshStateIdle;
                _dataArray = dataArray;
            }else{
            [_dataArray addObjectsFromArray:dataArray];
            }
        }else{
            //移除无数据的View
//            if (self.removeMaskView) {
//                self.removeMaskView();
//            }
            _dataArray = dataArray;
        }
       
    }
        [UIView performWithoutAnimation:^{
           //刷新界面 必须得用这个 不然闪屏 Ps: 妈蛋。加主线程也是一样闪一闪。
            [self.collectionView reloadData];
         }];
}//给数据源赋值

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}//返回多少条数据


- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [collectionView dequeueReusableCellWithReuseIdentifier:VideoCollectionViewCellID forIndexPath:indexPath];
}//cell构建

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%ld",indexPath.row);
    VideoItemModel *model = _dataArray[indexPath.row];
    if (self.collectionViewItemDidSelectBlock) {
        self.collectionViewItemDidSelectBlock(model);
    }
    
}//点击 用block传一个model 出去

#pragma mark - UICollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoItemModel *model = self.dataArray[indexPath.row];
    [(VideoCollectionViewCell *)cell configureCellWithModel:model];
    //赋值
}//给cell model赋值
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
