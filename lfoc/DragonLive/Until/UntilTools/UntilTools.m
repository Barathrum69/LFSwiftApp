//
//  UntilTools.m
//  DragonLive
//
//  Created by LoaA on 2020/12/19.
//

#import "UntilTools.h"
#import <CommonCrypto/CommonDigest.h>
#import "LoginController.h"
#import "UploadParam.h"
#import "BAWebViewController.h"
#import "XMNShareView.h"
#import "MineProxy.h"
#import "UserTaskInstance.h"
#import "JHRotatoUtil.h"
#import "ShareHeaderView.h"

NSString *const kXMNShareTitle = @"com.XMFraker.kXMNShareTitle";
NSString *const kXMNShareImage = @"com.XMFraker.kXMNShareImage";
NSString *const kXMNShareHighlightImage = @"com.XMFraker.kXMNShareHighlightImage";
NSString *const kXMNShareTag = @"com.XMFraker.kXMNShareTag";

@implementation UntilTools

/// 组装fans
/// @param fans 粉丝数
+(NSMutableAttributedString *)attHostFans:(NSString *)fans
{
    NSMutableAttributedString *attri =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@  ",fans]];
    // 2.添加表情图片
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:@"icon_sazbrd"];
    
    //        attch.image = [UIImage imageNamed:@"football.gif"];
    // 设置图片大小
    attch.bounds = CGRectMake(0, kWidth(-3), kWidth(13), kWidth(13));
    
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:0];// 插入某个位置
    
   
    return attri;
}




/// 组合起来观看量和评论量
/// @param watch 观看量
/// @param comment 评论量
+(NSMutableAttributedString *)videoItemWatchNum:(NSString *)watch comment:(NSString *)comment
{
    NSMutableAttributedString *attri =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@  ",watch]];
    // 2.添加表情图片
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:@"icon_video_play"];
    
    //        attch.image = [UIImage imageNamed:@"football.gif"];
    // 设置图片大小
    attch.bounds = CGRectMake(0, kWidth(-2), kWidth(11), kWidth(11));
    
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:0];// 插入某个位置
    
    
    NSMutableAttributedString *att =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",comment]];
    NSTextAttachment *attch2 = [[NSTextAttachment alloc] init];
    attch2.image = [UIImage imageNamed:@"icon_video_comment"];
    attch2.bounds = CGRectMake(0, kWidth(-2), kWidth(11), kWidth(11));
    NSAttributedString *string2 = [NSAttributedString attributedStringWithAttachment:attch2];
    [att insertAttributedString:string2 atIndex:0];// 插入某个位置
    [attri appendAttributedString:att];
    
    return attri;
}

/// 视频推荐的组合起来观看量和评论量
/// @param watch 观看量
/// @param comment 评论量
+(NSMutableAttributedString *)recommedVideoItemWatchNum:(NSString *)watch comment:(NSString *)comment
{
    NSMutableAttributedString *attri =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@  ",watch]];
    // 2.添加表情图片
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:@"icon_video_play_gary"];
    
    //        attch.image = [UIImage imageNamed:@"football.gif"];
    // 设置图片大小
    attch.bounds = CGRectMake(0, kWidth(-2), kWidth(11), kWidth(11));
    
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:0];// 插入某个位置
    
    
    NSMutableAttributedString *att =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",comment]];
    NSTextAttachment *attch2 = [[NSTextAttachment alloc] init];
    attch2.image = [UIImage imageNamed:@"icon_video_comment_gary"];
    attch2.bounds = CGRectMake(0, kWidth(-2), kWidth(11), kWidth(11));
    NSAttributedString *string2 = [NSAttributedString attributedStringWithAttachment:attch2];
    [att insertAttributedString:string2 atIndex:0];// 插入某个位置
    [attri appendAttributedString:att];
    
    return attri;
}

/// 单位转万 百万 千万
/// @param string 字符串
+(NSString *)getDealNumwithstring:(NSString *)string
{
    NSDecimalNumber *numberA = [NSDecimalNumber decimalNumberWithString:string];
    NSDecimalNumber *numberB ;
    NSString *unitStr;
    if (string.length > 4 && string.length <=8 ) {
        numberB =  [NSDecimalNumber decimalNumberWithString:@"10000"];
        unitStr = @"万";
    }
    else if (string.length > 8){
        numberB =  [NSDecimalNumber decimalNumberWithString:@"100000000"];
        unitStr = @"亿";
    }else{
        return string;
    }
    //NSDecimalNumberBehaviors对象的创建  参数 1.RoundingMode 一个取舍枚举值 2.scale 处理范围 3.raiseOnExactness  精确出现异常是否抛出原因 4.raiseOnOverflow  上溢出是否抛出原因  4.raiseOnUnderflow  下溢出是否抛出原因  5.raiseOnDivideByZero  除以0是否抛出原因。
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:1 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    /// 这里不仅包含Multiply还有加 减 乘。
    NSDecimalNumber *numResult = [numberA decimalNumberByDividingBy:numberB withBehavior:roundingBehavior];
    NSString *strResult = [NSString stringWithFormat:@"%@%@",[numResult stringValue],unitStr];
    return strResult;
}

