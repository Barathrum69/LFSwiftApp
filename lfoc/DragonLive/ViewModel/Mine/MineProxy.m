//
//  MineProxy.m
//  DragonLive
//
//  Created by LoaA on 2020/12/25.
//

#import "MineProxy.h"
#import "StationMessageModel.h"
#import "TaskModel.h"
#import "MyFocusModel.h"
#import "AnchorModel.h"
#import "WalletRecordModel.h"
#import "RechargeMethodModel.h"
#import "RechargeModel.h"

@implementation MineProxy


/// 获取钱币的接口
/// @param success 成功
/// @param failure 失败
+(void)getAccountCoinsSuccess:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];

    [HttpRequest requestWithURLType:UrlTypeGetAccountCoins parameters:params type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            NSString *coins = [responseObject objectForKey:@"data"];
            [[UserInstance shareInstance].userDict setValue:coins forKey:@"coins"];
            [UserInstance shareInstance].userModel.coins = coins;
            NSString *userJsonStr = [UntilTools convertToJsonData:[UserInstance shareInstance].userDict];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:userJsonStr forKey:UserDefaultsUserInfo];
            [userDefaults synchronize];
            success(YES);
        }else{
            NSError *error;
            failure(error);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}


/// 获取站内信列表
/// @param success 成功
/// @param failure 失败
+(void)getStationMessageWithPage:(NSInteger)page success:(void (^)(NSMutableArray * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[UserInstance shareInstance].userId forKey:@"userId"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@"10" forKey:@"size"];

    [HttpRequest requestWithURLType:UrlTypeStationMeesgae parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            NSDictionary *dict = responseObject[@"data"];
            NSArray *array = dict[@"list"];
            NSMutableArray *dataArray = [NSMutableArray new];
            for (NSDictionary *obj in array) {
                StationMessageModel *model = [StationMessageModel modelWithDictionary:obj];
                [dataArray addObject:model];
            }
            success(dataArray);
        }else{
            NSError *error;
            failure(error);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}


/// 获取任务接口
/// @param page 页码
/// @param success 成功
/// @param failure 失败
+(void)getTaskListWithPage:(NSInteger)page success:(nonnull void (^)(NSMutableArray * _Nonnull))success failure:(nonnull void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[UserInstance shareInstance].userId forKey:@"userId"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@"10" forKey:@"size"];

    [HttpRequest requestWithURLType:UrlTypeTaskList parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            NSArray *array = responseObject[@"data"];
            NSMutableArray *dataArray = [NSMutableArray new];
            for (NSDictionary *obj in array) {
                TaskModel *model = [TaskModel modelWithDictionary:obj];
                [dataArray addObject:model];
            }
            success(dataArray);
        }else{
            NSError *error;
            failure(error);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}


/// 我的关注列表
/// @param page 页码
/// @param success 成功
/// @param failure 失败
+(void)getMyFocusListWithPage:(NSInteger)page success:(nonnull void (^)(NSMutableArray * _Nonnull))success failure:(nonnull void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[UserInstance shareInstance].userId forKey:@"userId"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@"10000" forKey:@"size"];

    [HttpRequest requestWithURLType:UrlTypeMyFocusList parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            NSDictionary *dict = responseObject[@"data"];
            NSArray *array = dict[@"list"];
            NSMutableArray *dataArray = [NSMutableArray new];
            for (NSDictionary *obj in array) {
                MyFocusModel *model = [MyFocusModel modelWithDictionary:obj];
                [dataArray addObject:model];
            }
            success(dataArray);
        }else{
            NSError *error;
            failure(error);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/// 取消关注
/// @param attentionUser 目标id
/// @param success 成功
/// @param failure 失败
+(void)doAttentionUserWithAttentionUser:(NSString *)attentionUser success:(nonnull void (^)(BOOL))success failure:(nonnull void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[UserInstance shareInstance].userId forKey:@"userId"];
    [params setObject:attentionUser forKey:@"attentionUser"];

    [HttpRequest requestWithURLType:UrlTypeDoAttentionUser parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            success(YES);
        }else{
            NSError *error;
            failure(error);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}


/// 获取主播信息
/// @param success 成功
/// @param failure 失败
+(void)getAnchorWithUserId:(NSString *)userId success:(void (^)(BOOL, AnchorModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:userId forKey:@"userId"];

    [HttpRequest requestWithURLType:UrlTypeGetAnchor parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            AnchorModel *model = [AnchorModel modelWithDictionary:responseObject[@"data"]];
            NSLog(@"111");
            success(YES,model);
        }else{
            success(NO,[AnchorModel new]);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/// 获取个人信息的接口
/// @param success 成功
/// @param failure 失败
+(void)getUserInfoSuccess:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[UserInstance shareInstance].userId forKey:@"userId"];

    [HttpRequest requestWithURLType:UrlTypeGetUserInfo parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
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
            
            success(YES);
        }else{
            [[HCToast shareInstance]showToast:[responseObject objectForKey:@"message"]];
            NSError *error;
            failure(error);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}


/// 获取主播认证验证码
/// @param phoneNum 手机号
/// @param success 成功
/// @param failure 失败
+(void)getHostVerificationCodeWithPhone:(NSString *)phoneNum success:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[UserInstance shareInstance].userId forKey:@"hostId"];
    [params setObject:phoneNum forKey:@"phoneNum"];

    [HttpRequest requestWithURLType:UrlTypeHostVerificationCode parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
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


/// 上传图片
/// @param image 图片
/// @param success 成功
/// @param failure 失败ge
+(void)uploadImageWith:(UIImage *)image success:(void (^)(NSString * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
 
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[UntilTools convertImage:image] forKey:@"base64"];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *imgName = [NSString stringWithFormat:@"%f",time];
    [params setObject:[NSString stringWithFormat:@"%@%@",imgName,[UntilTools getImageName:image]] forKey:@"fileName"];
    
    [HttpRequest requestWithURLType:UrlTypeUpLoadingFile parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            NSDictionary *data = responseObject[@"data"];
            success(data[@"id"]);
        }else{
            [[HCToast shareInstance]showToast:[responseObject objectForKey:@"message"]];
            NSError *error;
            failure(error);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);

    }];
    
}


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
+(void)hostApplyLiveWithVerificationCode:(NSString *)verificationCode phoneNum:(NSString *)phoneNum realName:(NSString *)realName idCard:(NSString *)idCard idImgFrontUrlGuid:(NSString *)idImgFrontUrlGuid idImgBackUrlGuid:(NSString *)idImgBackUrlGuid idImgHandUrlGuid:(NSString *)idImgHandUrlGuid success:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[UserInstance shareInstance].userId forKey:@"hostId"];
    [params setObject:phoneNum forKey:@"phoneNum"];
    [params setObject:verificationCode forKey:@"verificationCode"];
    [params setObject:realName forKey:@"realName"];
    [params setObject:idCard forKey:@"idCard"];
    [params setObject:idImgFrontUrlGuid forKey:@"idImgFrontUrlGuid"];
    [params setObject:idImgBackUrlGuid forKey:@"idImgBackUrlGuid"];
    [params setObject:idImgHandUrlGuid forKey:@"idImgHandUrlGuid"];

    [HttpRequest requestWithURLType:UrlTypeHostApplyLive parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            success(YES);
        }else{
            [[HCToast shareInstance]showToast:[responseObject objectForKey:@"message"]];
            NSError *error;
            failure(error);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

/// 钱包充值信息查询
/// @param success 成功
/// @param failure 失败
+(void)walletQueryPayInfoSuccess:(void (^)(NSMutableArray *obj))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@(1) forKey:@"page"];
    [params setObject:@(100) forKey:@"size"];
    
    [HttpRequest requestWithURLType:UrlTypeQueryPayinfo parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            NSDictionary *data = responseObject[@"data"];
            NSArray *typeItems = data[@"payType"];
            NSMutableArray *typeArray = [NSMutableArray new];
            for (NSDictionary *obj in typeItems) {
                RechargeMethodModel *model = [RechargeMethodModel modelWithDictionary:obj];
                model.rate = data[@"rate"];
                [typeArray addObject:model];
            }
            NSArray *coinItems = data[@"coinPackage"];
            NSMutableArray *coinArray = [NSMutableArray new];
            for (NSDictionary *obj in coinItems) {
                RechargeModel *model = [RechargeModel modelWithDictionary:obj];
                [coinArray addObject:model];
            }
            NSMutableArray *dataArr = [NSMutableArray arrayWithObjects:typeArray,coinArray, nil];
            success(dataArr);
        }else{
            NSError *error;
            failure(error);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/// 钱包获取收支明细
/// @param page 页码
/// @param bType  交易类型 1 - 充值入账,2 - 提现出账,3 - 冻结,4 - 解冻,5 - 礼物支出 ,6 - 礼物收入,7 - 任务收入
/// @param queryTime 交易时间 yyyy-MM
/// @param success 成功
/// @param failure 失败
+(void)walletFindRecordWithPage:(NSInteger)page bType:(NSString *)bType queryTime:(NSString *)queryTime success:(void (^)(NSMutableArray * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(20) forKey:@"size"];
    [params setObject:bType forKey:@"bType"];
    [params setObject:queryTime forKey:@"queryTime"];
    
    [HttpRequest requestWithURLType:UrlTypeFindRecord parameters:params type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            NSDictionary *data = responseObject[@"data"];
            NSArray *items = data[@"items"];
            NSMutableArray *array = [NSMutableArray new];
            for (NSDictionary *obj in items) {
                WalletRecordModel *model = [WalletRecordModel modelWithDictionary:obj];
                [model dealData];
                [array addObject:model];
            }
            success(array);
        }else{
            [[HCToast shareInstance]showToast:[responseObject objectForKey:@"message"]];
            NSError *error;
            failure(error);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/// 确认充值
/// @param payId 支付id
/// @param channelId 渠道id
/// @param amount 金额 单位为 10000 = 1元
/// @param success 成功
/// @param failure 失败
+(void)walletRechargeWithPayId:(NSString *)payId channelId:(NSString *)channelId amount:(NSInteger)amount success:(void (^)(NSString *otherLink))success failure:(void (^)(NSError *error))failure
{
    long long rechargeAmount = amount * 10000;
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:payId forKey:@"payId"];
    [params setObject:channelId forKey:@"channelId"];
    [params setObject:[NSString stringWithFormat:@"%lld",rechargeAmount] forKey:@"amount"];
    [params setObject:@"4" forKey:@"payEnv"];
    
    [HttpRequest requestWithURLType:UrlTypeRechargeOrder parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
//            [[HCToast shareInstance]showToast:@"充值成功"];
            success([responseObject objectForKey:@"data"]);
            
        }else{
            if (code == 9214) {
                [[HCToast shareInstance] showToast:@"账号被冻结，请联系客服"];
            }else {
                [[HCToast shareInstance] showToast:@"充值失败"];
            }
            NSError *error;
            failure(error);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}


/// 提现明细查询
/// @param success 成功
/// @param failure 失败
+(void)walletQueryRevenue:(void (^)(NSDictionary *obj))success failure:(void (^)(NSError *error))failure
{
    [HttpRequest requestWithURLType:UrlTypeQueryRevenueInfo parameters:nil type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            NSDictionary *data = responseObject[@"data"];
            
            success(data);
        }else{
            NSError *error;
            failure(error);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}


/// 发起提现
/// @param coins 提现金币
/// @param money 提现人民币
/// @param cosRate 比例
/// @param success 成功
/// @param failure 失败
+(void)walletApproveWithCoins:(NSString *)coins money:(NSString *)money cosRate:(NSString *)cosRate success:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:coins forKey:@"availablestar"];
    [params setObject:money forKey:@"money"];
    [params setObject:cosRate forKey:@"cosRate"];
    
    [HttpRequest requestWithURLType:UrlTypeApproveRevenue parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            [[HCToast shareInstance]showToast:@"提现成功"];
            success();
        }else{
            if (code == 9214) {
                [[HCToast shareInstance]showToast:@"账号被冻结，请联系客服"];
            } else if (12102) {
                [[HCToast shareInstance]showToast:@"本月提现已超过最大次数"];
            }
            else {
                [[HCToast shareInstance]showToast:@"提现失败"];
            }
            NSError *error;
            failure(error);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/// 修改头像
/// @param picGuid 图片id
/// @param success 成功
/// @param failure 失败
+(void)modifyHeadImageWithPicGuid:(NSString *)picGuid success:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[UserInstance shareInstance].userId forKey:@"userId"];
    [params setObject:picGuid forKey:@"picGuid"];
    
    [HttpRequest requestWithURLType:UrlTypeModifyHeadImage parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
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
        
/// 修改名字
/// @param nickname 名字
/// @param success 成功
/// @param failure 失败
+(void)modifyNameWithNickName:(NSString *)nickname success:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[UserInstance shareInstance].userId forKey:@"userId"];
    [params setObject:nickname forKey:@"nickname"];
    
    [HttpRequest requestWithURLType:UrlTypeModifyName parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
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

/// 完成任务的接口
/// @param taskId 任务id(1 分享房间, 2 观看直播,3 发送弹幕,4 礼物打赏)
/// @param success 成功
/// @param failure 失败
+(void)completeTaskWithTaskId:(NSString *)taskId success:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:taskId forKey:@"taskId"];
    
    [HttpRequest requestWithURLType:UrlTypeCompleteTask parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            success(YES);
        }else{
//            [[HCToast shareInstance]showToast:[responseObject objectForKey:@"message"]];
            NSError *error;
            failure(error);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);

    }];
}


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
+(void)bingBankCardWithAccountName:(NSString *)accountName bank:(NSString *)bank bankCard:(NSString *)bankCard province:(NSString *)province city:(NSString *)city bankPhone:(NSString *)bankPhone subbranch:(NSString *)subbranch bankId:(NSString *)bankId success:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:accountName forKey:@"accountName"];
    [params setObject:bank forKey:@"bank"];
    [params setObject:bankCard forKey:@"bankCard"];
    [params setObject:province forKey:@"province"];
    [params setObject:city forKey:@"city"];
