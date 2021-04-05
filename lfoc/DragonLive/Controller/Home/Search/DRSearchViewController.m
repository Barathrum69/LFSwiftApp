//
//  DRSearchViewController.m
//  DragonLive
//
//  Created by 11号 on 2020/12/15.
//

#import "DRSearchViewController.h"
#import "DRSearchHistoryView.h"
#import "DRKeywordsViewController.h"
#import "DRSearchBar.h"
#import "DRSearchAllViewController.h"
#import "DRSearchStreamViewController.h"
#import "DRSearchLiveViewController.h"
#import "DRSearchVideoViewController.h"
#import "HGSegmentedPageViewController.h"
#import "HttpRequest.h"
#import "SearchViewModel.h"
#import "SearchAllModel.h"

@interface DRSearchViewController ()<DRSearchViewDelegate,HGSegmentedPageViewControllerDelegate,SearchViewModelDelegate>

@property (nonatomic, strong) HGSegmentedPageViewController *pageViewController;
@property (nonatomic, strong) DRSearchBar *searchBarView;
@property (nonatomic, strong) DRSearchHistoryView *historyView;
@property (nonatomic, strong) DRKeywordsViewController *keywordsVC;
@property (nonatomic, strong) SearchViewModel *searchViewModel;

@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) NSArray *controllerArray;

@end

@implementation DRSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:self.searchBarView];
    
    _searchViewModel = [[SearchViewModel alloc] initWithDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!_pageViewController) {
        [self.searchBarView becomeFirstResponder];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 回收键盘
    [self.searchBarView resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //判断当前controller是否被pop
    NSUInteger isPop = [[self.navigationController viewControllers] indexOfObject:self];
    if (isPop == 0) {
        [self.searchBarView removeFromSuperview];
        if (_keywordsVC) {
            [_keywordsVC removeFromParentViewController];
        }
        if (_pageViewController) {
            [_pageViewController removeFromParentViewController];
        }
    }
}

- (void)pushToSearchResultWithSearchStr:(NSString *)str
{
    //如果重新搜索分类选择为全部
    if (self.pageViewController.selectedIndex != 0) {
        [self.pageViewController resetSelectIndex:0];
    }
    
    //重新搜索清除历史搜索数据
    if (_controllerArray.count) {
        UIViewController *controller = [_controllerArray objectAtIndex:0];
        DRSearchAllViewController *allController = (DRSearchAllViewController *)controller;
        [allController clearSearchHistory];
        [_searchViewModel clearHistory];
    }
    
    self.searchBarView.text = str;
    [self.searchBarView resignFirstResponder];
    [self setHistoryArrWithStr:str];
    
    [self.searchViewModel searchRequestWithKeyword:str];
    [self.view bringSubviewToFront:self.pageViewController.view];
}

//刷新切换controller的数据
- (void)reloadSearchData:(NSInteger)index
{
     UIViewController *controller = [_controllerArray objectAtIndex:index];
    if (index == 1) {
        DRSearchStreamViewController *hostController = (DRSearchStreamViewController *)controller;
        [hostController reloadHostData:_searchViewModel.hostArray];
    }
    else if (index == 2) {
        DRSearchLiveViewController *liveController = (DRSearchLiveViewController *)controller;
        [liveController reloadLiveData:_searchViewModel.liveArray];
    }
    else if (index == 3) {
        DRSearchVideoViewController *videoController = (DRSearchVideoViewController *)controller;
        [videoController reloadVideoData:_searchViewModel.videoArray];
    }
}

- (void)setHistoryArrWithStr:(NSString *)str
{
    for (int i = 0; i < _historyArray.count; i++) {
        if ([_historyArray[i] isEqualToString:str]) {
            [_historyArray removeObjectAtIndex:i];
            break;
        }
    }
    [_historyArray insertObject:str atIndex:0];
    [NSKeyedArchiver archiveRootObject:_historyArray toFile:KHistorySearchPath];
    
    [self.historyView reloadHistoryView];
}

//判断跳转到哪个类目
- (NSInteger)getPageIndexInSection:(NSInteger)section
{
    SearchAllModel *allModel = [_searchViewModel.allArray objectAtIndex:section];
    if ([allModel.resultTitle isEqualToString:@"相关主播"]) {
        return 1;
    }else if ([allModel.resultTitle isEqualToString:@"相关直播"]) {
        return 2;
    }
    return 3;
}

#pragma mark -网络请求delegate
- (void)requestSearchHotwordsFinish:(nullable NSError *)error
{
    [self.view addSubview:self.historyView];
}

- (void)requestSearchAllFinish:(nullable NSError *)error
{
    UIViewController *controller = [_controllerArray objectAtIndex:_pageViewController.selectedIndex];
    DRSearchAllViewController *allController = (DRSearchAllViewController *)controller;
    allController.searchKey = _searchBarView.text;
    [allController reloadData:_searchViewModel.allArray];
//    [allController reloadData:_searchViewModel.hostArray lvArray:_searchViewModel.liveArray vdArray:_searchViewModel.videoArray];
}

- (void)requestSearchHostsFinish:(nullable NSError *)error
{
    [self reloadSearchData:1];
}

- (void)requestSearchLivesFinish:(nullable NSError *)error
{
    [self reloadSearchData:2];
}

- (void)requestSearchVideosFinish:(nullable NSError *)error
{
    [self reloadSearchData:3];
}

- (void)segmentedPageViewControllerDidEndDeceleratingWithPageIndex:(NSInteger)index
{
    [self reloadSearchData:index];
}

#pragma mark - DRSearchViewDelegate -
- (void)searchBar:(DRSearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text == nil || [searchBar.text length] <= 0) {
//        self.keywordsVC.view.hidden = YES;
        [self.view bringSubviewToFront:self.historyView];
    } else {
//        self.keywordsVC.view.hidden = NO;
        [self.view bringSubviewToFront:self.keywordsVC.view];
        [_keywordsVC searchTestChangeWithTest:searchBar.text];
    }
}