/// 秒转时分秒
/// @param totalTime 秒
+(NSString *)getMMSSFromSS:(NSString *)totalTime
{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of hour
    
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    
    //format of minute
    
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    
    //format of second
    
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    
    //format of time
    NSString *format_time;
    if ([str_hour isEqualToString:@"00"]) {
        format_time =  [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    }else{
        format_time =  [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    }
    
    return format_time;
    
}


/// 根据传入的字符串 字体大小 宽度,计算size
/// @param txt 文字
/// @param font 字体大小
/// @param size 传入的宽度和最大值
+(CGSize)boundingALLRectWithSize:(NSString*) txt Font:(UIFont*) font Size:(CGSize) size
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:txt];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:2.0f];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [txt length])];
    
    CGSize realSize = CGSizeZero;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    CGRect textRect = [txt boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:style} context:nil];
    realSize = textRect.size;
#else
    realSize = [txt sizeWithFont:font constrainedToSize:size];
#endif
    
    realSize.width = ceilf(realSize.width);
    realSize.height = ceilf(realSize.height);
    return realSize;
}


/// 时间转换
/// @param time 时间
/// @param format 格式
+(NSString *)converTimeWithString:(NSString *)time format:(NSString *)format
{
    NSDate *currentDate = [NSDate dateWithString:time format:@"YYYY-MM-dd HH:mm:ss"]; // 获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // 创建一个时间格式化对象
    [dateFormatter setDateFormat:format]; // 设定时间格式,这里可以设置成自己需要的格式
    NSString *dateString = [dateFormatter stringFromDate:currentDate]; // 将时间转化成字符串
    return dateString;
}



+(NSString *)converTimeWithMMDDString:(NSString *)dateString{
    // 实例化NSDateFormatter
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    // 设置日期格式
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    // 要转换的日期字符串
//    NSString *dateString1 = @"2011-05-03";
    // NSDate形式的日期
    NSDate *date =[formatter1 dateFromString:dateString];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"MM月dd日"];
    NSString *dateString2 = [formatter2 stringFromDate:date];
    return dateString2;
}

/// 判断密码 只有数字+字母
/// @param password 密码
+(BOOL)checkIsHaveNumAndLetter:(NSString*)password
{
    //数字条件
    NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合数字条件的有几个字节
    NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:password
                                                                       options:NSMatchingReportProgress
                                                                         range:NSMakeRange(0, password.length)];
    
    //英文字条件
    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合英文字条件的有几个字节
    NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:password options:NSMatchingReportProgress range:NSMakeRange(0, password.length)];
    
    if (tNumMatchCount>0 && tLetterMatchCount>0&&tNumMatchCount + tLetterMatchCount == password.length) {
        
        //    if (tNumMatchCount + tLetterMatchCount == password.length) {
        //全部符合数字，表示沒有英文
        return YES;
    }
    
    //    [[HCToast shareInstance]showToast:@"请输入密码(6-12位字母+数字)"];
    return NO;
}


/// 根据大小裁剪图片
/// @param image 图片
/// @param newSize 大小
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}//


/// 邮箱正则
/// @param email email
+ (BOOL)checkEmail:(NSString *)email
{
    
    //^(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w{2,3}){1,3})$
    //[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4} //2020.1.10更换
    //^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [emailTest evaluateWithObject:email];
    
}


/// 手机正则
/// @param mobile 手机号
+ (BOOL)isValidateMobile:(NSString *)mobile
{
    NSString *phoneRegex = @"1[3456789]([0-9]){9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}



/// 32位MD5加密大写
/// @param string 需要加密的字符串
+ (NSString*)md532BitUpperString:(NSString *)string
{
    const char *cStr = [string UTF8String];
    unsigned char result[16];
    
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5( cStr,[num intValue], result );
    
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}


/// 把32位MD5后的密码和盐拼接起来
/// @param md5String Md5
/// @param salt 盐
+ (NSString *)dealMd532BitString:(NSString *)md5String salt:(NSString *)salt
{
    NSMutableString* str1 =[[NSMutableString alloc]initWithString:md5String];//存在堆区，可变字符串
    NSMutableString *saltString = [NSMutableString stringWithString:salt];
    
    for (NSInteger i=saltString.length-1; i>0; i--) {
        [saltString insertString:@"," atIndex:i];
    }
    NSArray *aResult = [saltString componentsSeparatedByString:@","];
    NSInteger index = -1;
    for (int i =1;i<aResult.count+1;i++) {
        index ++;
        [str1 insertString:aResult[i-1] atIndex:i*2+index-1];
    }
    return str1;
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}



/// 字典转json
/// @param dict 字典
+(NSString *)convertToJsonData:(NSDictionary *)dict

{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

//处理一下那个countryCode。
+(NSString *)dealCountryCode:(NSString *)code
{
    if (code.length == 2) {
        return [NSString stringWithFormat:@"0%@",code];
    }else{
        return code;
    }
}


+(void)cleanUserDefault
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:UserDefaultsUserInfo];
    [userDefaults removeObjectForKey:UserDefaultsToken];
    
    //游客
    NSDictionary *visitorDic = [userDefaults objectForKey:UserVisitorAccount];
    NSString *visitorAccount;
    NSString *visitorNickName;
    if (visitorDic) {
        visitorAccount = [visitorDic objectForKey:@"visitorAccount"];
        visitorNickName = [visitorDic objectForKey:@"visitorNickName"];
    }
    UserModel *userModel = [[UserModel alloc] init];
    userModel.userName = visitorAccount;
    userModel.nickname = visitorNickName;
    [UserInstance shareInstance].userId = @"";
    [UserInstance shareInstance].userModel = userModel;
    [UserInstance shareInstance].userDict = [NSDictionary new];
}


