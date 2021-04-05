//
//  ApplyAnchorController.m
//  DragonLive
//
//  Created by LoaA on 2020/12/28.
//

#import "ApplyAnchorController.h"
#import "ApplyAnchorDataController.h"
#import "ApplyAnchorCodeController.h"
@interface ApplyAnchorController ()

@end

@implementation ApplyAnchorController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"主播中心";
    self.view.backgroundColor = The_MainColor;
    // Do any additional setup after loading the view.
    NSLog(@"%@",[UserInstance shareInstance].userModel.hostApplyResult);
    if ([[UserInstance shareInstance].userModel.hostApplyResult isEqualToString:@"-1"]) {
        [self initView];
    }else if([[UserInstance shareInstance].userModel.hostApplyResult isEqualToString:@"0"])
    {
        //审核中
        [self inReview];
    }else if ([[UserInstance shareInstance].userModel.hostApplyResult isEqualToString:@"2"])
    {
        //审核不通过
        [self pass];
    }
}

-(void)initView
{
    
    UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(0, kWidth(100), kScreenWidth, kWidth(14))];
    message.textAlignment = NSTextAlignmentCenter;
    message.text = @"完成主播认证后即可轻松开播";
    message.font = [UIFont systemFontOfSize:kWidth(14)];
    message.textColor = [UIColor colorFromHexString:@"222222"];
    [self.view addSubview:message];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-kWidth(295))/2, message.bottom+kWidth(80), kWidth(295), kWidth(40))];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"申请直播" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:kWidth(16)];
    btn.layer.cornerRadius = btn.height/2;
    btn.backgroundColor = SelectedBtnColor;
    [btn addTarget:self action:@selector(btnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)inReview{
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-kWidth(170))/2, kWidth(144), kWidth(170), kWidth(120))];
    [image setImage:[UIImage imageNamed:@"inReviewBg"]];
    [self.view addSubview:image];
    
    UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(0, image.bottom+kWidth(24), kScreenWidth, kWidth(14))];
    message.textAlignment = NSTextAlignmentCenter;
    message.text = @"审核中，请等待";
    message.font = [UIFont systemFontOfSize:kWidth(14)];
    message.textColor = [UIColor colorFromHexString:@"222222"];
    [self.view addSubview:message];
    
}//审核中


-(void)pass{
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-kWidth(170))/2, kWidth(144), kWidth(170), kWidth(120))];
    [image setImage:[UIImage imageNamed:@"inReviewpass"]];
    [self.view addSubview:image];
    
    UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(0, image.bottom+kWidth(24), kScreenWidth, kWidth(14))];
    message.textAlignment = NSTextAlignmentCenter;
    message.text = @"认证失败，请联系客服或继续申请";
    message.font = [UIFont systemFontOfSize:kWidth(14)];
    message.textColor = [UIColor colorFromHexString:@"222222"];
    [self.view addSubview:message];
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-kWidth(295))/2, message.bottom+kWidth(30), kWidth(295), kWidth(40))];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"申请直播" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:kWidth(16)];
    btn.layer.cornerRadius = btn.height/2;
    btn.backgroundColor = SelectedBtnColor;
    [btn addTarget:self action:@selector(btnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}//审核不通过.


-(void)btnOnClick
{
    ApplyAnchorCodeController *vc = [ApplyAnchorCodeController new];
    [self.navigationController pushViewController:vc animated:YES];
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