- (void)searchBarSearchButtonClicked:(DRSearchBar *)searchBar{

    [self pushToSearchResultWithSearchStr:searchBar.text];
    
}

- (void)searchBarCancelButtonClicked:(DRSearchBar *)searchBar{

    [self.searchBarView resignFirstResponder];
    [self.searchBarView removeFromSuperview];
    if (_keywordsVC) {
        [_keywordsVC removeFromParentViewController];
    }
    if (_pageViewController) {
        [_pageViewController removeFromParentViewController];
    }
    [self.navigationController popViewControllerAnimated:NO];
    
}

#pragma mark - 懒加载
- (NSMutableArray *)historyArray
{
    if (!_historyArray) {
        _historyArray = [NSKeyedUnarchiver unarchiveObjectWithFile:KHistorySearchPath];
        if (!_historyArray) {
            self.historyArray = [NSMutableArray array];
        }
    }
    return _historyArray;
}

- (DRSearchBar *)searchBarView
{
    if (!_searchBarView) {
        _searchBarView = [[DRSearchBar alloc]initWithFrame:CGRectMake(0, 7, self.view.frame.size.width, 30)];
        _searchBarView.delegate = self;
        _searchBarView.placeholder = @"搜索主播/直播/视频";
    }
    return _searchBarView;
}

- (DRSearchHistoryView *)historyView
{
    if (!_historyView) {
        _historyView = [[DRSearchHistoryView alloc] initWithFrame:CGRectMake(0, 0, kkScreenWidth, kkScreenHeight - kNavBarAndStatusBarHeight) hotArray:self.searchViewModel.hotArray historyArray:self.historyArray];
        __weak __typeof(self)weakSelf = self;
        _historyView.tapAction = ^(NSString *str) {
            [weakSelf pushToSearchResultWithSearchStr:str];
        };
    }
    return _historyView;
}

- (DRKeywordsViewController *)keywordsVC
{
    if (!_keywordsVC) {
        _keywordsVC = [[DRKeywordsViewController alloc] init];
        
        [self addChildViewController:_keywordsVC];
        [self.view addSubview:_keywordsVC.view];
        [_keywordsVC didMoveToParentViewController:self];
        _keywordsVC.view.frame = CGRectMake(0, 0, kkScreenWidth, kkScreenHeight - kNavBarAndStatusBarHeight);
        
        __weak __typeof(self)weakSelf = self;
        _keywordsVC.wordsSelectBlock = ^(NSString *searchTest) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf pushToSearchResultWithSearchStr:searchTest];
        };
        _keywordsVC.scrollBlock = ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.searchBarView resignFirstResponder];
        };
    }
    return _keywordsVC;
}

- (HGSegmentedPageViewController *)pageViewController {
    if (!_pageViewController) {
        NSArray *titles = @[@"全部", @"主播", @"直播",@"视频"];
        DRSearchAllViewController *allController = [[DRSearchAllViewController alloc] init];
        __weak __typeof(self)weakSelf = self;
        allController.tapActionBlock = ^(NSInteger index) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.pageViewController resetSelectIndex:[self getPageIndexInSection:index]];
            [strongSelf reloadSearchData:[self getPageIndexInSection:index]];
        };
        DRSearchStreamViewController *streamerController = [[DRSearchStreamViewController alloc] init];
        streamerController.footerLoadBlock = ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.searchViewModel hostRequestMore];
        };
        DRSearchLiveViewController *liveController = [[DRSearchLiveViewController alloc] init];
        liveController.footerLoadBlock = ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.searchViewModel liveRequestMore];
        };
        DRSearchVideoViewController *videoController = [[DRSearchVideoViewController alloc] init];
        videoController.footerLoadBlock = ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.searchViewModel videoRequestMore];
        };
        _controllerArray = [NSArray arrayWithObjects:allController,streamerController,liveController,videoController, nil];
        _pageViewController = [[HGSegmentedPageViewController alloc] init];
        _pageViewController.delegate = self;
        _pageViewController.pageViewControllers = _controllerArray.copy;
        _pageViewController.categoryView.titles = titles;
        
        [self addChildViewController:_pageViewController];
        [self.view addSubview:_pageViewController.view];
        [_pageViewController didMoveToParentViewController:self];
        _pageViewController.view.frame = CGRectMake(0, 0, kkScreenWidth, kkScreenHeight - kNavBarAndStatusBarHeight);
    }
    return _pageViewController;
}


@end
