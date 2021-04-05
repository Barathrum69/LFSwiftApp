//
//  ExtractCashView.m
//  DragonLive
//
//  Created by LoaA on 2020/12/11.
//

#import "ExtractCashView.h"
#import "RevenueInfoModel.h"

@interface ExtractCashView()

/// 当前虚拟币金额
@property (nonatomic,strong) UILabel *virtualCurrency;

/// 可兑换虚拟币
@property (nonatomic,strong) UILabel *convertibleVirtualCurrency;

/// 可兑换人民币
@property (nonatomic,strong) UILabel *convertibleRMB;

@property (nonatomic,strong) UIButton *submitBut;

@end
@implementation ExtractCashView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initView];

    }
    return self;
}//init

-(void)initView
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, kWidth(11), kScreenWidth, kWidth(225))];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    //可兑换虚拟币
    _virtualCurrency = [[UILabel alloc]initWithFrame:CGRectMake(kWidth(27), kWidth(30), self.width-kWidth(27*2), kWidth(15))];
    [self addSubview:_virtualCurrency];
    
    //可以换成人民币的虚拟币数量
    _convertibleVirtualCurrency = [[UILabel alloc]initWithFrame:CGRectMake(_virtualCurrency.left, _virtualCurrency.bottom+kWidth(22), _virtualCurrency.width, _virtualCurrency.height)];
    [self addSubview:_convertibleVirtualCurrency];
    
    //可以换成多少人民币
    _convertibleRMB = [[UILabel alloc]initWithFrame:CGRectMake(_virtualCurrency.left, _convertibleVirtualCurrency.bottom+kWidth(22), _virtualCurrency.width, _virtualCurrency.height)];
    [self addSubview:_convertibleRMB];

    _virtualCurrency.font = _convertibleVirtualCurrency.font = _convertibleRMB.font = [UIFont systemFontOfSize:kWidth(15)];
    _virtualCurrency.textColor = _convertibleVirtualCurrency.textColor = _convertibleRMB.textColor = [UIColor colorFromHexString:@"333333"];
    
    UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.width-kWidth(295))/2, _convertibleRMB.bottom+kWidth(33), kWidth(295), kWidth(41))];
    [submitBtn setTitle:@"申请提现" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(19)];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"common_orangeBg"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setCornerWithType:UIRectCornerAllCorners Radius:submitBtn.width/2];
    [self addSubview:submitBtn];
    self.submitBut = submitBtn;
    
}//initView

- (void)submitAction
{
    if (self.sendRevenueBlock) {
        self.sendRevenueBlock();
    }
}

- (void)setExtractCashViewRevenueModel:(RevenueInfoModel *)rmodel
{
    if ([rmodel.money integerValue] <= 0) {
        self.submitBut.enabled = NO;
    }else {
        self.submitBut.enabled = YES;
    }
    _virtualCurrency.text = [NSString stringWithFormat:@"当前龙币余额：%@",rmodel.allstar];
    _convertibleVirtualCurrency.text = [NSString stringWithFormat:@"当前可兑换龙币：%@",rmodel.availablestar];
    _convertibleRMB.text = [NSString stringWithFormat:@"可兑换人民币：%@",rmodel.money];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}  //点击响应
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
