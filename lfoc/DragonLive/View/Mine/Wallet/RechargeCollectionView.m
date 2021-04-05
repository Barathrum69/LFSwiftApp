//
//  RechargeCollectionView.m
//  DragonLive
//
//  Created by LoaA on 2020/12/30.
//

#import "RechargeCollectionView.h"
#import "RechargeCollectionViewCell.h"
#import "RechargeModel.h"

@interface RechargeCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>


/// 金额框
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation RechargeCollectionView

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
    [_collectionView registerClass:[RechargeCollectionViewCell class] forCellWithReuseIdentifier:RechargeCollectionViewCellID];
    [self addSubview:_collectionView];
}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [_collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}


- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [collectionView dequeueReusableCellWithReuseIdentifier:RechargeCollectionViewCellID forIndexPath:indexPath];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%ld",indexPath.row);
    for (NSInteger i=0; i<self.dataArray.count; i++) {
        RechargeModel *model = self.dataArray[i];
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
    
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, kWidth(17), 0, kWidth(17));//坐标从padding开始。contentOffset.x的O点从padding开始。
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    RechargeModel *model = self.dataArray[indexPath.row];
    [(RechargeCollectionViewCell *)cell configureCellWithModel:model];
    //赋值
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