/// image转base64
/// @param image image
+(NSString *)convertImage:(UIImage *)image
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha: image]) {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
        mimeType = @"image/jpeg";
    }
    NSLog(@"data-%@", imageData);
    return [NSString stringWithFormat:@"data:%@;base64,%@",mimeType,[imageData base64EncodedStringWithOptions: 0]];
}


///获取图片转Md5
+(NSString *)getDataMd5WithImage:(UIImage *)image
{
    NSData *imageData = nil;
    
    if ([self imageHasAlpha: image]) {
        imageData = UIImagePNGRepresentation(image);
    } else {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
    }
    return [self getMD5WithData:imageData];
}


///获取图片名的后缀
+(NSString *)getImageName:(UIImage *)image
{
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha: image]) {
        mimeType = @".png";
    } else {
        mimeType = @".jpeg";
    }
    
    return mimeType;
}


+ (NSString*)getMD5WithData:(NSData *)data{
    
    const char* original_str = (const char *)[data bytes];
    
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    
    CC_MD5(original_str, (uint)strlen(original_str), digist);
    
    NSMutableString *outPutStr = [NSMutableString stringWithCapacity:10];
    
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        
        [outPutStr appendFormat:@"%02x",digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
        
    }
    
    return [outPutStr lowercaseString];
    
}

+ (BOOL) imageHasAlpha: (UIImage *) image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

/// 身份证正则
/// @param value 身份证号
+(BOOL)validateIDCardNumber:(NSString *)value
{
    
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger length =0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        //不满足15位和18位，即身份证错误
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray = @[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    // 检测省份身份行政区代码
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO; //标识省份代码是否正确
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return NO;
    }
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    //分为15位、18位身份证进行校验
    switch (length) {
        case 15:
            //获取年份对应的数字
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                //创建正则表达式 NSRegularExpressionCaseInsensitive：不区分字母大小写的模式
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            //使用正则表达式匹配字符串 NSMatchingReportProgress:找到最长的匹配字符串后调用block回调
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            if(numberofMatch >0) {
                //1：校验码的计算方法 身份证号码17位数分别乘以不同的系数。从第一位到第十七位的系数分别为：7－9－10－5－8－4－2－1－6－3－7－9－10－5－8－4－2。将这17位数字和系数相乘的结果相加。
                int S = [value substringWithRange:NSMakeRange(0,1)].intValue*7 + [value substringWithRange:NSMakeRange(10,1)].intValue *7 + [value substringWithRange:NSMakeRange(1,1)].intValue*9 + [value substringWithRange:NSMakeRange(11,1)].intValue *9 + [value substringWithRange:NSMakeRange(2,1)].intValue*10 + [value substringWithRange:NSMakeRange(12,1)].intValue *10 + [value substringWithRange:NSMakeRange(3,1)].intValue*5 + [value substringWithRange:NSMakeRange(13,1)].intValue *5 + [value substringWithRange:NSMakeRange(4,1)].intValue*8 + [value substringWithRange:NSMakeRange(14,1)].intValue *8 + [value substringWithRange:NSMakeRange(5,1)].intValue*4 + [value substringWithRange:NSMakeRange(15,1)].intValue *4 + [value substringWithRange:NSMakeRange(6,1)].intValue*2 + [value substringWithRange:NSMakeRange(16,1)].intValue *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                
                //2：用加出来和除以11，看余数是多少？余数只可能有0－1－2－3－4－5－6－7－8－9－10这11个数字
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 3：获取校验位
                NSString *lastStr = [value substringWithRange:NSMakeRange(17,1)];
                NSLog(@"%@",M);
                NSLog(@"%@",[value substringWithRange:NSMakeRange(17,1)]);
                //4：检测ID的校验位
                if ([lastStr isEqualToString:@"x"]) {
                    if ([M isEqualToString:@"X"]) {
                        return YES;
                    }else{
                        return NO;
                    }
                }else{
                    if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                        return YES;
                    }else {
                        return NO;
                    }
                }
            }else {
                return NO;
            }
        default:
            return NO;
    }
}


/// 进入登录页
+(void)pushLoginPage
{
    if([JHRotatoUtil isOrientationLandscape]) {
        [JHRotatoUtil forceOrientation: UIInterfaceOrientationPortrait];
    }
    LoginController *vc = [LoginController new];
    [[self topViewController].navigationController pushViewController:vc animated:YES];
}

/// 带回调的推出登录页
/// @param success 成功
+(void)pushLoginPageSuccess:(void (^)(void))success
{
    LoginController *vc = [LoginController new];
    vc.loginBlock = ^{
        success();
    };
    [[self topViewController].navigationController pushViewController:vc animated:YES];
}


