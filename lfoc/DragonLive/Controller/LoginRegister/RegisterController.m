//
//  LoginController.m
//  DragonLive
//
//  Created by LoaA on 2020/12/11.
//

#import "RegisterController.h"
#import <AVFoundation/AVFoundation.h>
#import "XWCountryCodeController.h"
#import "LeftRightTextField.h"
#import "LeftTextRightImageBtn.h"
#import "LoginRegisterProxy.h"
#import "AttributeTapLabel.h"
#import "UserAgreementController.h"
#import "ZGAlertView.h"
@interface RegisterController (){
    CGFloat offsetY;
}
@property (nonatomic, assign) BOOL isHeight;

//1 播放器
@property (strong, nonatomic) AVPlayer *player;

/// 电话
@property (strong, nonatomic) LeftRightTextField *phoneTextField;

/// 密码
@property (strong, nonatomic) LeftRightTextField *passWordTextField;

/// 验证码
@property (strong, nonatomic) LeftRightTextField *codeTextField;

/// 国家代码选择的按钮
@property (strong, nonatomic) LeftTextRightImageBtn *countryCodeBtn;

/// 注册按钮
@property (strong, nonatomic) UIButton *registerBtn;

/// 验证码和密码登录的按钮选择
@property (strong, nonatomic) UIButton *passCodeBtn;

/// 验证码的按钮
@property (strong, nonatomic) UIButton *codeBtn;

/// 小眼睛btn
@property (nonatomic,strong) UIButton *pswBtn;

/// 国家代码
@property (nonatomic,strong) NSString *countryCodeString;

@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = The_MainColor;
    
    _countryCodeString = @"086";
    
    [self initView];
    [self addNotification];
    
    // Do any additional setup after loading the view.
}


-(void)addNotification{
    
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
    
    if (keyboardSize.height>0 && _codeTextField.secureTextEntry == YES) {
        _codeTextField.secureTextEntry = NO;
    }
}

-(void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}//返回

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
    
    
    _countryCodeBtn  = [[LeftTextRightImageBtn alloc]init];
    _countryCodeBtn.size = CGSizeMake(kWidth(68),kWidth(45));
    [_countryCodeBtn setTitle:@"+86" forState:UIControlStateNormal];
