//
//  MineTopView.m
//  DragonLive
//
//  Created by LoaA on 2020/12/9.
//

#import "MineTopView.h"
@interface MineTopView()

/// 头像View
@property (nonatomic, strong) UIImageView *headImg;

/// 等级
@property (nonatomic, strong) UIImageView *levelImg;

/// 姓名
@property (nonatomic, strong) UILabel     *nameLab;

/// 钱币的lab
@property (nonatomic, strong) UILabel     *moneyLab;

/// 登录按钮
@property (nonatomic, strong) UIButton    *loginBtn;


/// 登录提示语
@property (nonatomic, strong) UILabel     *loginMessageLab;


@end
@implementation MineTopView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self  initView];
    }
    return self;
}//init

-(void)initView
{
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.height)];
    img.contentMode = UIViewContentModeScaleToFill;
    [img setImage:[UIImage imageNamed:@"mine_top_view_bg"]];
    [self addSubview:img];
    
    //头像
    _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(20), kTopHeight-kWidth(10), kWidth(61), kWidth(61))];
    [_headImg setImage:[UIImage imageNamed:@"headNomorl"]];
//    [_headImg setCornerWithType:UIRectCornerAllCorners Radius:_headImg.width/2];
    _headImg.layer.masksToBounds = YES;
    _headImg.layer.cornerRadius = _headImg.width/2;
    _headImg.layer.borderWidth = kWidth(3);
    _headImg.layer.borderColor = [UIColor whiteColor].CGColor;
//    _headImg.center = CGPointMake(self.centerX, _headImg.centerY);
    [self addSubview:_headImg];
    
    //登录按钮
    _loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(_headImg.right+kWidth(13), _headImg.top+kWidth(6), kWidth(80), kWidth(25))];
    [_loginBtn setCornerWithType:UIRectCornerAllCorners Radius:_loginBtn.width/2];
    _loginBtn.backgroundColor = [UIColor colorFromHexString:@"000000" withAlph:0.3];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(13)];
    [_loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(loginBtnonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_loginBtn];
    
    _loginMessageLab = [[UILabel alloc]initWithFrame:CGRectMake(_loginBtn.left, _loginBtn.bottom+kWidth(7), kWidth(200), kWidth(13))];
    _loginMessageLab.font = [UIFont systemFontOfSize:kWidth(13)];
    _loginMessageLab.textColor = [UIColor whiteColor];
    _loginMessageLab.text = @"点击登录享受更多精彩功能";
    [self addSubview:_loginMessageLab];
    
    
    //等级
    _levelImg = [[UIImageView alloc]initWithFrame:CGRectMake(_headImg.right-kWidth(27), _headImg.bottom-kWidth(11), kWidth(27), kWidth(11))];
//    [_levelImg setImage:[UIImage imageNamed:@"mine_lev_1"]];
//    _levelImg.backgroundColor = [UIColor redColor];
    _levelImg.hidden = YES;
    [self addSubview:_levelImg];
    
    
    _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _headImg.bottom+kWidth(8), self.width, kWidth(16))];
    _nameLab.textColor = [UIColor colorFromHexString:@"FFFFFF"];
    _nameLab.text = @"隔壁王老五";
    _nameLab.textAlignment = NSTextAlignmentCenter;
    _nameLab.font = [UIFont boldSystemFontOfSize:kWidth(16)];
    _nameLab.hidden = YES;
    [self addSubview:_nameLab];
    
    _moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _nameLab.bottom+kWidth(6), kScreenWidth, kWidth(16))];
    _moneyLab.textColor = [UIColor colorFromHexString:@"FFFFFF"];
    _moneyLab.textAlignment = NSTextAlignmentCenter;
    _moneyLab.font = [UIFont systemFontOfSize:kWidth(12)];
    _moneyLab.hidden = YES;
    [self addSubview:_moneyLab];
    
}//initView



-(void)setModel:(UserModel *)model
{
    _model = model;
    _nameLab.text = _model.nickname;
    _moneyLab.attributedText = _model.coinsAtt;
    [_levelImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"mine_lev_%@",_model.currentGradle]]];
    _headImg.frame = CGRectMake(kWidth(20), kTopHeight-kWidth(10), kWidth(61), kWidth(61));
    _headImg.center = CGPointMake(self.centerX, _headImg.centerY);
    [_headImg sd_setImageWithURL:[NSURL URLWithString:_model.headicon] placeholderImage:[UIImage imageNamed:@"headNomorl"]];
    _levelImg.frame = CGRectMake(_headImg.right-kWidth(27), _headImg.bottom-kWidth(14), kWidth(27), kWidth(11));
    _loginBtn.hidden = YES;
    _loginMessageLab.hidden = YES;
    _levelImg.hidden = NO;
    _nameLab.hidden = NO;
    _moneyLab.hidden = NO;
}


-(void)loginBtnonClick
{
    if (self.loginBtnOnClickBlock) {
        self.loginBtnOnClickBlock();
    }
}




-(void)showLogin
{
    
    _headImg.frame = CGRectMake(kWidth(20), kTopHeight-kWidth(10)+kWidth(25), kWidth(61), kWidth(61));
    [_headImg setImage:[UIImage imageNamed:@"headNomorl"]];
    
    _loginBtn.frame = CGRectMake(_headImg.right+kWidth(13), _headImg.top+kWidth(6), kWidth(80), kWidth(25));
    _loginMessageLab.frame = CGRectMake(_loginBtn.left, _loginBtn.bottom+kWidth(7), kWidth(200), kWidth(13));

    _loginBtn.hidden = NO;
    _loginMessageLab.hidden = NO;
    _levelImg.hidden = YES;
    _nameLab.hidden = YES;
    _moneyLab.hidden = YES;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