+(void)advertisingPushVC
{
    
    
    BAWebViewController *webVC = [BAWebViewController new];
    webVC.ba_web_progressTintColor = [UIColor cyanColor];
    webVC.ba_web_progressTrackTintColor = [UIColor whiteColor];
    
    [webVC ba_web_loadURLString:[[NSUserDefaults standardUserDefaults] valueForKey:@"adImageUrl"]];
    
    
    
    [[self topViewController].navigationController pushViewController:webVC animated:YES];
}

/// 给subview添加渐变色图层
/// @param subView 添加渐变色的view
/// @param fromColor 起始颜色
/// @param toColor 结束颜色
+ (void)addCAGradientLayer:(UIView *)subView fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor
{
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.colors = @[(__bridge id)fromColor.CGColor,(__bridge id)toColor.CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(subView.frame), CGRectGetHeight(subView.frame));
    [subView.layer addSublayer:gradientLayer];
}

/// 弹起分享页面
/// @param sysparamCode  sysparamCode sysparamCode SHARE_VIDEO_URL   视频分享链接前缀 SHARE_LIVE_ROOM_URL  直播间分享链接前缀
/// @param itemId 目标id
+(void)pushSharePageSysparamCode:(NSString *)sysparamCode itemId:(NSString *)itemId isTask:(BOOL)isTask shareView:(XMNShareView *)shareView success:(void (^)(void))successokay
{
    //分享媒介数据源
    NSArray *shareAry = @[@{kXMNShareImage:@"more_weixin",
                            kXMNShareHighlightImage:@"more_weixin_highlighted",
                            kXMNShareTitle:@"微信"},
                          @{kXMNShareImage:@"more_icon_qq",
                            kXMNShareHighlightImage:@"more_icon_qq_highlighted",
                            kXMNShareTitle:@"QQ"},
                          @{kXMNShareImage:@"shareView_wb",
                            kXMNShareHighlightImage:@"shareView_wb",
                            kXMNShareTitle:@"微博"},
                          @{kXMNShareImage:@"share_copyLink",
                            kXMNShareHighlightImage:@"share_copyLink",
                            kXMNShareTitle:@"复制链接"},
    ];
    
    //自定义头部[UIScreen mainScreen].bounds.size.width
    ShareHeaderView *headerView = [[ShareHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 36)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    footerView.backgroundColor = [UIColor colorFromHexString:@"EEEEEE" withAlph:0.5];
    
    //设置头部View 如果不设置则不显示头部
    shareView.headerView = headerView;
    shareView.footerView = footerView;
    
    [shareView setSelectedBlock:^(NSUInteger tag, NSString *title) {
        [STTextHudTool showWaitText:@"分享中..."];
        [MineProxy getShareLinkWithSysparamCode:sysparamCode itemId:itemId success:^(NSString * _Nonnull success) {
            UIPasteboard *appPasteBoard =  [UIPasteboard generalPasteboard];
            successokay();
            [appPasteBoard setString:success];
            if (tag != 3) {
                [STTextHudTool hideSTHud];
                [STTextHudTool showText:@"链接已复制,请粘贴分享" withSecond:2];
//                [self performSelector:@selector(openWithTag:) withObject:@(tag) afterDelay:2.1];
                
                kWeakSelf(self);
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.1 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//                    [weakSelf delayMethod];
                    [weakself openWithTag:@(tag)isTask:isTask];
                });
                
            }else{
                
                [STTextHudTool hideSTHud];
                [STTextHudTool showText:@"链接已复制,请粘贴分享" withSecond:2];
                //调用完成任务接口
                [MineProxy completeTaskWithTaskId:@"1" success:^(BOOL success) {
                    [UserTaskInstance shareInstance].shareStatus = 2;
                    [[NSUserDefaults standardUserDefaults] setInteger:[UserTaskInstance shareInstance].shareStatus forKey:kkLiveShareStatus];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                } failure:^(NSError * _Nonnull error) {
                }];
            }
            //            [self openWithTag:tag];
        } failure:^(NSError * _Nonnull error) {
            UIPasteboard *appPasteBoard =  [UIPasteboard generalPasteboard];
            [appPasteBoard setString:@"https://www.kuailong.com/home"];
            [STTextHudTool hideSTHud];
            [STTextHudTool showText:@"链接已复制,请粘贴分享" withSecond:2];
            kWeakSelf(self);
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.1 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//                    [weakSelf delayMethod];
                [weakself openWithTag:@(tag)isTask:isTask];
            });
            
        }];
        
    }];
    
    //计算高度 根据第一行显示的数量和总数,可以确定显示一行还是两行,最多显示2行
    [shareView setupShareViewWithItems:shareAry];
    
    [shareView showUseAnimated:YES];
}//分享页面


