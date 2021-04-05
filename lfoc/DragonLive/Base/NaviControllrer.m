//
//  BXNavigationController.m
//  BaoXianDaiDai
//
//  Created by JYJ on 15/5/28.
//  Copyright (c) 2015年 baobeikeji.cn. All rights reserved.
//

#import "NaviControllrer.h"

@interface NaviControllrer () <UINavigationControllerDelegate>

@end

@implementation NaviControllrer

+ (void)initialize {
    // 设置UIUINavigationBar的主题
    [self setupNavigationBarTheme];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
//    self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
}

/**
 *  设置UIBarButtonItem的主题
 */
+ (void)setupNavigationBarTheme {
    // 通过appearance对象能修改整个项目中所有UIBarbuttonItem的样式
    UINavigationBar *appearance = [UINavigationBar appearance];
    [appearance setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];

    // 1.设置导航条的背景
//    [appearance setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault]appearance
//    [appearance setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    //覆盖边框阴影
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    // 设置文字
    NSMutableDictionary *att = [NSMutableDictionary dictionary];
    att[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    att[NSForegroundColorAttributeName] = [UIColor blackColor];
    [appearance setTitleTextAttributes:att];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if (self.viewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
        self.interactivePopGestureRecognizer.delegate = nil;
        
        UIBarButtonItem *popToPreButton = [self barButtonItemWithImage:@"left-arrow" highImage:nil target:self action:@selector(back)];
        viewController.navigationItem.leftBarButtonItem = popToPreButton;
    }
//    [super pushViewController:viewController animated:animated];
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    
    [self popViewControllerAnimated:YES];
}

//这里可以封装成一个分类
- (UIBarButtonItem *)barButtonItemWithImage:(NSString *)imageName highImage:(NSString *)highImageName target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 40, 40);
    button.imageView.contentMode = UIViewContentModeLeft;
//    button.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    button.adjustsImageWhenHighlighted = NO;
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    return  [[UIBarButtonItem alloc] initWithCustomView:button];
}
//// 完全展示完调用
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    // 如果展示的控制器是根控制器，就还原pop手势代理
//    if (viewController == [self.viewControllers firstObject]) {
//        self.interactivePopGestureRecognizer.delegate = self.popDelegate;
//    }
//}

- (void )navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL )animated
{
    [viewController viewWillAppear:animated];

}

- (void )navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL )animated
{
    [viewController viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
