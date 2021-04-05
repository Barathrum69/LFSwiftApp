//
//  MatchViewController.m
//  DragonLive
//
//  Created by 11号 on 2020/11/25.
//

#import "MatchViewController.h"
#import "MLMSegmentHead.h"
#import "MatchView.h"
#import "MatchProxy.h"
#import "MatchCtgModel.h"
#import "MatchItemModel.h"
#import "LiveItem.h"
#import "LiveRoomViewController.h"
#import "MatchTableView.h"
#import "DKBottomView.h"
#import "HostModel.h"
@interface MatchViewController ()<MLMSegmentHeadDelegate,UIScrollViewDelegate,DKBottomViewDelegate>

///nav titleView
@property (nonatomic, strong) MLMSegmentHead *segHead;

//头部数组
@property (nonatomic, strong) NSArray *headlist;

//scrollView
@property (nonatomic, strong) UIScrollView *scrollView;

/// 足球
@property (nonatomic, strong) MatchView *footBallView;

/// 篮球
@property (nonatomic, strong) MatchView *basketBallView;

/// 电竞
@property (nonatomic, strong) MatchView *gamingBallView;

/// 足球的seg模型数组
@property (nonatomic, strong) NSMutableArray *footModelArray;

/// 篮球的seg模型数组
@property (nonatomic, strong) NSMutableArray *basketModelArray;

/// 电竞的seg模型数组
@property (nonatomic, strong) NSMutableArray *gamingModelArray;

@end

@implementation MatchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = The_MainColor;
    [self initNavigationItem];
    [self initScrollView];
    [self initFootBallView];
    [self initBasketBallView];
    [self initGamingView];
    [self loadSegRequestWithIndex:0];
    
    // Do any additional setup after loading the view from its nib.
}//viewdidload


-(void)loadSegRequestWithIndex:(NSInteger)index
{

    kWeakSelf(self);
    if (index == 0) {
        //足球
        if (!_footModelArray) {
            [STTextHudTool showWaitText:@"加载中..."view:self.view];

            [self loadSegRequestWithType:2 success:^(NSMutableArray *obj) {
                weakself.footModelArray = obj;
                weakself.footBallView.sectionTitles = [self getSectionArrayWithModelArray:obj];
                MatchCtgModel *model = [obj firstObject];
//                kStrongSelf(weakself);
                [weakself loadMatchListWithPage:1 ctgId:model.ctgId success:^(NSMutableArray *obj) {
                    weakself.footBallView.dataArray = obj;
                    [STTextHudTool hideSTHud];

                }];
            }];
        }
    }else if(index == 1){
        //篮球
        if (!_basketModelArray) {
            [STTextHudTool showWaitText:@"加载中..."view:self.view];

            [self loadSegRequestWithType:1 success:^(NSMutableArray *obj) {
                weakself.basketModelArray = obj;
                weakself.basketBallView.sectionTitles = [self getSectionArrayWithModelArray:obj];
                MatchCtgModel *model = [obj firstObject];
                [weakself loadMatchListWithPage:1 ctgId:model.ctgId success:^(NSMutableArray *obj) {
                    weakself.basketBallView.dataArray = obj;
                    [STTextHudTool hideSTHud];

                }];
            }];
        }
    }else if (index == 2){
        //电竞
        if (!_gamingModelArray) {
            [STTextHudTool showWaitText:@"加载中..."view:self.view];
            [self loadSegRequestWithType:3 success:^(NSMutableArray *obj) {
                weakself.gamingModelArray = obj;
                weakself.gamingBallView.sectionTitles = [self getSectionArrayWithModelArray:obj];
                MatchCtgModel *model = [obj firstObject];
                [weakself loadMatchListWithPage:1 ctgId:model.ctgId success:^(NSMutableArray *obj) {
                    weakself.gamingBallView.dataArray = obj;
                    [STTextHudTool hideSTHud];
                }];
            }];
        }
    }
}//请求分类下的标签 第一次进来的时候 进行的请求

-(void)loadMatchListWithPage:(NSInteger)page ctgId:(NSString *)ctgId success:(void (^)(NSMutableArray *obj))success
{
    [MatchProxy getMatchListWithPage:page ctgId:ctgId success:^(NSMutableArray * _Nonnull obj) {
        success(obj);
        
    } failure:^(NSError * _Nonnull error) {
        [self endRefresh];
        [STTextHudTool hideSTHud];

    }];
}//请求

-(void)endRefresh
{
    [self.footBallView headerFooterEnd];
    [self.basketBallView headerFooterEnd];
    [self.gamingBallView headerFooterEnd];
}//结束刷新

-(NSMutableArray *)getSectionArrayWithModelArray:(NSMutableArray *)array
{
    NSMutableArray *dataArray = [NSMutableArray new];
    for (MatchCtgModel *obj in array) {
        [dataArray addObject:obj.ctgName];
    }
    return dataArray;
}//根据ModelArray去组合一个新的array 然后返回一个新的数组

