//
//  LoginController.m
//  DragonLive
//
//  Created by LoaA on 2020/12/11.
//

#import "LoginController.h"
#import <AVFoundation/AVFoundation.h>
#import "XWCountryCodeController.h"
#import "LeftRightTextField.h"
#import "LeftTextRightImageBtn.h"
#import "RegisterController.h"
#import "LoginRegisterProxy.h"
#import "ForgetPwdController.h"
#import "AttributeTapLabel.h"
#import "UserAgreementController.h"
#import "MineProxy.h"
@interface LoginController (){
    CGFloat offsetY;
}

@property (nonatomic, assign) BOOL isHeight;

//1 播放器
@property (strong, nonatomic) AVPlayer *player;

/// 电话
@property (strong, nonatomic) LeftRightTextField *phoneTextField;

/// 密码
@property (strong, nonatomic) LeftRightTextField *passWordTextField;

/// 国家代码选择的按钮
@property (strong, nonatomic) LeftTextRightImageBtn *countryCodeBtn;

/// 登录按钮
@property (strong, nonatomic) UIButton *loginBtn;

/// 验证码和密码登录的按钮选择
@property (strong, nonatomic) UIButton *passCodeBtn;

/// 验证码的按钮
@property (strong, nonatomic) UIButton *codeBtn;

/// 小眼睛btn
@property (nonatomic,strong) UIButton *pswBtn;

/// 是否是密码登录.
@property (assign , nonatomic) BOOL isPsw;

/// 国家代码
@property (nonatomic,strong) NSString *countryCodeString;

@end

@implementation LoginController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = The_MainColor;
    [self initView];
    
    [self addNotification];
    _countryCodeString = @"086";
    _isPsw = YES;
    // Do any additional setup after loading the view.
}

-(void)addNotification
{

        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(playToEnd)
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:nil];
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

    
    
}

-(void)goback
{
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)initView
{
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, 44)];
    topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topView];
    
    UIButton *goback = [[UIButton alloc]initWithFrame:CGRectMake(20, topView.height-kWidth(29), 40, 40)];
    [goback setBackgroundImage:[UIImage imageNamed:@"left-arrow_white"] forState:UIControlStateNormal];
    [topView addSubview:goback];
    goback.center = CGPointMake(goback.centerX, topView.height/2);
    [goback  addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kWidth(57)+kTopHeight, kScreenWidth, kWidth(202))];
    [bgImageView setImage:[UIImage imageNamed:@"login_bg_icon"]];
    [self.view addSubview:bgImageView];
    
    UIButton *registBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-10-60, topView.height-kWidth(29), 60, 40)];
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(registBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    registBtn.center = CGPointMake(registBtn.centerX, topView.height/2);
    [topView addSubview:registBtn];
    
    _countryCodeBtn  = [[LeftTextRightImageBtn alloc]init];
    _countryCodeBtn.size = CGSizeMake(kWidth(68),kWidth(45));
    [_countryCodeBtn setTitle:@"+86" forState:UIControlStateNormal];
//    [_countryCodeBtn setImage:[UIImage imageNamed:@"phone_selected_icon"] forState:UIControlStateNormal];
    [_countryCodeBtn setTitleColor:[UIColor colorFromHexString:@"CCCCCC"] forState:UIControlStateNormal];
    _countryCodeBtn.backgroundColor = [UIColor clearColor];
//    [_countryCodeBtn addTarget:self action:@selector(btnOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _phoneTextField = [[LeftRightTextField alloc]initWithFrame:CGRectMake(kWidth(40),bgImageView.bottom+kWidth(72) , kScreenWidth-kWidth(40*2), kWidth(45))];
    _phoneTextField.backgroundColor = [UIColor colorFromHexString:@"FFFFFF" withAlph:0.05];
    _phoneTextField.textColor = [UIColor colorFromHexString:@"FFFFFF"];
    _phoneTextField.leftView.frame = CGRectMake(0, 0, kWidth(68), kWidth(45));
    _phoneTextField.leftView = _countryCodeBtn;
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTextField.secureTextEntry = YES;
    _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:
        @{NSForegroundColorAttributeName:[UIColor colorFromHexString:@"CCCCCC"],
                     NSFontAttributeName:_phoneTextField.font
             }];
    _phoneTextField.attributedPlaceholder = attrString;