//    [_countryCodeBtn setImage:[UIImage imageNamed:@"phone_selected_icon"] forState:UIControlStateNormal];
    [_countryCodeBtn setTitleColor:[UIColor colorFromHexString:@"CCCCCC"] forState:UIControlStateNormal];
    _countryCodeBtn.backgroundColor = [UIColor clearColor];
    //    [_countryCodeBtn addTarget:self action:@selector(btnOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _phoneTextField = [[LeftRightTextField alloc]initWithFrame:CGRectMake(kWidth(40),bgImageView.bottom+kWidth(17) , kScreenWidth-kWidth(40*2), kWidth(45))];
    _phoneTextField.backgroundColor = [UIColor colorFromHexString:@"FFFFFF" withAlph:0.05];
    _phoneTextField.leftView.frame = CGRectMake(0, 0, kWidth(68), kWidth(45));
    _phoneTextField.textColor = [UIColor colorFromHexString:@"FFFFFF"];
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
    _passWordTextField.leftView = btn;
    _passWordTextField.textColor = [UIColor colorFromHexString:@"FFFFFF"];
    
    _passWordTextField.leftViewMode = UITextFieldViewModeAlways;
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:@"请输入密码(6-10位字母和数字)" attributes:
                                       @{NSForegroundColorAttributeName:[UIColor colorFromHexString:@"CCCCCC"],
                                         NSFontAttributeName:_passWordTextField.font}];
    _passWordTextField.attributedPlaceholder = attrString1;
    _passWordTextField.secureTextEntry = YES;
    //    _passWordTextField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_passWordTextField];
    
    _pswBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth(45), kWidth(45))];
    [self.pswBtn setImage:[UIImage imageNamed:@"login_eye"] forState:UIControlStateSelected];
    [self.pswBtn setImage:[UIImage imageNamed:@"login_eye_closed"] forState:UIControlStateNormal];
    [self.pswBtn addTarget:self action:@selector(eyesBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _passWordTextField.rightView = _pswBtn;
    _passWordTextField.rightViewMode = UITextFieldViewModeAlways;
    //    [_passWordTextField addSubview:self.pswBtn];
    
    
    _codeTextField =  [[LeftRightTextField alloc]initWithFrame:CGRectMake(kWidth(40),_passWordTextField.bottom+kWidth(15) , kScreenWidth-kWidth(40*2), kWidth(45))];
    _codeTextField.backgroundColor = [UIColor colorFromHexString:@"FFFFFF" withAlph:0.05];
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth(10), kWidth(45))];
    _codeTextField.leftView = btn1;
    _codeTextField.textColor = [UIColor colorFromHexString:@"FFFFFF"];
    _codeTextField.leftViewMode = UITextFieldViewModeAlways;
    NSAttributedString *attrString2 = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:
                                       @{NSForegroundColorAttributeName:[UIColor colorFromHexString:@"CCCCCC"],
                                         NSFontAttributeName:_passWordTextField.font}];
    _codeTextField.attributedPlaceholder = attrString2;
    _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    _codeTextField.secureTextEntry = YES;

    [self.view addSubview:_codeTextField];
    
    //获取验证码按钮
    _codeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth(63), kWidth(45))];
    [_codeBtn setTitle:@"获取" forState:UIControlStateNormal];
    [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _codeBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(16)];
    //    _codeBtn.backgroundColor = SelectedBtnColor;
    _codeBtn.backgroundColor = UnSelectedBtnColor;
    _codeBtn.userInteractionEnabled = NO;
    [_codeBtn setCornerWithType:UIRectCornerAllCorners Radius:kWidth(3)];
    [_codeBtn addTarget:self action:@selector(codeBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    self.codeTextField.rightView = _codeBtn;
    self.codeTextField.rightViewMode = UITextFieldViewModeAlways;
    
    //注册按钮
    _registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(_passWordTextField.left, _codeTextField.bottom+kWidth(21), _passWordTextField.width, kWidth(42))];
    //    _registerBtn.backgroundColor = SelectedBtnColor;
    _registerBtn.backgroundColor = UnSelectedBtnColor;
    _registerBtn.userInteractionEnabled = NO;
    
    [_registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [_registerBtn setTitleColor:[UIColor colorFromHexString:@"FFFFFF"] forState:UIControlStateNormal];
    _registerBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(17)];
    [_registerBtn addTarget:self action:@selector(registerBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerBtn];
    
    //账号密码登录按钮
    //    _passCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(_passWordTextField.left, _registerBtn.bottom+kWidth(21), 100, kWidth(12))];
    //    _passCodeBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(12)];
    //    [_passCodeBtn setTitle:@"帐号密码登录" forState:UIControlStateNormal];
    //    [_passCodeBtn addTarget:self action:@selector(passCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    //    [_passCodeBtn sizeToFit];
    //    _passCodeBtn.frame = CGRectMake(_passWordTextField.left, _registerBtn.bottom+kWidth(21), _passCodeBtn.width, _passCodeBtn.height);
    //    [self.view addSubview:_passCodeBtn];
    
    _phoneTextField.textColor = _passWordTextField.textColor = _codeTextField.textColor = [UIColor colorFromHexString:@"FFFFFF"];
    
    
    NSString *str = @"注册即代表您同意《注册协议》《隐私政策》";
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
        [weakself noticationRegisterBtn];
    };
    //监听密码
    _passWordTextField.textFieldDidChange = ^(NSString * _Nonnull text) {
        [weakself noticationCodeBtn];
        [weakself noticationRegisterBtn];
    };
    //监听验证码
    _codeTextField.textFieldDidChange = ^(NSString * _Nonnull text) {
        [weakself noticationRegisterBtn];
    };
    
}//加载view


-(void)noticationCodeBtn{
    
    if (!_isHeight) {
        if ([UntilTools isValidateMobile:self.phoneTextField.text] && self.passWordTextField.text.length != 0) {
            self.codeBtn.backgroundColor = SelectedBtnColor;
            self.codeBtn.userInteractionEnabled = YES;
        }else{
            //            weakself.codeBtn.backgroundColor = SelectedBtnColor;
            self.codeBtn.backgroundColor = UnSelectedBtnColor;
            self.codeBtn.userInteractionEnabled = NO;
        }
    }
    
}//监听获取验证码按钮的方法


