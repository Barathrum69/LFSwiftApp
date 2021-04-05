//
//  AboutUsController.m
//  DragonLive
//
//  Created by LoaA on 2021/1/16.
//

#import "AboutUsController.h"

@interface AboutUsController ()

@end

@implementation AboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于我们";
    self.view.backgroundColor = The_MainColor;
    [self initView];
    // Do any additional setup after loading the view.
}

-(void)initView
{
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-kWidth(102))/2, kWidth(182), kWidth(102), kWidth(102))];
    [image setImage:[UIImage imageNamed:@"aboutUsBg"]];
    [self.view addSubview:image];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

    UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(0, image.bottom+kWidth(15), kScreenWidth, kWidth(13))];
    message.textColor = [UIColor colorFromHexString:@"999999"];
    message.font = [UIFont systemFontOfSize:kWidth(12)];
    message.textAlignment = NSTextAlignmentCenter;
    message.text = [NSString stringWithFormat:@"当前版本:%@",app_Version];
    [self.view addSubview:message];    
    
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
