//
//  HomeLiveViewController.m
//  DragonLive
//
//  Created by 11号 on 2020/11/25.
//

#import "HomeLiveViewController.h"
#import "HttpRequest.h"
#import "LiveCollectionViewCell.h"
#import "LiveRoomViewController.h"
#import "LiveItem.h"
#import "LiveCategory.h"
#import "SegmentHeaderView.h"
#import "LiveBannerHeaderView.h"
#import "BannerModel.h"
#import "DRSmallDragView.h"
#import "EasyTextView.h"
#import "DREmptyView.h"
#import "BAWebViewController.h"
#import "MatchLiveRoomViewController.h"
#import "VideoItemModel.h"
#import "VideoInformationController.h"
#import "NewsController.h"

@interface HomeLiveViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView *liveCollectionView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *collectionTop;

@property (nonatomic, strong) SegmentHeaderView *headerView;                        //直播列表顶部分类view

@property (nonatomic, strong) NSMutableArray *marqueeArray;
@property (nonatomic, strong) NSMutableArray *bannerArray;                          //广告数据集合
@property (nonatomic, strong) NSMutableArray *dataArray;                            //直播列表数据集合
@property (nonatomic, strong) NSMutableArray *ctgArray;                             //直播分类数据集合
@property (nonatomic,copy) NSString *selectCtgId;                                   //当前选中分类id
@property (nonatomic) NSInteger livePage;                                           //页码
@property (nonatomic) NSInteger totalSize;                                          //数据总条数

@end

@implementation HomeLiveViewController

static NSInteger const pageSize = 20;           //分页长度

static CGFloat const marginLeftRight = 5;       //列表左右间距
static CGFloat const lineSpacing = 4;          //行的上下间距
static CGFloat const interSpacing = 4;         //列的左右间距

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.liveCollectionView registerNib:[UINib nibWithNibName:@"LiveCollectionViewCell"bundle:nil] forCellWithReuseIdentifier:@"LiveCollectionViewCell"];
    
    if (self.selectIndex > 0) {
        [self.view addSubview:self.headerView];
    }
    
    __weak __typeof(self)weakSelf = self;
    _liveCollectionView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        strongSelf.livePage = 1;
        [strongSelf requestLiveList:weakSelf.selectCtgId];
        if (strongSelf.selectIndex == 0) {
            [strongSelf requestBannerList];
            [strongSelf requestMarqueeList];
        }
        if (strongSelf.selectIndex > 0) {
            [strongSelf requestLiveChildrenList];
        }
     }];
    _liveCollectionView.mj_footer =  [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        strongSelf.livePage ++;
        [strongSelf requestLiveList:strongSelf.selectCtgId];
    }];
//    _liveCollectionView.mj_header.hidden = YES;
    _liveCollectionView.mj_footer.hidden = YES;
    
    [_liveCollectionView.mj_header beginRefreshing];
    
    self.marqueeArray = [NSMutableArray array];
    self.bannerArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    self.ctgArray = [NSMutableArray array];
    self.livePage = 1;
}

- (SegmentHeaderView *)headerView
{
    if (!_headerView) {
        self.headerView = [[SegmentHeaderView alloc] initWithFrame:CGRectMake(0, 0, kkScreenWidth, 40) titleArray:self.ctgArray];
        __weak __typeof(self)weakSelf = self;
        _headerView.selectedItemHelper = ^(NSUInteger index) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            if (index == 0) {
                [strongSelf requestLiveList:nil];
                strongSelf.selectCtgId = nil;
            }else {
                LiveCategory *ctgModel = [strongSelf.ctgArray objectAtIndex:index-1];
                [strongSelf requestLiveList:ctgModel.ctgId];
                strongSelf.selectCtgId = ctgModel.ctgId;
            }
        };
        _collectionTop.constant = -40.0;
    }
    return _headerView;
}