-(void)noticationRegisterBtn
{
    if ([UntilTools isValidateMobile:self.phoneTextField.text] && self.passWordTextField.text.length != 0 && self.codeTextField.text.length != 0) {
        _registerBtn.backgroundColor = SelectedBtnColor;
        _registerBtn.userInteractionEnabled = YES;
    }
    else{
        _registerBtn.backgroundColor = UnSelectedBtnColor;
        _registerBtn.userInteractionEnabled = NO;
    }
}



-(void)registerBtnOnClick
{
    if ([_countryCodeString isEqualToString:@"086"]) {
        //如果是中国手机,做正则处理
        if (![UntilTools isValidateMobile:self.phoneTextField.text]) {
            [self showToast:@"请输入正确手机号"];
            return;
        }
    }
    
    if (self.passWordTextField.text.length >11 ||self.passWordTextField.text.length < 6) {
        [self showToast:@"请输入正确格式的密码"];
        return;
    }
    
    
    if (![UntilTools checkIsHaveNumAndLetter:self.passWordTextField.text]) {
        [self showToast:@"请输入正确格式的密码"];
        return;
    }
    
    [self loadRegisterRequest];
    
}//注册按钮点击事件

-(void)loadRegisterRequest
{
    [STTextHudTool showWaitText:@"注册中..."];
    
    [LoginRegisterProxy registerSaltSuccess:^(NSString * _Nonnull salt) {
        
        NSString *string = [UntilTools dealMd532BitString:[UntilTools md532BitUpperString:self.passWordTextField.text] salt:salt];
        [LoginRegisterProxy registerUserWithPhoneNum:self.phoneTextField.text userPass:string phoneCountryCode:self.countryCodeString code:self.codeTextField.text success:^(BOOL isSuccess) {
            [STTextHudTool hideSTHud];
            [self showToast:@"注册成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } failure:^(NSError * _Nonnull error) {
            [STTextHudTool hideSTHud];
            
        }];
    } failure:^(NSError * _Nonnull error) {
        [STTextHudTool hideSTHud];
        
    }];
}



-(void)passCodeBtn:(UIButton *)sender{
    [self goback];
}//返回




- (void)codeBtnOnClick
{
    if ([self.countryCodeString isEqualToString:@"086"]) {
        if (![UntilTools isValidateMobile:self.phoneTextField.text]) {
            [self showToast:@"请输入正确手机号"];
            return;
        }
    }
    [STTextHudTool showWaitText:@"请求中..."];
    [LoginRegisterProxy regirstLoginVerificationCodeWithPhoneNum:self.phoneTextField.text phoneCountryCode:self.countryCodeString codeType:@"2" success:^(BOOL isSuccess, int code) {
        [STTextHudTool hideSTHud];
        if (isSuccess) {
            [self showToast:@"已发送"];
            [self startTime];
        }else{
            if (code == 2005) {
                
                ZGAlertView *alertView = [[ZGAlertView alloc] initWithTitle:@"该手机号已存在，请登录"
                                                                    message:nil
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:@"登录", nil];
                [alertView show];
                
                alertView.dismissBlock = ^(NSInteger clickIndex) {
                    if (clickIndex == 1) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                };
            };
        }
    } failure:^(NSError * _Nonnull error) {
        [STTextHudTool hideSTHud];
    }];
    
}//验证码按钮点击执行


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
}//开始计时器

-(void)btnOnClick
{
    XWCountryCodeController *countryCodeVC = [[XWCountryCodeController alloc] init];
    __weak __typeof(self)weakSelf = self;
    countryCodeVC.returnCountryCodeBlock = ^(NSString *countryName, NSString *code) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf->_countryCodeBtn setTitle:[NSString stringWithFormat:@"+%@",code] forState:UIControlStateNormal];
        strongSelf->_countryCodeString = [UntilTools dealCountryCode:code];
        
        NSLog(@"%@",code);
    };
    
    [self.navigationController pushViewController:countryCodeVC animated:YES];
}







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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing: YES];
}

-(void)dealloc{
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