/// 根据时间转星期几
/// @param timeString 时间戳
+(NSString*)weekdayStringFromDate:(NSString *)timeString
{
    NSDate *date = [NSDate dateWithString:timeString format:@"YYYY-MM-dd"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:date];
    
    NSInteger week = components.weekday;
    
    NSString *weekStr = @"";
    
    switch (week) {
        case 1:
            weekStr = @"星期日";
            break;
        case 2:
            weekStr = @"星期一";
            break;
        case 3:
            weekStr = @"星期二";
            break;
        case 4:
            weekStr = @"星期三";
            break;
        case 5:
            weekStr = @"星期四";
            break;
        case 6:
            weekStr = @"星期五";
            break;
        case 7:
            weekStr = @"星期六";
            break;
        default:
            weekStr = @"星期";
            break;
    }
    
    return weekStr;
    
    
}


+(void)openWithTag:(NSNumber *)tag isTask:(BOOL)isTask{
    NSString *str;
    NSInteger itag = [tag integerValue];
    if (itag == 0) {
        str = @"weixin://";
    }else if (itag == 1){
        str = @"mqq://";
    }else if (itag == 2){
        str = @"sinaweibo://";
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:str]]) {
        if (isTask) {
            //调用完成任务接口
            [MineProxy completeTaskWithTaskId:@"1" success:^(BOOL success) {
                [UserTaskInstance shareInstance].shareStatus = 2;
                [[NSUserDefaults standardUserDefaults] setInteger:[UserTaskInstance shareInstance].shareStatus forKey:kkLiveShareStatus];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } failure:^(NSError * _Nonnull error) {
            }];
        }
       
        
        NSURL *URL = [NSURL URLWithString:[[NSString stringWithFormat:@"%@", str] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [[UIApplication sharedApplication] openURL:URL];
        return;
    }else{
        [[HCToast shareInstance]showToast:@"您并未安装此软件"];
    }
}


+ (UIViewController * )topViewController
{
    UIViewController *resultVC;
    resultVC = [self recursiveTopViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self recursiveTopViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController * )recursiveTopViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self recursiveTopViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self recursiveTopViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}


//根据卡号判断银行
+ (NSString *)returnBankName:(NSString *)cardName
{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"bank" ofType:@"plist"];
    NSDictionary *resultDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSArray *bankBin = resultDic.allKeys;
    if (cardName.length < 6) {
        return @"";
    }
    NSString *cardbin_6 ;
    if (cardName.length >= 6) {
        cardbin_6 = [cardName substringWithRange:NSMakeRange(0, 6)];
    }
    NSString *cardbin_8 = nil;
    if (cardName.length >= 8) {
        //8位
        cardbin_8 = [cardName substringWithRange:NSMakeRange(0, 8)];
    }
    if ([bankBin containsObject:cardbin_6]) {
        return [resultDic objectForKey:cardbin_6];
    } else if ([bankBin containsObject:cardbin_8]){
        return [resultDic objectForKey:cardbin_8];
    } else {
        return @"";
    }
    return @"";
    
}



