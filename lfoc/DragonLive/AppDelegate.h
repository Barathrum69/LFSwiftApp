//
//  AppDelegate.h
//  DragonLive
//
//  Created by 11号 on 2020/11/18.
//

#import <UIKit/UIKit.h>

@class BaseTabBarController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BaseTabBarController *tabBarController;
@property (assign, nonatomic) BOOL showStyemKeyBoard;
@end

