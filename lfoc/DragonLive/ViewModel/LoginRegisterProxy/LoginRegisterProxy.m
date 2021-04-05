//
//  LoginRegisterProxy.m
//  DragonLive
//
//  Created by LoaA on 2020/12/23.
//

#import "LoginRegisterProxy.h"
#import "UserInstance.h"
#import "SHXMPPManager.h"
#import "AppVersionModel.h"
@implementation LoginRegisterProxy


/// 获取盐的接口.
/// @param success 成功
/// @param failure 失败
+(void)registerSaltSuccess:(void (^)(NSString * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure{

    NSMutableDictionary *params = [NSMutableDictionary new];
    [HttpRequest requestWithURLType:UrlTypeCommonSalt parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        NSLog(@"111");
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            NSString *salt = [responseObject objectForKey:@"data"];
            success(salt);
        }else{
            NSError *error;
            failure(error);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}


/// 注册接口
/// @param phoneNum 手机号
/// @param userPass 用户密码
/// @param phoneCountryCode 国家区号
/// @param code 验证码
/// @param success 成功
/// @param failure 失败
+(void)registerUserWithPhoneNum:(NSString *)phoneNum userPass:(NSString *)userPass phoneCountryCode:(NSString *)phoneCountryCode code:(NSString *)code success:(void (^)(BOOL isSuccess))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:phoneNum forKey:@"phoneNum"];
    [params setObject:userPass forKey:@"userPass"];
    [params setObject:phoneCountryCode forKey:@"phoneCountryCode"];
    [params setObject:code forKey:@"code"];
    
    [HttpRequest requestWithURLType:UrlTypeUserRegister parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        NSLog(@"111111");
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            
            UserModel *model =[UserModel modelWithDictionary:responseObject[@"data"]];
            NSString *userJsonStr = [UntilTools convertToJsonData:responseObject[@"data"]];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:userJsonStr forKey:UserDefaultsUserInfo];
            [UserInstance shareInstance].userModel = model;
            [UserInstance shareInstance].userId = model.userId;
            [UserInstance shareInstance].userDict = responseObject[@"data"];
            [userDefaults setObject:[UserInstance shareInstance].userId forKey:UserDefaultsToken];
            
            //注册成功连接xmpp服务并注册
//            [[SHXMPPManager xmppManager] setupStream];
            [[SHXMPPManager xmppManager] registerWithUserName:[UserInstance shareInstance].userModel.userName password:@"123456" registerSuccess:^{
                [[SHXMPPManager xmppManager] disconnect];
                NSLog(@"xmpp注册成功！");
            } registerFailed:^(NSString * _Nonnull error) {
                
            }];
            
            success(YES);
        }else{
            [UntilTools showErrorCode:code];

            NSError *error;
            failure(error);        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

/// 获取验证码
/// @param phoneNum 手机号
/// @param phoneCountryCode 国家代码
/// @param codeType 1-登录,2注册，3-找回密码,4，主播申请 5修改密码-验证手机号，6绑定手机号
/// @param success 成功
/// @param failure 失败
+(void)regirstLoginVerificationCodeWithPhoneNum:(NSString *)phoneNum phoneCountryCode:(NSString *)phoneCountryCode codeType:(nonnull NSString *)codeType success:(nonnull void (^)(BOOL, int))success failure:(nonnull void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:phoneNum forKey:@"phoneNum"];
    [params setObject:phoneCountryCode forKey:@"phoneCountryCode"];
    [params setObject:codeType forKey:@"codeType"];
    
    [HttpRequest requestWithURLType:UrlTypeVerificationCode parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            success(YES,code);
        }else{
//            [[HCToast shareInstance]showToast:[responseObject objectForKey:@"message"]];
            if (code == 2005||code == 2001) {
                //已经注册过.
                success(NO,code);
            }else{
                [[HCToast shareInstance]showToast:[UntilTools showErrorMessage:[responseObject objectForKey:@"message"]]];
                NSError *error;
                failure(error);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

/// 登录
/// @param phoneNum 电话号码
/// @param userPass 密码
/// @param phoneCountryCode 国家代码
/// @param loginType 登录类型（账号登录-3，验证码登录-1）
/// @param code 验证码
/// @param success 成功
/// @param failure 失败
+(void)loginRequestWithPhoneNum:(NSString *)phoneNum userPass:(NSString *)userPass phoneCountryCode:(NSString *)phoneCountryCode loginType:(NSString *)loginType code:(NSString *)code salt:(NSString *)salt success:(void (^)(BOOL isSuccess,int code))success failure:(void (^)(NSError *error))failure
{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:phoneNum forKey:@"phoneNum"];
    [params setObject:phoneCountryCode forKey:@"phoneCountryCode"];
    if ([loginType isEqualToString:@"3"]) {
        [params setObject:userPass forKey:@"password"];
    }else if ([loginType isEqualToString:@"1"]){
        [params setObject:code forKey:@"code"];
    }
    [params setObject:loginType forKey:@"loginType"];
    [params setObject:salt forKey:@"salt"];

    [HttpRequest requestWithURLType:UrlTypeUserLogin parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            UserModel *model =[UserModel modelWithDictionary:responseObject[@"data"]];
            NSString *userJsonStr = [UntilTools convertToJsonData:responseObject[@"data"]];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:userJsonStr forKey:UserDefaultsUserInfo];
            [UserInstance shareInstance].userModel = model;
            [UserInstance shareInstance].userId = model.userId;
            [UserInstance shareInstance].userDict = responseObject[@"data"];
            [userDefaults setObject:[UserInstance shareInstance].userId forKey:UserDefaultsToken];

            success(YES,code);
        }else
        {
            success(NO,code);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    

}

/// 更新密码
/// @param oldPwd 旧密码
/// @param userPass 新密码
/// @param success 成功
/// @param failure 失败
+(void)modifyPasswordWitOldPwd:(NSString *)oldPwd userPass:(NSString *)userPass success:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:oldPwd forKey:@"oldPwd"];
    [params setObject:userPass forKey:@"userPass"];
    [params setObject:[UserInstance shareInstance].userId forKey:@"userId"];

    
    [HttpRequest requestWithURLType:UrlTypeModifyPassword parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            success(YES);
        }else{
            [[HCToast shareInstance]showToast:[UntilTools showErrorMessage:[responseObject objectForKey:@"message"]]];
            NSError *error;
            failure(error);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

/// 换绑手机号
/// @param phoneNum 手机号
/// @param phoneCountryCode 国家代码
/// @param code 验证码
/// @param success 成功
/// @param failure 失败
+(void)modifyPhoneNumerWithPhoneNum:(NSString *)phoneNum phoneCountryCode:(NSString *)phoneCountryCode code:(NSString *)code success:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:phoneNum forKey:@"phoneNum"];
    [params setObject:phoneCountryCode forKey:@"phoneCountryCode"];
    [params setObject:code forKey:@"code"];
    [params setObject:[UserInstance shareInstance].userId forKey:@"userId"];
    [HttpRequest requestWithURLType:UrlTypeModifyPhone parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            success(YES);
        }else{
            [[HCToast shareInstance]showToast:[UntilTools showErrorMessage:[responseObject objectForKey:@"message"]]];
            NSError *error;
            failure(error);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);

    }];
    
}

