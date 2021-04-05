//
//  AppDelegate.m
//  DragonLive
//
//  Created by 11号 on 2020/11/18.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "TXLiveBase.h"
#import "OttoFPSButton.h"
#import "EasyTextGlobalConfig.h"
#import "EasyLoadingGlobalConfig.h"
#import "EasyLoadingConfig.h"
#import "SHXMPPManager.h"
#import "DRSmallDragView.h"
#import "HLNetWorkReachability.h"
#import "BadNetWorkView.h"
#import "SELUpdateAlert.h"
#import "LoginRegisterProxy.h"
#import "AppVersionModel.h"
@import TXLiteAVSDK_Professional;

@interface AppDelegate ()<TXLiveBaseDelegate>

@property (nonatomic) HLNetWorkReachability *hostReachability;

/// 全局无网络的view
@property (nonatomic, strong) BadNetWorkView *badNetWorkView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self accessibility];
    //网络状态判断
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(kNetWorkReachabilityChangedNotification:) name:kNetWorkReachabilityChangedNotification object:nil];
    
    
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayback
     error: &setCategoryErr];
    [[AVAudioSession sharedInstance]
     setActive: YES
     error: &activationErr];
    self.tabBarController = [[BaseTabBarController alloc] init];
    self.window.rootViewController = self.tabBarController;
    [self  keyBoard];
    //初始化腾讯直播拉流sdk
    NSString * const licenceURL = @"<获取到的licenseUrl>";
    NSString * const licenceKey = @"<获取到的key>";
    //TXLiveBase 位于 "TXLiveBase.h" 头文件中
    [TXLiveBase setLicenceURL:@"" key:@""];
    NSLog(@"SDK Version = %@", [TXLiveBase getSDKVersionStr]);
    
    //初始化直播sdk日志服务
    [TXLiveBase sharedInstance].delegate = self;
    [TXLiveBase setConsoleEnabled:NO];
    [TXLiveBase setAppID:@"1252463788"];
    
    //初始化loading和toast动画配置
    [self easyGlobalConfig];
    
    //获取本地登录信息
    [self getUserModel];
    
    //获取设置信息
    [self getSettingInfo];
    
    [self checkVersion];
    //版本更新
//    [SELUpdateAlert showUpdateAlertWithVersion:@"1.0.0" Descriptions:@[@"1.更新条数3",@"2.哈就是克利夫兰的刚开打算发",@"3.还是贷记卡的健身卡萨达",@"4.我是第四条"]isShowCancel:NO url:@"https://www.baidu.com"];
    
    
//#if DEBUG
//    //测试开启监听fps
//    CGRect frame = CGRectMake(0, 300, 80, 30);
//    UIColor *btnBGColor = [UIColor colorWithWhite:0.000 alpha:0.700];
//    OttoFPSButton *btn = [OttoFPSButton setTouchWithFrame:frame titleFont:[UIFont systemFontOfSize:15] backgroundColor:btnBGColor backgroundImage:nil];
//    [self.window addSubview:btn];
//#endif

    return YES;
}


-(void)checkVersion{
    [LoginRegisterProxy getCurrentAppVersionsSuccess:^(AppVersionModel * _Nonnull model) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];


        if (![appCurVersion isEqualToString:model.versions]) {
            BOOL isShow = YES;
            if (model.modeType == 1) {
                isShow = NO;
            }
            [SELUpdateAlert showUpdateAlertWithVersion:model.versions Description:model.descriptions isShowCancel:isShow url:model.goToUrl];

        }
        

    } failure:^(NSError * _Nonnull error) {
        
    }];
}


-(void)accessibility{
    HLNetWorkReachability *reachability = [HLNetWorkReachability reachabilityWithHostName:@"www.baidu.com"];
    self.hostReachability = reachability;
    [reachability startNotifier];
}//网络检测

