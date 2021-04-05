//
//  HomeViewController.m
//  DragonLive
//
//  Created by 11号 on 2020/11/25.
//

#import "HomeViewController.h"
#import "YJPageControlView.h"
#import "HomeLiveViewController.h"
#import "DRSearchViewController.h"
#import "AnchorCenterController.h"
#import "ApplyAnchorController.h"
#import "MineProxy.h"
#import "TaskModel.h"
#import "UserTaskInstance.h"
#import "HGSegmentedPageViewController.h"

@interface HomeViewController ()<YJPageControlViewDelegate>

@property (nonatomic, strong) YJPageControlView *segmentedPageViewController;
@property (nonatomic, strong) HGSegmentedPageViewController *pageViewController;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.navigationItem.titleView = [self navTitleView];
//    [self.segmentedPageViewController showInViewController:self];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //获取任务
    if ([[UserInstance shareInstance]isLogin]) {
        [self requestTastList];
    }
    
    [self getXmppServer];
    [self getTaskInfo];
}

- (HGSegmentedPageViewController *)pageViewController {
    if (!_pageViewController) {
        NSMutableArray *controllers = [NSMutableArray array];
        NSArray *titles = @[@"推荐", @"足球",@"篮球", @"电竞",@"综合"];
        for (int i = 0; i < titles.count; i++) {
            HomeLiveViewController *controller = [[HomeLiveViewController alloc] init];
            controller.selectIndex = i;
            [controllers addObject:controller];
        }
        _pageViewController = [[HGSegmentedPageViewController alloc] init];
        _pageViewController.pageViewControllers = controllers.copy;
        _pageViewController.categoryView.bottomMargin = 4;
        _pageViewController.categoryView.isFullScreen = YES;
        _pageViewController.categoryView.titles = titles;
        _pageViewController.categoryView.originalIndex = 0;
    }
    return _pageViewController;
}

//获取任务
- (void)requestTastList
{
    [MineProxy getTaskListWithPage:1 success:^(NSMutableArray * _Nonnull obj) {
        
        for (TaskModel *model in obj) {
            NSInteger taskType = [model.taskType integerValue];
            NSInteger currentType = [model.currentType integerValue];
            if (taskType == 1) {
                [UserTaskInstance shareInstance].shareStatus = currentType;
                [[NSUserDefaults standardUserDefaults] setInteger:currentType forKey:kkLiveShareStatus];
            }else if (taskType == 2) {
                [UserTaskInstance shareInstance].livePlayStatus = currentType;
                [[NSUserDefaults standardUserDefaults] setInteger:currentType forKey:kkLivePlayStatus];
            }else if (taskType == 3) {
                [UserTaskInstance shareInstance].barrageStatus = currentType;
                [[NSUserDefaults standardUserDefaults] setInteger:currentType forKey:kkBarrageSendStatus];
            }else if (taskType == 4) {
                [UserTaskInstance shareInstance].giftStatus = currentType;
            }

        }
    } failure:^(NSError * _Nonnull error) {
    }];
}

//获取上次任务完成情况
- (void)getTaskInfo
{
    if ([UserInstance shareInstance].isLogin) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [UserTaskInstance shareInstance].shareCount = [[userDefaults objectForKey:kkLiveShareCount] integerValue];
        [UserTaskInstance shareInstance].livePlayTime = [[userDefaults objectForKey:kkLivePlayTimes] integerValue];
        [UserTaskInstance shareInstance].barrageCount = [[userDefaults objectForKey:kkBarrageSendCount] integerValue];
    }
}

//获取xmppserver
- (void)getXmppServer
{
    
    __weak __typeof(self)weakSelf = self;
    [HttpRequest requestWithURLType:UrlTypeXMPPServer parameters:[NSDictionary dictionaryWithObject:@"true" forKey:@"flag"] type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code==200) {
            [UserInstance shareInstance].xmppServerAddress = responseObject[@"data"];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"] forKey:kkXmppServerAddress];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark Getters
- (YJPageControlView *)segmentedPageViewController {
    if (!_segmentedPageViewController) {
        NSMutableArray *controllers = [NSMutableArray array];
        NSArray *titles = @[@"推荐", @"足球",@"篮球", @"电竞",@"综合"];
        for (int i = 0; i < titles.count; i++) {
            HomeLiveViewController *controller = [[HomeLiveViewController alloc] init];
            controller.selectIndex = i;
            [controllers addObject:controller];
        }
        _segmentedPageViewController = [[YJPageControlView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kMainViewHeight) Titles:titles viewControllers:controllers Selectindex:0];
        _segmentedPageViewController.delegate = self;
    }
    return _segmentedPageViewController;
}

/**
 * 切换位置后的代理方法
 */
- (void)SelectAtIndex:(NSInteger)index controller:(UIViewController *)controller
{
//    HomeLiveViewController *homeControl = (HomeLiveViewController *)controller;
//    [homeControl selectedLiveType:index];
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
