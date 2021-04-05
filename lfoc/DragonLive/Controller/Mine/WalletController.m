//
//  WalletController.m
//  DragonLive
//
//  Created by LoaA on 2020/12/9.
//

#import "WalletController.h"
#import "HMSegmentedControl.h"
#import "RechargeView.h"
#import "ExtractCashView.h"
#import "RechargeModel.h"
#import "RechargeMethodModel.h"
#import "WalletDetailsController.h"
#import "MineProxy.h"
#import "RevenueInfoModel.h"
#import "AddBankCardController.h"
#import "BAWebViewController.h"

@interface WalletController ()<UIScrollViewDelegate>

/// 刷新
@property (nonatomic, strong) UIScrollView *bgScrollView;

/// 筛选框
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

/// 筛选框数组
@property (nonatomic, strong) NSArray *segmentArray;

/// 当前选择的下标
@property (nonatomic, assign) NSInteger selectedSegmentIndex;

//scrollView
@property (nonatomic, strong) UIScrollView *scrollView;

/// 充值界面
@property (nonatomic, strong) RechargeView *rechargeView;

/// 提现界面
@property (nonatomic, strong) ExtractCashView *extractCashView;

/// 充值的数组
@property (nonatomic, strong) NSMutableArray *rechargeArray;

/// 充值模型的数组
@property (nonatomic, strong) NSMutableArray *rechargeMethodArray;

/// 记录选择的渠道
@property (nonatomic, strong) RechargeMethodModel *channelModel;

/// 记录选择的金额
@property (nonatomic, strong) RechargeModel *coinsModel;

/// 提现信息
@property (nonatomic, strong) RevenueInfoModel *revenueModel;

@end

@implementation WalletController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"钱包";
    self.view.backgroundColor = The_MainColor;
    [self initNavigationItem];
    [self initBgScrollView];
    [self initSegmentedControl];
    [self initScrollView];
    [self initRechargeView];
    [self initExtractCashView];
    
    [self loadRequestPayInfo];
    [self loadRequestQueryRevenue];
}

#pragma mark - nav
-(void)initNavigationItem
{
    //    右边
    UIButton  *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 20);
    [rightBtn setTitle:@"账户明细" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorFromHexString:@"222222"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightItemClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barRightBtn = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    [self.navigationItem setRightBarButtonItem:barRightBtn];
    
    
    
}//加载Nav

-(void)rightItemClicked
{
    
    //    [_footBallView startTimer];
    WalletDetailsController *vc = [WalletDetailsController new];
    [self.navigationController pushViewController:vc animated:YES];
    
    NSLog(@"右边边");
    
    
}//nav右边点击
#pragma mark  - 初始化加载的东西
-(void)initSegmentedControl
{
    CGFloat width = 115.0;
    if ([[UserInstance shareInstance].userModel.userType isEqualToString:@"2"]) {
        _segmentArray = @[@"充值",@"提现"];
    }else{
        _segmentArray = @[@"充值"];
        width = 115.0/2;
    }
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:_segmentArray];
    _segmentedControl.frame = CGRectMake(0, 10, width, 30);
    _segmentedControl.backgroundColor = [UIColor clearColor];
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    
    //indicator位置
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    //选中indicator
    _segmentedControl.selectionIndicatorColor = BXColor(255, 101, 69);
    _segmentedControl.selectionIndicatorHeight = 4.0f;
//    _segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, -4, 0);
    //        _segmentedControl.backgroundColor =[UIColor whiteColor];
    //标题属性
    _segmentedControl.titleTextAttributes = @{
        NSForegroundColorAttributeName : BXColor(51, 51, 51),
        NSFontAttributeName:[UIFont systemFontOfSize:15.0]
    };
    //选中标题属性
    _segmentedControl.selectedTitleTextAttributes =@{
        NSForegroundColorAttributeName : BXColor(51, 51, 51),
        NSFontAttributeName:[UIFont boldSystemFontOfSize:20]
    };
    _segmentedControl.selectedSegmentIndex = 0;
    
    [self.bgScrollView addSubview:_segmentedControl];
    
    kWeakSelf(self);
    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        weakself.selectedSegmentIndex = index;
        [weakself.scrollView scrollRectToVisible:CGRectMake(kScreenWidth * index, 0, kScreenWidth, weakself.scrollView.frame.size.height) animated:YES];