//    _phoneTextField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_phoneTextField];
    
    _passWordTextField =  [[LeftRightTextField alloc]initWithFrame:CGRectMake(kWidth(40),_phoneTextField.bottom+kWidth(15) , kScreenWidth-kWidth(40*2), kWidth(45))];
    _passWordTextField.backgroundColor = [UIColor colorFromHexString:@"FFFFFF" withAlph:0.05];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth(10), kWidth(45))];
    _passWordTextField.textColor = [UIColor colorFromHexString:@"FFFFFF"];

    _passWordTextField.leftView = btn;
    _passWordTextField.leftViewMode = UITextFieldViewModeAlways;
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:
        @{NSForegroundColorAttributeName:[UIColor colorFromHexString:@"CCCCCC"],
                     NSFontAttributeName:_passWordTextField.font}];
    _passWordTextField.attributedPlaceholder = attrString1;
    _passWordTextField.secureTextEntry = YES;
//    _passWordTextField.textAlignment = NSTextAlignmentCenter;
    
    _pswBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth(45), kWidth(45))];
    [self.pswBtn setImage:[UIImage imageNamed:@"login_eye"] forState:UIControlStateSelected];
    [self.pswBtn setImage:[UIImage imageNamed:@"login_eye_closed"] forState:UIControlStateNormal];
    [self.pswBtn addTarget:self action:@selector(eyesBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _passWordTextField.rightView = _pswBtn;
    _passWordTextField.rightViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:_passWordTextField];
    
    _loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(_passWordTextField.left, _passWordTextField.bottom+kWidth(21), _passWordTextField.width, kWidth(42))];
    _loginBtn.backgroundColor = UnSelectedBtnColor;
    _loginBtn.userInteractionEnabled = NO;
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor colorFromHexString:@"FFFFFF"] forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(17)];
    [_loginBtn addTarget:self action:@selector(loginBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    _passCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(_passWordTextField.left, _loginBtn.bottom+kWidth(21), kWidth(120), kWidth(12))];
    _passCodeBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(12)];
    [_passCodeBtn setTitle:@"验证码登录    " forState:UIControlStateNormal];
    [_passCodeBtn setTitle:@"帐号密码登录" forState:UIControlStateSelected];
    [_passCodeBtn addTarget:self action:@selector(passCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_passCodeBtn sizeToFit];
    _passCodeBtn.frame = CGRectMake(_passWordTextField.left, _loginBtn.bottom+kWidth(21), _passCodeBtn.width, _passCodeBtn.height);
    [self.view addSubview:_passCodeBtn];
    
    UIButton *forgetBtn = [[UIButton alloc]initWithFrame:CGRectMake(_loginBtn.right-kWidth(50), _passCodeBtn.top, kWidth(50), kWidth(12))];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(12)];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn sizeToFit];
    forgetBtn.frame = CGRectMake(_loginBtn.right-forgetBtn.width, _passCodeBtn.top, forgetBtn.width, forgetBtn.height);
    [forgetBtn addTarget:self action:@selector(forgetPwdBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];

    NSString *str = @"登录即代表您同意《注册协议》《隐私政策》";
    AttributeTapLabel *messageLab = [[AttributeTapLabel alloc]initWithFrame:CGRectMake(0, kScreenHeight-kTabBarHeight, kScreenWidth, kWidth(13))];
    [self.view addSubview:messageLab];
    AttributeModel *model1 = [[AttributeModel alloc] init];
    model1.range = [str rangeOfString:@"《注册协议》"];
    model1.attributeDic = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:kWidth(13)]};
    model1.string = @"《注册协议》";
    
    AttributeModel *model2 = [[AttributeModel alloc] init];
    model2.range = [str rangeOfString:@"《隐私政策》"];
    model2.attributeDic = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:kWidth(13)]};
    model2.string = @"《隐私政策》";
    
    
    [messageLab setText:str attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:kWidth(13)]}
               tapStringArray:@[model1,model2]];
    [messageLab sizeToFit];