- (void)selectedLiveType:(NSInteger)selectIndex
{
    self.selectIndex = selectIndex;
    if (_bannerArray.count == 0 && selectIndex == 0) {
        [self requestBannerList];
        [self requestMarqueeList];
    }
    if (_dataArray.count == 0) {
        [self requestLiveList:nil];
    }
    if (_ctgArray.count == 0 && selectIndex > 0) {
        [self.view addSubview:self.headerView];
        [self requestLiveChildrenList];
    }
}

//请求直播列表
- (void)requestLiveList:(NSString *)ctgId
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"page"] = @(_livePage);
    params[@"size"] = @(pageSize);
    params[@"type"] = [self getRequestType];
    if (ctgId) {
        params[@"ctgId"] = ctgId;
    }else {
        params[@"ctgId"] = @"";
    }
    
    __weak __typeof(self)weakSelf = self;
    [HttpRequest requestWithURLType:UrlTypeLiveList parameters:params type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code==200) {
            NSMutableArray *arr = responseObject[@"data"][@"items"];
            NSInteger total = [responseObject[@"data"][@"total"] integerValue];
            
            if (strongSelf.livePage == 1) {
                [strongSelf.dataArray removeAllObjects];
            }
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                LiveItem *model = [LiveItem modelWithDictionary:obj];
                [strongSelf.dataArray addObject:model];
            }];
            [strongSelf.liveCollectionView reloadData];
            
            if (total == 0) {
                [DREmptyView showEmptyInView:strongSelf.view emptyType:DREmptyDataType];
            }else {
                [DREmptyView hiddenEmptyInView:strongSelf.view];
            }
            
//            //只有一页的数据没有刷新和翻页
//            if (total < pageSize) {
//                [strongSelf.liveCollectionView.mj_header removeFromSuperview];
//                [strongSelf.liveCollectionView.mj_footer removeFromSuperview];
//            }else {
//                strongSelf.liveCollectionView.mj_header.hidden = NO;
//                strongSelf.liveCollectionView.mj_footer.hidden = NO;
//            }
            
            strongSelf.liveCollectionView.mj_footer.hidden = NO;
            strongSelf.liveCollectionView.mj_footer.state = MJRefreshStateIdle;
            //翻页到最后一页显示没有更多数据了
            if (strongSelf.dataArray.count == total) {
                if (strongSelf.dataArray.count > 10 ) {
                    strongSelf.liveCollectionView.mj_footer.state = MJRefreshStateNoMoreData;
                }else {
                    strongSelf.liveCollectionView.mj_footer.hidden = YES;
                }
            }

            if (strongSelf.liveCollectionView.mj_header.isRefreshing) {
                [strongSelf.liveCollectionView.mj_header endRefreshing];
            }
            if (strongSelf.liveCollectionView.mj_footer.isRefreshing) {
                [strongSelf.liveCollectionView.mj_footer endRefreshing];
            }
        }else {
            [EasyTextView showText:@"当前数据异常，请稍后再试"];
        }
        
    } failure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.liveCollectionView.mj_header.isRefreshing) {
            [strongSelf.liveCollectionView.mj_header endRefreshing];
        }
        if (strongSelf.liveCollectionView.mj_footer.isRefreshing) {
            [strongSelf.liveCollectionView.mj_footer endRefreshing];
        }
        
        if (strongSelf.dataArray.count == 0) {
            [DREmptyView showEmptyInView:strongSelf.view emptyType:DRNetworkErrorType refresh:^{
                [strongSelf.liveCollectionView.mj_header beginRefreshing];
            }];
        }
    }];
}

//请求子级分类列表
- (void)requestLiveChildrenList
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"id"] = [self getRequestType];
    
    __weak __typeof(self)weakSelf = self;
    [HttpRequest requestWithURLType:UrlTypeLiveChildrenList parameters:params type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code==200) {
            NSMutableArray *arr = responseObject[@"data"];
            NSMutableArray *rArray = [NSMutableArray arrayWithCapacity:arr.count + 1];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                LiveCategory *model = [LiveCategory modelWithDictionary:obj];
                [strongSelf.ctgArray addObject:model];
                [rArray addObject:model.ctgName];
            }];
            
            //第一条插入全部数据
            [rArray insertObject:@"全部" atIndex:0];
            
            [strongSelf.headerView setTitleArray:rArray];
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

