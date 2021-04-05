//
//  DRSearchAllViewController.m
//  DragonLive
//
//  Created by 11号 on 2020/12/17.
//

#import "DRSearchAllViewController.h"
#import "DRStreamerAllCell.h"
#import "LiveCollectionViewCell.h"
#import "VideoCollectionViewCell.h"
#import "LiveHosts.h"
#import "LiveItem.h"
#import "VideoItemModel.h"
#import "DRSearchAllHeaderView.h"
#import "LiveRoomViewController.h"
#import "VideoInformationController.h"
#import "DREmptyView.h"
#import "SearchAllModel.h"

@interface DRSearchAllViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak) IBOutlet UICollectionView *resultCollectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation DRSearchAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [The_MainColor];
    
    [self.resultCollectionView registerNib:[UINib nibWithNibName:@"DRStreamerAllCell" bundle:nil] forCellWithReuseIdentifier:@"DRStreamerAllCell"];
    [self.resultCollectionView registerNib:[UINib nibWithNibName:@"LiveCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LiveCollectionViewCell"];
    [self.resultCollectionView registerClass:[VideoCollectionViewCell class] forCellWithReuseIdentifier:@"VideoCollectionViewCell"];
    
}

- (void)reloadData:(NSMutableArray *)allArray
{
    self.dataArray = allArray;
    [self.resultCollectionView reloadData];
    
    if (!self.dataArray || self.dataArray.count == 0) {
        [DREmptyView showEmptyInView:self.view emptyType:DREmptyDataType];
    }else {
        [DREmptyView hiddenEmptyInView:self.view];
    }
}

- (void)clearSearchHistory
{
    [self.dataArray removeAllObjects];
    [self.resultCollectionView reloadData];
}

#pragma mark -collectionview 数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    SearchAllModel *allModel = [self.dataArray objectAtIndex:section];
    NSInteger rowCount = allModel.resultArray.count<5?allModel.resultArray.count:4;
    return rowCount;
}

//UICollectionViewCell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BOOL isHost = NO;
    if (self.dataArray.count) {
        SearchAllModel *allModel = [self.dataArray firstObject];
        if ([allModel.resultTitle isEqualToString:@"相关主播"]) {
            isHost = YES;
        }
    }
    if (indexPath.section == 0 && isHost) {
        return CGSizeMake(70, 70);
    }
    
    CGFloat liveTitleH = 38.0;      //直播标题高
    CGFloat ratio = 16/9.0;         //封面图宽高比
    CGFloat cellWidth = ([UIScreen mainScreen].bounds.size.width - 4 - 10) * 0.5;
    CGFloat cellHeight = cellWidth / ratio + liveTitleH;
//    NSLog(@"宽：%f 高：%f",cellWidth,cellHeight);
    return CGSizeMake(cellWidth, cellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    BOOL isHost = NO;
    if (self.dataArray.count) {
        SearchAllModel *allModel = [self.dataArray firstObject];
        if ([allModel.resultTitle isEqualToString:@"相关主播"]) {
            isHost = YES;
        }
    }
    
    if (section == 0 && isHost) {
        return UIEdgeInsetsMake(10, 15, 5, 15);
    }
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 5, 5, 5);
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
    
    SearchAllModel *allModel = [self.dataArray objectAtIndex:indexPath.section];
    if ([allModel.resultTitle isEqualToString:@"相关主播"]) {
        DRStreamerAllCell *hostCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DRStreamerAllCell" forIndexPath:indexPath];
        LiveHosts *hostsModel = allModel.resultArray[indexPath.item];
        [hostCell setLiveHosts:hostsModel searchKey:_searchKey];
        
        return hostCell;
    }else if ([allModel.resultTitle isEqualToString:@"相关直播"]) {
        LiveCollectionViewCell *liveCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LiveCollectionViewCell" forIndexPath:indexPath];
        
        LiveItem *item = allModel.resultArray[indexPath.item];
        [liveCell setCellItem:item searchKey:_searchKey];
        
        return liveCell;
    }

    VideoCollectionViewCell *videoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCollectionViewCell" forIndexPath:indexPath];
    VideoItemModel *videoItem = allModel.resultArray[indexPath.item];
    [videoCell configureCellWithModel:videoItem searchKey:_searchKey];
        
    return videoCell;

}

// 要先设置表头大小
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 40);
    return size;
}

// 创建一个继承collectionReusableView的类,用法类比tableViewcell
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        // 头部视图
        [collectionView registerNib:[UINib nibWithNibName:@"DRSearchAllHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DRSearchAllHeaderView"];
        DRSearchAllHeaderView *tempHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DRSearchAllHeaderView" forIndexPath:indexPath];
        
        __weak __typeof(self)weakSelf = self;
        tempHeaderView.moreBlock = ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf.tapActionBlock) {
                strongSelf.tapActionBlock(indexPath.section);
            }
        };
        SearchAllModel *allModel = [self.dataArray objectAtIndex:indexPath.section];
        [tempHeaderView setTitleStr:allModel.resultTitle];
        reusableView = tempHeaderView;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        // 底部视图
    }
    return reusableView;
}

#pragma mark - 点击 某个Item时 调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];//取消选中
    
    SearchAllModel *allModel = [self.dataArray objectAtIndex:indexPath.section];
    if ([allModel.resultTitle isEqualToString:@"相关主播"]) {
        LiveHosts *hostsModel = allModel.resultArray[indexPath.row];
        if ([hostsModel.livestatus integerValue] == 1) {
            LiveItem *lvItem = [[LiveItem alloc] init];
            lvItem.roomId = hostsModel.roomid;
            LiveRoomViewController *controller = [[LiveRoomViewController alloc] init];
            controller.liveItem = lvItem;
            [self.navigationController pushViewController:controller animated:YES];
        }else {
            [[HCToast shareInstance] showToast:@"当前主播尚未开播"];
        }
        
    }else if ([allModel.resultTitle isEqualToString:@"相关直播"]) {
        LiveItem *item = allModel.resultArray[indexPath.item];
        LiveRoomViewController *controller = [[LiveRoomViewController alloc] init];
        controller.liveItem = item;
        [self.navigationController pushViewController:controller animated:YES];
    }else {
        VideoItemModel *videoItem = allModel.resultArray[indexPath.item];
        VideoInformationController *vc = [VideoInformationController new];
        vc.itemModel = videoItem;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