-(void)loadSegRequestWithType:(NSInteger)type success:(void (^)(NSMutableArray *obj))success
{
    [MatchProxy getGameTypeListWithType:type success:^(NSMutableArray * _Nonnull obj) {
        [self removeWithType:type];
        success(obj);
    } failure:^(NSError * _Nonnull error) {
        [self addMaskViewWithType:type];
    }];
    
}//请求分类下的标签的request


-(void)addMaskViewWithType:(NSInteger)type{
    if (type == 4) {
        //足球
        if (_footBallView.dataArray == 0&&_footModelArray.count == 0) {
            [DREmptyView showEmptyInView:_footBallView.matchTableView emptyType:DRNetworkErrorType refresh:^{
                [self loadSegRequestWithIndex:0];
            }];
        }
        
    }else if (type == 5){
        //篮球
        if (_basketBallView.dataArray == 0&&_basketModelArray.count == 0) {
            [DREmptyView showEmptyInView:_basketBallView.matchTableView emptyType:DRNetworkErrorType refresh:^{
                [self loadSegRequestWithIndex:1];
            }];
        }
    }else if (type == 2){
        //电竞
        if (_gamingBallView.dataArray == 0&&_gamingModelArray.count == 0) {
            [DREmptyView showEmptyInView:_gamingBallView.matchTableView emptyType:DRNetworkErrorType refresh:^{
                [self loadSegRequestWithIndex:2];
            }];
        }
    }
}//网络不好的时候 执行。

-(void)removeWithType:(NSInteger)type{
    if (type == 4) {
        //足球
        [DREmptyView hiddenEmptyInView:_footBallView.matchTableView];
    }else if (type == 5){
        //篮球
        [DREmptyView hiddenEmptyInView:_basketBallView.matchTableView];
    }else if (type == 2){
        //电竞
        [DREmptyView hiddenEmptyInView:_gamingBallView.matchTableView];
    }
}




#pragma mark - nav
-(void)initNavigationItem
{
    self.headlist = @[@"足球",@"篮球",@"电竞"];
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, 200, 30) titles:self.headlist headStyle:SegmentHeadStyleSlide layoutStyle:MLMSegmentLayoutDefault];
    _segHead.delegate = self;
    _segHead.fontSize = (15);
    _segHead.slideColor = [UIColor clearColor];
    _segHead.headColor = [UIColor whiteColor];
     //  选中颜色
    _segHead.selectColor = [UIColor whiteColor];
    //未选中颜色
    _segHead.deSelectColor = [UIColor blackColor];
    [_segHead defaultAndCreateView];
    self.navigationItem.titleView = _segHead;
}//nav

-(void)initScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kMainViewHeight)];
//    self.scrollView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    self.scrollView.pagingEnabled = YES;
//    self.scrollView.scrollEnabled = NO;
//    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth*3, kMainViewHeight);
//    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, kMainViewHeight) animated:NO];
    [self.view addSubview:self.scrollView];
}//外部的scrollView

-(void)initFootBallView
{
    kWeakSelf(self);
    _footBallView = [[MatchView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kMainViewHeight)];
    [_scrollView addSubview:_footBallView];

    //上下拉请求
    _footBallView.matchHeaderRefreshBlock = ^(NSInteger page, NSInteger selectedSegmentIndex) {
        MatchCtgModel *model = weakself.footModelArray[selectedSegmentIndex];
        [weakself loadMatchListWithPage:page ctgId:model.ctgId success:^(NSMutableArray *obj) {
            weakself.footBallView.dataArray = obj;
            [weakself endRefresh];
        }];
    };
    _footBallView.matchFooterRefreshBlock = ^(NSInteger page, NSInteger selectedSegmentIndex) {
        MatchCtgModel *model = weakself.footModelArray[selectedSegmentIndex];
        [weakself loadMatchListWithPage:page ctgId:model.ctgId success:^(NSMutableArray *obj) {
            weakself.footBallView.dataArray = obj;
            [weakself endRefresh];
        }];
    };
    
    //点击事件
    _footBallView.matchItemDidSelected = ^(MatchItemModel * _Nonnull model) {
        [weakself pushNextPageWithModel:model];
    };
    
    
}//加载足球View