/// Email
/// @param email 邮箱
/// @param codeType 类型（1，注册，2，登录，3，找回密码，4.绑定邮箱）
/// @param success 成功
/// @param failure 失败
+(void)getEmailCodeWithEmail:(NSString *)email codeType:(NSString *)codeType success:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure
{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:email forKey:@"email"];
    [params setObject:codeType forKey:@"codeType"];
    [params setObject:[UserInstance shareInstance].userId forKey:@"userId"];

    [HttpRequest requestWithURLType:UrlTypeGetEmailCode parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            success(YES);
        }else{
            [[HCToast shareInstance]showToast:[UntilTools showErrorMessage:[responseObject objectForKey:@"message"]]];
            NSError *error;
            failure(error);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);

    }];
}

/// 修改邮箱
/// @param email 邮箱
/// @param code 验证码
/// @param success 成功
/// @param failure 失败
+(void)modifyEmailWithEmail:(NSString *)email code:(NSString *)code success:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:email forKey:@"email"];
    [params setObject:code forKey:@"code"];
    [params setObject:[UserInstance shareInstance].userId forKey:@"userId"];

    [HttpRequest requestWithURLType:UrlTypeModifyEmail parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            success(YES);
        }else{
            [[HCToast shareInstance]showToast:[UntilTools showErrorMessage:[responseObject objectForKey:@"message"]]];
            NSError *error;
            failure(error);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}


/// 找回密码
/// @param phoneNum 手机号
/// @param code 验证码
/// @param userPass 密码
/// @param phoneCountryCode 国家区号
/// @param success 成功
/// @param failure 失败
+(void)findPswWithPhoneNum:(NSString *)phoneNum code:(NSString *)code userPass:(NSString *)userPass phoneCountryCode:(NSString *)phoneCountryCode success:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:phoneNum forKey:@"phoneNum"];
    [params setObject:code forKey:@"code"];
    [params setObject:userPass forKey:@"userPass"];
    [params setObject:phoneCountryCode forKey:@"phoneCountryCode"];
    
    [HttpRequest requestWithURLType:UrlTypeFindPassWord parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            success(YES);
        }else{
            [[HCToast shareInstance]showToast:[UntilTools showErrorMessage:[responseObject objectForKey:@"message"]]];
            NSError *error;
            failure(error);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}



/// 获取开屏广告页
/// @param success 成功
/// @param failure 失败
+(void)getAdvertisingRequestSuccess:(void (^)(NSString * _Nonnull, NSString * _Nonnull, NSInteger))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"22" forKey:@"tabId"];
    [params setObject:@"46" forKey:@"positionId"];
    
    [HttpRequest requestWithURLType:UrlTypeHomeBanner parameters:params type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            
            NSArray *array = responseObject[@"data"];
            if (array.count != 0) {
                NSDictionary *dict = array[0];
                NSString *contentUrl = dict[@"contentUrl"];
                NSString *linkUrl    = dict[@"linkUrl"];
                success(contentUrl,linkUrl,code);
            }else{
                success(@"",@"",2001);

            }
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);

    }];
}

/// 获取最新版本
/// @param success 成功
/// @param failure 失败
+(void)getCurrentAppVersionsSuccess:(void (^)(AppVersionModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"3" forKey:@"clientType"];
    
    [HttpRequest requestWithURLType:UrlTypeGetCurrentAppVersions parameters:params type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            AppVersionModel *model = [AppVersionModel modelWithDictionary:responseObject[@"data"]];
            success(model);
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


@end
