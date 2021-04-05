//
//  AJADLaunchObject.m
//  AJADLaunchObject
//
//  Created by Jame on 19/6/16.
//  Copyright © 2019年 Jame. All rights reserved.
//


#import "AJADLaunchObject.h"
#import "AJCountDownView.h"
#import "LoginRegisterProxy.h"

static NSString *const adImageName = @"adImageName";
static NSString *const adImagePath = @"adImagepath";
static NSString *const adUrl = @"adImageUrl";
static NSString *const adDeadline = @"adDeadline";

@interface AJADLaunchObject ()
@property (nonatomic, strong) UIWindow* window;
@property (nonatomic, assign) NSInteger downCount;
@property (nonatomic, strong) AJCountDownView *countDownView;
//路径
@property (nonatomic, strong) NSString *img_path;

@property (nonatomic, strong) NSString *img_url;

@end

@implementation AJADLaunchObject
///在load 方法中，启动监听，可以做到无注入
+ (void)load
{
    [self shareInstance];
}
+ (instancetype)shareInstance
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        ///如果是没啥经验的开发，请不要在初始化的代码里面做别的事，防止对主线程的卡顿，和 其他情况
        
        ///应用启动, 首次开屏广告
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            ///要等DidFinished方法结束后才能初始化UIWindow，不然会检测是否有rootViewController
            [self checkAD];
        }];
        ///进入后台
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [self request];
        }];
        ///后台启动,二次开屏广告
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
//            [self checkAD];
        }];
    }
    return self;
}


- (void)request
{
    
    
    [LoginRegisterProxy getAdvertisingRequestSuccess:^(NSString * _Nonnull imgString, NSString * _Nonnull linkUrl, NSInteger code) {
        if (code == 200) {
            [[NSUserDefaults standardUserDefaults]setObject:imgString forKey:adImagePath];
            [self getAdvertisingImageUrl:imgString];
            [[NSUserDefaults standardUserDefaults] setObject:linkUrl forKey:adUrl];
        }else{
            [self deleteOldImage];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    

    ///.... 请求新的广告数据
}
- (void)checkAD
{
    // 1.判断沙盒中是否存在广告图片
    NSString *filePath = [self getFilePathWithImageName:[[NSUserDefaults standardUserDefaults] valueForKey:adImageName]];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    NSLog(@"%hhd  %@ %@",isExist,[[NSUserDefaults standardUserDefaults] valueForKey:adDeadline],filePath);
    if (isExist) {
        self.img_path = filePath;
        //如果有就显示.
        [self show];
    }else{
        //没有 那就通知换界面了.
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WindowSkipAction" object:nil userInfo:nil];
    }
    // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:adImagePath]isEqualToString:@""]) {
        [self getAdvertisingImageUrl:[[NSUserDefaults standardUserDefaults]objectForKey:adImagePath]];
    }else{
        [self hide];
    }
    
    ///我们这里都当做有
}
- (void)show
{
    ///初始化一个Window， 做到对业务视图无干扰。
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = [BaseViewController new];
    window.rootViewController.view.backgroundColor = [UIColor clearColor];
    window.rootViewController.view.userInteractionEnabled = NO;
    ///广告布局
    [self setupSubviews:window];
    
    ///设置为最顶层，防止 AlertView 等弹窗的覆盖
    window.windowLevel = UIWindowLevelStatusBar + 1;
    
    ///默认为YES，当你设置为NO时，这个Window就会显示了
    window.hidden = NO;
    window.alpha = 1;
    
    ///防止释放，显示完后  要手动设置为 nil
    self.window = window;
}

- (void)letGo
{
    ///不直接取KeyWindow 是因为当有AlertView 或者有键盘弹出时， 取到的KeyWindow是错误的。
    [self hide];
    [self performSelector:@selector(pushVC) afterDelay:0.11];
    
}

-(void)pushVC
{
    [UntilTools advertisingPushVC];

}

- (void)goOut
{
    [self hide];
}
- (void)hide
{
    ///来个渐显动画
    [UIView animateWithDuration:0.1 animations:^{
        self.window.alpha = 0;
    } completion:^(BOOL finished) {
        [self.window.subviews.copy enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        self.window.hidden = YES;
        self.window = nil;
        //通知换界面了.
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WindowSkipAction" object:nil userInfo:nil];

    }];
}

///初始化显示的视图， 可以挪到具
- (void)setupSubviews:(UIWindow*)window
{
    ///随便写写
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:window.bounds];
//    imageView.image = [UIImage imageNamed:@"adimage.png"];
    imageView.image = [UIImage imageWithContentsOfFile:self.img_path];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    
    ///给非UIControl的子类，增加点击事件
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(letGo)];
    [imageView addGestureRecognizer:tap];
    
    [window addSubview:imageView];
    
    ///增加一个倒计时跳过按钮
    
    self.countDownView = [[AJCountDownView alloc]initWithFrame:CGRectMake(window.bounds.size.width - 40 - 20, kTopHeight-44, 40, 40)];
    
    __weak AJADLaunchObject *weakself = self;
    self.countDownView.countFinished = ^{
        [weakself goOut];
    };
     [window addSubview:self.countDownView];
    [self.countDownView showWithTime:5];

}

/**
 *  初始化广告页面
 */
- (void)getAdvertisingImageUrl:(NSString *)url
{
    
    
//    NSArray *imageArray = @[@"http://image.thepaper.cn/www/image/22/411/501.jpg"];
    NSString *imageUrl = url;
    
    NSString  *imgLinkUrl = [[NSUserDefaults standardUserDefaults] objectForKey:adUrl];
    
    NSString  *imgDeadline =  @"09/30/2016 14:25";
    
    
    // 获取图片名
    NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
    NSString *imageName = stringArr.lastObject;
    
    // 拼接沙盒路径
    NSString *filePath = [self getFilePathWithImageName:imageName];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    
    
    if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
        
        [self downloadAdImageWithUrl:imageUrl imageName:imageName imgLinkUrl:imgLinkUrl imgDeadline:imgDeadline];
        
    }
    
    
}


/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}


/**
 *  下载新的图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName imgLinkUrl:(NSString *)imgLinkUrl imgDeadline:(NSString *)imgDeadline
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        
        
        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
        [UIImageJPEGRepresentation(image, 0) writeToFile:filePath atomically:YES];
        if ([UIImageJPEGRepresentation(image, 0) writeToFile:filePath atomically:YES]) {
            
            // 保存成功
            //判断保存下来的图片名字和本地沙盒中存在的图片是否一致，如果不一致，说明图片有更新，此时先删除沙盒中的旧图片，如果一致说明是删除缓存后再次下载，这时不需要进行删除操作，否则找不到已保存的图片
            if (![imageName isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:adImageName] ]) {
                [self deleteOldImage];
            }
            
            [[NSUserDefaults standardUserDefaults] setValue:imageName forKey:adImageName];
            [[NSUserDefaults standardUserDefaults] setValue:imgLinkUrl forKey:adUrl];
            [[NSUserDefaults standardUserDefaults] setValue:imgDeadline forKey:adDeadline];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }else{
            NSLog(@"保存失败");
        }
        
    });
}




/**
 *  删除旧图片
 */
- (void)deleteOldImage
{
    NSString *imageName = [[NSUserDefaults standardUserDefaults] valueForKey:adImageName];
    
    if (imageName) {
        
        NSString *filePath = [self getFilePathWithImageName:imageName];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:adImageName];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:adUrl];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:adDeadline];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:adImagePath];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
}

/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName

{
    
    if (imageName) {
        
        NSString *paths = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) lastObject];
        NSString *filePath = [paths stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    return nil;
}



@end