//        messageLab.textAlignment = NSTextAlignmentCenter;
    messageLab.center = CGPointMake(self.view.centerX, messageLab.centerY);
    messageLab.tapBlock = ^(NSString * _Nonnull string) {
        if ([string isEqualToString:@"《注册协议》"]) {
            UserAgreementController *vc = [UserAgreementController new];
            NSString *path = [[NSBundle mainBundle] pathForResource:@"userAgreement" ofType:@"txt"];
            vc.navtitle = @"用户协议";
            vc.path = path;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        if ([string isEqualToString:@"《隐私政策》"]) {
            UserAgreementController *vc = [UserAgreementController new];
            NSString *path = [[NSBundle mainBundle] pathForResource:@"privacyAgreement" ofType:@"txt"];
            vc.navtitle = @"隐私政策";
            vc.path = path;
            [self.navigationController pushViewController:vc animated:YES];        }
    };
    
    kWeakSelf(self);
    //监听手机号
    _phoneTextField.textFieldDidChange = ^(NSString * _Nonnull text) {
        NSLog(@"%@",text);
        if ([weakself.countryCodeString isEqualToString:@"086"]) {
            if (text.length > 11) {
                weakself.phoneTextField.text = [text substringToIndex:11];
            }
        }
        
        
        [weakself noticationCodeBtn];
        [weakself noticationLoginBtn];
    };
    //监听密码
    _passWordTextField.textFieldDidChange = ^(NSString * _Nonnull text) {
        [weakself noticationCodeBtn];
        [weakself noticationLoginBtn];
    };
}



-(void)forgetPwdBtnOnClick
{
    ForgetPwdController *vc = [ForgetPwdController new];
    [self.navigationController pushViewController:vc animated:YES];
}//忘记密码

-(void)loginBtnOnClick
{
    if ([_countryCodeString isEqualToString:@"086"]) {
        //如果是中国手机,做正则处理
        if (![UntilTools isValidateMobile:self.phoneTextField.text]) {
            [self showToast:@"请输入正确手机号"];
            return;
        }
    }
    
    [self loadLoginRequest];
    
}

