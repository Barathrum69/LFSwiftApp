//
//  BankListController.m
//  DragonLive
//
//  Created by LoaA on 2020/12/11.
//

#import "BankListController.h"
#import "IDInfoViewController.h"
#import "JYBDBankCardVC.h"
#import "JYBDIDCardVC.h"
#import "AddBankCardController.h"

@interface BankListController ()

@end

@implementation BankListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"银行卡列表";
    self.view.backgroundColor = The_MainColor;
    [self initNavigationItem];
    // Do any additional setup after loading the view.
}

#pragma mark - nav
-(void)initNavigationItem
{
    
  
    //    右边
    UIButton  *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 20, 20);
    [rightBtn addTarget:self action:@selector(rightItemClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"添加" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *barRightBtn = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    [self.navigationItem setRightBarButtonItem:barRightBtn];
    
    
    
}//加载Nav


-(void)rightItemClicked
{
    
    AddBankCardController *vc = [AddBankCardController new];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    //    [_footBallView startTimer];
    
//    kWeakSelf(self);
//    JYBDBankCardVC *vc = [[JYBDBankCardVC alloc]init];
//    vc.finish = ^(JYBDBankCardInfo *info, UIImage *image) {
//
//        IDInfoViewController *infoM = [[IDInfoViewController alloc]init];
//        infoM.cardInfo = info;
//        infoM.IDImage = image;
//        [weakself.navigationController pushViewController:infoM animated:YES];
//    };
//    [self.navigationController pushViewController:vc animated:YES];
    
}//nav右边点击


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