//        [weakself addContentView];//滑动加载View

    }];
    
}

-(void)initBgScrollView
{
    UIScrollView *bScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kkScreenWidth, kkScreenHeight-kNavBarAndStatusBarHeight)];
    bScrollView.showsHorizontalScrollIndicator = NO;
    bScrollView.showsVerticalScrollIndicator = NO;
    bScrollView.contentSize = CGSizeMake(kkScreenWidth, kkScreenHeight);
    [self.view addSubview:bScrollView];
    self.bgScrollView = bScrollView;
}//scroll

-(void)initScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _segmentedControl.bottom, kScreenWidth, kScreenHeight-40-kTopHeight-kBottomSafeHeight)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth*_segmentArray.count, self.scrollView.height);
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, self.scrollView.height) animated:NO];
    [self.bgScrollView addSubview:self.scrollView];
}//scroll


-(void)initRechargeView
{
    __weak __typeof(self)weakSelf = self;
    _rechargeView = [[RechargeView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, _scrollView.height)];
    [_scrollView addSubview:_rechargeView];
    
    //立即充值
    _rechargeView.submitBlock = ^{
        [weakSelf loadRequestRecharge];
    };
    //充值金额选择
    _rechargeView.rechargeItemDidSelectBlock = ^(RechargeModel * _Nonnull model) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.coinsModel = model;
    };
    
    //充值方式选择
    _rechargeView.rechargeMethodItemDidSelectBlock = ^(RechargeMethodModel * _Nonnull model) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.channelModel = model;
        [strongSelf reloadRechargeViewWithChannel:model];
    };
    
    _bgScrollView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadRequestPayInfo];
        [self loadRequestQueryRevenue];
     }];
    
}//充值界面

-(void)initExtractCashView
{
    __weak __typeof(self)weakSelf = self;
    _extractCashView =[[ExtractCashView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, _scrollView.height)];
    _extractCashView.sendRevenueBlock = ^{
        [weakSelf loadRequestApproveRevenue];
    };
    [_scrollView addSubview:_extractCashView];
    
}//提现界面

//请求钱包充值信息（支付方式和选择充值金额）
-(void)loadRequestPayInfo
{
    __weak __typeof(self)weakSelf = self;
    [MineProxy walletQueryPayInfoSuccess:^(NSMutableArray * _Nonnull obj) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.rechargeMethodArray = [obj firstObject];
        strongSelf.rechargeArray = obj[1];
        
        [strongSelf reloadChannelView];
        
        if (strongSelf.bgScrollView.mj_header.isRefreshing) {
            [strongSelf.bgScrollView.mj_header endRefreshing];
        }
        
    } failure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.bgScrollView.mj_header.isRefreshing) {
            [strongSelf.bgScrollView.mj_header endRefreshing];
        }
    }];
}

//立即充值
-(void)loadRequestRecharge
{
    _rechargeView.submitBtn.enabled = NO;
    __weak __typeof(self)weakSelf = self;
    [MineProxy walletRechargeWithPayId:self.channelModel.payId channelId:self.channelModel.channelId amount:self.coinsModel.amount success:^(NSString * _Nonnull otherLink) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        strongSelf.rechargeView.submitBtn.enabled = YES;
        BAWebViewController *webVC = [BAWebViewController new];
        webVC.ba_web_progressTintColor = [UIColor cyanColor];
        webVC.ba_web_progressTrackTintColor = [UIColor whiteColor];
        [webVC ba_web_loadURLString:otherLink];
        [self.navigationController pushViewController:webVC animated:YES];
        
    } failure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.rechargeView.submitBtn.enabled = YES;
    }];
}

