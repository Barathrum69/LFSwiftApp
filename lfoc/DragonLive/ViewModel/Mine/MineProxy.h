//
//  MineProxy.h
//  DragonLive
//
//  Created by LoaA on 2020/12/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class AnchorModel;
@interface MineProxy : NSObject


/// 获取钱币的接口
/// @param success 成功
/// @param failure 失败
+(void)getAccountCoinsSuccess:(void (^)(BOOL isSuccess))success failure:(void (^)(NSError *error))failure;


/// 获取站内信列表
/// @param success 成功
/// @param failure 失败
+(void)getStationMessageWithPage:(NSInteger)page success:(void (^)(NSMutableArray *obj))success failure:(void (^)(NSError *error))failure;


/// 获取任务接口
/// @param page 页码
/// @param success 成功
/// @param failure 失败
+(void)getTaskListWithPage:(NSInteger)page success:(void (^)(NSMutableArray *obj))success failure:(void (^)(NSError *error))failure;


/// 我的关注列表
/// @param page 页码
/// @param success 成功
/// @param failure 失败
+(void)getMyFocusListWithPage:(NSInteger)page success:(void (^)(NSMutableArray *obj))success failure:(void (^)(NSError *error))failure;


/// 取消关注
/// @param attentionUser 目标id
/// @param success 成功
/// @param failure 失败
+(void)doAttentionUserWithAttentionUser:(NSString *)attentionUser success:(void (^)(BOOL success))success failure:(void (^)(NSError *error))failure;


/// 获取主播信息
/// @param userId 主播id
/// @param success 成功
/// @param failure 失败
+(void)getAnchorWithUserId:(NSString *)userId success:(void (^)(BOOL success,AnchorModel *model))success failure:(void (^)(NSError *error))failure;


/// 获取个人信息的接口
/// @param success 成功
/// @param failure 失败
+(void)getUserInfoSuccess:(void (^)(BOOL success))success failure:(void (^)(NSError *error))failure;


/// 获取主播认证验证码
/// @param phoneNum 手机号
/// @param success 成功
/// @param failure 失败
+(void)getHostVerificationCodeWithPhone:(NSString *)phoneNum success:(void (^)(BOOL success))success failure:(void (^)(NSError *error))failure;


/// 上传图片
/// @param image 图片
/// @param success 成功
/// @param failure 失败
+(void)uploadImageWith:(UIImage *)image success:(void (^)(NSString *url))success failure:(void (^)(NSError *error))failure;




/// 主播认证
/// @param verificationCode 验证码
/// @param phoneNum 手机号
/// @param realName 真实姓名
/// @param idCard 身份证号
/// @param idImgFrontUrlGuid 身份证正面
/// @param idImgBackUrlGuid 身份证反面
/// @param idImgHandUrlGuid 手持身份证
/// @param success 成功
/// @param failure 失败
+(void)hostApplyLiveWithVerificationCode:(NSString *)verificationCode phoneNum:(NSString *)phoneNum realName:(NSString *)realName idCard:(NSString *)idCard idImgFrontUrlGuid:(NSString *)idImgFrontUrlGuid idImgBackUrlGuid:(NSString *)idImgBackUrlGuid idImgHandUrlGuid:(NSString *)idImgHandUrlGuid success:(void (^)(BOOL isSuccess))success failure:(void (^)(NSError *error))failure;


/// 钱包充值信息查询
/// @param success 成功
/// @param failure 失败
+(void)walletQueryPayInfoSuccess:(void (^)(NSMutableArray *obj))success failure:(void (^)(NSError *error))failure;

/// 钱包获取收支明细
/// @param page 页码
/// @param bType  交易类型 1 - 充值入账,2 - 提现出账,3 - 冻结,4 - 解冻,5 - 礼物支出 ,6 - 礼物收入,7 - 任务收入
/// @param queryTime 交易时间 yyyy-MM
/// @param success 成功
/// @param failure 失败
+(void)walletFindRecordWithPage:(NSInteger)page bType:(NSString *)bType queryTime:(NSString *)queryTime success:(void (^)(NSMutableArray *obj))success failure:(void (^)(NSError *error))failure;


