//
//  BaseTableViewController.m
//  DragonLive
//
//  Created by 11号 on 2020/11/25.
//

#import "BaseTabBarController.h"
#import "HomeViewController.h"
#import "VideoListController.h"
#import "MatchViewController.h"
#import "MineViewController.h"
#import "NaviControllrer.h"

@interface BaseTabBarController ()<UITabBarControllerDelegate>

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];


    [self.tabBar setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]]];

    self.delegate = self;
    
    NSArray *titleArr  = [NSArray arrayWithObjects:@"首页",@"视频",@"赛事",@"我的", nil];
    NSArray *defaulImgArr  = [NSArray arrayWithObjects:@"home_normal",@"video_normal",@"match_normal",@"me_normal", nil];
    NSArray *selImgArr  = [NSArray arrayWithObjects:@"home_sel",@"video_sel",@"match_sel",@"me_sel", nil];
    
    NSArray *controArr = [NSArray arrayWithObjects:[HomeViewController new],[VideoListController new],[MatchViewController new],[MineViewController new], nil];
    
    for (NSInteger i=0; i<controArr.count; i++) {
        [self addOneViewController:controArr[i] image:defaulImgArr[i] selectedImage:selImgArr[i] title:titleArr[i]];
    }
}

- (void)addOneViewController:(UIViewController *)childViewController image:(NSString *)imageName selectedImage:(NSString *)selectedImageName title:(NSString *)title{

    NaviControllrer *nav = [[NaviControllrer alloc] initWithRootViewController:childViewController];

    //     设置图片和文字之间的间
//    nav.tabBarItem.imageInsets = UIEdgeInsetsMake(-3, 0, 3, 0);
//    nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
    nav.title = title;
    
//     2.1 正常状态下的文字
    NSMutableDictionary *normalAttr = [NSMutableDictionary dictionary];
    normalAttr[NSForegroundColorAttributeName] = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    normalAttr[NSFontAttributeName] = [UIFont systemFontOfSize:12];

    // 2.2 选中状态下的文字
    NSMutableDictionary *selectedAttr = [NSMutableDictionary dictionary];
    selectedAttr[NSForegroundColorAttributeName] = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
    selectedAttr[NSFontAttributeName] = [UIFont systemFontOfSize:12];

    // 设置对应的颜色
    [nav.tabBarItem setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    [nav.tabBarItem setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];
    nav.tabBarItem.image = [self imageWithOriRenderingImage:imageName];
    nav.tabBarItem.selectedImage = [self imageWithOriRenderingImage:selectedImageName];
    
    [self addChildViewController:nav];
}

- (UIImage *)imageWithOriRenderingImage:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}



@end
