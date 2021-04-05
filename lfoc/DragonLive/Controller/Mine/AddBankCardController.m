//
//  AddBankCardController.m
//  DragonLive
//
//  Created by LoaA on 2021/1/6.
//

#import "AddBankCardController.h"
#import "LeftRightTextField.h"
#import "JYBDBankCardVC.h"
#import "IDInfoViewController.h"
#import "BankBtn.h"
#import "JHAddressPickView.h"
#import "ChoseBankController.h"
#import "MineProxy.h"
#import "PlaceholderTextView.h"
@interface AddBankCardController (){
    CGFloat offsetY;
}

/// 名字
@property (nonatomic ,strong) LeftRightTextField *nameTextField;

/// 手机号
//@property (nonatomic, strong) LeftRightTextField *phoneTextField;

/// 银行卡
@property (nonatomic, strong) LeftRightTextField *bankCardTextField;

/// 开户行
@property (nonatomic, strong) BankBtn *accountBankBtn;

/// 选择省/市
@property (nonatomic, strong) BankBtn *selectedAddress;

/// 具体地址
@property (nonatomic, strong) PlaceholderTextView *addressTextField;

/// 省市选择
@property (nonatomic, strong) JHAddressPickView *pickView;

/// 地址字符串
@property (nonatomic, strong) NSString *addressString;

/// 银行卡开户行字符串
@property (nonatomic, strong) NSString *bankNameString;

/// 下一步按钮
@property (strong, nonatomic) UIButton *nextBtn;

/// 省份
@property (strong, nonatomic) NSString *province_str;

/// 市区
@property (strong, nonatomic) NSString *city_str;

@end

@implementation AddBankCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"银行卡";
    self.view.backgroundColor = The_MainColor;
    [self initNavItem];
    [self initView];
    [self coverData];
//    [self addNotification];
    // Do any additional setup after loading the view.
}


