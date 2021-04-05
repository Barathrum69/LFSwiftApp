//
//  ModifyPasswordController.m
//  DragonLive
//
//  Created by LoaA on 2021/1/1.
//

#import "ModifyPasswordController.h"
#import "LeftRightTextField.h"
#import "LoginRegisterProxy.h"

@interface ModifyPasswordController ()
/// 旧密码
@property (strong, nonatomic) LeftRightTextField *oldPwdTextField;

/// 新密码
@property (strong, nonatomic) LeftRightTextField *setPwdTextField;

/// 再次输入新密码
@property (strong, nonatomic) LeftRightTextField *againPwdTextField;

/// 提交按钮
@property (strong, nonatomic) UIButton *submitBtn;

@end

@implementation ModifyPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
    self.view.backgroundColor = The_MainColor;
    [self initView];
    // Do any additional setup after loading the view.
}


-(void)initView
{
    _oldPwdTextField =[[LeftRightTextField alloc]init];
    _setPwdTextField =[[LeftRightTextField alloc]init];
    _againPwdTextField =[[LeftRightTextField alloc]init];

    
    [self creatWithLeftRightTextField:_oldPwdTextField frame:CGRectMake(kWidth(40), kWidth(23), kScreenWidth-kWidth(40*2), kWidth(44)) placeholder:@"请输入旧密码（6-10位字母和数字）"];
    
    [self creatWithLeftRightTextField:_setPwdTextField frame:CGRectMake(kWidth(40), _oldPwdTextField.bottom+kWidth(20), kScreenWidth-kWidth(40*2), kWidth(44)) placeholder:@"请输入新密码（6-10位字母和数字）"];
    
    [self creatWithLeftRightTextField:_againPwdTextField frame:CGRectMake(kWidth(40), _setPwdTextField.bottom+kWidth(20), kScreenWidth-kWidth(40*2), kWidth(44)) placeholder:@"请再次输入新密码"];
    
    _submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth(40), _againPwdTextField.bottom+kWidth(20), _againPwdTextField.width, _againPwdTextField.height)];
    [_submitBtn setCornerWithType:UIRectCornerAllCorners Radius:_submitBtn.height/2];
    _submitBtn.backgroundColor = UnSelectedBtnColor;
    _submitBtn.userInteractionEnabled = NO;
    [_submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor colorFromHexString:@"FFFFFF"] forState:UIControlStateNormal];
    _submitBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(17)];
    [_submitBtn addTarget:self action:@selector(submitBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitBtn];
    
}


-(void)submitBtnOnClick
{
    if (![UntilTools checkIsHaveNumAndLetter:_oldPwdTextField.text]||![UntilTools checkIsHaveNumAndLetter:_setPwdTextField.text]||![UntilTools checkIsHaveNumAndLetter:_againPwdTextField.text]) {
        [[HCToast shareInstance]showToast:@"密码格式错误"];
        return;
    }
    
    if (_oldPwdTextField.text.length < 6 || _oldPwdTextField.text.length >10) {
        [[HCToast shareInstance]showToast:@"请输入旧密码(6-10位字母和数字)"];
        return;
    }
    if (_setPwdTextField.text.length < 6 || _setPwdTextField.text.length >10) {
        [[HCToast shareInstance]showToast:@"请输入新密码(6-10位字母和数字)"];
        return;
    }
    if (_againPwdTextField.text.length < 6 || _againPwdTextField.text.length >10) {
        [[HCToast shareInstance]showToast:@"请输入新密码(6-10位字母和数字)"];
        return;
    }
    
    if (![_setPwdTextField.text isEqualToString:_againPwdTextField.text]) {
        [[HCToast shareInstance]showToast:@"两次输入密码不正确"];
        return;
    }
    [STTextHudTool showWaitText:@"请求中..."];
    [LoginRegisterProxy registerSaltSuccess:^(NSString * _Nonnull salt) {
//        NSString *oldPwd = [UntilTools dealMd532BitString:[UntilTools md532BitUpperString:self.oldPwdTextField.text] salt:salt];
//        NSString *userPass = [UntilTools dealMd532BitString:[UntilTools md532BitUpperString:self.setPwdTextField.text] salt:salt];
        [LoginRegisterProxy modifyPasswordWitOldPwd:[UntilTools dealMd532BitString:[UntilTools md532BitUpperString:self.oldPwdTextField.text] salt:salt] userPass:[UntilTools dealMd532BitString:[UntilTools md532BitUpperString:self.setPwdTextField.text] salt:salt] success:^(BOOL isSuccess) {
            [STTextHudTool hideSTHud];
            [self showToast:@"密码修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError * _Nonnull error) {
            [STTextHudTool hideSTHud];
        }];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    
}


/// 创建街面上的输入框
/// @param textField text
/// @param frame frame
/// @param placeholder placeholder
-(void)creatWithLeftRightTextField:(LeftRightTextField *)textField frame:(CGRect)frame placeholder:(NSString *)placeholder
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth(15), 20)];
    textField.frame = frame;
    textField.leftView = view;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.placeholder = placeholder;
    textField.textColor = [UIColor colorFromHexString:@"222222"];
    textField.layer.borderColor = [UIColor colorFromHexString:@"ECECEC"].CGColor;
    textField.font = [UIFont systemFontOfSize:kWidth(16)];
    textField.layer.borderWidth = 1;
    textField.secureTextEntry = YES;
    [self.view addSubview:textField];
    kWeakSelf(self);
    textField.textFieldDidChange = ^(NSString * _Nonnull text) {
       
        if (weakself.oldPwdTextField.text.length != 0 && weakself.setPwdTextField.text.length != 0 && weakself.againPwdTextField.text.length != 0) {
            weakself.submitBtn.backgroundColor = SelectedBtnColor;
            weakself.submitBtn.userInteractionEnabled = YES;
        }else{
            weakself.submitBtn.backgroundColor = UnSelectedBtnColor;
            weakself.submitBtn.userInteractionEnabled = NO;
        }
    };
    
    
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
