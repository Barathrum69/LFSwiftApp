//
//  StationMessageController.m
//  DragonLive
//
//  Created by LoaA on 2020/12/9.
//

#import "StationMessageController.h"
#import "StationMessageModel.h"
#import "StationMessageTableView.h"
#import "MineProxy.h"

@interface StationMessageController ()

/// tableView
@property (nonatomic, strong) StationMessageTableView *messageTableView;

@end

@implementation StationMessageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"站内信";
    self.view.backgroundColor = The_MainColor;
    
    [self initView];
    // Do any additional setup after loading the view.
}

-(void)loadDataWithPage:(NSInteger)page
{
    [MineProxy getStationMessageWithPage:page success:^(NSMutableArray * _Nonnull obj) {
        self->_messageTableView.dataArray = obj;
        [self headerFooterEnd];
        
        [DREmptyView hiddenEmptyInView:self->_messageTableView];
        
    } failure:^(NSError * _Nonnull error) {
        [self headerFooterEnd];
        
        if ( self.messageTableView.dataArray.count == 0) {
            [DREmptyView showEmptyInView:self.messageTableView emptyType:DRNetworkErrorType refresh:^{
                [self.messageTableView.mj_header beginRefreshing];
            }];
        }
        
    }];
}

-(void)headerFooterEnd
{
    if (_messageTableView.mj_header.isRefreshing) {
        [_messageTableView.mj_header endRefreshing];

    }
    if (_messageTableView.mj_footer.isRefreshing) {
        [_messageTableView.mj_footer endRefreshing];
    }
}//结束头部尾部的刷新

-(void)initView
{
    _messageTableView = [[StationMessageTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTopHeight-kBottomSafeHeight)style:UITableViewStylePlain];
    [self.view addSubview:_messageTableView];
    kWeakSelf(self);
    //头部尾部刷新 加载更多
    _messageTableView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        weakself.messageTableView.page = 1;
        [weakself loadDataWithPage: weakself.messageTableView.page];
        
     }];
    
    _messageTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        weakself.messageTableView.page ++;
        [weakself loadDataWithPage: weakself.messageTableView.page];
     }];
    [_messageTableView.mj_header beginRefreshing];
    
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