-(void)kNetWorkReachabilityChangedNotification:(NSNotification *)note
{
    HLNetWorkReachability *curReach = [note object];
    HLNetWorkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus) {
        case HLNetWorkStatusNotReachable:
            NSLog(@"网络不可用");
            [self initNotReachable];
            break;
        case HLNetWorkStatusUnknown:
            NSLog(@"未知网络");
            [self removeNotReachable];
            break;
        case HLNetWorkStatusWWAN2G:
            NSLog(@"2G网络");
            [self removeNotReachable];
            
            break;
        case HLNetWorkStatusWWAN3G:
            NSLog(@"3G网络");
            [self removeNotReachable];
            
            break;
        case HLNetWorkStatusWWAN4G:
            NSLog(@"4G网络");
            [self removeNotReachable];
            
            break;
        case HLNetWorkStatusWiFi:
            NSLog(@"WiFi");
            [self removeNotReachable];
            break;
            
        default:
            break;
    }
    
} //网络状态判断
-(void)initNotReachable
{
    kWeakSelf(self);
    if (!_badNetWorkView) {
        _badNetWorkView = [[BadNetWorkView alloc]initWithFrame:self.window.frame];
        _badNetWorkView.refreshBlock = ^{
            [weakself gotoSettings];
        };
        [self.window addSubview:_badNetWorkView];
    }

}//增加View

-(void)removeNotReachable
{
    if (_badNetWorkView) {
        [_badNetWorkView removeFromSuperview];
        _badNetWorkView = nil;
    }
}//移除掉.
- (void)gotoSettings {
    NSString *urlString = @"App-Prefs:root=WIFI";
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}//去setting页面

-(void)keyBoard
{
    IQKeyboardManager* manager = [IQKeyboardManager sharedManager];

    manager.enable = YES;

    manager.shouldResignOnTouchOutside = YES;

    manager.shouldToolbarUsesTextFieldTintColor = YES;

    manager.enableAutoToolbar = NO;

 
}


-(void)onLog:(NSString*)log LogLevel:(int)level WhichModule:(NSString*)module
{
    NSLog(@"level:%d|module:%@| %@\n", level, module, log);
}

-(void)getUserModel{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [userDefaults objectForKey:UserDefaultsUserInfo];
    NSString *token = [userDefaults objectForKey:UserDefaultsToken];
    if (token.length != 0) {
        [UserInstance shareInstance].userId = token;
    }
    if (str.length != 0) {
        NSDictionary *dict = [UntilTools dictionaryWithJsonString:str];
        if (dict) {
            [UserInstance shareInstance].userDict = dict;
            [UserInstance shareInstance].userModel = [UserModel modelWithDictionary:dict];
        }
    }else {
        //游客首次进入
        NSDictionary *visitorDic = [userDefaults objectForKey:UserVisitorAccount];
        NSString *visitorAccount;
        NSString *visitorNickName;
        if (visitorDic) {
            visitorAccount = [visitorDic objectForKey:@"visitorAccount"];
            visitorNickName = [visitorDic objectForKey:@"visitorNickName"];
        }else {
            
            //用户信息
            visitorAccount = [NSString stringWithFormat:@"%lld",[self getDateTimeTOMilliSeconds]];
            int random = (arc4random() % 100000) + 900000;  //游客默认6位随机数为账号
            visitorNickName = [NSString stringWithFormat:@"游客%d",random];
            visitorDic = [NSDictionary dictionaryWithObjectsAndKeys:visitorAccount,@"visitorAccount",visitorNickName,@"visitorNickName", nil];
            [userDefaults setObject:visitorDic forKey:UserVisitorAccount];

            //游客首次进入连接xmpp服务并注册
//            [[SHXMPPManager xmppManager] setupStream];
            [[SHXMPPManager xmppManager] registerWithUserName:visitorAccount password:@"123456" registerSuccess:^{
                [[SHXMPPManager xmppManager] disconnect];
                NSLog(@"xmpp注册成功！");
            } registerFailed:^(NSString * _Nonnull error) {
            }];
            
            //默认设置
            [self setSettinginfo];
        }
        UserModel *userModel = [[UserModel alloc] init];
        userModel.userName = visitorAccount;
        userModel.nickname = visitorNickName;
        [UserInstance shareInstance].userModel = userModel;
    }
}//给usermodel赋值

//初始化设置信息
- (void)setSettinginfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:kkSetSmallWindow];
    [userDefaults setBool:YES forKey:kkSetBackgroundPlay];
    [userDefaults setBool:YES forKey:kkBarrageOpenManager];
    [userDefaults setFloat:0.5 forKey:kkBarrageFontAlpha];
    [userDefaults setFloat:16 forKey:kkBarrageFontSize];
    [userDefaults setInteger:1 forKey:kkBarrageFontPosition];
    [userDefaults synchronize];
}