//    [params setObject:bankPhone forKey:@"bankPhone"];
    [params setObject:subbranch forKey:@"subbranch"];
    if (bankId.length != 0) {
        [params setObject:bankId forKey:@"id"];
    }

    
    [HttpRequest requestWithURLType:UrlTypeBingBankCardInfo parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
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

/// 更新主播房间的公告
/// @param roomId 房间id
/// @param notice 公告内容
/// @param success 成功
/// @param failure 失败
+(void)updateRoomNoticeWithRoomId:(NSString *)roomId notice:(NSString *)notice success:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:roomId forKey:@"roomId"];
    [params setObject:notice forKey:@"notice"];
    
    [HttpRequest requestWithURLType:UrlTypeUpdateRoomSetting parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
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


/// 领取任务奖励
/// @param taskId 任务Id
/// @param success 成功
/// @param failure 失败  我听alex说.. eric  每天的日常
+(void)taskRecivedWithTaskId:(NSString *)taskId success:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:taskId forKey:@"taskId"];
    
    [HttpRequest requestWithURLType:UrlTypeRecivedTask parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
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
        [[HCToast shareInstance] showToast:@"领取失败"];

    }];
}


/// 获取分享的链接.
/// @param sysparamCode sysparamCode sysparamCode SHARE_VIDEO_URL ： 视频分享链接前缀 SHARE_LIVE_ROOM_URL ： 直播间分享链接前缀
/// @param itemId 目标id
/// @param success 成功
/// @param failure 失败
+(void)getShareLinkWithSysparamCode:(NSString *)sysparamCode itemId:(NSString *)itemId success:(void (^)(NSString * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:sysparamCode forKey:@"sysparamCode"];
    
    [HttpRequest requestWithURLType:UrlTypeGetSysparam parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            NSDictionary *dict = responseObject[@"data"];
            NSString *sysparamValue = dict[@"sysparamValue"];
            success([NSString stringWithFormat:@"%@%@",sysparamValue,itemId]);
        }else{
            [[HCToast shareInstance]showToast:[responseObject objectForKey:@"message"]];
            NSError *error;
            failure(error);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);

    }];
}

