//
//  AnnounceController.m
//  DragonLive
//
//  Created by LoaA on 2021/1/7.
//

#import "AnnounceController.h"
#import "PlaceholderTextView.h"
#import "MineProxy.h"
@interface AnnounceController ()

/// 直播公告
@property (nonatomic, strong) PlaceholderTextView *noteTextView;

/// 提交按钮
@property (nonatomic, strong) UIButton *submitBtn;
@end

@implementation AnnounceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"主播公告";
    self.view.backgroundColor = The_MainColor;
    [self initView];
    [self loadRequest];
    // Do any additional setup after loading the view.
}


-(void)loadRequest
{
    [MineProxy getRoomSettingSuccess:^(NSString * _Nonnull success) {
        self.noteTextView.text = success;
    } failure:^(NSError * _Nonnull error) {
            
    }];
}//加载网络请求


-(void)initView
{
    kWeakSelf(self);
    _noteTextView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(kWidth(15), kWidth(10), kScreenWidth-kWidth(30), kWidth(239))];
    _noteTextView.placeholderLabel.font = [UIFont systemFontOfSize:kWidth(12)];
    _noteTextView.placeholderLabel.textColor = [UIColor colorFromHexString:@"949AAF"];
    _noteTextView.placeholder = @"不超过100字符";
    _noteTextView.font = [UIFont systemFontOfSize:kWidth(12)];
    _noteTextView.textColor = [UIColor colorFromHexString:@"475F7B"];
    _noteTextView.backgroundColor = [UIColor whiteColor];
    _noteTextView.maxLength = 100;
//    _noteTextView.layer.cornerRadius = 5.f;
//    _noteTextView.layer.borderColor = [UIColor colorFromHexString:@"E0E0E0"].CGColor;
//    _noteTextView.layer.borderWidth = 1;
    [_noteTextView didChangeText:^(PlaceholderTextView *textView) {
        NSLog(@"%@",textView.text);
        if (self->_noteTextView.text.length != 0) {
            [weakself submitBtnOpen];
        }else{
            [weakself submitClose];
        }
    }];
    
    [self.view addSubview:_noteTextView];
    
    
    _submitBtn = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-kWidth(300))/2, _noteTextView.bottom+kWidth(50), kWidth(300), kWidth(44))];
    _submitBtn.backgroundColor = UnSelectedBtnColor;
    _submitBtn.userInteractionEnabled = NO;
    [_submitBtn addTarget:self action:@selector(submitBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [_submitBtn setCornerWithType:UIRectCornerAllCorners Radius:_submitBtn.width/2];
    _submitBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(16)];
    [_submitBtn setTitle:@"保存修改" forState:UIControlStateNormal];
    [self.view addSubview:_submitBtn];
    
    
}//


-(void)submitBtnOnClick
{
    [STTextHudTool showWaitText:@"发布中..."];
    [MineProxy updateRoomNoticeWithRoomId:_roomId notice:_noteTextView.text success:^(BOOL success) {
        [self showToast:@"修改成功"];
        [STTextHudTool hideSTHud];
//        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError * _Nonnull error) {
        [STTextHudTool hideSTHud];
    }];
}


-(void)submitBtnOpen
{
    _submitBtn.backgroundColor = SelectedBtnColor;
    _submitBtn.userInteractionEnabled = YES;
}

-(void)submitClose
{
    _submitBtn.backgroundColor = UnSelectedBtnColor;
    _submitBtn.userInteractionEnabled = NO;
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