//请求广告banner
- (void)requestBannerList
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"tabId"] = @"4";
    params[@"positionId"] = @"28";
    params[@"page"] = @"1";
    params[@"size"] = @"20";
    
    __weak __typeof(self)weakSelf = self;
    [HttpRequest requestWithURLType:UrlTypeHomeBanner parameters:params type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.liveCollectionView.mj_header.isRefreshing) {
            [strongSelf.liveCollectionView.mj_header endRefreshing];
        }
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code==200) {
            [strongSelf.bannerArray removeAllObjects];
            NSMutableArray *arr = responseObject[@"data"];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BannerModel *model = [BannerModel modelWithDictionary:obj];
                [strongSelf.bannerArray addObject:model];
            }];
            [strongSelf.liveCollectionView reloadData];
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.liveCollectionView.mj_header.isRefreshing) {
            [strongSelf.liveCollectionView.mj_header endRefreshing];
        }
    }];
}

//请求资讯信息
- (void)requestMarqueeList
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"1" forKey:@"page"];
    [params setObject:@"7" forKey:@"size"];
    __weak __typeof(self)weakSelf = self;
    [HttpRequest requestWithURLType:UTTypeGetNewsList parameters:params type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            [strongSelf.marqueeArray removeAllObjects];
            NSDictionary *data = responseObject[@"data"];
            NSArray *items = data[@"list"];
            for (NSDictionary *obj in items) {
                [strongSelf.marqueeArray addObject:obj[@"articleTitle"]];
            }
            [strongSelf.liveCollectionView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
    }];
}

//获取直播类型
- (NSString *)getRequestType
{
    //类型(-1=推荐,4=足球,5=篮球,2=电竞,3=综合)
    NSArray *typeArr = [NSArray arrayWithObjects:@"-1",@"4",@"5",@"2",@"3", nil];
    return [typeArr objectAtIndex:_selectIndex];
}

