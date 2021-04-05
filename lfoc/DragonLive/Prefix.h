//
//  Prefix.h
//  DragonLive
//
//  Created by 11号 on 2020/11/28.
//

#ifndef Prefix_h
#define Prefix_h

#define kIs_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kIs_iPhoneX kScreenWidth >=375.0f && kScreenHeight >=812.0f&& kIs_iphone
//强弱引用
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;


#define BXNoteCenter [NSNotificationCenter defaultCenter]
#define BXScreenH [UIScreen mainScreen].bounds.size.height
#define BXScreenW [UIScreen mainScreen].bounds.size.width
#define BXScreenBounds [UIScreen mainScreen].bounds
#define BXKeyWindow [UIApplication sharedApplication].keyWindow


/*屏幕高度*/
#define kkScreenHeight [UIScreen mainScreen].bounds.size.height
/*屏幕宽度*/
#define kkScreenWidth [UIScreen mainScreen].bounds.size.width
/*状态栏高度*/
#define kStatusBarHeight (CGFloat)(kIs_iPhoneX?(44.0):(20.0))
/*导航栏高度*/
#define kNavBarHeight (44)
/*状态栏和导航栏总高度*/
#define kNavBarAndStatusBarHeight (CGFloat)(kIs_iPhoneX?(88.0):(64.0))
/*TabBar高度*/
#define kTabBarHeight (CGFloat)(kIs_iPhoneX?(44.0 + 34.0):(44.0))
/*顶部安全区域高度*/
#define kTopBarSafeHeight (CGFloat)(kIs_iPhoneX?(44.0):(0))
 /*底部安全区域高度*/
#define kBottomSafeHeight (CGFloat)(kIs_iPhoneX?(34.0):(0))
/*iPhoneX的状态栏高度差值*/
#define kTopBarDifHeight (CGFloat)(kIs_iPhoneX?(24.0):(0))
/*导航条和Tabbar总高度*/
#define kNavAndTabHeight (kNavBarAndStatusBarHeight + kTabBarHeight)
/*获取屏幕除导航和底部之外的高度*/
#define kMainViewHeight (kScreenHeight - kNavAndTabHeight)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)

// 随机色
#define BXColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//按钮不可点击时候的颜色
#define UnSelectedBtnColor [UIColor colorFromHexString:@"F67C37" withAlph:0.5]

#define SelectedBtnColor [UIColor colorFromHexString:@"F67C37"]

//详情到指示箭头或开关的距离
#define DetailViewToIndicatorGap 13

#define MakeColorWithRGB(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
//功能图片到左边界的距离
#define FuncImgToLeftGap 20

//功能名称字体
#define FuncLabelFont kWidth(15)

//功能名称到功能图片的距离,当功能图片funcImg不存在时,等于到左边界的距离
#define FuncLabelToFuncImgGap 7

//指示箭头或开关到右边界的距离
#define IndicatorToRightGap 19

//详情文字字体
#define DetailLabelFont 12

#define BXRandomColor BXColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#define kWidth(R) (R)*(kScreenWidth)/375.0

//主题色
#define The_MainColor BXColor(245, 245, 245)


//用户信息
#define UserDefaultsUserInfo @"UserDefaults_userInfo"
#define UserDefaultsToken @"UserDefaults_token"
#define UserVisitorAccount @"UserVisitor_account"
#define kkXmppServerAddress @"kkXmppServerAddress"

//直播设置信息
#define kkSetSmallWindow @"kkSetSmallWindow"
#define kkSetBackgroundPlay @"kkSetBackgroundPlay"
#define kkBarrageOpenManager @"kkBarrageOpenManager"
#define kkBarrageFontAlpha @"kkBarrageFontAlpha"
#define kkBarrageFontSize @"kkBarrageFontSize"
#define kkBarrageFontPosition @"kkBarrageFontPosition"

//任务信息
#define kkLiveShareStatus @"kkLiveShareStatus"
#define kkLivePlayStatus @"kkLivePlayStatus"
#define kkBarrageSendStatus @"kkBarrageSendStatus"
#define kkLiveShareCount @"kkLiveShareCount"
#define kkLivePlayTimes @"kkLivePlayTimes"
#define kkBarrageSendCount @"kkBarrageSendCount"

//即将回到前台
#define ApplicationDidBecomeActiveNotification @"ApplicationDidBecomeActiveNotification"

//即将进入后台
#define ApplicationDidEnterBackgroundNotification @"ApplicationDidEnterBackgroundNotification"

#define TitleColor [UIColor colorFromHexString:@"333333"]
#define DetailColor [UIColor colorFromHexString:@"333333"]

//文字发生变化
#define TextChangeNotification @"TextChangeNotification"

#define RequestSuccessCode 200

#import "UntilTools.h"
#import "HCLLoadingWaitBoxManager.h"
#import <Foundation/Foundation.h>
#import "EnumHeader.h"
#import "BaseTabBarController+autoRotate.h"
#import "NaviControllrer+autoRotate.h"

#import "AppDelegate.h"
#import "BaseBarController.h"
#import "BaseViewController.h"
#import "Colours.h"
#import "UIView+LXShadowPath.h"
#import "HCToast.h"
#import "UserInstance.h"
#import "Masonry.h"
#import <YYKit/YYKit.h>
#import <SDWebImage/SDWebImage.h>
#import "BXExtensions.h"
#import "STTextHudTool.h"
#import "HttpRequest.h"
#import "MJRefresh.h"
#import "ACActionSheet.h"
#import "UIAlertController+ACAlertView.h"
#import "BDCustomAlertView.h"
#import "STTextHudTool.h"
#import "ZGAlertView.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "KeychainTool.h"
#import "DREmptyView.h"
#import "NoMoreView.h"
//#import "AppDelegate.h"
#endif /* Prefix_h */