//获取设置信息
- (void)getSettingInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [UserInstance shareInstance].xmppServerAddress = [userDefaults objectForKey:kkXmppServerAddress];
    [UserInstance shareInstance].isSetSmallWindow = [userDefaults objectForKey:kkSetSmallWindow];
    [UserInstance shareInstance].isSetBackgroundPlay = [userDefaults objectForKey:kkSetBackgroundPlay];
    [UserInstance shareInstance].isSetBarrageOpen = [userDefaults objectForKey:kkBarrageOpenManager];
    [UserInstance shareInstance].barrageFontAlpha = [[userDefaults objectForKey:kkBarrageFontAlpha] floatValue];
    [UserInstance shareInstance].barrageFontSize = [[userDefaults objectForKey:kkBarrageFontSize] floatValue];
    [UserInstance shareInstance].barrageFontPosition = [[userDefaults objectForKey:kkBarrageFontPosition] integerValue];
}

//精确到毫秒时间戳
-(long long)getDateTimeTOMilliSeconds
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    long long totalMilliseconds = interval*1000 ;       //毫秒
     
    NSLog(@"totalMilliseconds=%llu",totalMilliseconds);
     
    return totalMilliseconds;
 
}

/// tost提示框和loading动画初始化配置
- (void)easyGlobalConfig
{
    /**显示文字**/
    EasyTextGlobalConfig *config = [EasyTextGlobalConfig shared];
    config.bgColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    config.titleColor = [UIColor whiteColor];
    config.titleFont = [UIFont systemFontOfSize:13];
    config.shadowColor = [UIColor clearColor];
    
   /**显示加载框**/
//    EasyLoadingGlobalConfig *loadingConfig = [EasyLoadingGlobalConfig shared];
//    loadingConfig.LoadingType = LoadingAnimationTypeFade ;
//    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:23];
//    for (int i = 0; i < 9; i++) {
//        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"icon_hud_%d",i]];
//        [tempArr addObject:img] ;
//    }
//    loadingConfig.tintColor = [UIColor blackColor];
//    loadingConfig.bgColor = [UIColor blackColor];
//    loadingConfig.playImagesArray = tempArr ;
//
//    EasyLoadingConfig *submitLoading = [EasyLoadingConfig shared];
//    submitLoading.LoadingType = LoadingShowTypeIndicatorLeft;
//    submitLoading.bgColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
//    submitLoading.textFont = [UIFont systemFontOfSize:13];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"应用程序已经进入后台运行");
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    UIApplication*   app = [UIApplication sharedApplication];
      __block    UIBackgroundTaskIdentifier bgTask;
      bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
          dispatch_async(dispatch_get_main_queue(), ^{
              if (bgTask != UIBackgroundTaskInvalid)
              {
                  bgTask = UIBackgroundTaskInvalid;
              }
          });
      }];
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          dispatch_async(dispatch_get_main_queue(), ^{
              if (bgTask != UIBackgroundTaskInvalid)
              {
                  bgTask = UIBackgroundTaskInvalid;
              }
          });
      });
    
    [[NSNotificationCenter defaultCenter]postNotificationName:ApplicationDidEnterBackgroundNotification object:nil];

    if ([DRSmallDragView smallDragViewManager].isSmallShow && ![UserInstance shareInstance].isSetBackgroundPlay) {
        [[DRSmallDragView smallDragViewManager] pause];
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    [[WebSocketRequest sharedInstance]socketOpen];
    
    //app回到前台
    [[NSNotificationCenter defaultCenter]postNotificationName:ApplicationDidBecomeActiveNotification object:nil];
    NSLog(@"应用程序已进入前台，处于活动状态");
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];

    if ([DRSmallDragView smallDragViewManager].isSmallShow && ![UserInstance shareInstance].isSetBackgroundPlay) {
        [[DRSmallDragView smallDragViewManager] resume];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier
//{
//    if (_showStyemKeyBoard) {
//        return YES;
//    }else{
//        return NO;
//    }
////    if ([extensionPointIdentifier isEqualToString:@"com.apple.keyboard-service"]) {
////        return NO;
////    }
////    return YES;
//}// 无赖搜狗键盘。 坑死我.


@end
