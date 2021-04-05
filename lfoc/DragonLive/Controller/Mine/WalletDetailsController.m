//
//  WalletDetailsController.m
//  DragonLive
//
//  Created by LoaA on 2020/12/30.
//

#import "WalletDetailsController.h"
#import "ZRGridView.h"
#import "LeftTextRightImageBtn.h"
#import "LBYearMonthPickerVC.h"
#import "XDSDropDownMenu.h"
#import "MineProxy.h"
#import "WalletRecordModel.h"
#import "DropDownMenuModel.h"
#import "DREmptyView.h"

@interface WalletDetailsController ()<ZRGridViewDelegate,ZRGridViewDataSource,XDSDropDownMenuDelegate>


/// 日期选择按钮
@property (nonatomic, strong) LeftTextRightImageBtn *dateBtn;

/// 上面的横排.
@property (nonatomic, strong) NSArray *columnsArray;

/// 类型btn
@property (nonatomic, strong) LeftTextRightImageBtn *typeBtn;

/// 下拉菜单
@property (nonatomic, strong) XDSDropDownMenu *dropDownMenu;

/// 下拉菜单数组
@property (nonatomic, strong) NSArray *dropDownMenuArray;

@property (nonatomic, strong) NSMutableArray *dropModelArray;


/// 数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

/// 表
@property (nonatomic, strong) ZRGridView *gridView;

/// 时间字符串
@property (nonatomic, strong) NSString *dateString;

/// 类型string
@property (nonatomic, strong) NSString *typeString;

@end

@implementation WalletDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"账户明细";
    self.view.backgroundColor = The_MainColor;
    [self getYYYYMM];
    self.typeString = @"";
    [self initView];
    [self initDropDownMenu];
    
    // Do any additional setup after loading the view.
}


-(void)getYYYYMM
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
       // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
       [formatter setDateFormat:@"yyyy-MM"];
       //现在时间,你可以输出来看下是什么格式
       NSDate *datenow = [NSDate date];
       //----------将nsdate按formatter格式转成nsstring
    self.dateString = [formatter stringFromDate:datenow];
}

-(void)loadRequestPage:(NSInteger)page
{
    kWeakSelf(self);
    [MineProxy walletFindRecordWithPage:page bType:self.typeString queryTime:self.dateString success:^(NSMutableArray * _Nonnull obj) {
        weakself.dataArray = obj;
        [self->_gridView endRefresh];
        } failure:^(NSError * _Nonnull error) {
            [self->_gridView endRefresh];
        }];
}


-(void)setDataArray:(NSMutableArray *)dataArray{
    if (_gridView.page == 1) {
        _dataArray = dataArray;
    }else{
        [_dataArray addObjectsFromArray:dataArray];
    }
    
    if (_dataArray.count != 0 && dataArray.count < 10) {
        _gridView.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
    }else{
        _gridView.collectionView.mj_footer.state = MJRefreshStateIdle;
    }
    [_gridView reloadData];
    
    if (!self.dataArray || self.dataArray.count == 0) {
        [DREmptyView showEmptyInView:_gridView.collectionView emptyType:DREmptyDataType];
    }else {
        [DREmptyView hiddenEmptyInView:_gridView.collectionView];
    }
}


-(void)initDropDownMenu
{
    if ([[UserInstance shareInstance].userModel.userType isEqualToString:@"2"]) {
        _dropDownMenuArray = @[@"全部",@"充值入账",@"提现出账",@"冻结",@"解冻",@"礼物支出",@"礼物收入",@" 任务收入",@"冲正"];
    }else{
        _dropDownMenuArray = @[@"全部",@"充值入账",@"礼物支出",@" 任务收入",@"冲正"];
    }
    _dropModelArray = [NSMutableArray new];
    for (int i=0; i<_dropDownMenuArray.count; i++) {
        DropDownMenuModel *model = [DropDownMenuModel new];
        if (i == 0) {
            model.item_id = @"";
        }else{
            model.item_id = [NSString stringWithFormat:@"%d",i];
        }
        model.name = _dropDownMenuArray[i];
        [_dropModelArray addObject:model];
    }
    
    _dropDownMenu = [[XDSDropDownMenu alloc] init];
    _dropDownMenu.tag = 1000;
    _dropDownMenu.delegate = self;//设置代理
}//下拉菜单

