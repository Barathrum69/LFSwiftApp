//
//  NewsController.m
//  DragonLive
//
//  Created by LoaA on 2021/2/17.
//

#import "NewsController.h"
#import "NewsListView.h"
#import "NewsProxy.h"
#import "DREmptyView.h"
#import "BAWebViewController.h"
#import "NewsItemModel.h"
@interface NewsController ()
/// 列表
@property (nonatomic, strong) NewsListView * listView;

/// title数组
@property (nonatomic, strong) NSMutableArray *sectionArray;
@end

@implementation NewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"资讯";
    [self initView];
    [self initSegmentData];
    // Do any additional setup after loading the view.
}

-(void)initView
{
    kWeakSelf(self);
    _listView = [[NewsListView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTopHeight-kBottomSafeHeight)];
    [self.view addSubview:_listView];
    // 第一次加载
    _listView.tableViewFirstRequest = ^(NSInteger page, NSInteger selectedSegmentIndex) {
        [STTextHudTool showWaitText:@"加载中..."view:weakself.view];
        [weakself loadRequestWithPage:page type:selectedSegmentIndex];
    };
    
    //刷新
    _listView.tableViewHeaderBlock = ^(NSInteger page, NSInteger selectedSegmentIndex) {
        [weakself loadRequestWithPage:page type:selectedSegmentIndex];
    };
    
    //上拉加载更多
    _listView.tableViewFooterBlock = ^(NSInteger page, NSInteger selectedSegmentIndex) {
        [weakself loadRequestWithPage:page type:selectedSegmentIndex];
    };
    
    //点击
    _listView.tableViewDidSelected = ^(NewsItemModel * _Nonnull model) {
        // tableView点击
        //do somethings
        BAWebViewController *webVC = [BAWebViewController new];
        webVC.ba_web_progressTintColor = [UIColor lightGrayColor];
        webVC.ba_web_progressTrackTintColor = [UIColor whiteColor];
        [webVC ba_web_loadURLString:model.contentUrl];
        webVC.showTitle = YES;
        if ([model.atype isEqualToString:@"3"]) {
            //新闻
            webVC.navigationItem.title = @"新闻";
        }else if ([model.atype isEqualToString:@"2"]) {
            //活动
            webVC.navigationItem.title = @"活动";
        }else if ([model.atype isEqualToString:@"1"]) {
            //公告
            webVC.navigationItem.title = @"公告";
        }
        
        
        [weakself.navigationController pushViewController:webVC animated:YES];
    };
    
}

-(void)loadRequestWithPage:(NSInteger)page type:(NewsListType)type{
    
    [NewsProxy getNewsListWithPage:page itemType:type success:^(NewsModel * _Nonnull obj) {
        self.listView.itemModel = obj;
        [STTextHudTool hideSTHud];
        [DREmptyView hiddenEmptyInView:[self.listView getCurrtView]];
    } failure:^(NSError * _Nonnull error) {
        [STTextHudTool hideSTHud];
        [self.listView headerFooterEnd];
        if ([self.listView getCurrtDataArray].count == 0) {
            [DREmptyView showEmptyInView:[self.listView getCurrtView] emptyType:DRNetworkErrorType refresh:^{
                [self.listView currtPageRefrash];
            }];
        }
        
    }];
}//请求




-(void)initSegmentData
{
    _sectionArray = [NSMutableArray arrayWithObjects:@"全部", @"新闻",@"活动",@"公告", nil];
    self.listView.sectionTitles = _sectionArray;
}//组装section 的数据 .

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