/// 银行卡正则.
/// @param cardNumber 银行卡
+ (BOOL)IsBankCard:(NSString *)cardNumber
{
    if(cardNumber.length==0)
    {
        return NO;
    }
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < cardNumber.length; i++)
    {
        c = [cardNumber characterAtIndex:i];
        if (isdigit(c))
        {
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--)
    {
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo)
        {
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}

/// 根据错误提示返回错误
/// @param message 错误
+(NSString *)showErrorMessage:(NSString *)message{
    if ([message isEqualToString:@"PARAMS_IS_NULL"]) {
        return @"参数为空";
    }else if ([message isEqualToString:@"PARAMS_NOT_COMPLETE"]){
        return @"参数不全";
    }else if ([message isEqualToString:@"PARAMS_TYPE_ERROR"]){
        return @"参数类型错误";
    }else if ([message isEqualToString:@"PARAMS_IS_INVALID"]){
        return @"参数无效";
    }else if ([message isEqualToString:@"WRONG_OPERATION"]){
        return @"操作有误";
    }else if ([message isEqualToString:@"USER_NOT_EXIST"]){
        return @"用户不存在";
    }else if ([message isEqualToString:@"USER_NOT_LOGGED_IN"]){
        return @"用户未登陆";
    }else if ([message isEqualToString:@"USER ACCOUNT OR PASSWORD IS WRONG!"]){
        return @"请输入正确的账号或密码";
    }else if ([message isEqualToString:@"USER_ACCOUNT_FORBIDDEN"]){
        return @"账号被禁用，请联系客服";
    }else if ([message isEqualToString:@"USER_HAS_EXIST"]){
        return @"用户已存在";
    }else if ([message isEqualToString:@" the validate code has expire！"]){
        return @"验证码已失效，请重新发送";
    }else if ([message isEqualToString:@" the validate code is wrong！"]){
        return @"请输入正确的验证码";
    }else if ([message isEqualToString:@" this time count has transfinite，please try again!"]){
        return @"登录次数过限";
    }else if ([message isEqualToString:@" get token has wrong，please try again later!"]){
        return @"获取token错误";
    }else if ([message isEqualToString:@" email has been bind!"]){
        return @"邮箱已被绑定";
    }else if ([message isEqualToString:@" you have input more three times wrong password,please input verification code!"]){
        return @"账号密码输入错误次数过多，请尝试验证码登录！";
    }else if ([message isEqualToString:@" you have send the sms code more than three times!"]){
        return @"短信连续发送三次，禁止发送";
    }else if ([message isEqualToString:@" you have send the code in the one minute,don't send again!"]){
        return @"您刚刚已经发送过验证码，请稍后再试";
    }else if ([message isEqualToString:@"phoneNumber or password or salt or phoneCountryCode must input!"]){
        return @"登录传参错误";
    }else if ([message isEqualToString:@"This user type can't login!"]){
        return @"前端登录--非主播、用户类型不可登录";
    }else if ([message isEqualToString:@"This not a right login type!"]){
        return @"登录类型不正确";
    }else if ([message isEqualToString:@"phone number or phone country code must input!"]){
        return @"登录的手机号或区号必须要添加";
    }else if ([message isEqualToString:@"user account or password or salt or validateCodeGuid or code must input!"]){
        return @"管理后台登录传参错误";
    }else if ([message isEqualToString:@"The phone number has been bound!"]){
        return @"当前手机号已绑定过其他账号";
    }else if ([message isEqualToString:@"BUSINESS_ERROR"]){
        return @"直播业务出现问题";
    }else if ([message isEqualToString:@"The import user data error ! Unsuccessful users:{}"]){
        return @"旧外星人用户导入快龙直播错误";
    }else if ([message isEqualToString:@"SYSTEM_INNER_ERROR"]){
        return @"系统内部错误";
    }else if ([message isEqualToString:@"DATA_NOT_FOUND"]){
        return @"数据未找到";
    }else if ([message isEqualToString:@"DATA_IS_WRONG"]){
        return @"数据有误";
    }else if ([message isEqualToString:@"DATA_ALREADY_EXISTED"]){
        return @"数据已存在";
    }else if ([message isEqualToString:@"INTERFACE_INNER_INVOKE_ERROR"]){
        return @"系统内部接口调用异常";
    }else if ([message isEqualToString:@"INTERFACE_OUTER_INVOKE_ERROR"]){
        return @"系统外部接口调用异常";
    }else if ([message isEqualToString:@"INTERFACE_FORBIDDEN"]){
        return @"接口禁止访问";
    }else if ([message isEqualToString:@"INTERFACE_ADDRESS_INVALID"]){
        return @"接口地址无效";
    }else if ([message isEqualToString:@"INTERFACE_REQUEST_TIMEOUT"]){
        return @"接口请求超时";
    }else if ([message isEqualToString:@"INTERFACE_EXCEED_LOAD"]){
        return @"接口负载过高";
    }else if ([message isEqualToString:@"PERMISSION_NO_ACCESS"]){
        return @"没有访问权限";
    }else if ([message isEqualToString:@"PERMISSION_EXCEPTION"]){
        return @"权限异常";
    }else if ([message isEqualToString:@"your password is not a right format!"]){
        return @"密码格式不正确";
    }else if ([message isEqualToString:@"phoneCountryCode is not a right format!"]){
        return @"国家区号不正确";
    }else if ([message isEqualToString:@"phone number is not a right format!"]){
        return @"手机号码格式不正确";
    }else if ([message isEqualToString:@"The verification code can't be null!"]){
        return @"验证码不能为空";
    }else if ([message isEqualToString:@"Verification code is already invalid!"]){
        return @"验证码已失效";
    }else if ([message isEqualToString:@"The Verification code is error!"]){
        return @"请输入正确的验证码";
    }else if ([message isEqualToString:@"sorry，your account has been locked!"]){
        return @"账号被锁定,请联系客服";
    }else if ([message isEqualToString:@"not support this country's user!"]){
        return @"不支持该地区用户";
    }else if ([message isEqualToString:@" the validate code has expire！"]){
        return @"验证码过期";
    }else if ([message isEqualToString:@"You have sent the captCHA three times in 10 minutes. Please try again after 10 minutes!"]){
        return @"次数超过限制，请10分钟后再尝试";
    }else if ([message isEqualToString:@"The phone number must be register phone number"]){
        return @"该手机号必须为注册手机号";
    }else if ([message isEqualToString:@"user's old password is wrong!"]){
        return @"当前密码错误";
    }else if ([message isEqualToString:@"Incorrect email format!"]){
        return @"邮箱格式不正确";
    }else if ([message isEqualToString:@"The account balance coins is insufficient, please recharge it"]){
        return @"余额不足";
    }else if ([message isEqualToString:@"The account balance available coins is insufficient, please recharge it"]){
        return @"可用余额不足";
    }else if ([message isEqualToString:@"Order ID can not be null!"]){
        return @"订单ID 为空";
    }else if ([message isEqualToString:@"Pay ID can not be null!"]){
        return @"支付渠道ID 为空";
    }else if ([message isEqualToString:@"The Pay ID can not be found!"]){
        return @"支付渠道ID 不存在";
    }else if ([message isEqualToString:@"Channel ID can not be null!"]){
        return @"通道ID 不能为空";
    }else if ([message isEqualToString:@"The Channel ID not be found!"]){
        return @"通道ID 不存在";
    }else if ([message isEqualToString:@"Amount can not be null!"]){
        return @"金额不能为空";
    }else if ([message isEqualToString:@"Invalid amount!"]){
        return @"金额无效";
    }else if ([message isEqualToString:@"Pay Env can not be null!"]){
        return @"支付环境参数为空";
    }else if ([message isEqualToString:@"Uid can not be null!"]){
        return @"用户ID 不能为空";
    }else if ([message isEqualToString:@"order id is already exists!"]){
        return @"订单ID 已经存在";
    }else if ([message isEqualToString:@"order id is not exists!"]){
        return @"订单ID 无法找到";
    }else if ([message isEqualToString:@"The remote invocation service failed"]){
        return @"调用用户服务失败";
    }else if ([message isEqualToString:@"User be frozen!"]){
        return @"用户被冻结";
    }else if ([message isEqualToString:@"current user type not host"]){
        return @"绑定银行卡-当前用户非主播";
    }else if ([message isEqualToString:@"current user no real-name authentication"]){
        return @"绑定银行卡-当前用户未实名认证";
    }else if ([message isEqualToString:@"accountName not equals current user realName"]){
        return @"绑定银行卡-开户人姓名和主播认证姓名不一致";
    }else if ([message isEqualToString:@"The current user seems to have a record, please refresh and rebind"]){
        return @"绑定银行卡-当前用户似乎存在记录，请刷新后重新绑定";
    }else if ([message isEqualToString:@"This video doesn't exist"]){
        return @"视频不存在";
    }else if ([message isEqualToString:@"This video is not allowed to be shown, so it cannot be placed at the top"]){
        return @"视频不允许展示, 不能被置顶";
    }else if ([message isEqualToString:@"Video is not allowed to repeat the top"]){
        return @"视频不允许重复置顶";
    }else if ([message isEqualToString:@"The video was not placed at the top"]){
        return @"视频没有被置顶";
    }else if ([message isEqualToString:@"This videoCategory already exist"]){
        return @"视频分类已存在";
    }else if ([message isEqualToString:@"This videoCategory doesn't exist"]){
        return @"视频分类不存在";
    }else if ([message isEqualToString:@"The videoCategory already deleted"]){
        return @"该视频分类不是一个父级分类";
    }else if ([message isEqualToString:@"This live doesn't exist"]){
        return @"直播不存在";
    }else if ([message isEqualToString:@"Comment on the operation of barrage is not supported"]){
        return @"暂不支持对弹幕经行评论相关操作";
    }else if ([message isEqualToString:@"This comment doesn't exist"]){
        return @"评论不存在";
    }else if ([message isEqualToString:@"You haven't been banned"]){
        return @"用户没有被禁播";
    }else if ([message isEqualToString:@"please wait for the administrator's approval"]){
        return @"已经提交申诉, 等待管理员审批";
    }else if ([message isEqualToString:@"The resume info doesn't exist"]){
        return @"申诉记录不存在";
    }else if ([message isEqualToString:@"This info for this room does not exist"]){
        return @"房间不存在";
    }else if ([message isEqualToString:@"This room has been banned"]){
        return @"房间已经被禁播";
    }else if ([message isEqualToString:@"This room has been resumed"]){
        return @"房间已经被解禁";
    }else if ([message isEqualToString:@"This notice doesn't exist"]){
        return @"预告不存在";
    }else if ([message isEqualToString:@"This notice has been shown"]){
        return @"预告已经被显示";
    }else if ([message isEqualToString:@"This notice has been hidden"]){
        return @"预告已经被隐藏";
    }else if ([message isEqualToString:@"This notice not have lives"]){
        return @"预告没有对应的直播信息";
    }else if ([message isEqualToString:@"This notice.live have already live"]){
        return @"该预告已经存在了对应的直播信息";
    }else if ([message isEqualToString:@"Error SMS verification code"]){
        return @"验证码不正确";
    }else if ([message isEqualToString:@"The verification code is not matching!"]){
        return @"验证码不正确";
    }else if ([message isEqualToString:@"There is an exception while invoking the remote service"]){
        return @"请勿过于频繁点击";
    }else if ([message isEqualToString:@"the user nickname has exist!"]){
        return @"该昵称已经存在";
    }
    return @"未知错误";
    
}


/// 几分钟前 几小时前  大于24小时 显示正常
/// @param str str
+ (NSString *) compareCurrentTime:(NSString *)str
{
    
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    
    //得到与当前时间差
    NSTimeInterval  timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    //标准时间和北京时间差8个小时
    timeInterval = timeInterval - 8*60*60;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }else{
        return str;
    }
    return  result;
}