//广告跳转处理
- (void)bannerLinkJump:(BannerModel *)bannerModel
{
    if ([bannerModel.contentType integerValue] == 5) {
        //web链接跳转
        if ([bannerModel.openWay integerValue] == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:bannerModel.linkUrl]];
        }else {
            BAWebViewController *webVC = [BAWebViewController new];
            webVC.ba_web_progressTintColor = [UIColor cyanColor];
            webVC.ba_web_progressTrackTintColor = [UIColor whiteColor];
            [webVC ba_web_loadURLString:bannerModel.linkUrl];
            webVC.showTitle = YES;
            if ([bannerModel.atype isEqualToString:@"3"]) {
                //新闻
                webVC.navigationItem.title = @"新闻";
            }else if ([bannerModel.atype isEqualToString:@"2"]) {
                //活动
                webVC.navigationItem.title = @"活动";
            }else if ([bannerModel.atype isEqualToString:@"1"]) {
                //公告
                webVC.navigationItem.title = @"公告";
            }
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }
    else if ([bannerModel.contentType integerValue] == 1) {
        //直播
        LiveItem *item = [[LiveItem alloc] init];
        item.roomId = bannerModel.contentId;
        LiveRoomViewController *controller = [[LiveRoomViewController alloc] init];
        controller.liveItem = item;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if ([bannerModel.contentType integerValue] == 2) {
        //视频
        VideoItemModel *videoItem = [VideoItemModel new];
        videoItem.videoId = bannerModel.contentId;
        VideoInformationController *vc = [VideoInformationController new];
        vc.itemModel = videoItem;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([bannerModel.contentType integerValue] == 4) {
        //资讯详情
        BAWebViewController *webVC = [BAWebViewController new];
        webVC.ba_web_progressTintColor = [UIColor lightGrayColor];
        webVC.ba_web_progressTrackTintColor = [UIColor whiteColor];
        [webVC ba_web_loadURLString:bannerModel.mobileLinkUrl];
        webVC.showTitle = YES;
        if ([bannerModel.atype isEqualToString:@"3"]) {
            //新闻
            webVC.navigationItem.title = @"新闻";
        }else if ([bannerModel.atype isEqualToString:@"2"]) {
            //活动
            webVC.navigationItem.title = @"活动";
        }else if ([bannerModel.atype isEqualToString:@"1"]) {
            //公告
            webVC.navigationItem.title = @"公告";
        }
        [self.navigationController pushViewController:webVC animated:YES];
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
    
    CGFloat liveTitleH = 30.0;      //直播标题高
    CGFloat ratio = 16/9.0;         //封面图宽高比
    CGFloat cellWidth = ([UIScreen mainScreen].bounds.size.width - interSpacing - 2*marginLeftRight) * 0.5;
    CGFloat cellHeight = cellWidth / ratio + liveTitleH;
//    NSLog(@"宽：%f 高：%f",cellWidth,cellWidth / ratio);
    return CGSizeMake(cellWidth, cellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets insets = UIEdgeInsetsMake(marginLeftRight, marginLeftRight, 15, marginLeftRight);
    return insets;
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return lineSpacing;
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return interSpacing;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //创建item / 从缓存池中拿 Item
    LiveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LiveCollectionViewCell" forIndexPath:indexPath];
    
    LiveItem *item = self.dataArray[indexPath.item];
    [cell setCellItem:item];
    
    return cell;

}

// 要先设置表头大小
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (_selectIndex == 0 && self.bannerArray.count) {
        CGFloat ratio = 365.0/120.0;         //广告view宽高比
        CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width - 2*marginLeftRight;
        CGFloat cellHeight = cellWidth / ratio + 12 + 20;
        CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, cellHeight);
        return size;
        
    }
    if (_selectIndex == 0 && self.marqueeArray.count) {
        CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 20 + 12);
        return size;
        
    }
    return CGSizeMake(0, 0);
}
 
// 创建一个继承collectionReusableView的类,用法类比tableViewcell
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (_selectIndex == 0) {
        UICollectionReusableView *reusableView = nil;
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            // 头部视图
            [collectionView registerClass:[LiveBannerHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LiveBannerHeaderView"];
            LiveBannerHeaderView *tempHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LiveBannerHeaderView" forIndexPath:indexPath];
            if (self.bannerArray.count) {
                tempHeaderView.dataArray = self.bannerArray;
            }
            if (self.marqueeArray.count) {
                tempHeaderView.marqueeArray = self.marqueeArray;
            }
            __weak __typeof(self)weakSelf = self;
            tempHeaderView.selectedItemHelper = ^(NSUInteger index) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                
                BannerModel *bannerModel = strongSelf.bannerArray[index];
                if (bannerModel.linkUrl && bannerModel.linkUrl.length) {
                    [strongSelf bannerLinkJump:bannerModel];
                }
            };
            tempHeaderView.selectedMarquee = ^{
                NewsController *vc = [NewsController new];
                [self.navigationController pushViewController:vc animated:YES];
            };
            reusableView = tempHeaderView;
            
        } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
            // 底部视图
        }
        return reusableView;
    }
    
    return nil;
}

#pragma mark - 点击 某个Item时 调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];//取消选中
    
    [[DRSmallDragView smallDragViewManager] closeSmallView];

    LiveItem *item = self.dataArray[indexPath.item];
    LiveRoomViewController *controller = [[LiveRoomViewController alloc] init];
    controller.liveItem = item;
    [self.navigationController pushViewController:controller animated:YES];
    
    
//    MatchLiveRoomViewController *controller = [[MatchLiveRoomViewController alloc] init];
//    [self.navigationController pushViewController:controller animated:YES];
}

@end
