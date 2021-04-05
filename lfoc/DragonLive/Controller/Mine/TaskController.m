//
//  TaskController.m
//  DragonLive
//
//  Created by LoaA on 2020/12/9.
//

#import "TaskController.h"
#import "TaskTableView.h"
#import "MineProxy.h"
#import "UserTaskInstance.h"
#import "TaskModel.h"

@interface TaskController ()

/// tableView
@property (nonatomic, strong) TaskTableView *taskTableView;

@end

@implementation TaskController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"任务";
    self.view.backgroundColor = The_MainColor;
    [self initTableView];
    // Do any additional setup after loading the view.
}

-(void)initTableView
{
    _taskTableView = [[TaskTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTopHeight-kBottomSafeHeight)style:UITableViewStylePlain];
    [self.view addSubview:_taskTableView];
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(6))];
    header.backgroundColor = The_MainColor;
    _taskTableView.tableHeaderView = header;
    
    kWeakSelf(self);
    //头部尾部刷新 加载更多
    _taskTableView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        weakself.taskTableView.page = 1;
        [weakself loadDataWithPage: weakself.taskTableView.page];
     }];
    
//    _taskTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        //Call this Block When enter the refresh status automatically
//        weakself.taskTableView.page ++;
//        [weakself loadDataWithPage: weakself.taskTableView.page];
//     }];
    
    
    _taskTableView.cellBlock = ^(TaskModel * _Nonnull model) {
        [weakself itemSelectedRequestWithModel:model];
    };
    
    [_taskTableView.mj_header beginRefreshing];
    
    
}


-(void)itemSelectedRequestWithModel:(TaskModel *)model
{
    [MineProxy taskRecivedWithTaskId:model.taskId success:^(BOOL success) {
        [self->_taskTableView.mj_header beginRefreshing];
        
        [self showToast:@"领取成功"];
        
    } failure:^(NSError * _Nonnull error) {
    }];
}//点击领取任务


-(void)headerFooterEnd
{
    if (_taskTableView.mj_header.isRefreshing) {
        [_taskTableView.mj_header endRefreshing];

    }
    if (_taskTableView.mj_footer.isRefreshing) {
        [_taskTableView.mj_footer endRefreshing];
    }
}//结束头部尾部的刷新

-(void)loadDataWithPage:(NSInteger)page
{
    [MineProxy getTaskListWithPage:page success:^(NSMutableArray * _Nonnull obj) {
        
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
        
        [DREmptyView hiddenEmptyInView:self.taskTableView];
        self.taskTableView.dataArray = obj;
        [self headerFooterEnd];
    } failure:^(NSError * _Nonnull error) {
        [self headerFooterEnd];
        
        if ( self.taskTableView.dataArray.count == 0) {
            [DREmptyView showEmptyInView:self.taskTableView emptyType:DRNetworkErrorType refresh:^{
                
                [self.taskTableView.mj_header beginRefreshing];
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
