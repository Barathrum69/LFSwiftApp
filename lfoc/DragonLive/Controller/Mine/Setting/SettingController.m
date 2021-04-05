//
//  SettingController.m
//  DragonLive
//
//  Created by LoaA on 2020/12/9.
//

#import "SettingController.h"
#import "SettingItemModel.h"
#import "SettingSectionModel.h"
#import "SettingCell.h"
#import "ZGAlertView.h"
#import "BarrageSetViewController.h"
#import "UserAgreementController.h"
#import "AboutUsController.h"

@interface SettingController ()<UITableViewDelegate,UITableViewDataSource>
/// section模型数组
@property (nonatomic, strong) NSArray  *sectionArray;

/// tableView
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = The_MainColor;
    // Do any additional setup after loading the view.
    [self initTableView];
    [self setupSections];
    
    // Do any additional setup after loading the view.
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
    
    //************************************section1*******
    SettingItemModel *item1 = [[SettingItemModel alloc]init];
    item1.funcName = @"弹幕设置";
    item1.titleColor = TitleColor;
    item1.executeCode = ^(SettingItemModel *model) {
        BarrageSetViewController *controller = [BarrageSetViewController new];
        [self.navigationController pushViewController:controller animated:YES];
    };
    
//    if (_userModel.img.length == 0) {
//    }else{
//
////        item1.detailImage = self.userModel.headImage;
//    }
    item1.accessoryType = SettingAccessoryTypeDisclosureIndicator;

    
    
    SettingItemModel *item2 = [[SettingItemModel alloc]init];
    item2.funcName =   @"清除缓存";
    item2.settingItemType = SettingItemTypeNickName;
    item2.count    = 10;
    NSUInteger bytesCache = [[SDImageCache sharedImageCache] totalDiskSize];
    //换算成 MB (注意iOS中的字节之间的换算是1000不是1024)
    float MBCache = bytesCache/1000.00/1000.00;
    item2.detailText = [NSString stringWithFormat:@"%0.2fMB",MBCache];;

    item2.detailColor = DetailColor;
    item2.titleColor = TitleColor;

    item2.executeCode = ^(SettingItemModel *model) {
        ZGAlertView *alertView = [[ZGAlertView alloc] initWithTitle:@"确定清除缓存？"
                                               message:nil
                                     cancelButtonTitle:@"取消"
                                     otherButtonTitles:@"确认", nil];
        [alertView show];
        
        __weak __typeof(self)weakSelf = self;
        alertView.dismissBlock = ^(NSInteger clickIndex) {
            
            if (clickIndex == 1) {
                [weakSelf performSelector:@selector(showClean) afterDelay:1];
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                NSString *cachesDir = [paths objectAtIndex:0];
                [weakSelf clearCache:cachesDir];
                [weakSelf setupSections];
            }
        };
    };
 
    SettingItemModel *item3 = [[SettingItemModel alloc]init];
    item3.funcName = @"小窗播放";
    item3.detailColor = DetailColor;
    item3.titleColor = TitleColor;
    item3.isOn = [UserInstance shareInstance].isSetSmallWindow;
    item3.accessoryType = SettingAccessoryTypeSwitch;
    item3.switchValueChanged = ^(BOOL isOn) {
        [UserInstance shareInstance].isSetSmallWindow = isOn;
        [[NSUserDefaults standardUserDefaults] setBool:isOn forKey:kkSetSmallWindow];
        [[NSUserDefaults standardUserDefaults] synchronize];
    };

    SettingItemModel *item4 = [[SettingItemModel alloc]init];
    item4.funcName = @"后台播放";
    item4.isOn = [UserInstance shareInstance].isSetBackgroundPlay;
    item4.detailColor = DetailColor;
    item4.titleColor = TitleColor;
    item4.accessoryType = SettingAccessoryTypeSwitch;
    item4.switchValueChanged = ^(BOOL isOn) {
        [UserInstance shareInstance].isSetBackgroundPlay = isOn;
        [[NSUserDefaults standardUserDefaults] setBool:isOn forKey:kkSetBackgroundPlay];
        [[NSUserDefaults standardUserDefaults] synchronize];
    };
    
    SettingSectionModel *section1 = [[SettingSectionModel alloc]init];
    section1.sectionHeaderHeight = kWidth(7);
    section1.itemArray = @[item1,item2,item3,item4];
    

    SettingItemModel *item5 = [[SettingItemModel alloc]init];
    item5.funcName = @"界面模式";
    item5.detailText = @"跟随系统";
    item5.detailColor = DetailColor;
    item5.titleColor = TitleColor;
    item5.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    
    
    SettingItemModel *item6 = [[SettingItemModel alloc]init];
    item6.funcName = @"关于我们";
    item6.detailColor = DetailColor;
    item6.titleColor = TitleColor;
    item6.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    item6.executeCode = ^(SettingItemModel *model) {
        AboutUsController *vc = [AboutUsController new];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    
    SettingItemModel *item7 = [[SettingItemModel alloc]init];
    item7.funcName = @"用户协议";
    item7.detailColor = DetailColor;
    item7.titleColor = TitleColor;
    item7.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    item7.executeCode = ^(SettingItemModel *model) {
        UserAgreementController *vc = [UserAgreementController new];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"userAgreement" ofType:@"txt"];
        vc.navtitle = @"用户协议";
        vc.path = path;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    
    SettingItemModel *item8 = [[SettingItemModel alloc]init];
    item8.funcName = @"隐私政策";
    item8.detailColor = DetailColor;
    item8.titleColor = TitleColor;
    item8.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    item8.executeCode = ^(SettingItemModel *model) {
        UserAgreementController *vc = [UserAgreementController new];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"privacyAgreement" ofType:@"txt"];
        vc.navtitle = @"隐私政策";
        vc.path = path;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    
    SettingSectionModel *section2 = [[SettingSectionModel alloc]init];
    section2.sectionHeaderHeight = kWidth(10);
    section2.itemArray = @[item6,item7,item8];
    
    
    SettingItemModel *item9 = [[SettingItemModel alloc]init];
    item9.funcName = @"退出登录";
    item9.detailColor = DetailColor;
    item9.accessoryType = SettingAccessoryTypeLogout;
    item9.executeCode = ^(SettingItemModel *model) {

        ZGAlertView *alertView = [[ZGAlertView alloc] initWithTitle:@"确认退出？"
                                               message:nil
                                     cancelButtonTitle:@"取消"
                                     otherButtonTitles:@"确认", nil];
        [alertView show];
        
        __weak __typeof(self)weakSelf = self;
        alertView.dismissBlock = ^(NSInteger clickIndex) {
            
            if (clickIndex == 1) {
                [weakSelf performSelector:@selector(exitOut) afterDelay:1];
               
                [UntilTools cleanUserDefault];
//                [weakSelf setupSections];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        };
    };
    
    
    SettingSectionModel *section3 = [[SettingSectionModel alloc]init];
    section3.sectionHeaderHeight = kWidth(30);
    section3.itemArray = @[item9];
    if ([[UserInstance shareInstance]isLogin]) {
        self.sectionArray = @[section1,section2,section3];
    }else{
        self.sectionArray = @[section1,section2];
    }
    [self.tableView reloadData];
}//组建model


// 3.清除缓存
- (void)clearCache:(NSString *)path {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] clearMemory];
}

-(void)exitOut{
    [[HCToast shareInstance]showToast:@"已退出"];

}


-(void)showClean{
    [[HCToast shareInstance]showToast:@"清除完毕"];

}


-(void)submitWithModel:(SettingItemModel *)model
{
//    [LoginRegisterPorxy postUpdateMembersWithModel:model success:^(BOOL isSuccess) {
//
//    } failure:^(NSError * _Nonnull error) {
//
//    }];
}//提交数据

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
