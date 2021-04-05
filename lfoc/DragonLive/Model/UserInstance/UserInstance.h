//
//  UserInstance.h
//  BallSaintSport
//
//  Created by LoaA on 2020/11/12.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserInstance : NSObject

/// 用户模型
@property (nonatomic, strong) UserModel *userModel;

/// 用户的dict
@property (nonatomic, strong) NSDictionary *userDict;

@property (nonatomic, strong) NSString *userId;

/// xmpp服务地址
@property (nonatomic, strong) NSString *xmppServerAddress;

/// xmpp服务是否登录
@property (nonatomic, assign) BOOL isXmppLogin;

/// 设置小窗播放
@property (nonatomic, assign) BOOL isSetSmallWindow;

/// 设置后台播放
@property (nonatomic, assign) BOOL isSetBackgroundPlay;

/// 设置弹幕开关
@property (nonatomic, assign) BOOL isSetBarrageOpen;

/// 设置弹幕透明度
@property (nonatomic, assign) CGFloat barrageFontAlpha;

/// 设置弹幕字体大小
@property (nonatomic, assign) CGFloat barrageFontSize;

/// 设置弹幕位置
@property (nonatomic, assign) NSInteger barrageFontPosition;

/// 用户是否被禁言
@property (nonatomic, assign) BOOL disableUserMessage;

/// 用户是否绑定银行卡卡号
@property (nonatomic, assign) BOOL havebankCard;

+(instancetype)shareInstance;


/// 是否登录 返回NO为未登录
-(BOOL)isLogin;

@end

NS_ASSUME_NONNULL_END
