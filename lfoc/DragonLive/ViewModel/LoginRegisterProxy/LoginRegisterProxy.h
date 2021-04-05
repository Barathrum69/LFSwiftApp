//
//  LoginRegisterProxy.h
//  DragonLive
//
//  Created by LoaA on 2020/12/23.
//

#import <Foundation/Foundation.h>
@class AppVersionModel;
NS_ASSUME_NONNULL_BEGIN

@interface LoginRegisterProxy : NSObject


/// 获取盐的接口.
/// @param success 成功
/// @param failure 失败
+(void)registerSaltSuccess:(void (^)(NSString *salt))success failure:(void (^)(NSError *error))failure;


/// 注册接口
/// @param phoneNum 手机号
/// @param userPass 用户密码
/// @param phoneCountryCode 国家区号
/// @param code 验证码
/// @param success 成功
/// @param failure 失败
+(void)registerUserWithPhoneNum:(NSString *)phoneNum userPass:(NSString *)userPass phoneCountryCode:(NSString *)phoneCountryCode code:(NSString *)code success:(void (^)(BOOL isSuccess))success failure:(void (^)(NSError *error))failure;


/// 获取验证码
/// @param phoneNum 手机号
/// @param phoneCountryCode 国家代码
/// @param codeType 1-登录,2注册，3-找回密码,4，主播申请 5修改密码-验证手机号，6绑定手机号
/// @param success 成功
/// @param failure 失败
+(void)regirstLoginVerificationCodeWithPhoneNum:(NSString *)phoneNum phoneCountryCode:(NSString *)phoneCountryCode codeType:(NSString *)codeType success:(void (^)(BOOL isSuccess,int code))success failure:(void (^)(NSError *error))failure;


/// 登录
/// @param phoneNum 电话号码
/// @param userPass 密码
/// @param phoneCountryCode 国家代码
/// @param loginType 登录类型（账号登录-3，验证码登录-1）
/// @param salt 盐
/// @param code 验证码
/// @param success 成功
/// @param failure 失败
+(void)loginRequestWithPhoneNum:(NSString *)phoneNum userPass:(NSString *)userPass phoneCountryCode:(NSString *)phoneCountryCode loginType:(NSString *)loginType code:(NSString *)code salt:(NSString *)salt success:(void (^)(BOOL isSuccess,int code))success failure:(void (^)(NSError *error))failure;


/// 更新密码
/// @param oldPwd 旧密码
/// @param userPass 新密码
/// @param success 成功
/// @param failure 失败
+(void)modifyPasswordWitOldPwd:(NSString *)oldPwd userPass:(NSString *)userPass success:(void (^)(BOOL isSuccess))success failure:(void (^)(NSError *error))failure;



/// 换绑手机号
/// @param phoneNum 手机号
/// @param phoneCountryCode 国家代码
/// @param code 验证码
/// @param success 成功
/// @param failure 失败
+(void)modifyPhoneNumerWithPhoneNum:(NSString *)phoneNum phoneCountryCode:(NSString *)phoneCountryCode code:(NSString *)code success:(void (^)(BOOL isSuccess))success failure:(void (^)(NSError *error))failure;




/// Email
/// @param email 邮箱
/// @param codeType 类型（1，注册，2，登录，3，找回密码，4.绑定邮箱）
/// @param success 成功
/// @param failure 失败
+(void)getEmailCodeWithEmail:(NSString *)email codeType:(NSString *)codeType success:(void (^)(BOOL isSuccess))success failure:(void (^)(NSError *error))failure;


/// 修改邮箱
/// @param email 邮箱
/// @param code 验证码
/// @param success 成功
/// @param failure 失败
+(void)modifyEmailWithEmail:(NSString *)email code:(NSString *)code success:(void (^)(BOOL isSuccess))success failure:(void (^)(NSError *error))failure;



/// 找回密码
/// @param phoneNum 手机号
/// @param code 验证码
/// @param userPass 密码
/// @param phoneCountryCode 国家区号
/// @param success 成功
/// @param failure 失败
+(void)findPswWithPhoneNum:(NSString *)phoneNum code:(NSString *)code userPass:(NSString *)userPass phoneCountryCode:(NSString *)phoneCountryCode success:(void (^)(BOOL isSuccess))success failure:(void (^)(NSError *error))failure;


/// 获取开屏广告页
/// @param success 成功
/// @param failure 失败
+(void)getAdvertisingRequestSuccess:(void (^)(NSString *imgString,NSString *linkUrl,NSInteger code))success failure:(void (^)(NSError *error))failure;


/// 获取最新版本
/// @param success 成功
/// @param failure 失败
+(void)getCurrentAppVersionsSuccess:(void (^)(AppVersionModel *model))success failure:(void (^)(NSError *error))failure;


@end

NS_ASSUME_NONNULL_END