/// 确认充值
/// @param payId 支付id
/// @param channelId 渠道id
/// @param amount 金额 单位为 10000 = 1元
/// @param success 成功
/// @param failure 失败
+(void)walletRechargeWithPayId:(NSString *)payId channelId:(NSString *)channelId amount:(NSInteger)amount success:(void (^)(NSString *otherLink))success failure:(void (^)(NSError *error))failure;


/// 提现明细查询
/// @param success 成功
/// @param failure 失败
+(void)walletQueryRevenue:(void (^)(NSDictionary *obj))success failure:(void (^)(NSError *error))failure;


/// 发起提现
/// @param coins 提现金币
/// @param money 提现人民币
/// @param cosRate 比例
/// @param success 成功
/// @param failure 失败
+(void)walletApproveWithCoins:(NSString *)coins money:(NSString *)money cosRate:(NSString *)cosRate success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

/// 修改头像
/// @param picGuid 图片id
/// @param success 成功
/// @param failure 失败
+(void)modifyHeadImageWithPicGuid:(NSString *)picGuid success:(void (^)(BOOL success))success failure:(void (^)(NSError *error))failure;



/// 修改名字
/// @param nickname 名字
/// @param success 成功
/// @param failure 失败
+(void)modifyNameWithNickName:(NSString *)nickname success:(void (^)(BOOL success))success failure:(void (^)(NSError *error))failure;


/// 完成任务的接口
/// @param taskId 任务id(1 分享房间, 2 观看直播,3 发送弹幕)
/// @param success 成功
/// @param failure 失败
+(void)completeTaskWithTaskId:(NSString *)taskId success:(void (^)(BOOL success))success failure:(void (^)(NSError *error))failure;



/// 绑定银行卡
/// @param accountName 账户名称
/// @param bank 银行名称
/// @param bankCard 银行卡号
/// @param province 省份
/// @param city 城市
/// @param bankPhone 绑定手机号
/// @param subbranch 支行
/// @param success 成功
/// @param failure 失败
+(void)bingBankCardWithAccountName:(NSString *)accountName bank:(NSString *)bank bankCard:(NSString *)bankCard province:(NSString *)province city:(NSString *)city bankPhone:(NSString *)bankPhone subbranch:(NSString *)subbranch bankId:(NSString *)bankId success:(void (^)(BOOL success))success failure:(void (^)(NSError *error))failure;


/// 更新主播房间的公告
/// @param roomId 房间id
/// @param notice 公告内容
/// @param success 成功
/// @param failure 失败
+(void)updateRoomNoticeWithRoomId:(NSString *)roomId notice:(NSString *)notice success:(void (^)(BOOL success))success failure:(void (^)(NSError *error))failure;


/// 领取任务奖励
/// @param taskId 任务Id
/// @param success 成功
/// @param failure 失败
+(void)taskRecivedWithTaskId:(NSString *)taskId success:(void (^)(BOOL success))success failure:(void (^)(NSError *error))failure;



/// 获取分享的链接.
/// @param sysparamCode sysparamCode sysparamCode SHARE_VIDEO_URL ： 视频分享链接前缀 SHARE_LIVE_ROOM_URL ： 直播间分享链接前缀
/// @param itemId 目标id
/// @param success 成功
/// @param failure 失败
+(void)getShareLinkWithSysparamCode:(NSString *)sysparamCode itemId:(NSString *)itemId success:(void (^)(NSString *success))success failure:(void (^)(NSError *error))failure;


/// 校验验证码
/// @param code 验证码
/// @param success 成功
/// @param failure 失败
+(void)verificationCodeCompareWithCode:(NSString *)code success:(void (^)(BOOL success))success failure:(void (^)(NSError *error))failure;

/// 获取银行卡
/// @param success 成功
/// @param failure 失败
+(void)getBankCardSuccess:(void (^)(NSString *success))success failure:(void (^)(NSError *error))failure;


/// 获取直播房间的设置
/// @param success 成功
/// @param failure 失败
+(void)getRoomSettingSuccess:(void (^)(NSString *success))success failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
