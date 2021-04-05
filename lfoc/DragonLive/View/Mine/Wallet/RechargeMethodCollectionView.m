//
//  RechargeMethodCollection.m
//  DragonLive
//
//  Created by LoaA on 2020/12/30.
//

#import "RechargeMethodCollectionView.h"
#import "RechargeMethodCollectionCell.h"
#import "RechargeMethodModel.h"

@interface RechargeMethodCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>

/// 选择方式框框
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation RechargeMethodCollectionView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView
{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake((kScreenWidth-kWidth(8+17*2))/2, kWidth(40));
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = kWidth(7);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(100))collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = YES;
    _collectionView.showsVerticalScrollIndicator = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[RechargeMethodCollectionCell class] forCellWithReuseIdentifier:RechargeMethodCollectionCellID];
    [self addSubview:_collectionView];
    
}//init



-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [_collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return 3;
    return _dataArray.count;
}//数量

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [collectionView dequeueReusableCellWithReuseIdentifier:RechargeMethodCollectionCellID forIndexPath:indexPath];
}//cell

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%ld",indexPath.row);
    
    for (NSInteger i=0; i<_dataArray.count; i++) {
        RechargeMethodModel *model = _dataArray[i];
        if (indexPath.row == i) {
            model.isSelected = YES;
        }else {
            model.isSelected = NO;
        }
    }
    [_collectionView reloadData];
    
    if (self.collectionViewDidSelectBlock) {
        self.collectionViewDidSelectBlock(_dataArray[indexPath.row]);
    }
    
}//点击

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, kWidth(17), 0, kWidth(17));//坐标从padding开始。contentOffset.x的O点从padding开始。
}//定义每个UICollectionView 的间距

#pragma mark - UICollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    RechargeMethodModel *model = _dataArray[indexPath.row];
    [(RechargeMethodCollectionCell *)cell configureCellWithModel:model];
    
}//赋值



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
