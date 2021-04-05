//
//  RechargeView.m
//  DragonLive
//
//  Created by LoaA on 2020/12/11.
//

#import "RechargeView.h"
#import "RechargeCollectionView.h"
#import "RechargeMethodCollectionView.h"
@interface RechargeView ()

/// 余额
@property (nonatomic, strong) UILabel *balanceLab;

/// 充值按钮
@property (nonatomic, strong) UIButton *submitBtn;

/// 金额框
@property (nonatomic, strong) RechargeCollectionView *rechargeView;

/// 支付方式选择框
@property (nonatomic, strong) RechargeMethodCollectionView *rechargeMethodView;

@end

@implementation RechargeView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self endEditing:YES];
        [self initView];
    }
    return self;
}

-(void)initView
{
    kWeakSelf(self);

    UIView *balanceBG = [[UIView alloc]initWithFrame:CGRectMake(0, kWidth(11), kScreenWidth, kWidth(52))];
    balanceBG.backgroundColor = [UIColor whiteColor];
    [self addSubview:balanceBG];
    
    
    _balanceLab = [[UILabel alloc]initWithFrame:CGRectMake(kWidth(19), 0, kScreenWidth-kWidth(19*2), kWidth(16))];
    _balanceLab.center = CGPointMake(_balanceLab.centerX, balanceBG.centerY);

    _balanceLab.textColor = [UIColor colorFromHexString:@"333333"];
    _balanceLab.text = [NSString stringWithFormat:@"余额:%@龙币",[UserInstance shareInstance].userModel.coins];
    _balanceLab.font = [UIFont systemFontOfSize:kWidth(16)];
    [self addSubview:_balanceLab];
    
    
    UIView *rechargeBG = [[UIView alloc]initWithFrame:CGRectMake(0, balanceBG.bottom+kWidth(10), self.width, kWidth(385))];
    rechargeBG.backgroundColor = [UIColor whiteColor];
//    rechargeBG.backgroundColor = [UIColor greenColor];

    [self addSubview:rechargeBG];
    
    UILabel *waytLab = [[UILabel alloc]initWithFrame:CGRectMake(_balanceLab.left, rechargeBG.top+kWidth(15), _balanceLab.width, kWidth(16))];
    waytLab.textColor = [UIColor colorFromHexString:@"333333"];
    waytLab.text = @"请选择充值方式";
    waytLab.font = [UIFont boldSystemFontOfSize:kWidth(16)];
    [self addSubview:waytLab];
    
    
    _rechargeMethodView = [[RechargeMethodCollectionView alloc]initWithFrame:CGRectMake(0, waytLab.bottom+kWidth(20), kScreenWidth, kWidth(100))];
    [self addSubview:_rechargeMethodView];
    _rechargeMethodView.collectionViewDidSelectBlock = ^(RechargeMethodModel * _Nonnull model) {
        if (weakself.rechargeMethodItemDidSelectBlock) {
            weakself.rechargeMethodItemDidSelectBlock(model);
        }
    };
    
    
    UILabel *promptLab = [[UILabel alloc]initWithFrame:CGRectMake(_balanceLab.left, _rechargeMethodView.bottom+kWidth(10), _balanceLab.width, kWidth(16))];
    promptLab.textColor = [UIColor colorFromHexString:@"333333"];
    promptLab.text = @"请选择充值金额";
    promptLab.font = [UIFont boldSystemFontOfSize:kWidth(16)];
    [self addSubview:promptLab];
    
    _rechargeView = [[RechargeCollectionView alloc]initWithFrame:CGRectMake(0, promptLab.bottom+kWidth(20), kScreenWidth, kWidth(100))];
    _rechargeView.collectionViewDidSelectBlock = ^(RechargeModel * _Nonnull model) {
        if (weakself.rechargeItemDidSelectBlock) {
            weakself.rechargeItemDidSelectBlock(model);
        }
    };
    
    [self addSubview:_rechargeView];
    
    
    UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.width-kWidth(295))/2, rechargeBG.bottom-kWidth(41+30), kWidth(295), kWidth(41))];
    [submitBtn setTitle:@"立即充值" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(19)];
    submitBtn.backgroundColor = SelectedBtnColor;
    [submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setCornerWithType:UIRectCornerAllCorners Radius:submitBtn.width/2];
    [self addSubview:submitBtn];
    self.submitBtn = submitBtn;

}//init

- (void)submitAction
{
    if (self.submitBlock) {
        self.submitBlock();
    }
}

-(void)setRechargeArray:(NSMutableArray *)rechargeArray
{
    _rechargeArray = rechargeArray;
    _rechargeView.dataArray = _rechargeArray;
}//充值的数据源


-(void)setRechargeMethodArray:(NSMutableArray *)rechargeMethodArray
{
    _rechargeMethodArray = rechargeMethodArray;
    _rechargeMethodView.dataArray = _rechargeMethodArray;
}//充值方式数据源


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}//解除键盘的第一响应
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
