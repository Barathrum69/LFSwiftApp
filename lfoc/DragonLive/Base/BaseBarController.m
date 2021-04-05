//
//  BaseViewController.m
//  MaJingGallery
//
//  Created by T34 on 2019/7/13.
//  Copyright © 2019 T34. All rights reserved.
//

#import "BaseBarController.h"
#import "BaseTabBarController.h"
#import "HCToast.h"
#import "MineViewController.h"

@interface BaseBarController ()

@end

@implementation BaseBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeAll];
    }
    self.navigationController.delegate = self;
}
//- (TabBarController *)rdv_tabBarController {
//    TabBarController *tabBarController = objc_getAssociatedObject(self, @selector(rdv_tabBarController));
//    
////    if (!tabBarController && self.parentViewController) {
////        tabBarController = [self.parentViewController rdv_tabBarController];
////    }
//    
//    return tabBarController;
//}

-(void)setHidesBottomBarWhenPushed:(BOOL)hidesBottomBarWhenPushed{
//    [super setHidesBottomBarWhenPushed:hidesBottomBarWhenPushed];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.tabBarController.hidesBottomBarWhenPushed = hidesBottomBarWhenPushed;
    
}

//提示信息.
-(void)showToast:(NSString *)message{
    [[HCToast shareInstance] showToast:message];
}
- (UIImageView *)findLineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
     {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findLineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}//去黑线
- (void )navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL )animated
{
//    [viewController viewWillAppear:animated];
//    即将展示
    
//    [UntilTools showAppKeyBoard:YES];
    
    if (navigationController.childViewControllers.count > 1) {
//        NSLog(@"我的数量是：%lu",(unsigned long)navigationController.childViewControllers.count);
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        viewController.view.frame = CGRectMake(0, 0, kkScreenWidth, kkScreenHeight-kNavBarAndStatusBarHeight);
        app.tabBarController.hidesBottomBarWhenPushed = YES;
    }
    
    if([viewController isKindOfClass:[MineViewController class]]){
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

- (void )navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL )animated
{
//    [viewController viewDidAppear:animated];
//    展示完成
    if (navigationController.childViewControllers.count == 1) {
//        NSLog(@"我的数量是：%lu",(unsigned long)navigationController.childViewControllers.count);
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        app.tabBarController.hidesBottomBarWhenPushed = NO;
    }}




- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
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