/// 根据错误码显示中文提示语 （这段代码由可爱的Remi小姐姐协助。 非常感谢.）
/// @param code 错误码
+(void)showErrorCode:(int)code
{
    
    switch (code) {
        case 2023://登录传参错误
            [[HCToast shareInstance]showToast:@"登录传参错误"];
            break;
        case 8001:
            [[HCToast shareInstance]showToast:@"密码格式不正确"];
            break;
        case 8002:
            [[HCToast shareInstance]showToast:@"国家区号不正确"];
            break;
        case 8008:
            [[HCToast shareInstance]showToast:@"不支持该地区用户"];
            break;
        case 8003:
            [[HCToast shareInstance]showToast:@"手机号码格式不正确"];
            break;
        case 2025:
            [[HCToast shareInstance]showToast:@"登录类型不正确"];
            break;
        case 2001:
            [[HCToast shareInstance]showToast:@"用户不存在"];
            break;
        case 2004:
            [[HCToast shareInstance]showToast:@"账号被禁用，请联系客服"];
            break;
        case 8007:
            [[HCToast shareInstance]showToast:@"账号被锁定,请联系客服"];
            break;
        case 2003:
            [[HCToast shareInstance]showToast:@"请输入正确的账号或密码"];
            break;
        case 8004:
            [[HCToast shareInstance]showToast:@"验证码不能为空"];
            break;
        case 8005:
            [[HCToast shareInstance]showToast:@"请输入正确的验证码"];
            break;
        case 8006:
            [[HCToast shareInstance]showToast:@"请输入正确的验证码"];
            break;
        case 2024:
            [[HCToast shareInstance]showToast:@"用户类型不可登录"];
            break;
        case 7002:
            [[HCToast shareInstance]showToast:@"权限异常"];
            break;
        case 8009:
            [[HCToast shareInstance]showToast:@"验证码已失效，请重新发送"];
            break;
        case 2026:
            [[HCToast shareInstance]showToast:@"登录的手机号或区号必须要添加"];
            break;
        case 1003:
            [[HCToast shareInstance]showToast:@"参数类型错误"];
            break;
        case 2027:
            [[HCToast shareInstance]showToast:@"管理后台登录传参错误"];
            break;
        case 8010:
            [[HCToast shareInstance]showToast:@"发送次数过多，请十分钟之后再试"];
            break;
        case 2011:
            [[HCToast shareInstance]showToast:@"账号密码输入错误次数过多，请尝试验证码登录！"];
            break;
        default:
            break;
    }
    
}
+ (NSString *)checkTheDate:(NSString *)string{
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [format dateFromString:string];
    BOOL isToday = [[NSCalendar currentCalendar] isDateInToday:date];
    BOOL isTomorrow = [[NSCalendar currentCalendar] isDateInTomorrow:date];
    
    NSString *strDiff = @"";
    
    if(isToday) {
        strDiff= [NSString stringWithFormat:@"今天 "];
    }
    if (isTomorrow) {
        strDiff= [NSString stringWithFormat:@"明天 "];
    }
    
    
    return strDiff;
}