//请求提现信息
-(void)loadRequestQueryRevenue
{
    __weak __typeof(self)weakSelf = self;
    [MineProxy walletQueryRevenue:^(NSDictionary * _Nonnull obj) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        RevenueInfoModel *rmodel = [RevenueInfoModel modelWithDictionary:obj];
        strongSelf.revenueModel = rmodel;
        
        [UserInstance shareInstance].havebankCard = [obj[@"havebankCard"] boolValue];
        [UserInstance shareInstance].userModel.coins = rmodel.allstar;
        
        [strongSelf.extractCashView setExtractCashViewRevenueModel:rmodel];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

//申请提现
-(void)loadRequestApproveRevenue
{
    if ([UserInstance shareInstance].havebankCard) {
        __weak __typeof(self)weakSelf = self;
        [MineProxy walletApproveWithCoins:_revenueModel.availablestar money:_revenueModel.money cosRate:_revenueModel.cosRate success:^{
            [weakSelf loadRequestQueryRevenue];
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }else {
        
        ZGAlertView *alertView = [[ZGAlertView alloc] initWithTitle:@"您尚未绑定银行卡，是否绑定？"
                                               message:nil
                                     cancelButtonTitle:@"取消"
                                     otherButtonTitles:@"绑定银行卡", nil];
        [alertView show];
        
        __weak __typeof(self)weakSelf = self;
        alertView.dismissBlock = ^(NSInteger clickIndex) {
            
            if (clickIndex == 1) {
                AddBankCardController *vc = [AddBankCardController new];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        };
    }
}

//刷新支付方式view
- (void)reloadChannelView
{
    if (self.rechargeMethodArray.count) {
    
        self.channelModel = [self.rechargeMethodArray firstObject];
        self.channelModel.isSelected = YES;
        //刷新渠道界面数据
        self.rechargeView.rechargeMethodArray = self.rechargeMethodArray;
        
        [self reloadRechargeViewWithChannel:self.channelModel];

    }
}

//根据选择渠道去刷新充值金额数据
- (void)reloadRechargeViewWithChannel:(RechargeMethodModel *)clModel
{
    NSMutableArray *filterCoinsArr;
    if (clModel.validMoney && [clModel.validMoney length]) {
        //固定金额
        filterCoinsArr = [self filterSolidifyCoinsWithChannel:clModel];
        
    }else {
        //可以手动输入
        filterCoinsArr = [self filterCoinsWithChannel:clModel];
        //充值金额数据最后一条默认手动输入
        if (filterCoinsArr.count) {
            RechargeModel *lastModel = [[RechargeModel alloc] init];
            lastModel.minAmount = clModel.minAmount;              //限制手动输入金额的最小值
            lastModel.maxAmount = clModel.maxAmount;              //限制手动输入金额的最大值
            lastModel.rechargeStyleType = RechargeStyleTypeTextField;
            [filterCoinsArr addObject:lastModel];
        }
    }
    
    //默认选中充值金额第一个
    for (NSInteger i=0; i<filterCoinsArr.count; i++) {
        RechargeModel *coinsModel = [filterCoinsArr objectAtIndex:i];
        if (i==0) {
            coinsModel.isSelected = YES;
            self.coinsModel = coinsModel;
        } else {
            coinsModel.isSelected = NO;
        }
    }
    
    _rechargeView.rechargeArray = filterCoinsArr;
}

//根据支付渠道的最小最大金额限制，过滤充值金额数据
- (NSMutableArray *)filterCoinsWithChannel:(RechargeMethodModel *)clModel
{
    //快速查找出接收的某个礼物
    NSPredicate *modelPredicate = [NSPredicate predicateWithFormat:@"(SELF.amount >= %ld) AND (SELF.amount <= %ld)", [clModel.minAmount integerValue],[clModel.maxAmount integerValue]];
    NSArray *result = [self.rechargeArray filteredArrayUsingPredicate:modelPredicate];
    
    return [NSMutableArray arrayWithArray:result];
}

//根据支付渠道组装固定金额数据
- (NSMutableArray *)filterSolidifyCoinsWithChannel:(RechargeMethodModel *)clModel
{
    NSString *validMoney = clModel.validMoney;
    NSArray *aResult = [validMoney componentsSeparatedByString:@","];
    NSMutableArray *resultArr = [NSMutableArray arrayWithCapacity:aResult.count];
    [aResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RechargeModel *rModel = [[RechargeModel alloc] init];
        rModel.minAmount = clModel.minAmount;              //限制手动输入金额的最小值
        rModel.maxAmount = clModel.maxAmount;              //限制手动输入金额的最大值
        rModel.amount = [obj integerValue];
        NSInteger coinsNum = [clModel.rate integerValue] * [obj integerValue];
        rModel.coinsNum = [NSString stringWithFormat:@"%ld",coinsNum];
        rModel.rechargeStyleType = RechargeStyleTypeNormal;
        [resultArr addObject:rModel];
    }];
    
    return resultArr;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


#pragma mark  -- scrollViewDidScroll
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
    self.selectedSegmentIndex = page;

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
