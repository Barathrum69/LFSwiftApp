//
//  ModifyEmailController.m
//  DragonLive
//
//  Created by LoaA on 2021/1/1.
//

#import "ModifyEmailController.h"
#import "LeftRightTextField.h"
#import "LoginRegisterProxy.h"
#import "MineProxy.h"
@interface ModifyEmailController ()

@property (nonatomic, assign) BOOL isHeight;

/// 电话
@property (strong, nonatomic) LeftRightTextField *phoneTextField;

/// 验证码
@property (strong, nonatomic) LeftRightTextField *codeTextField;

/// 验证码的按钮
@property (strong, nonatomic) UIButton *codeBtn;

/// 下一步按钮
@property (strong, nonatomic) UIButton *nextBtn;
@end

@implementation ModifyEmailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改邮箱";
    
    self.view.backgroundColor = The_MainColor;
    [self initView];
    // Do any additional setup after loading the view.
}

-(void)initView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth(15), 20)];
    _phoneTextField = [[LeftRightTextField alloc]initWithFrame:CGRectMake(kWidth(40),kWidth(18) , kScreenWidth-kWidth(40*2), kWidth(45))];
    _phoneTextField.backgroundColor = [UIColor colorFromHexString:@"FFFFFF" withAlph:0.05];
    _phoneTextField.leftView.frame = CGRectMake(0, 0, kWidth(68), kWidth(45));
    _phoneTextField.leftView = view;
    _phoneTextField.keyboardType = UIKeyboardTypeEmailAddress;
    
    _phoneTextField.layer.borderColor = [UIColor colorFromHexString:@"#ECECEC"].CGColor;
    _phoneTextField.layer.borderWidth = 1;
    _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入新邮箱地址" attributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexString:@"CCCCCC"],NSFontAttributeName:_phoneTextField.font}];
    _phoneTextField.attributedPlaceholder = attrString;
    //    _phoneTextField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_phoneTextField];
    
    _codeTextField =  [[LeftRightTextField alloc]initWithFrame:CGRectMake(kWidth(40),_phoneTextField.bottom+kWidth(20) , kScreenWidth-kWidth(40*2), kWidth(45))];
    _codeTextField.layer.borderColor = [UIColor colorFromHexString:@"#ECECEC"].CGColor;
    _codeTextField.layer.borderWidth = 1;
    
    _codeTextField.backgroundColor = [UIColor colorFromHexString:@"FFFFFF" withAlph:0.05];
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth(10), kWidth(45))];
    _codeTextField.leftView = btn1;
    _codeTextField.textColor = [UIColor colorFromHexString:@"000000"];
    _codeTextField.leftViewMode = UITextFieldViewModeAlways;
    NSAttributedString *attrString2 = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:
                                       @{NSForegroundColorAttributeName:[UIColor colorFromHexString:@"CCCCCC"],
                                         NSFontAttributeName:_phoneTextField.font}];
    _codeTextField.attributedPlaceholder = attrString2;
    _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
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
    
    _nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(_codeTextField.left, _codeTextField.bottom+kWidth(21), _codeTextField.width, kWidth(42))];
    _nextBtn.backgroundColor = UnSelectedBtnColor;
    _nextBtn.userInteractionEnabled = NO;
    [_nextBtn setTitle:@"确定" forState:UIControlStateNormal];
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


-(void)nextBtnOnClick
{
        
    if (![UntilTools checkEmail:_phoneTextField.text] && _codeTextField.text.length != 6) {
        [[HCToast shareInstance]showToast:@"请检查输入的邮箱和验证码"];
        return;
    }
    
    [STTextHudTool showWaitText:@"请求中..."];
    [LoginRegisterProxy modifyEmailWithEmail:_phoneTextField.text code:_codeTextField.text success:^(BOOL isSuccess) {
        [MineProxy getUserInfoSuccess:^(BOOL success) {
            [self showToast:@"修改成功"];
            
            
            [STTextHudTool hideSTHud];
            [self.navigationController popViewControllerAnimated:YES];

        } failure:^(NSError * _Nonnull error) {
            [STTextHudTool hideSTHud];
        }];
       
    } failure:^(NSError * _Nonnull error) {
        [STTextHudTool hideSTHud];
    }];

}//点击确定


-(void)codeBtnOnClick
{
    if (![UntilTools checkEmail:_phoneTextField.text])
    {
        [[HCToast shareInstance]showToast:@"请输入正确格式邮箱"];
        return;
    }
    [STTextHudTool showWaitText:@"请求中..."];

    //验证码点击
    [LoginRegisterProxy getEmailCodeWithEmail:_phoneTextField.text codeType:@"4" success:^(BOOL isSuccess) {
        [self showToast:@"发送成功"];
        [self startTime];
        [STTextHudTool hideSTHud];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