/// 校验验证码
/// @param code 验证码
/// @param success 成功
/// @param failure 失败
+(void)verificationCodeCompareWithCode:(NSString *)code success:(void (^)(BOOL))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:code forKey:@"code"];
    [params setObject:[UserInstance shareInstance].userId forKey:@"userId"];

    [HttpRequest requestWithURLType:UrlTypeVerificationCompare parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
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

/// 获取银行卡
/// @param success 成功
/// @param failure 失败
+(void)getBankCardSuccess:(void (^)(NSString * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [HttpRequest requestWithURLType:UrlTypeGetBankCard parameters:params type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            if (![dict isKindOfClass:[NSNull class]]) {
                NSString *bankCard = dict[@"bankCard"];
                NSString *bank     = dict[@"bank"];
                NSString *province = dict[@"province"];
                NSString *city     = dict[@"city"];
                NSString *subbranch= dict[@"subbranch"];
                NSString *bankPhone= dict[@"bankPhone"];
                NSString *bankId   = [NSString stringWithFormat:@"%lld",[dict[@"id"]longLongValue]];
                
                [[UserInstance shareInstance].userDict setValue:bankCard forKey:@"bankCard"];
                [[UserInstance shareInstance].userDict setValue:bank forKey:@"bank"];
                [[UserInstance shareInstance].userDict setValue:province forKey:@"province"];
                [[UserInstance shareInstance].userDict setValue:city forKey:@"city"];
                [[UserInstance shareInstance].userDict setValue:subbranch forKey:@"subbranch"];
                [[UserInstance shareInstance].userDict setValue:bankPhone forKey:@"bankPhone"];
                [[UserInstance shareInstance].userDict setValue:bankId forKey:@"bankId"];

                [UserInstance shareInstance].userModel.bankCard = bankCard;
                [UserInstance shareInstance].userModel.bank = bank;
                [UserInstance shareInstance].userModel.province = province;
                [UserInstance shareInstance].userModel.city = city;
                [UserInstance shareInstance].userModel.subbranch = subbranch;
                [UserInstance shareInstance].userModel.bankPhone = bankPhone;
                [UserInstance shareInstance].userModel.bankId = bankId;

                NSString *userJsonStr = [UntilTools convertToJsonData:[UserInstance shareInstance].userDict];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:userJsonStr forKey:UserDefaultsUserInfo];
                [userDefaults synchronize];
            }
            success(@"");
        }else{
            [[HCToast shareInstance]showToast:[UntilTools showErrorMessage:[responseObject objectForKey:@"message"]]];
            NSError *error;
            failure(error);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}


/// 获取直播房间的设置
/// @param success 成功
/// @param failure 失败
+(void)getRoomSettingSuccess:(void (^)(NSString * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [HttpRequest requestWithURLType:UrlTypeGetRoomSetting parameters:params type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            NSDictionary *data = responseObject[@"data"];
            NSDictionary *roomSetting = data[@"roomSetting"];
            NSString *notice = roomSetting[@"notice"];
            success(notice);
        }else{
//            [[HCToast shareInstance]showToast:[UntilTools showErrorMessage:[responseObject objectForKey:@"message"]]];
            NSError *error;
            failure(error);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
