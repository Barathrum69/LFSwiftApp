//
//  ModifyNameController.m
//  DragonLive
//
//  Created by LoaA on 2021/1/1.
//

//女生对你说失恋怎么回复？
//公式 数落前男友 + 安慰 + 展望 + 装可怜 +包装自己 +升华
//
//事例:你的前男友本来对你就不好 你和他分手其实是一件好事 以后啊 你会遇到一个爱你 珍惜你的男孩子的 你看我就没那么幸运  我单身了那么多年 就是一直在等待一个我爱的女孩子 如果能找到像你这样的女孩子我一定把她怎么怎么
#import "ModifyNameController.h"
#import "XJTextField.h"
#import "MineProxy.h"
@interface ModifyNameController ()

/// 输入框
@property (strong, nonatomic) XJTextField *textField;

@end

@implementation ModifyNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改昵称";
    self.view.backgroundColor = The_MainColor;
    [self initNavigationItem];
    [self initView];
    // Do any additional setup after loading the view.
}

#pragma mark - nav
-(void)initNavigationItem
{
    
//    UIButton  *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 40, 40);
//    [leftBtn addTarget:self action:@selector(leftItemClicked) forControlEvents:UIControlEventTouchUpInside];
//    [leftBtn setImage:[UIImage imageNamed:@"main_nav_left"]  forState:UIControlStateNormal];
//    UIBarButtonItem *barLeftBtn = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    //    右边
    UIButton  *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 20);
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorFromHexString:@"222222"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightItemClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barRightBtn = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    [self.navigationItem setRightBarButtonItem:barRightBtn];
}//加载Nav

-(void)rightItemClicked
{
    NSString *str = [_textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    [_footBallView startTimer];
    if (str.length == 0) {
        [self showToast:@"昵称长度2-20个字符,且不能全部为空"];
        return;
    }
    
    if (str.length < 2 || _textField.text.length > 20) {
        [self showToast:@"昵称长度2-20个字符"];
        return;
    }
    
    [STTextHudTool showWaitText:@"请求中..."];
    [MineProxy modifyNameWithNickName:_textField.text success:^(BOOL success) {
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
    NSLog(@"右边边");
    
    
}//nav右边点击
-(void)initView
{
    _textField = [[XJTextField alloc]initWithFrame:CGRectMake(kWidth(27), kWidth(25), kScreenWidth-kWidth(27*2), kWidth(30))];
    [self.view addSubview: _textField];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(_textField.left, _textField.bottom+1, _textField.width, 1)];
    line.backgroundColor = SelectedBtnColor;
    [self.view addSubview:line];
    _textField.maxLength = 20;
    _textField.textColor = [UIColor colorFromHexString:@"222222"];
    _textField.text = [UserInstance shareInstance].userModel.nickname;
    _textField.font = [UIFont systemFontOfSize:kWidth(18)];
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
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