/// 键盘展示,是否允许强制系统键盘
/// @param show NO 强制使用系统键盘。YES 
//+(void)showAppKeyBoard:(BOOL)show
//{
//    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    app.showStyemKeyBoard = show;
//    [app performSelector:@selector(application:shouldAllowExtensionPointIdentifier:)withObject:app];
//}


//.../登录传参错误
//    ERROR_2023("2023","phoneNumber or password or salt or phoneCountryCode must input!"),
//   //密码格式不正确
//    ERROR_8001("8001","your password is not a right format!"),
//  //国家区号不正确
//    ERROR_8002("8002","phoneCountryCode is not a right format!"),
//  //不支持该地区用户
//    ERROR_8008("8008","not support this country's user!");
//  //手机号码格式不正确
//    ERROR_8003("8003","phone number is not a right format!"),
//  // 连续输出3次错误密码，请输入验证码！
//    ERROR_2011("2011", " you have input more three times wrong password,please input verification code!"),
//  //登录类型不正确
//    ERROR_2025("2025","This not a right login type!"),
//  // 用户不存在
//    ERROR_2001("2001", "USER_NOT_EXIST"),
//  // 用户账户已被禁用
//    ERROR_2004("2004", "USER_ACCOUNT_FORBIDDEN"),
//  //账号被锁定
//    ERROR_8007("8007","sorry，your account has been locked!"),
//  // 用户名或密码错误
//    ERROR_2003("2003", "USER ACCOUNT OR PASSWORD IS WRONG!"),
//  //验证码不能为空
//    ERROR_8004("8004","The verification code can't be null!"),
//  //验证码已失效
//    ERROR_8005("8005","Verification code is already invalid!"),
//   //验证码错误
//    ERROR_8006("8006","The Verification code is error!"),
//  //用户类型不可登录
//    ERROR_2024("2024","This user type can't login!"),
//  // 权限异常
//    ERROR_7002(" 7002", "PERMISSION_EXCEPTION"),
//  // 验证码过期
//    ERROR_8009("8009", " the validate code has expire！");
//  //登录的手机号或区号必须要添加
//    ERROR_2026("2026","phone number or phone country code must input!"),
//  // 参数类型错误
//    ERROR_1003("1003", "PARAMS_TYPE_ERROR"),
//  //管理后台登录传参错误
//    ERROR_2027("2027","user account or password or salt or validateCodeGuid or code must input!"),
//
//
//  //发送次数过多，请十分钟之后再试
//    ERROR_8010("8010","You have sent the captCHA three times in 10 minutes. Please try again after 10 minutes!");
//
//// 连续输出3次错误密码，请输入验证码！
//    ERROR_2011("2011", " you have input more three times wrong password,please input verification code!"),





@end
