//
//  MyfocusController.m
//  DragonLive
//
//  Created by LoaA on 2020/12/9.
//

#import "MyfocusController.h"
#import "MyfocusTableView.h"
#import "MineProxy.h"
#import "MyFocusModel.h"
#import "LiveRoomViewController.h"
#import "LiveItem.h"

@interface MyfocusController ()

/// tableView
@property (nonatomic, strong) MyfocusTableView *myfocusTableView;

@end

@implementation MyfocusController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"我的关注";
    self.view.backgroundColor = The_MainColor;
    [self initTableView];
    // Do any additional setup after loading the view.
}


-(void)initTableView
{
    _myfocusTableView = [[MyfocusTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTopHeight-kBottomSafeHeight)style:UITableViewStylePlain];
    [self.view addSubview:_myfocusTableView];
    
    kWeakSelf(self);
    //头部尾部刷新 加载更多
    _myfocusTableView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        weakself.myfocusTableView.page = 1;
        [weakself loadDataWithPage: weakself.myfocusTableView.page];
     }];
    
    _myfocusTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        weakself.myfocusTableView.page ++;
        [weakself loadDataWithPage: weakself.myfocusTableView.page];
     }];
    
    _myfocusTableView.ItemBlock = ^(MyFocusModel * _Nonnull model) {

        ACActionSheet *actionSheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"取消关注"] actionSheetBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                NSLog(@"%@",model.userId);
                [MineProxy doAttentionUserWithAttentionUser:model.attentionUser success:^(BOOL success) {
                    [weakself.myfocusTableView.mj_header beginRefreshing];
                    [weakself showToast:@"取消关注成功"];
                } failure:^(NSError * _Nonnull error) {
                    
                }];
            }
        }];
        [actionSheet show];
    };
    
    
    _myfocusTableView.cellItemSelectedBlock = ^(MyFocusModel * _Nonnull model) {
        if ([model.hasLive integerValue] == 1) {
            LiveItem *lvItem = [[LiveItem alloc] init];
            lvItem.roomId = model.roomId;
            LiveRoomViewController *controller = [[LiveRoomViewController alloc] init];
            controller.liveItem = lvItem;
            [weakself.navigationController pushViewController:controller animated:YES];
        }else {
            [[HCToast shareInstance] showToast:@"当前主播尚未开播"];
        }
    };
    
    
    
    [_myfocusTableView.mj_header beginRefreshing];

}

-(void)headerFooterEnd
{
    if (_myfocusTableView.mj_header.isRefreshing) {
        [_myfocusTableView.mj_header endRefreshing];
    }
    if (_myfocusTableView.mj_footer.isRefreshing) {
        [_myfocusTableView.mj_footer endRefreshing];
    }
}//结束头部尾部的刷新

-(void)loadDataWithPage:(NSInteger)page
{
    [MineProxy getMyFocusListWithPage:page success:^(NSMutableArray * _Nonnull obj) {
        self.myfocusTableView.dataArray = obj;
        [self headerFooterEnd];
        [DREmptyView hiddenEmptyInView:self.myfocusTableView];

    } failure:^(NSError * _Nonnull error) {
        [self headerFooterEnd];
        if (self.myfocusTableView.dataArray.count == 0) {
            [DREmptyView showEmptyInView:self.myfocusTableView emptyType:DRNetworkErrorType refresh:^{
                [self.myfocusTableView.mj_header beginRefreshing];
            }];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
