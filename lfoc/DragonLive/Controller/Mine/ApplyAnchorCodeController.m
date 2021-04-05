//
//  ApplyAnchorCodeController.m
//  DragonLive
//
//  Created by LoaA on 2020/12/29.
//

#import "ApplyAnchorCodeController.h"
#import "LeftRightTextField.h"
#import "LeftTextRightImageBtn.h"
#import "XWCountryCodeController.h"
#import "ApplyAnchorDataController.h"
#import "MineProxy.h"
#import "ZGAlertView.h"

@interface ApplyAnchorCodeController ()

@property (nonatomic, assign) BOOL isHeight;

/// 电话
@property (strong, nonatomic) LeftRightTextField *phoneTextField;

/// 密码
@property (strong, nonatomic) LeftRightTextField *passWordTextField;

/// 国家代码选择的按钮
@property (strong, nonatomic) LeftTextRightImageBtn *countryCodeBtn;

/// 国家代码
@property (nonatomic,strong) NSString *countryCodeString;

/// 验证码
@property (strong, nonatomic) LeftRightTextField *codeTextField;

/// 验证码的按钮
@property (strong, nonatomic) UIButton *codeBtn;

/// 下一步按钮
@property (strong, nonatomic) UIButton *nextBtn;

@end

@implementation ApplyAnchorCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    _countryCodeString = @"086";
    self.navigationItem.title = @"申请直播";

    self.view.backgroundColor = The_MainColor;
    
    [self initNavItem];
    [self initView];
    [self addNotification];

    // Do any additional setup after loading the view.
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
}//增加

-(void)keyboardWasShown:(NSNotification *)notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    
    CGSize keyboardSize = [value CGRectValue].size;
    
    //DLog(@"keyBoard:%f", keyboardSize.height);
    
    
    
    if (keyboardSize.height>0 && _phoneTextField.secureTextEntry == YES) {
        //不让换键盘的textField的
        _phoneTextField.secureTextEntry = NO;
        
    }
    
    if (keyboardSize.height>0 && _codeTextField.secureTextEntry == YES) {
        _codeTextField.secureTextEntry = NO;
    }
    
}

-(void)initView
{
    _countryCodeBtn  = [[LeftTextRightImageBtn alloc]init];
    _countryCodeBtn.size = CGSizeMake(kWidth(68),kWidth(45));
    [_countryCodeBtn setTitle:@"+86" forState:UIControlStateNormal];
//    [_countryCodeBtn setImage:[UIImage imageNamed:@"phone_selected_icon"] forState:UIControlStateNormal];
    [_countryCodeBtn setTitleColor:[UIColor colorFromHexString:@"CCCCCC"] forState:UIControlStateNormal];
    _countryCodeBtn.backgroundColor = [UIColor clearColor];
//    [_countryCodeBtn addTarget:self action:@selector(btnOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _phoneTextField = [[LeftRightTextField alloc]initWithFrame:CGRectMake(kWidth(40),kWidth(18) , kScreenWidth-kWidth(40*2), kWidth(45))];
    _phoneTextField.backgroundColor = [UIColor colorFromHexString:@"FFFFFF" withAlph:0.05];
    _phoneTextField.leftView.frame = CGRectMake(0, 0, kWidth(68), kWidth(45));
    _phoneTextField.leftView = _countryCodeBtn;
    _phoneTextField.secureTextEntry = YES;
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    NSLog(@"%@",[UserInstance shareInstance].userModel.userName);
    _phoneTextField.text = [UserInstance shareInstance].userModel.userName;
    _phoneTextField.userInteractionEnabled = NO;
    _phoneTextField.layer.borderColor = [UIColor colorFromHexString:@"#ECECEC"].CGColor;
    _phoneTextField.layer.borderWidth = 1;
    _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:
                                      @{NSForegroundColorAttributeName:[UIColor colorFromHexString:@"CCCCCC"],
                                        NSFontAttributeName:_phoneTextField.font
                                      }];
    _phoneTextField.attributedPlaceholder = attrString;
    //    _phoneTextField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_phoneTextField];
    
    _codeTextField =  [[LeftRightTextField alloc]initWithFrame:CGRectMake(kWidth(40),_phoneTextField.bottom+kWidth(20) , kScreenWidth-kWidth(40*2), kWidth(45))];
    _codeTextField.layer.borderColor = [UIColor colorFromHexString:@"#ECECEC"].CGColor;
    _codeTextField.layer.borderWidth = 1;
    
    _codeTextField.backgroundColor = [UIColor colorFromHexString:@"FFFFFF" withAlph:0.05];
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth(10), kWidth(45))];
    _codeTextField.leftView = btn1;
//    _codeTextField.textColor = [UIColor colorFromHexString:@"FFFFFF"];
    _codeTextField.leftViewMode = UITextFieldViewModeAlways;
    NSAttributedString *attrString2 = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:
                                       @{NSForegroundColorAttributeName:[UIColor colorFromHexString:@"CCCCCC"],
                                         NSFontAttributeName:_phoneTextField.font}];
    _codeTextField.attributedPlaceholder = attrString2;
    _codeTextField.secureTextEntry = YES;
    _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_codeTextField];
    
    //获取验证码按钮
    _codeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth(63), kWidth(45))];
    [_codeBtn setTitle:@"获取" forState:UIControlStateNormal];
    [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _codeBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(16)];
        _codeBtn.backgroundColor = SelectedBtnColor;
