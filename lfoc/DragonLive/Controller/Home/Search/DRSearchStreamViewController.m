//
//  DRSearchStreamViewController.m
//  DragonLive
//
//  Created by 11号 on 2020/12/17.
//

#import "DRSearchStreamViewController.h"
#import "DRSearchHostCell.h"
#import "LiveHosts.h"
#import "LiveRoomViewController.h"
#import "DREmptyView.h"
#import "LiveItem.h"

@interface DRSearchStreamViewController ()

@property (nonatomic, weak) IBOutlet UITableView *bgTableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation DRSearchStreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = The_MainColor;
    
    __weak __typeof(self)weakSelf = self;
    _bgTableView.mj_footer =  [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.footerLoadBlock) {
            weakSelf.footerLoadBlock();
        }
    }];
}

- (void)reloadHostData:(NSArray *)dataArray
{
    if (dataArray.count < 20) {
        _bgTableView.mj_footer.hidden = YES;
    }
    if (_bgTableView.mj_footer.isRefreshing) {
        [_bgTableView.mj_footer endRefreshing];
    }
    
    self.dataArray = dataArray;
    [self.bgTableView reloadData];
    
    if (!self.dataArray || self.dataArray.count == 0) {
        [DREmptyView showEmptyInView:self.view emptyType:DREmptyDataType];
    }else {
        [DREmptyView hiddenEmptyInView:self.view];
    }
    
}

#pragma mark - UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"DRSearchHostCell";
    DRSearchHostCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell =  [[NSBundle mainBundle] loadNibNamed:@"DRSearchHostCell" owner:self options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    LiveHosts *hostModel = [_dataArray objectAtIndex:indexPath.row];
    [cell setHostModel:hostModel];
    
    
    return cell;
}


#pragma mark - UITableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveHosts *hostModel = [_dataArray objectAtIndex:indexPath.row];
    if ([hostModel.livestatus integerValue] == 1) {
        LiveItem *lvItem = [[LiveItem alloc] init];
        lvItem.roomId = hostModel.roomid;
        LiveRoomViewController *controller = [[LiveRoomViewController alloc] init];
        controller.liveItem = lvItem;
        [self.navigationController pushViewController:controller animated:YES];
    }else {
        [[HCToast shareInstance] showToast:@"当前主播尚未开播"];
    }
}

@end