-(void)coverData{
    if ([UserInstance shareInstance].userModel.bankCard.length != 0 && [UserInstance shareInstance].userModel.realName.length != 0 ) {
        _nameTextField.userInteractionEnabled = NO;
        _nameTextField.text = [UserInstance shareInstance].userModel.realName;
        
        _bankNameString = [UserInstance shareInstance].userModel.bank;
        [_accountBankBtn setTitle:_bankNameString forState:UIControlStateNormal];
//        _phoneTextField.text = [UserInstance shareInstance].userModel.bankPhone;
        self.province_str = [UserInstance shareInstance].userModel.province;
        self.city_str = [UserInstance shareInstance].userModel.city;
        
        self.addressString = [NSString stringWithFormat:@"%@/%@",self.province_str,self.city_str];
        [self.selectedAddress setTitle:self.addressString forState:UIControlStateNormal];
        
        _addressTextField.text = [UserInstance shareInstance].userModel.subbranch;
        self.navigationItem.title = @"修改银行卡";
    }else{
        self.navigationItem.title = @"绑定银行卡";
    }
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
    
    NSString *str = @"";
    if ([UserInstance shareInstance].userModel.bankCard.length != 0) {
        str = @"确定退出修改银行卡？";
    }else{
        str = @"确定退出绑定银行卡？";
    }
    
    ZGAlertView *alertView = [[ZGAlertView alloc] initWithTitle:str
                                                        message:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    [alertView show];
    
    alertView.dismissBlock = ^(NSInteger clickIndex) {
        
        if (clickIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
}

-(void)initView
{
    _nameTextField = [[LeftRightTextField alloc]init];
//    _phoneTextField = [[LeftRightTextField alloc]init];
    _bankCardTextField = [[LeftRightTextField alloc]init];
    _bankCardTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    
    UIButton *takePhoto = [[UIButton alloc]initWithFrame:CGRectMake(0, (kWidth(44-26))/2, kWidth(26), kWidth(26))];
    [takePhoto setBackgroundImage:[UIImage imageNamed:@"takePhotoBG"] forState:UIControlStateNormal];
//    takePhoto.backgroundColor = [UIColor redColor];
    [takePhoto addTarget:self action:@selector(takePhotoScan) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self creatWithLeftRightTextField:_nameTextField frame:CGRectMake(kWidth(39), kWidth(15), kScreenWidth-kWidth(39*2), kWidth(44)) placeholder:@"请输入开户人" rightView:nil];
//    [self creatWithLeftRightTextField:_phoneTextField frame:CGRectMake(kWidth(39), _nameTextField.bottom+kWidth(23), kScreenWidth-kWidth(39*2), kWidth(44)) placeholder:@"请输入银行预留手机号码" rightView:nil];
    
    [self creatWithLeftRightTextField:_bankCardTextField frame:CGRectMake(kWidth(39), _nameTextField.bottom+kWidth(23), kScreenWidth-kWidth(39*2), kWidth(44)) placeholder:@"请输入银行卡号" rightView:takePhoto];
    
    
    //开户行.
    _accountBankBtn = [[BankBtn alloc]initWithFrame:CGRectMake(_bankCardTextField.left, _bankCardTextField.bottom+kWidth(23), _bankCardTextField.width, _bankCardTextField.height)];
    [_accountBankBtn setTitle:@"请选择开户银行" forState:UIControlStateNormal];
    [_accountBankBtn setTitleColor:[UIColor colorFromHexString:@"222222"] forState:UIControlStateNormal];
    [_accountBankBtn setImage:[UIImage imageNamed:@"bankBtnSelectImg"] forState:UIControlStateNormal];
    [_accountBankBtn addTarget:self action:@selector(accountBankBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    _accountBankBtn.layer.borderColor = [UIColor colorFromHexString:@"ECECEC"].CGColor;
    _accountBankBtn.layer.borderWidth = 1;
    [self.view addSubview:_accountBankBtn];
    
    
    _selectedAddress = [[BankBtn alloc]initWithFrame:CGRectMake(_bankCardTextField.left, _accountBankBtn.bottom+kWidth(23), _bankCardTextField.width, _bankCardTextField.height)];
    [_selectedAddress setTitle:@"请选择省/市" forState:UIControlStateNormal];
    [_selectedAddress setTitleColor:[UIColor colorFromHexString:@"222222"] forState:UIControlStateNormal];
    [_selectedAddress setImage:[UIImage imageNamed:@"bankBtnSelectImg"] forState:UIControlStateNormal];
    [_selectedAddress addTarget:self action:@selector(selectedAddressOnClick) forControlEvents:UIControlEventTouchUpInside];
    _selectedAddress.layer.borderColor = [UIColor colorFromHexString:@"ECECEC"].CGColor;
    _selectedAddress.layer.borderWidth = 1;
    [self.view addSubview:_selectedAddress];
    
//    [self creatWithLeftRightTextField:_addressTextField frame:CGRectMake(kWidth(39), _selectedAddress.bottom+kWidth(23), kScreenWidth-kWidth(39*2), kWidth(44)) placeholder:@"请您正确填写开户支行信息" rightView:nil];
  
    _addressTextField = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(kWidth(39), _selectedAddress.bottom+kWidth(23), kScreenWidth-kWidth(39*2),kWidth(60))];
    _addressTextField.placeholder = @"请您正确填写开户支行信息";
    _addressTextField.maxLength = 300;
    _addressTextField.wordNumLabel.hidden = YES;
    _addressTextField.textColor = [UIColor colorFromHexString:@"222222"];
    _addressTextField.layer.borderColor = [UIColor colorFromHexString:@"ECECEC"].CGColor;
    _addressTextField.font = [UIFont systemFontOfSize:kWidth(16)];
    _addressTextField.layer.borderWidth = 1;
    _addressTextField.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_addressTextField];
    kWeakSelf(self);
    _addressTextField.didChangeText = ^(PlaceholderTextView *textView) {
        if (textView.text.length > 50) {
            weakself.addressTextField.text = [textView.text substringToIndex:50];
        }
        [weakself noticationNextBtn];
    };
    
    
    
    UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(_selectedAddress.left, _addressTextField.bottom+kWidth(20), _selectedAddress.width, kWidth(50))];
    message.font = [UIFont systemFontOfSize:kWidth(12)];
    message.textColor = SelectedBtnColor;
    message.text = @"1.银行卡信息/开户人必须与主播认证的真实姓名一致\n2.请确保开户行支行信息填写正确";
    message.numberOfLines = 0;
    [self.view addSubview:message];
    
        
    _nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(_selectedAddress.left, message.bottom+kWidth(21), _addressTextField.width, kWidth(42))];
    _nextBtn.backgroundColor = UnSelectedBtnColor;
    _nextBtn.userInteractionEnabled = NO;
    if ([UserInstance shareInstance].userModel.bankCard.length != 0 && [UserInstance shareInstance].userModel.realName.length != 0 ) {
        [_nextBtn setTitle:@"保存修改" forState:UIControlStateNormal];
    }else{
        [_nextBtn setTitle:@"确定" forState:UIControlStateNormal];
    }
    [_nextBtn setTitleColor:[UIColor colorFromHexString:@"FFFFFF"] forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(17)];
    [_nextBtn addTarget:self action:@selector(nextBtnOnClick)
       forControlEvents:UIControlEventTouchUpInside];
    [_nextBtn setCornerWithType:UIRectCornerAllCorners Radius:_nextBtn.width/2];
    [self.view addSubview:_nextBtn];
    
}//initView


-(void)nextBtnOnClick
{
    if (_nameTextField.text.length == 0) {
        [self showToast:@"姓名不能为空"];
        return;
    }
    
//    if (![UntilTools isValidateMobile:_phoneTextField.text]) {
//        [self showToast:@"请输入正确的手机号"];
//        return;
//    }
    
    if (![UntilTools IsBankCard:_bankCardTextField.text]) {
        [self showToast:@"请输入正确的银行卡号"];
        return;
    }
    
    if (_bankNameString.length == 0) {
        [self showToast:@"请选择开户行"];
        return;
    }
    
    if (_addressString.length == 0) {
        [self showToast:@"请选择省/市"];
        return;
    }
    
    if (_addressTextField.text.length == 0) {
        [self showToast:@"请输入开户支行信息"];
        return;
    }
    [STTextHudTool showWaitText:@"请求中..."];
    
    NSString *bankId = @"";
    if ([UserInstance shareInstance].userModel.bankCard.length != 0 && [UserInstance shareInstance].userModel.realName.length != 0 ) {
        bankId = [UserInstance shareInstance].userModel.bankId;
    }
    
    [MineProxy bingBankCardWithAccountName:_nameTextField.text bank:_bankNameString bankCard:_bankCardTextField.text province:_province_str city:_city_str bankPhone:@"" subbranch:_addressTextField.text bankId:bankId success:^(BOOL success) {
        if ([UserInstance shareInstance].userModel.bankCard.length != 0 && [UserInstance shareInstance].userModel.realName.length != 0 ) {
            [self showToast:@"修改成功"];
        }else{
            [self showToast:@"绑定成功"];
        }
        [self.navigationController popViewControllerAnimated:YES];
        [STTextHudTool hideSTHud];
        
    } failure:^(NSError * _Nonnull error) {
        [STTextHudTool hideSTHud];
        if ([UserInstance shareInstance].userModel.bankCard.length != 0 && [UserInstance shareInstance].userModel.realName.length != 0 ) {
            [self showToast:@"修改失败"];
        }else{
            [self showToast:@"绑定失败"];
        }
        
    }];
    
}




-(void)noticationNextBtn
{
    if (self.nameTextField.text != 0  && self.bankCardTextField.text.length != 0 && self.bankNameString.length != 0 && self.addressString.length != 0 && self.addressTextField.text.length != 0){
        _nextBtn.backgroundColor = SelectedBtnColor;
        _nextBtn.userInteractionEnabled = YES;
    }
    else{
        _nextBtn.backgroundColor = UnSelectedBtnColor;
        _nextBtn.userInteractionEnabled = NO;
    }
}


-(void)selectedAddressOnClick
{
    [self.view endEditing:YES];
    kWeakSelf(self);
    _pickView = [[JHAddressPickView alloc] init];
    _pickView.hideWhenTapGrayView = YES;
    _pickView.columns = 2;    // 省市二级选择
    //_pickView.columns = 3;  // 省市区三级选择
    [_pickView showInView:self.view];
    
    _pickView.pickBlock = ^(NSDictionary *dic) {
        NSString *province = dic[@"province"];
        NSString *city     = dic[@"city"];
        
        weakself.province_str = province;
        weakself.city_str     = city;
        
        weakself.addressString = [NSString stringWithFormat:@"%@/%@",province,city];
        [weakself.selectedAddress setTitle:weakself.addressString forState:UIControlStateNormal];
        [weakself noticationNextBtn];
    };
}//


-(void)accountBankBtnOnClick
{
    ChoseBankController *vc = [[ChoseBankController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    vc.returnBankNameBlock = ^(NSString * _Nonnull name) {
        [self->_accountBankBtn setTitle:name forState:UIControlStateNormal];
        self->_bankNameString = name;
    };
    

}//开户行选择


-(void)takePhotoScan
{
    NSLog(@"123123");
    
        kWeakSelf(self);
        JYBDBankCardVC *vc = [[JYBDBankCardVC alloc]init];
        vc.finish = ^(JYBDBankCardInfo *info, UIImage *image) {
            weakself.bankCardTextField.text = @"";
            NSString *originalStr = [info.bankNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
            [weakself.bankCardTextField insertText:originalStr];
            
        };
        [self.navigationController pushViewController:vc animated:YES];
    
}//扫描。

/// 构建textField
/// @param textField 输入框
/// @param frame frame
/// @param placeholder placeholder
/// @param rightView 右边的view
-(void)creatWithLeftRightTextField:(LeftRightTextField *)textField frame:(CGRect)frame placeholder:(NSString *)placeholder rightView:(UIButton *)rightView
{
    if (rightView) {
        textField.rightView = rightView;
        textField.rightViewMode = UITextFieldViewModeAlways;
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth(15), 20)];
    textField.frame = frame;
    textField.leftView = view;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.placeholder = placeholder;
    textField.textColor = [UIColor colorFromHexString:@"222222"];
    textField.layer.borderColor = [UIColor colorFromHexString:@"ECECEC"].CGColor;
    textField.font = [UIFont systemFontOfSize:kWidth(16)];
    textField.layer.borderWidth = 1;
//    textField.secureTextEntry = YES;
    [self.view addSubview:textField];
    
   
    
    
    kWeakSelf(self);
    textField.textFieldDidChange = ^(NSString * _Nonnull text) {
        if (weakself.bankCardTextField == textField) {
            //如果是银行卡.
            if (text.length > 19) {
                weakself.bankCardTextField.text = [text substringToIndex:19];
            }
            
            if ([UntilTools returnBankName:text].length >0) {
                [weakself.accountBankBtn setTitle:[UntilTools returnBankName:text] forState:UIControlStateNormal];
                self->_bankNameString = [UntilTools returnBankName:text];
            }else{
                [self->_accountBankBtn setTitle:@"请选择开户银行" forState:UIControlStateNormal];
                self->_bankNameString = @"";
            }
        }else if(weakself.nameTextField == textField){
            if (text.length > 20) {
                weakself.nameTextField.text = [text substringToIndex:20];
            }
        }
       
        
        [weakself noticationNextBtn];
        
    };
    
    
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