//    _codeBtn.backgroundColor = [UIColor colorFromHexString:@"777777"];
//    _codeBtn.userInteractionEnabled = NO;
    [_codeBtn setCornerWithType:UIRectCornerAllCorners Radius:kWidth(3)];
    [_codeBtn addTarget:self action:@selector(codeBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    self.codeTextField.rightView = _codeBtn;
    self.codeTextField.rightViewMode = UITextFieldViewModeAlways;
    
    _nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(_codeTextField.left, _codeTextField.bottom+kWidth(21), _codeTextField.width, kWidth(42))];
    _nextBtn.backgroundColor = UnSelectedBtnColor;
    _nextBtn.userInteractionEnabled = NO;
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor colorFromHexString:@"FFFFFF"] forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(17)];
    [_nextBtn addTarget:self action:@selector(nextBtnOnClick)
       forControlEvents:UIControlEventTouchUpInside];
    [_nextBtn setCornerWithType:UIRectCornerAllCorners Radius:_nextBtn.width/2];
    [self.view addSubview:_nextBtn];
    
    kWeakSelf(self);
    
    //监听手机号
    _phoneTextField.textFieldDidChange = ^(NSString * _Nonnull text) {
        NSLog(@"%@",text);
        [weakself noticationCodeBtn];
        [weakself noticationNextBtn];
    };
    
    //监听验证码
    _codeTextField.textFieldDidChange = ^(NSString * _Nonnull text) {
        [weakself noticationNextBtn];
    };
    
}


-(void)initNavItem{
    UIButton  *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn addTarget:self action:@selector(popViewcontrollerFunc) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"left-arrow"]  forState:UIControlStateNormal];
    UIBarButtonItem *barLeftBtn = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    
    [self.navigationItem setLeftBarButtonItem:barLeftBtn];
}

- (void)popViewcontrollerFunc {
    ZGAlertView *alertView = [[ZGAlertView alloc] initWithTitle:@"确认退出认证流程？"
                                                        message:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"退出", nil];
    [alertView show];
    
    alertView.dismissBlock = ^(NSInteger clickIndex) {
        
        if (clickIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
}

-(void)nextBtnOnClick
{
    if ([_countryCodeString isEqualToString:@"086"]) {
        if (![UntilTools isValidateMobile:_phoneTextField.text] && _codeTextField.text.length != 6) {
            [[HCToast shareInstance]showToast:@"请检查输入的手机号和验证码"];
            return;
        }
    }
    
    [STTextHudTool showWaitText:@"请求中..."];
    [MineProxy verificationCodeCompareWithCode:_codeTextField.text success:^(BOOL success) {
        [STTextHudTool hideSTHud];
        ApplyAnchorDataController *vc = [ApplyAnchorDataController new];
        vc.phoneText = self->_phoneTextField.text;
        vc.codeText  = self->_codeTextField.text;
        [self.navigationController pushViewController:vc animated:YES];
        } failure:^(NSError * _Nonnull error) {
            [STTextHudTool hideSTHud];
        }];
    
}//


-(void)codeBtnOnClick
{
    if (![UntilTools isValidateMobile:_phoneTextField.text])
    {
        [[HCToast shareInstance]showToast:@"请检查输入的手机号"];
        return;
    }
    
    
    [STTextHudTool showWaitText:@"请求中..."];
    //验证码点击
    [MineProxy getHostVerificationCodeWithPhone:_phoneTextField.text success:^(BOOL success) {
        [STTextHudTool hideSTHud];
        if (success) {
            [self showToast:@"已发送"];
            [self startTime];
        }
    } failure:^(NSError * _Nonnull error) {
        [STTextHudTool hideSTHud];
    }];
    
}//验证码点击


-(void)noticationCodeBtn
{
    if (!_isHeight) {
        if (self.phoneTextField.text.length != 0) {
            self.codeBtn.backgroundColor = SelectedBtnColor;
            self.codeBtn.userInteractionEnabled = YES;
        }else{
            self.codeBtn.backgroundColor = UnSelectedBtnColor;
            self.codeBtn.userInteractionEnabled = NO;
        }
    }
    
  
}

-(void)noticationNextBtn
{
    if (self.phoneTextField.text != 0 && self.codeTextField.text.length != 0) {
        _nextBtn.backgroundColor = SelectedBtnColor;
        _nextBtn.userInteractionEnabled = YES;
    }
    else{
        _nextBtn.backgroundColor = UnSelectedBtnColor;
        _nextBtn.userInteractionEnabled = NO;
    }
}



-(void)btnOnClick
{
    XWCountryCodeController *countryCodeVC = [[XWCountryCodeController alloc] init];
    __weak __typeof(self)weakSelf = self;
    countryCodeVC.returnCountryCodeBlock = ^(NSString *countryName, NSString *code) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf->_countryCodeBtn setTitle:[NSString stringWithFormat:@"+%@",code] forState:UIControlStateNormal];
        strongSelf->_countryCodeString = [UntilTools dealCountryCode:code];
    };
    
    [self.navigationController pushViewController:countryCodeVC animated:YES];
}

-(void)startTime
{
    _isHeight = YES;
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self->_codeBtn setTitle:@"获取" forState:UIControlStateNormal];
                self->_codeBtn.backgroundColor = SelectedBtnColor;
                self->_codeBtn.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                self->_codeBtn.backgroundColor = UnSelectedBtnColor;
                [self->_codeBtn setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                self->_codeBtn.userInteractionEnabled = NO;
                self->_isHeight = NO;

            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
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
