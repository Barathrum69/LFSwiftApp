//
//  VideoViewController.m
//  DragonLive
//
//  Created by 11号 on 2020/11/25.
//

#import "VideoListController.h"
#import "VideoListView.h"
#import "VideoInformationController.h"
#import "VideoProxy.h"
#import "DRSearchViewController.h"
#import "AnchorCenterController.h"
#import "ApplyAnchorController.h"


@interface VideoListController ()

/// 列表
@property (nonatomic, strong) VideoListView * videoListView;

/// title数组
@property (nonatomic, strong) NSMutableArray *sectionArray;
@end

@implementation VideoListController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.segmentedPageViewController showInViewController:self];
//    self.navigationItem.title = @"视频";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = [self navTitleView];
    
    [self initVideoListView];
    [self initSegmentData];
    // Do any additional setup after loading the view from its nib.
}
//WithSectionTitles:@[@"全部", @"足球",@"篮球", @"电竞",@"综合"]

-(void)initVideoListView
{
    kWeakSelf(self);
    _videoListView = [[VideoListView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTopHeight-kTabBarHeight)];
    [self.view addSubview:_videoListView];
    
    //点击事件
    _videoListView.videoListItemDidSelectBlock = ^(VideoItemModel * _Nonnull model) {
        VideoInformationController *vc = [VideoInformationController new];
        vc.itemModel = model;
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    
    //第一次页面构建完成后请求加载的Block
    _videoListView.videoListFirstRequest = ^(NSInteger page, NSInteger selectedSegmentIndex) {
        [STTextHudTool showWaitText:@"加载中..."view:weakself.view];
        [weakself loadListRequestWithCtgName:weakself.sectionArray[selectedSegmentIndex] page:page itemType:selectedSegmentIndex];
    };
    //下啦刷新
    _videoListView.headerRefreshBlock = ^(NSInteger page, NSInteger selectedSegmentIndex) {
        [weakself loadListRequestWithCtgName:weakself.sectionArray[selectedSegmentIndex] page:page itemType:selectedSegmentIndex];
    };
    //上啦加载更多
    _videoListView.footerRefreshBlock = ^(NSInteger page, NSInteger selectedSegmentIndex) {
        [weakself loadListRequestWithCtgName:weakself.sectionArray[selectedSegmentIndex] page:page itemType:selectedSegmentIndex];
    };
    
}//加载view


-(void)loadListRequestWithCtgName:(NSString *)ctgName page:(NSInteger )page itemType:(VideoListType)type
{
    
    [VideoProxy getCategoryOfVideoListWithCtgName:ctgName page:page itemType:type success:^(VideoModel * _Nonnull obj) {
        self.videoListView.itemModel = obj;
        [STTextHudTool hideSTHud];
        [DREmptyView hiddenEmptyInView:[self.videoListView getCurrtView]];
    } failure:^(NSError * _Nonnull error) {
        [STTextHudTool hideSTHud];
        [self.videoListView headerFooterEnd];

        if ([self.videoListView getCurrtDataArray].count == 0) {
            [DREmptyView showEmptyInView:[self.videoListView getCurrtView] emptyType:DRNetworkErrorType refresh:^{
                
                [self.videoListView currtPageRefrash];
            }];
        }
        
       
    }];
}//请求


#pragma mark - 数据 赋值 处理等等..
-(void)initSegmentData
{
    _sectionArray = [NSMutableArray arrayWithObjects:@"热门", @"足球",@"篮球", @"电竞",@"综合", nil];
    self.videoListView.sectionTitles = _sectionArray;
    
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

- (UIView *)navTitleView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    
    UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 2, 84, 28)];
    logoImgView.image = [UIImage imageNamed:@"home_logo"];
    [titleView addSubview:logoImgView];
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(103, 0, [UIScreen mainScreen].bounds.size.width-103-50, 30)];
    searchView.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    searchView.layer.cornerRadius = 14.0f;
    searchView.layer.masksToBounds = YES;
    [titleView addSubview:searchView];
    
    UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 5, 20, 20)];
    iconImgView.image = [UIImage imageNamed:@"icon_search"];
    [searchView addSubview:iconImgView];
    
    UILabel *noticeLab = [[UILabel alloc] initWithFrame:CGRectMake(39, 0, 130, 30)];
    noticeLab.font = [UIFont systemFontOfSize:13];
    noticeLab.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.5];
    noticeLab.text = @"搜索主播/直播/视频";
    [searchView addSubview:noticeLab];
    
    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(searchView.frame), 30)];
    [but addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:but];
    
    UIButton *playBut = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchView.frame)+5, -4, 30, 30)];
    [playBut setImage:[UIImage imageNamed:@"home_playBut"] forState:UIControlStateNormal];
    [playBut addTarget:self action:@selector(playButAction) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:playBut];
    
    UILabel *playLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(playBut.frame), 23, 30, 10)];
    playLab.font = [UIFont systemFontOfSize:8];
    playLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    playLab.text = @"开播";
    playLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:playLab];
    
    return titleView;
}

- (void)searchAction
{
    DRSearchViewController *controller = [[DRSearchViewController alloc] init];
    [self.navigationController pushViewController:controller animated:NO];
}

- (void)playButAction
{
    if (![[UserInstance shareInstance]isLogin]) {
        [UntilTools pushLoginPage];
        return;
    }
    
    NSLog(@"%@",[UserInstance shareInstance].userModel.hostApplyResult);
    if ([[UserInstance shareInstance].userModel.userType isEqualToString:@"2"]) {
        //说明已经是主播了.
        AnchorCenterController  *vc = [AnchorCenterController new];
        vc.userId = [UserInstance shareInstance].userId;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ApplyAnchorController *vc = [ApplyAnchorController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
