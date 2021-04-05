//
//  AccountSecurityController.m
//  DragonLive
//
//  Created by LoaA on 2020/12/9.
//

#import "AccountSecurityController.h"
#import "SettingItemModel.h"
#import "SettingSectionModel.h"
#import "SettingCell.h"
#import "ModifyPasswordController.h"
#import "ModifyPhoneController.h"
#import "ModifyEmailController.h"


@interface AccountSecurityController ()<UITableViewDelegate,UITableViewDataSource>
/// section模型数组
@property (nonatomic, strong) NSArray  *sectionArray;

/// tableView
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AccountSecurityController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = The_MainColor;
    self.navigationItem.title = @"账号与安全";
    
    [self initTableView];
    
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupSections];

}

-(void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTopHeight)style:UITableViewStyleGrouped];
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, kWidth(23), 0, kWidth(23))];
    }
    [self.tableView setSeparatorColor:[UIColor colorFromHexString:@"EEEEEE"]];
    self.tableView.backgroundColor = The_MainColor;
    self.tableView.dataSource = self;
//    self.tableView.scrollEnabled = NO;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    
}//初始化tableView

- (void)setupSections
{
    
    SettingItemModel *item2 = [[SettingItemModel alloc]init];
    item2.funcName =   @"修改密码";
    item2.settingItemType = SettingItemTypeNickName;
    item2.count    = 10;
    //名字
//    if (_userModel.nickName.length == 0) {
//        item2.detailText = @"请输入";
//    }else{
//        item2.detailText = _userModel.nickName;
//    }
    item2.detailColor = DetailColor;
    item2.titleColor = TitleColor;

    item2.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    item2.executeCode = ^(SettingItemModel *model) {
        NSLog(@"修改密码");
//        SettingItemModel *editModel = [self getNewModel:model];
        __block SettingItemModel *cellModel = model;
        ModifyPasswordController *vc = [[ModifyPasswordController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];

//        EditContentController *vc = [[EditContentController alloc]initWithModel:[self getNewModel:model] saveBlock:^(SettingItemModel * _Nonnull saveModel,BOOL isSave) {
//            if (isSave) {
//                cellModel.detailText = saveModel.detailText;
//                [self submitWithModel:cellModel];
//
//            }else{
//                cellModel.accessoryType = SettingAccessoryTypeDisclosureIndicator;
//            }
//
//            [self.tableView reloadData];
//        }];
//
    };
 
    SettingItemModel *item3 = [[SettingItemModel alloc]init];
    item3.funcName = @"更换手机号";
    item3.detailText = [UserInstance shareInstance].userModel.phoneNum;
    item3.detailColor = DetailColor;
    item3.titleColor = TitleColor;
    item3.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    item3.executeCode = ^(SettingItemModel *model) {
        ModifyPhoneController *vc = [[ModifyPhoneController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    
    SettingItemModel *item4 = [[SettingItemModel alloc]init];
    item4.funcName = @"修改邮箱";
    
    if ([UserInstance shareInstance].userModel.email.length != 0) {
        item4.detailText = [UserInstance shareInstance].userModel.email;
    }else{
        item4.detailText = @"未绑定";
    }
    item4.detailColor = DetailColor;
    item4.titleColor = TitleColor;
    item4.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    item4.executeCode = ^(SettingItemModel *model) {
        ModifyEmailController *vc = [ModifyEmailController new];
        [self.navigationController pushViewController:vc animated:YES];

    };
    
    
    SettingSectionModel *section1 = [[SettingSectionModel alloc]init];
    section1.sectionHeaderHeight = kWidth(3);
    section1.itemArray = @[item2,item3,item4];
    


    
    self.sectionArray = @[section1];
    [self.tableView reloadData];
}//组建model


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
