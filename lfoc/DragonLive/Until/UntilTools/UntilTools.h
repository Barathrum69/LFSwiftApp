//
//  UntilTools.h
//  DragonLive
//
//  Created by LoaA on 2020/12/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UploadParam;
@class XMNShareView;
@interface UntilTools : NSObject
    

/// 组装fans
/// @param fans 粉丝数
+(NSMutableAttributedString *)attHostFans:(NSString *)fans;

/// 首页组合起来观看量和评论量
/// @param watch 观看量
/// @param comment 评论量
+(NSMutableAttributedString *)videoItemWatchNum:(NSString *)watch comment:(NSString *)comment;

/// 视频推荐的组合起来观看量和评论量
/// @param watch 观看量
/// @param comment 评论量
+(NSMutableAttributedString *)recommedVideoItemWatchNum:(NSString *)watch comment:(NSString *)comment;

/// 单位转万 百万 千万
/// @param string 字符串
+(NSString *)getDealNumwithstring:(NSString *)string;

/// 秒转时分秒
/// @param totalTime 秒
+(NSString *)getMMSSFromSS:(NSString *)totalTime;

/// 根据传入的字符串 字体大小 宽度,计算size
/// @param txt 文字
/// @param font 字体大小
/// @param size 传入的宽度和最大值
+(CGSize)boundingALLRectWithSize:(NSString*) txt Font:(UIFont*) font Size:(CGSize) size;

/// 时间转换
/// @param time 时间
/// @param format 格式
+(NSString *)converTimeWithString:(NSString *)time format:(NSString *)format;

/// 日期年月日转月日
/// @param dateString 月日字符串
+(NSString *)converTimeWithMMDDString:(NSString *)dateString;

/// 判断密码 只有数字+字母
/// @param password 密码
+(BOOL)checkIsHaveNumAndLetter:(NSString*)password;

/// 手机正则
/// @param mobile 手机号
+ (BOOL)isValidateMobile:(NSString *)mobile;


/// 32位MD5加密大写
/// @param string 需要加密的字符串
+ (NSString*)md532BitUpperString:(NSString *)string;

/// 把32位MD5后的密码和盐拼接起来
/// @param md5String Md5
/// @param salt 盐
+ (NSString *)dealMd532BitString:(NSString *)md5String salt:(NSString *)salt;

/*!
* @brief 把格式化的JSON格式的字符串转换成字典
* @param jsonString JSON格式的字符串
* @return 返回字典
*/
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/// 字典转json
/// @param dict 字典
+(NSString *)convertToJsonData:(NSDictionary *)dict;

//处理一下那个countryCode。
+(NSString *)dealCountryCode:(NSString *)code;


/// 根据错误码显示中文提示语 （这段代码由可爱的Remi小姐姐协助。 非常感谢.）
/// @param code 错误码
+(void)showErrorCode:(int)code;


/// 根据错误提示返回错误
/// @param message 错误
+(NSString *)showErrorMessage:(NSString *)message;

/// 获取最顶层的VC
+ (UIViewController * )topViewController;

/// 推出登录页
+(void)pushLoginPage;


/// 带回调的推出登录页
/// @param success 成功
+(void)pushLoginPageSuccess:(void (^)(void))success;


/// 清除本地缓存
+(void)cleanUserDefault;

/// 身份证正则
/// @param value 身份证号
+(BOOL)validateIDCardNumber:(NSString *)value;

/// image转base64
/// @param image image
+(NSString *)convertImage:(UIImage *)image;


///获取图片名的后缀
+(NSString *)getImageName:(UIImage *)image;


///获取图片转Md5
+(NSString *)getDataMd5WithImage:(UIImage *)image;

/// data转md5
/// @param data 数据
+ (NSString*)getMD5WithData:(NSData *)data;
/// 根据大小裁剪图片
/// @param image 图片
/// @param newSize 大小
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
/// 邮箱正则
/// @param email email
+ (BOOL)checkEmail:(NSString *)email;

/// 银行卡正则.
/// @param cardNumber 银行卡
+ (BOOL)IsBankCard:(NSString *)cardNumber;

//根据卡号判断银行
+ (NSString *)returnBankName:(NSString *)cardName;

/// 跳转到广告页
+ (void)advertisingPushVC;


/// 根据时间转星期几
/// @param timeString 时间戳
+(NSString*)weekdayStringFromDate:(NSString *)timeString;


/// 弹起分享页面
/// @param sysparamCode  sysparamCode sysparamCode SHARE_VIDEO_URL   视频分享链接前缀 SHARE_LIVE_ROOM_URL  直播间分享链接前缀
/// @param itemId 目标id
+ (void)pushSharePageSysparamCode:(NSString *)sysparamCode itemId:(NSString *)itemId isTask:(BOOL)isTask shareView:(XMNShareView *)shareView success:(void (^)(void))success;


/// 给subview添加渐变色图层
/// @param subView 添加渐变色的view
/// @param fromColor 起始颜色
/// @param toColor 结束颜色
+ (void)addCAGradientLayer:(UIView *)subView fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor;

/// 根据时间去算是今天还是明天
/// @param string YYYY MM DD
+ (NSString *)checkTheDate:(NSString *)string;

/// 几分钟前 几小时前  大于24小时 显示正常
/// @param str str
+ (NSString *)compareCurrentTime:(NSString *)str;

/// 键盘展示,是否允许强制系统键盘
/// @param show NO 强制使用系统键盘。YES 允许使用第三方键盘
//+(void)showAppKeyBoard:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
