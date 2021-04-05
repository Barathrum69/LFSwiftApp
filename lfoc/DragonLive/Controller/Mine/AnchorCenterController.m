//
//  AnchorCenterController.m
//  DragonLive
//
//  Created by LoaA on 2020/12/9.
//

#import "AnchorCenterController.h"
#import "AnchorCenterTopView.h"
#import "SettingItemModel.h"
#import "SettingSectionModel.h"
#import "SettingCell.h"
#import "MineProxy.h"
#import "AnnounceController.h"
#import "AnchorModel.h"
@interface AnchorCenterController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
/// section模型数组
@property (nonatomic, strong) NSArray  *sectionArray;

/// tableView
@property (nonatomic, strong) UITableView *tableView;


/// 顶部view
@property (nonatomic, strong) AnchorCenterTopView *anchorCenterTopView;

@end

@implementation AnchorCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"主播中心";
    self.view.backgroundColor = The_MainColor;
    [self initView];
    if ([[UserInstance shareInstance].userId isEqualToString:_userId]) {
        [self initTableView];
        [self setupSections];
    }


    [self loadRequest];
    
    // Do any additional setup after loading the view.
}


-(void)loadRequest
{
    [STTextHudTool showWaitText:@"请求中..."];
    
    [MineProxy getAnchorWithUserId:_userId success:^(BOOL success, AnchorModel * _Nonnull model) {
        if (success) {
            self->_anchorCenterTopView.model = model;
        }
        
        [STTextHudTool hideSTHud];
    } failure:^(NSError * _Nonnull error) {
        [STTextHudTool hideSTHud];

    }];
}


-(void)initView{
    kWeakSelf(self);
    _anchorCenterTopView = [[AnchorCenterTopView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(205))];
    [self.view addSubview:_anchorCenterTopView];
    _anchorCenterTopView.gobackBlock = ^{
        [weakself.navigationController popViewControllerAnimated:YES];
    };
}


-(void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _anchorCenterTopView.bottom, kScreenWidth, kScreenHeight -_anchorCenterTopView.height-kBottomSafeHeight)style:UITableViewStyleGrouped];
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, kWidth(23), 0, kWidth(23))];
    }
    [self.tableView setSeparatorColor:[UIColor colorFromHexString:@"EEEEEE"]];
    self.tableView.backgroundColor = The_MainColor;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    
}//初始化tableView

- (void)setupSections
{
    
    SettingItemModel *item2 = [[SettingItemModel alloc]init];
    item2.funcName =   @"主播公告";
    item2.settingItemType = SettingItemTypeNickName;

    item2.detailColor = DetailColor;
    item2.titleColor = TitleColor;

    item2.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    item2.executeCode = ^(SettingItemModel *model) {
        NSLog(@"主播公告");
        AnnounceController *vc = [[AnnounceController alloc]init];
        
        vc.roomId = self->_anchorCenterTopView.model.liveBoardcastRoomNum;
        [self.navigationController pushViewController:vc animated:YES];
    };
 
    
    
    SettingSectionModel *section1 = [[SettingSectionModel alloc]init];
    section1.sectionHeaderHeight = kWidth(17);
    section1.itemArray = @[item2];
    


    
    self.sectionArray = @[section1];
    [self.tableView reloadData];
}//组建model




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    SettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.itemArray.count;}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"setting";
    SettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    SettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.item = itemModel;
//    cell.selectionStyle =
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    SettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.sectionHeaderHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kWidth(50);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    SettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
   
//    if(itemModel.settingItemType == SettingItemTypeSign||itemModel.settingItemType == SettingItemTypeNickName){
//        if (_userModel.sign.length == 0) {
//            itemModel.detailText = @"";
//        }
//    }

    
    if (itemModel.executeCode) {
        itemModel.executeCode(itemModel);
    }
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
