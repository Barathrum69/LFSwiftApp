//
//  DRSearchVideoViewController.m
//  DragonLive
//
//  Created by 11号 on 2020/12/17.
//

#import "DRSearchVideoViewController.h"
#import "VideoItemModel.h"
#import "VideoCollectionViewCell.h"
#import "VideoInformationController.h"
#import "DREmptyView.h"

@interface DRSearchVideoViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *videoCollectionView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation DRSearchVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.videoCollectionView registerClass:[VideoCollectionViewCell class] forCellWithReuseIdentifier:@"VideoCollectionViewCell"];
    
    __weak __typeof(self)weakSelf = self;
    _videoCollectionView.mj_footer =  [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.footerLoadBlock) {
            weakSelf.footerLoadBlock();
        }
    }];
}

- (void)reloadVideoData:(NSArray *)dataArray
{
    if (dataArray.count < 20) {
        _videoCollectionView.mj_footer.hidden = YES;
    }
    if (_videoCollectionView.mj_footer.isRefreshing) {
        [_videoCollectionView.mj_footer endRefreshing];
    }
    
    self.dataArray = dataArray;

    [self.videoCollectionView reloadData];
    
    if (!self.dataArray || self.dataArray.count == 0) {
        [DREmptyView showEmptyInView:self.view emptyType:DREmptyDataType];
    }else {
        [DREmptyView hiddenEmptyInView:self.view];
    }
}

#pragma mark -collectionview 数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;   //返回section数
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;  //每个section的Item数
}

//UICollectionViewCell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat liveTitleH = 38.0;      //直播标题高
    CGFloat ratio = 16/9.0;         //封面图宽高比
    CGFloat cellWidth = ([UIScreen mainScreen].bounds.size.width - 4 - 10) * 0.5;
    CGFloat cellHeight = cellWidth / ratio + liveTitleH;
//    NSLog(@"宽：%f 高：%f",cellWidth,cellHeight);
    return CGSizeMake(cellWidth, cellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 5, 15, 5);
    return insets;
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 6;
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    VideoCollectionViewCell *videoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCollectionViewCell" forIndexPath:indexPath];
    VideoItemModel *videoItem = self.dataArray[indexPath.item];
    [videoCell configureCellWithModel:videoItem];
    
    return videoCell;

}

#pragma mark - 点击 某个Item时 调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];//取消选中
    VideoItemModel *videoItem = self.dataArray[indexPath.item];
    VideoInformationController *vc = [VideoInformationController new];
    vc.itemModel = videoItem;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