-(void)initView{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
       // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
       [formatter setDateFormat:@"yyyy/MM"];
       //现在时间,你可以输出来看下是什么格式
       NSDate *datenow = [NSDate date];
       //----------将nsdate按formatter格式转成nsstring
    NSString *title = [formatter stringFromDate:datenow];
    _dateBtn = [[LeftTextRightImageBtn alloc]initWithFrame:CGRectMake(15, kWidth(10), kWidth(80), kWidth(26))];
    [_dateBtn setTitle:title forState:UIControlStateNormal];
    _dateBtn.layer.borderColor = [UIColor colorFromHexString:@"BCBCBC"].CGColor;
    _dateBtn.layer.borderWidth = 0.67;
    _dateBtn.layer.cornerRadius = 3.33; 
    _dateBtn.layer.masksToBounds = YES;
    [_dateBtn setImage:[UIImage imageNamed:@"zhmx_zk"] forState:UIControlStateNormal];
    _dateBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(13)];
    [_dateBtn setTitleColor:[UIColor colorFromHexString:@"2B2B2B"] forState:UIControlStateNormal];
    [_dateBtn addTarget:self action:@selector(dateBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_dateBtn];
    
    
    _typeBtn = [[LeftTextRightImageBtn alloc]initWithFrame:CGRectMake(kScreenWidth-15-kWidth(80), kWidth(10), kWidth(80), kWidth(26))];
    [_typeBtn setTitle:@"全部" forState:UIControlStateNormal];
    _typeBtn.layer.borderColor = [UIColor colorFromHexString:@"BCBCBC"].CGColor;
    _typeBtn.layer.borderWidth = 0.67;
    _typeBtn.layer.cornerRadius = 3.33; 
    _typeBtn.layer.masksToBounds = YES;
    [_typeBtn setImage:[UIImage imageNamed:@"zhmx_zk"] forState:UIControlStateNormal];
    _typeBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(13)];
    [_typeBtn addTarget:self action:@selector(typeBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [_typeBtn setTitleColor:[UIColor colorFromHexString:@"2B2B2B"] forState:UIControlStateNormal];
    [self.view addSubview:_typeBtn];
    
    
    _columnsArray = @[@"时间",@"交易类型",@"收支",@"余额"];
    
    ZRGridViewLayoutAndStyle *gridViewLayout = [[ZRGridViewLayoutAndStyle alloc] init];
    gridViewLayout.showGridLine = YES;
    gridViewLayout.headerBackgroudColor = [UIColor colorFromHexString:@"BCBCBC"];
    gridViewLayout.fieldTitleColor = [UIColor colorFromHexString:@"333333"];
    
    
    _gridView = [[ZRGridView alloc] initWithFrame:CGRectMake(15, kWidth(45), kkScreenWidth-30, kScreenHeight-kNavBarAndStatusBarHeight-kWidth(45) - 10) gridViewLayoutAndStyle:gridViewLayout];
    _gridView.gridViewDelegate = self;
    _gridView.gridViewDataSource = self;
    [self.view addSubview:_gridView];
    
    [_gridView.collectionView.mj_header beginRefreshing];
    
    kWeakSelf(self);
    //头部block
    _gridView.headerBlock = ^(NSInteger page) {
        [weakself loadRequestPage:page];
    };
    _gridView.footerBlock = ^(NSInteger page) {
        [weakself loadRequestPage:page];
    };
}


-(void)typeBtnOnClick
{
    CGRect btnFrame = _typeBtn.frame; //如果按钮在UIIiew上用这个
    
    if (_dropDownMenu.tag == 1000) {
        [_dropDownMenu showDropDownMenu:_typeBtn withButtonFrame:btnFrame arrayOfTitle:_dropDownMenuArray arrayOfImage:nil animationDirection:@"down"];
        [self.view addSubview:_dropDownMenu];
        _dropDownMenu.tag = 2000;


    }else{
        [_dropDownMenu hideDropDownMenuWithBtnFrame:btnFrame];
        _dropDownMenu.tag = 1000;
    }

}//类型按钮点击

#pragma mark - 下拉菜单代理
/*
 在点击下拉菜单后，将其tag值重新设为1000
 */

- (void)setDropDownDelegate:(XDSDropDownMenu *)sender index:(NSInteger)index{
    sender.tag = 1000;
    DropDownMenuModel *model = _dropModelArray[index];
    self.typeString = model.item_id;
    [self->_gridView.collectionView.mj_header beginRefreshing];
    [_typeBtn setTitle:model.name forState:UIControlStateNormal];
    [_typeBtn setImage:[UIImage imageNamed:@"zhmx_zk"] forState:UIControlStateNormal];
    
}


-(void)dateBtnOnClick
{
    LBYearMonthPickerVC *vc = [[LBYearMonthPickerVC alloc] init];
    vc.view.layer.cornerRadius = 10;
    [self presentViewController:vc animated:YES completion:nil];
    vc.pickerViewSelectDate = ^(NSString * _Nonnull yearString, NSString * _Nonnull monthString) {
        NSLog(@"%@年%@月",yearString,monthString);
        [self->_dateBtn setTitle:[NSString stringWithFormat:@"%@/%@",yearString,monthString] forState:UIControlStateNormal];
        self->_dateString = [NSString stringWithFormat:@"%@-%@",yearString,monthString];
        [self->_gridView.collectionView.mj_header beginRefreshing];
       
    };
    
}//日期选择执行


#pragma mark - ZRGridViewDataSource
- (NSInteger)numberOfColumnsInGridView:(ZRGridView *)gridView{
    return _columnsArray.count;
}//返回列

- (NSInteger)numberOfRowsInGridView:(ZRGridView *)gridView{
    return _dataArray.count;
}//返回行

- (NSString *)gridView:(ZRGridView *)gridView titleOfColumnsAtIndex:(NSInteger)index{
    return _columnsArray[index];
}//列的section名字

- (NSString *)gridView:(ZRGridView *)gridView valueAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex{
    WalletRecordModel *model = _dataArray[rowIndex];
    return model.rowArray[columnIndex];
}//每一行的名字

- (UIColor *)gridView:(ZRGridView *)gridView itemBackgroudColorAtRow:(NSInteger)rowIndex column:(NSInteger)column{
        return [UIColor whiteColor];
}//返回的颜色

- (CGFloat)gridView:(ZRGridView *)gridView widthForColumn:(NSInteger)index{
    return (kkScreenWidth-30)/4.0;
}//高度

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