-(void)loadLoginRequest
{
 
    
    [LoginRegisterProxy registerSaltSuccess:^(NSString * _Nonnull salt) {
//        NSString *md5 = [UntilTools md532BitUpperString:self.passWordTextField.text];
        NSString *string = [UntilTools dealMd532BitString:[UntilTools md532BitUpperString:self.passWordTextField.text] salt:salt];
        //验证码登录
        if (!self->_isPsw) {
            [self codeLoginSalt:salt];

        }else{
            [self passWordLoginWithPass:string salt:salt];
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


-(void)codeLoginSalt:(NSString *)salt
{
    [STTextHudTool showWaitText:@"登录中..."];

    [LoginRegisterProxy loginRequestWithPhoneNum:self.phoneTextField.text userPass:@"" phoneCountryCode:self.countryCodeString loginType:@"1" code:self.passWordTextField.text salt:salt success:^(BOOL isSuccess, int code) {
        [STTextHudTool hideSTHud];
        if (isSuccess) {
            [self showToast:@"登录成功"];
            [self getUserMessage];
        }else{
            if (code == 2001) {
                ZGAlertView *alertView = [[ZGAlertView alloc] initWithTitle:@"您尚未注册，是否立即注册"
                                                       message:nil
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"注册", nil];
                [alertView show];
                
                alertView.dismissBlock = ^(NSInteger clickIndex) {
                    if (clickIndex == 1) {
                        [self registBtnOnClick];
                    }
                };
            }else{
                [UntilTools showErrorCode:code];

            }
            
        }
    } failure:^(NSError * _Nonnull error) {
        [STTextHudTool hideSTHud];
    }];
}//验证码登录


-(void)passWordLoginWithPass:(NSString *)psw salt:(NSString *)salt
{
    [STTextHudTool showWaitText:@"登录中..."];
    [LoginRegisterProxy loginRequestWithPhoneNum:self.phoneTextField.text userPass:psw phoneCountryCode:self.countryCodeString loginType:@"3" code:@"" salt:salt success:^(BOOL isSuccess, int code) {
        [STTextHudTool hideSTHud];
        if (isSuccess) {
           
            [self showToast:@"登录成功"];
            [self getUserMessage];
        }else{
            
            if (code == 2001) {
                ZGAlertView *alertView = [[ZGAlertView alloc] initWithTitle:@"您尚未注册，是否立即注册"
                                                       message:nil
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"注册", nil];
                [alertView show];
                
                alertView.dismissBlock = ^(NSInteger clickIndex) {
                    if (clickIndex == 1) {
                        [self registBtnOnClick];
                    }
                };
            }else{
                [UntilTools showErrorCode:code];
                if (code == 2011) {
                    self->_passCodeBtn.selected = YES;
                    [self showCodeStyle];
                }
            }
            
            //这里根据code 可以进行N多种判断.
        }
    } failure:^(NSError * _Nonnull error) {
        [STTextHudTool hideSTHud];

    }];
}//密码登录.

-(void)getUserMessage
{
    [MineProxy getUserInfoSuccess:^(BOOL success) {
        if (self.loginBlock) {
            self.loginBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError * _Nonnull error) {
        
    }];
   
}//获取用户userMessage

-(void)noticationLoginBtn
{
    if ([UntilTools isValidateMobile:self.phoneTextField.text]&&_passWordTextField.text.length != 0) {
      
        _loginBtn.backgroundColor = SelectedBtnColor;
        _loginBtn.userInteractionEnabled = YES;
          
    }else{
        _loginBtn.backgroundColor = UnSelectedBtnColor;
        _loginBtn.userInteractionEnabled = NO;
    }
}

-(void)noticationCodeBtn
{
    if (!_isPsw) {
        if (!_isHeight) {
        if ([UntilTools isValidateMobile:self.phoneTextField.text]) {
            self.codeBtn.backgroundColor = SelectedBtnColor;
            self.codeBtn.userInteractionEnabled = YES;
        }else{
            self.codeBtn.backgroundColor = UnSelectedBtnColor;
            self.codeBtn.userInteractionEnabled = NO;
        }
        }
    }
}//监听验证吗按钮,



-(void)registBtnOnClick
{
    RegisterController *vc = [RegisterController new];
    //注册成功后回调
//    vc.registerSuccess = ^(NSString * _Nonnull phone, NSString * _Nonnull pwd, NSString * _Nonnull countryCode, NSString * _Nonnull salt) {
//
//        [LoginRegisterProxy loginRequestWithPhoneNum:phone userPass:pwd phoneCountryCode:countryCode loginType:@"3" code:@"" salt:salt success:^(BOOL isSuccess, int code) {
//            if (isSuccess) {
//                [self showToast:@"登录成功"];
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//        } failure:^(NSError * _Nonnull error) {
//
//        }];
//    };
    
    [self.navigationController pushViewController:vc animated:YES];
}//点击注册按钮 ， 注册成功后回调走这里 会自动进行登录操作.

-(void)passCodeBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [self showCodeStyle];
    }else{
        [self showPasswordStyle];
    }
//    [_passCodeBtn sizeToFit];
//    _passCodeBtn.frame = CGRectMake(_passWordTextField.left, _loginBtn.bottom+kWidth(21), _passCodeBtn.width, _passCodeBtn.height);
}//验证码登录还是 密码登录


-(void)showCodeStyle{
    _isPsw = NO;
    //显示验证码登录的一些东西
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:
        @{NSForegroundColorAttributeName:[UIColor colorFromHexString:@"CCCCCC"],
                     NSFontAttributeName:_passWordTextField.font}];
    _passWordTextField.attributedPlaceholder = attrString1;
    _passWordTextField.secureTextEntry = NO;
    _passWordTextField.keyboardType = UIKeyboardTypeNumberPad;
    if (_codeBtn == nil) {
        _codeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth(63), kWidth(45))];
        [_codeBtn setTitle:@"获取" forState:UIControlStateNormal];
        [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(16)];
//            _codeBtn.backgroundColor = SelectedBtnColor;
        if (self.phoneTextField.text.length != 0) {
            _codeBtn.backgroundColor = SelectedBtnColor;
            _codeBtn.userInteractionEnabled = YES;
        }else{
            _codeBtn.backgroundColor = UnSelectedBtnColor;
            _codeBtn.userInteractionEnabled = NO;
        }
        [_codeBtn setCornerWithType:UIRectCornerAllCorners Radius:kWidth(3)];
        [_codeBtn addTarget:self action:@selector(codeBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    self.passWordTextField.rightView = _codeBtn;
    _passWordTextField.rightViewMode = UITextFieldViewModeAlways;
    _passWordTextField.text = @"";
    _loginBtn.backgroundColor = UnSelectedBtnColor;
    _loginBtn.userInteractionEnabled = NO;
}//验证码登录的样式


-(void)showPasswordStyle
{
    _isPsw = YES;
    //显示密码登录的东西
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:@"输入密码" attributes:
        @{NSForegroundColorAttributeName:[UIColor colorFromHexString:@"CCCCCC"],
                     NSFontAttributeName:_passWordTextField.font}];
    _passWordTextField.attributedPlaceholder = attrString1;
    _passWordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _passWordTextField.rightView = _pswBtn;
    _passWordTextField.rightViewMode = UITextFieldViewModeAlways;
    
    _passWordTextField.text = @"";
    _loginBtn.backgroundColor = UnSelectedBtnColor;
    _loginBtn.userInteractionEnabled = NO;
}//显示密码登录

-(void)eyesBtnOnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) { // 按下去了就是明文
        NSString *tempPwdStr = self.passWordTextField.text;
        self.passWordTextField.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.passWordTextField.secureTextEntry = NO;
        self.passWordTextField.text = tempPwdStr;
          
      } else { // 暗文
          
          NSString *tempPwdStr = self.passWordTextField.text;
          self.passWordTextField.text = @"";
          self.passWordTextField.secureTextEntry = YES;
          self.passWordTextField.text = tempPwdStr;
      }
}//小眼睛点击的事件

