//
//  BaseViewController.m
//  DragonLive
//
//  Created by 11号 on 2020/11/28.
//

#import "BaseViewController.h"
#import "VideoInformationController.h"
#import "AnchorCenterController.h"
#import "LoginController.h"
#import "RegisterController.h"
#import "LiveRoomViewController.h"
#import "ForgetPwdController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.view.userInteractionEnabled = YES;
    // Do any additional setup after loading the view.
}

-(void)showToast:(NSString *)message{
    [[HCToast shareInstance] showToast:message];
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

-(void)close {
    if (self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void )navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL )animated
{
    
//    [viewController viewWillAppear:animated];
//    即将展示
  
//    if([viewController isKindOfClass:[LoginController class]]||[viewController isKindOfClass:[RegisterController class]]||[viewController isKindOfClass:[ForgetPwdController class]]){
//        [UntilTools showAppKeyBoard:NO];
//    }else{
//        [UntilTools showAppKeyBoard:YES];
//    }
    
    
    
    if([viewController isKindOfClass:[VideoInformationController class]]||[viewController isKindOfClass:[AnchorCenterController class]]||[viewController isKindOfClass:[LoginController class]]||[viewController isKindOfClass:[RegisterController class]]||[viewController isKindOfClass:[LiveRoomViewController class]]||[viewController isKindOfClass:[ForgetPwdController class]]){
        [navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        
        //系统相册继承自 UINavigationController 这个不能隐藏 所有就直接return
        if ([navigationController isKindOfClass:[UIImagePickerController class]]) {
            return;
        }
        
        //不在本页时，显示真正的navbar
        [navigationController setNavigationBarHidden:NO animated:YES];
        //当不显示本页时，要么就push到下一页，要么就被pop了，那么就将delegate设置为nil，防止出现BAD ACCESS
        //之前将这段代码放在viewDidDisappear和dealloc中，这两种情况可能已经被pop了，self.navigationController为nil，这里采用手动持有navigationController的引用来解决
        if(navigationController.delegate == self){
            //如果delegate是自己才设置为nil，因为viewWillAppear调用的比此方法较早，其他controller如果设置了delegate就可能会被误伤
            navigationController.delegate = nil;
        }
    }
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing: YES];
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
