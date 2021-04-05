//
//  MineViewController.m
//  DragonLive
//
//  Created by 11号 on 2020/11/25.
//

#import "MineViewController.h"
#import "SettingItemModel.h"
#import "SettingSectionModel.h"
#import "SettingCell.h"
#import "MineTopView.h"
#import "InformationController.h"
#import "WalletController.h"
#import "MyfocusController.h"
#import "TaskController.h"
#import "StationMessageController.h"
#import "AnchorCenterController.h"
#import "SettingController.h"
#import "LoginController.h"
#import "ApplyAnchorController.h"
#import "AnnounceController.h"
#import "MineProxy.h"
#import "BAWebViewController.h"
#import "NewsController.h"


@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
/// section模型数组
@property (nonatomic, strong) NSArray  *sectionArray;

/// tableView
@property (nonatomic, strong) UITableView *tableView;

/// 顶部View
@property (nonatomic, strong) MineTopView *topView;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = The_MainColor;
    // Do any additional setup after loading the view from its nib.
    [self initTopView];
    [self initTableView];
    [self setupSections];
    
}

-(void)getUserInfoRequest
{
    
    [MineProxy getUserInfoSuccess:^(BOOL success) {
        if (success) {
            //获取钱币
            [MineProxy getAccountCoinsSuccess:^(BOOL isSuccess) {
                self.topView.model = [UserInstance shareInstance].userModel;
            } failure:^(NSError * _Nonnull error) {
                self.topView.model = [UserInstance shareInstance].userModel;
            }];
            
            if ([[UserInstance shareInstance].userModel.userType isEqualToString:@"2"]) {
                [MineProxy getBankCardSuccess:^(NSString * _Nonnull success) {
                    
                } failure:^(NSError * _Nonnull error) {
                    
                }];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
   
}//获取这个人的个人信息

-(void)viewWillAppear:(BOOL)animated
{
    if ([[UserInstance shareInstance]isLogin]){
        self.topView.model = [UserInstance shareInstance].userModel;
        [self getUserInfoRequest];
    }else{
        [_topView showLogin];
    }

    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
//    [self.navigationController.navigationBar setHidden:YES];
}

-(void)initTopView
{
    _topView = [[MineTopView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(200)+kStatusBarHeight)];
    [self.view addSubview:_topView];
    
    _topView.loginBtnOnClickBlock = ^{
        [UntilTools pushLoginPage];
    };
}


-(void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(kWidth(8), _topView.bottom-kWidth(50), kScreenWidth-kWidth(8*2), kScreenHeight - kTopHeight)style:UITableViewStyleGrouped];
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        }
        [self.tableView setSeparatorColor:[UIColor colorFromHexString:@"EEEEEE"]];
    
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;

    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
//    self.tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never;
//
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.tableView.automaticallyAdjustsScrollIndicatorInsets = NO;
    }
  
    
}//初始化tableView
- (void)setupSections
{
    
    //************************************section1*******
    SettingItemModel *item1 = [[SettingItemModel alloc]init];
    item1.funcName = @"个人资料";
    item1.executeCode = ^(SettingItemModel *model) {
                NSLog(@"个人资料");
        
//        [UntilTools pushSharePage];
        
        if (![[UserInstance shareInstance]isLogin]) {
            [UntilTools pushLoginPage];
            return;
        }
        InformationController *vc = [InformationController new];
        [self.navigationController pushViewController:vc animated:YES];
         
    };
    item1.img = [UIImage imageNamed:@"mine_information"];
    item1.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    
    SettingItemModel *item2 = [[SettingItemModel alloc]init];
    item2.funcName = @"钱包";
    item2.img = [UIImage imageNamed:@"mine_wallet"];
    item2.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    item2.executeCode = ^(SettingItemModel *model) {
                NSLog(@"钱包");
        if (![[UserInstance shareInstance]isLogin]) {
            [UntilTools pushLoginPage];
            return;
        }
        WalletController *vc = [WalletController new];
        [self.navigationController pushViewController:vc animated:YES];
    };
    SettingItemModel *item3 = [[SettingItemModel alloc]init];
    item3.funcName = @"我的关注";
    item3.img = [UIImage imageNamed:@"mine_fav"];
    item3.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    item3.executeCode = ^(SettingItemModel *model) {
                NSLog(@"我的关注");
        if (![[UserInstance shareInstance]isLogin]) {
            [UntilTools pushLoginPage];
            return;
        }
        MyfocusController  *vc = [MyfocusController new];
        [self.navigationController pushViewController:vc animated:YES];
    };
    SettingItemModel *item4 = [[SettingItemModel alloc]init];
    item4.funcName = @"任务";
    item4.img = [UIImage imageNamed:@"mine_task"];
    item4.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    item4.executeCode = ^(SettingItemModel *model) {
                NSLog(@"任务");
        if (![[UserInstance shareInstance]isLogin]) {
            [UntilTools pushLoginPage];
            return;
        }
        TaskController  *vc = [TaskController new];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    SettingItemModel *item5 = [[SettingItemModel alloc]init];
    item5.funcName = @"站内信";
    item5.img = [UIImage imageNamed:@"mine_message"];
    item5.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    item5.executeCode = ^(SettingItemModel *model) {
                NSLog(@"站内信");
        if (![[UserInstance shareInstance]isLogin]) {
            [UntilTools pushLoginPage];
            return;
        }
    StationMessageController  *vc = [StationMessageController new];
    [self.navigationController pushViewController:vc animated:YES];
    };
    
    
    SettingSectionModel *section1 = [[SettingSectionModel alloc]init];
    section1.sectionHeaderHeight = kWidth(10);
    section1.itemArray = @[item1,item2,item3,item4,item5];
    
    SettingItemModel *item6 = [[SettingItemModel alloc]init];
    item6.funcName = @"主播中心";
    item6.img = [UIImage imageNamed:@"mine_anchor"];
    item6.executeCode = ^(SettingItemModel *model) {
        NSLog(@"主播中心");
        if (![[UserInstance shareInstance]isLogin]) {
            [UntilTools pushLoginPage];
            return;
        }
        
        NSLog(@"%@",[UserInstance shareInstance].userModel.hostApplyResult);
        if ([[UserInstance shareInstance].userModel.userType isEqualToString:@"2"]) {
            //说明已经是主播了.
            AnchorCenterController  *vc = [AnchorCenterController new];
            vc.userId = [UserInstance shareInstance].userId;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            ApplyAnchorController *vc = [ApplyAnchorController new];
            [self.navigationController pushViewController:vc animated:YES];
        }

    };
    item6.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    
    SettingItemModel *item8 = [[SettingItemModel alloc]init];
    item8.funcName = @"在线客服";
    item8.img = [UIImage imageNamed:@"mine_kefu"];
    item8.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    item8.executeCode = ^(SettingItemModel *model) {

        BAWebViewController *webVC = [BAWebViewController new];
        webVC.ba_web_progressTintColor = [UIColor cyanColor];
        webVC.ba_web_progressTrackTintColor = [UIColor whiteColor];

        [webVC ba_web_loadURLString:@"https://www.chuanyinke.com/kefu/6001227a81cc7"];
        [self.navigationController pushViewController:webVC animated:YES];
    };
    item8.accessoryType = SettingAccessoryTypeDisclosureIndicator;

    SettingItemModel *item7 = [[SettingItemModel alloc]init];
    item7.funcName = @"设置";
    item7.img = [UIImage imageNamed:@"mine_setting"];
    item7.executeCode = ^(SettingItemModel *model) {
        NSLog(@"设置");
        SettingController  *vc = [SettingController new];
        
//        AnnounceController *vc = [AnnounceController new];
        
        [self.navigationController pushViewController:vc animated:YES];

    };
    item7.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    
    
    
    //*********************第二个section
    SettingSectionModel *section2 = [[SettingSectionModel alloc]init];
    section2.sectionHeaderHeight = kWidth(5);
    section2.itemArray = @[item6,item8,item7];
    
    self.sectionArray = @[section1,section2];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    SettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.itemArray.count;
    
}

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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    SettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    if (itemModel.executeCode) {
        itemModel.executeCode(itemModel);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    SettingSectionModel *sectionModel = [self.sectionArray firstObject];
    CGFloat sectionHeaderHeight = sectionModel.sectionHeaderHeight;

    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}//uitableview处理section的不悬浮，禁止section停留的方法，主要是这段代码 但是写的有问题

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kWidth(45);
}
//CGRect bounds = CGRectInset(cell.bounds, 0, 0);

// 绘制每个group圆角阴影 用贝塞尔曲线重新绘制
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 圆角角度
    CGFloat radius = 5.0f;
    // 设置cell 背景色为透明
    cell.backgroundColor = UIColor.clearColor;
    // 创建两个layer
    CAShapeLayer *normalLayer = [[CAShapeLayer alloc] init];
    CAShapeLayer *selectLayer = [[CAShapeLayer alloc] init];
    // 获取显示区域大小
    CGRect bounds = CGRectInset(cell.bounds, 0, 0);
    // cell的backgroundView
    UIView *normalBgView = [[UIView alloc] initWithFrame:bounds];
    // 获取每组行数
    NSInteger rowNum = [tableView numberOfRowsInSection:indexPath.section];
    // 贝塞尔曲线
    CGMutablePathRef pathRef = CGPathCreateMutable();

    UIBezierPath *bezierPath = nil;
    BOOL addLine = NO;

    if (rowNum == 1) {
        // 一组只有一行（四个角全部为圆角）
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
        normalBgView.clipsToBounds = NO;
   
    }else {
       
        normalBgView.clipsToBounds = YES;
        if (indexPath.row == 0) {
            normalBgView.frame = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, 0, 0));
            CGRect rect = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, 0, 0));

            // 每组第一行（添加左上和右上的圆角）
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(radius, radius)];
            CGPathAddRect(pathRef, nil, bounds);
            addLine = NO;
        }else if (indexPath.row == rowNum - 1) {
            normalBgView.frame = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, 0, 0));
            CGRect rect = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, 0, 0));
            // 每组最后一行（添加左下和右下的圆角）
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(radius, radius)];
            //每组最后一个不要画线 超级难看