- (void)codeBtnOnClick
{
    if ([self.countryCodeString isEqualToString:@"086"]) {
        if (![UntilTools isValidateMobile:self.phoneTextField.text]) {
            [self showToast:@"请输入正确手机号"];
            return;
        }
    }
    
    [STTextHudTool showWaitText:@"请求中..."];
    [LoginRegisterProxy regirstLoginVerificationCodeWithPhoneNum:self.phoneTextField.text phoneCountryCode:self.countryCodeString codeType:@"1" success:^(BOOL isSuccess,int code) {
        [STTextHudTool hideSTHud];
        if (isSuccess) {
            [self startTime];
            [self showToast:@"已发送"];
        }else{
            if (code == 2001) {
            
            ZGAlertView *alertView = [[ZGAlertView alloc] initWithTitle:@"您尚未注册，是否立即注册"
                                                   message:nil
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"注册", nil];
            [alertView show];
            
            alertView.dismissBlock = ^(NSInteger clickIndex) {
                if (clickIndex == 1) {
                    [self registBtnOnClick];
                }
            };
        }
        }
    } failure:^(NSError * _Nonnull error) {
        [STTextHudTool hideSTHud];
    }];
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
                self->_isHeight = NO;
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
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
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



- (AVPlayer *)player
{
    if (!_player) {
        //1 创建一个播放item
        NSString *path = [[NSBundle mainBundle]pathForResource:@"register_guide_video.mp4" ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:path];
        AVPlayerItem *playItem = [AVPlayerItem playerItemWithURL:url];
        // 2 播放的设置
        _player = [AVPlayer playerWithPlayerItem:playItem];
        _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;// 永不暂停

        // 3 将图层嵌入到0层
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_player];
        layer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;

        [self.view.layer insertSublayer:layer atIndex:0];
        // 4 播放到头循环播放
    }
    return _player;
}

#pragma mark - 视频播放结束 触发
- (void)playToEnd
{
    // 重头再来
    [self.player seekToTime:kCMTimeZero];
}

#pragma mark - 1 viewWillAppear 就进行播放
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    //视频播放
    [self.player play];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.player pause];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing: YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