-(void)initBasketBallView
{
    kWeakSelf(self);
    _basketBallView = [[MatchView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kMainViewHeight)];
    [_scrollView addSubview:_basketBallView];
//    _basketBallView.sectionTitles = [NSMutableArray arrayWithObjects:@"篮球1",@"篮球2",@"篮球3",@"篮球4",@"篮球5",@"篮球6",@"篮球7",nil];
    //上下拉请求
    _basketBallView.matchHeaderRefreshBlock = ^(NSInteger page, NSInteger selectedSegmentIndex) {
        MatchCtgModel *model = weakself.basketModelArray[selectedSegmentIndex];
        [weakself loadMatchListWithPage:page ctgId:model.ctgId success:^(NSMutableArray *obj) {
            weakself.basketBallView.dataArray = obj;
            [weakself endRefresh];
        }];
    };
    _basketBallView.matchFooterRefreshBlock = ^(NSInteger page, NSInteger selectedSegmentIndex) {
        MatchCtgModel *model = weakself.basketModelArray[selectedSegmentIndex];
        [weakself loadMatchListWithPage:page ctgId:model.ctgId success:^(NSMutableArray *obj) {
            weakself.basketBallView.dataArray = obj;
            [weakself endRefresh];
        }];
    };
    
    //点击事件
    _basketBallView.matchItemDidSelected = ^(MatchItemModel * _Nonnull model) {
        [weakself pushNextPageWithModel:model];
    };
    
}//加载蓝球View

-(void)initGamingView
{
    kWeakSelf(self);
    _gamingBallView = [[MatchView alloc]initWithFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth, kMainViewHeight)];
    [_scrollView addSubview:_gamingBallView];
//    _gamingBallView.sectionTitles = [NSMutableArray arrayWithObjects:@"电竞1",@"电竞2",@"电竞3",@"电竞4",@"电竞5",@"电竞6",@"电竞7",@"电竞8",nil];
    //上下拉请求
    _gamingBallView.matchHeaderRefreshBlock = ^(NSInteger page, NSInteger selectedSegmentIndex) {
        MatchCtgModel *model = weakself.gamingModelArray[selectedSegmentIndex];
        [weakself loadMatchListWithPage:page ctgId:model.ctgId success:^(NSMutableArray *obj) {
            weakself.gamingBallView.dataArray = obj;
            [weakself endRefresh];
        }];
    };
    _gamingBallView.matchFooterRefreshBlock = ^(NSInteger page, NSInteger selectedSegmentIndex) {
        MatchCtgModel *model = weakself.gamingModelArray[selectedSegmentIndex];
        [weakself loadMatchListWithPage:page ctgId:model.ctgId success:^(NSMutableArray *obj) {
            weakself.gamingBallView.dataArray = obj;
            [weakself endRefresh];
        }];
    };
    
    //点击事件
    _gamingBallView.matchItemDidSelected = ^(MatchItemModel * _Nonnull model) {
        [weakself pushNextPageWithModel:model];
    };
}//加载电竞View


-(void)pushNextPageWithModel:(MatchItemModel *)model
{
 
//        if ([model.forward isEqualToString:@"0"]) {
            if (model.refHosts.count != 0 && model.refHosts.count > 1) {
                [DKBottomView showWithParams:model.refHosts delegate:self];
            }else{
                if (model.refHosts.count != 0) {
                    HostModel *hostModel = model.refHosts[0];
                    
                    if ([hostModel.hostType isEqualToString:@"2"]) {
                        //官方频道
                        LiveRoomViewController *controller = [[LiveRoomViewController alloc] init];
                        controller.matchItem = hostModel;
                        [self.navigationController pushViewController:controller animated:YES];
                    }else{
                    
                        if (![hostModel.roomId isEqualToString:@"0"]&&hostModel.roomId.length != 0) {
                            LiveItem *lvItem = [[LiveItem alloc] init];
                            lvItem.roomId = hostModel.roomId;
                            LiveRoomViewController *controller = [[LiveRoomViewController alloc] init];
                            controller.liveItem = lvItem;
                            [self.navigationController pushViewController:controller animated:YES];
                        }
                    }
                }
            }
//        }else{
////            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.baidu.com"]];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.url]];
//        }
    
}//这里进行跳转操作


-(void)hostTableViewDidSelected:(HostModel *)model
{
//    if (model.statusOfLive) {
    if ([model.hostType isEqualToString:@"2"]) {
        //官方频道
        LiveRoomViewController *controller = [[LiveRoomViewController alloc] init];
        controller.matchItem = model;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        if (![model.roomId isEqualToString:@"0"]&&model.roomId.length != 0) {
            LiveItem *lvItem = [[LiveItem alloc] init];
            lvItem.roomId = model.roomId;
            LiveRoomViewController *controller = [[LiveRoomViewController alloc] init];
            controller.liveItem = lvItem;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
//    }
}

#pragma mark MLMSegmentHead delegate
- (void)didSelectedIndex:(NSInteger)index
{
    [self loadSegRequestWithIndex:index];
    [self.scrollView scrollRectToVisible:CGRectMake(kScreenWidth * index, 0, kScreenWidth, self.scrollView.frame.size.height) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [_segHead changeSelectIndexPage:page];
//    self.selectedSegmentIndex = page;
//        [self addContentView];
    
}//减速结束了

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