//            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
//                addLine = YES;

        }else {
            // 每组不是首位的行不设置圆角
            bezierPath = [UIBezierPath bezierPathWithRect:bounds];
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
    }
    
    if (addLine == YES) {
        CALayer *lineLayer = [[CALayer alloc] init];
        CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
        lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight);
        // 分隔线颜色取自于原来tableview的分隔线颜色
        lineLayer.backgroundColor = [UIColor colorFromHexString:@"F5F5F5"].CGColor;
        [normalLayer addSublayer:lineLayer];
    }
    
    // 这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
    // 阴影
    normalLayer.shadowColor = [UIColor colorFromHexString:@"DEDEDE"].CGColor;
    normalLayer.shadowOpacity = 0.13;
    normalLayer.shadowOffset = CGSizeMake(2, 2);
    normalLayer.path = bezierPath.CGPath;
    normalLayer.shadowPath = bezierPath.CGPath;
    
    // 把已经绘制好的贝塞尔曲线路径赋值给图层，然后图层根据path进行图像渲染render
    normalLayer.path = bezierPath.CGPath;
    selectLayer.path = bezierPath.CGPath;
    
    // 设置填充颜色
    normalLayer.fillColor = [UIColor whiteColor].CGColor;
    // 添加图层到nomarBgView中
    [normalBgView.layer insertSublayer:normalLayer atIndex:0];
    normalBgView.backgroundColor = UIColor.clearColor;
    cell.backgroundView = normalBgView;
    
    // 替换cell点击效果
    UIView *selectBgView = [[UIView alloc] initWithFrame:bounds];
    selectLayer.fillColor = [UIColor colorWithWhite:0.95 alpha:1.0].CGColor;
    [selectBgView.layer insertSublayer:selectLayer atIndex:0];
    selectBgView.backgroundColor = UIColor.clearColor;
    cell.selectedBackgroundView = selectBgView;
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
