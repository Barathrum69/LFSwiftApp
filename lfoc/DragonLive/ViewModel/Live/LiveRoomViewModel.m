//
//  LiveRoomViewModel.m
//  DragonLive
//
//  Created by 11号 on 2020/12/12.
//

#import "LiveRoomViewModel.h"
#import "HttpRequest.h"
#import "RoomInfo.h"
#import "RoomGift.h"

@interface LiveRoomViewModel ()

@property (nonatomic, copy)NSString *roomId;                    //房间id
@property (nonatomic, strong)RoomInfo *roomInfoModel;           //房间信息
@property (nonatomic, copy)NSString *liveHot;                   //实时热度
@property (nonatomic, copy)NSString *systemNotice;              //系统公告
@property (nonatomic, strong)NSMutableArray *giftArray;         //礼物道具数据集合
@property (nonatomic, copy)NSString *systemTimeInterval;        //时间差

@end

@implementation LiveRoomViewModel

- (id)initWithDelegate:(id<LiveRoomViewModelDelegate>)delegate roomId:(NSString *)roomId
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        
        if (roomId) {
            self.roomId = roomId;
            [self requestRoomInfo:roomId];
            [self requestForbiduser];
        }
        
        [self requestSystemNotice];
        [self requestLiveGift];
    }
    
    return self;
}

/// 直播间详情接口请求：（获取热度 ，头像 ，礼物列表 房间表信息 直播表信息 可用余额，分类）
- (void)requestRoomInfo:(NSString *)roomId {
        
    NSDictionary *dic = [NSDictionary dictionaryWithObject:roomId forKey:@"roomId"];
    
    __weak __typeof(self)weakSelf = self;
    [HttpRequest requestWithURLType:UrlTypeLiveRoom parameters:dic type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if (code==200) {
            NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithDictionary:responseObject[@"data"]];

            NSDictionary *roomDic = dataDic[@"room"];
            NSDictionary *liveDic = dataDic[@"live"];
            NSDictionary *vodDic = dataDic[@"enterRoomRecordedInfo"];
            [dataDic addEntriesFromDictionary:roomDic];
            [dataDic addEntriesFromDictionary:liveDic];
            
            //录播的时候才会返回vodDic
            if (![vodDic isEqual:[NSNull null]]) {
                [dataDic addEntriesFromDictionary:vodDic];
            }
            
            RoomInfo *roomModel = [RoomInfo modelWithDictionary:dataDic];
            roomModel.roomId = strongSelf.roomId;
            strongSelf.roomInfoModel = roomModel;
            if (strongSelf.delegate) {
                [strongSelf.delegate requestRoomInfoFinish:nil];
            }
        }else {
            NSString *message = responseObject[@"message"];
            if ([message isEqual:[NSNull null]] && message == nil) {
                message = @"";
            }
            NSError *error = [NSError errorWithDomain:message code:code userInfo:nil];
            if (strongSelf.delegate) {
                [strongSelf.delegate requestRoomInfoFinish:error];
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.delegate) {
            [strongSelf.delegate requestRoomInfoFinish:error];
        }
    }];
}

/// 系统公告
- (void)requestSystemNotice {
        
    __weak __typeof(self)weakSelf = self;
    [HttpRequest requestWithURLType:UrlTypeSystemNotice parameters:nil type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code==200) {
            NSString *systemNotice = responseObject[@"data"];
            strongSelf.systemNotice = systemNotice;
            if (strongSelf.delegate) {
                [strongSelf.delegate requestSystemNoticeFinish:nil];
            }
        }else {
            NSString *message = responseObject[@"message"];
            if ([message isEqual:[NSNull null]] && message == nil) {
                message = @"";
            }
            NSError *error = [NSError errorWithDomain:message code:code userInfo:nil];
            if (strongSelf.delegate) {
                [strongSelf.delegate requestSystemNoticeFinish:error];
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.delegate) {
            [strongSelf.delegate requestSystemNoticeFinish:error];
        }
    }];
}

/// 礼物道具
- (void)requestLiveGift {
        
    __weak __typeof(self)weakSelf = self;
    [HttpRequest requestWithURLType:UrlTypeLiveGift parameters:nil type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code==200) {
            NSArray *dataArr = responseObject[@"data"];
            NSMutableArray *dataMutArr = [NSMutableArray arrayWithCapacity:dataArr.count];
            [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                RoomGift *giftModel = [RoomGift modelWithDictionary:obj];
                [dataMutArr addObject:giftModel];
            }];
            strongSelf.giftArray = dataMutArr;
            if (strongSelf.delegate) {
                [strongSelf.delegate requestLiveGiftFinish:nil];
            }
        }else {
            NSString *message = responseObject[@"message"];
            if ([message isEqual:[NSNull null]] && message == nil) {
                message = @"";
            }
            NSError *error = [NSError errorWithDomain:message code:code userInfo:nil];
            if (strongSelf.delegate) {
                [strongSelf.delegate requestLiveGiftFinish:error];
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.delegate) {
            [strongSelf.delegate requestLiveGiftFinish:error];
        }
    }];
}

/// 查询用户是否被禁言
- (void)requestForbiduser
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"userId"] = [UserInstance shareInstance].userModel.userId;
    params[@"roomId"] = self.roomId;
    
    __weak __typeof(self)weakSelf = self;
    [HttpRequest requestWithURLType:UrlTypeForbidUserStatus parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code==200) {
            [UserInstance shareInstance].disableUserMessage = [responseObject[@"data"] boolValue];
            if (strongSelf.delegate) {
                [strongSelf.delegate requestForbiduserStatusFinish:nil];
            }
        }else {
            NSString *message = responseObject[@"message"];
            if ([message isEqual:[NSNull null]] && message == nil) {
                message = @"";
            }
            NSError *error = [NSError errorWithDomain:message code:code userInfo:nil];
            if (strongSelf.delegate) {
                [strongSelf.delegate requestForbiduserStatusFinish:error];
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.delegate) {
            [strongSelf.delegate requestForbiduserStatusFinish:error];
        }
    }];
}

/// 主播关注/取关
- (void)requestAttentionUser
{
    if (!self.roomInfoModel) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"userId"] = [UserInstance shareInstance].userModel.userId;
    params[@"attentionUser"] = self.roomInfoModel.hostId;
    
    __weak __typeof(self)weakSelf = self;
    [HttpRequest requestWithURLType:UrlTypeDoAttentionUser parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSInteger code = [responseObject[@"code"] integerValue];
        NSDictionary *resultDic = responseObject[@"data"];
        if (code==200) {
            NSInteger hostFollow = [resultDic[@"flag"] integerValue];
            NSInteger hostFansNum = [resultDic[@"fans"] integerValue];
            
            strongSelf.roomInfoModel.hostFollow = [NSString stringWithFormat:@"%ld",(long)hostFollow];
            strongSelf.roomInfoModel.hostFansNum = [NSString stringWithFormat:@"%ld",(long)hostFansNum];
            if (strongSelf.delegate) {
                [strongSelf.delegate requestAttentionUserFinish:nil];
            }
        }else {
            NSString *message = responseObject[@"message"];
            if ([message isEqual:[NSNull null]] && message == nil) {
                message = @"";
            }
            
            NSError *error = [NSError errorWithDomain:message code:code userInfo:nil];
            if (strongSelf.delegate) {
                [strongSelf.delegate requestAttentionUserFinish:error];
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.delegate) {
            [strongSelf.delegate requestAttentionUserFinish:error];
        }
    }];
}

/// 直播禁言
- (void)requestUserDisableSpeak:(NSString *)userId
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"userId"] = userId;
    params[@"roomId"] = _roomId;
    
    __weak __typeof(self)weakSelf = self;
    [HttpRequest requestWithURLType:UrlTypeForbidUser parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code==200) {
            if (strongSelf.delegate) {
                [strongSelf.delegate requestUserDisableSpeakFinish:nil];
            }
        }else {
            NSString *message = responseObject[@"message"];
            if ([message isEqual:[NSNull null]] && message == nil) {
                message = @"";
            }
            NSError *error = [NSError errorWithDomain:message code:code userInfo:nil];
            if (strongSelf.delegate) {
                [strongSelf.delegate requestUserDisableSpeakFinish:error];
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.delegate) {
            [strongSelf.delegate requestUserDisableSpeakFinish:error];
        }
    }];
}

/// 直播礼物打赏
- (void)requestGiftReward:(NSString *)giftId giftNum:(NSString *)giftNum liveId:(NSString *)liveId
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"propId"] = giftId;
    params[@"count"] = giftNum;
    params[@"deviceCode"] = [NSString stringWithUUID];
    if (liveId.length) {
        params[@"liveId"] = liveId;
    }
    __weak __typeof(self)weakSelf = self;
    [HttpRequest requestWithURLType:UrlTypeLiveGiftReward parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code==200) {
            if (strongSelf.delegate) {
                [strongSelf.delegate requestLiveGiftRewardFinish:nil];
            }
        }
        else {
            NSString *message = responseObject[@"message"];
            if ([message isEqual:[NSNull null]] && message == nil) {
                message = @"";
            }
            NSError *error = [NSError errorWithDomain:message code:code userInfo:nil];
            if (strongSelf.delegate) {
                [strongSelf.delegate requestLiveGiftRewardFinish:error];
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.delegate) {
            [strongSelf.delegate requestLiveGiftRewardFinish:error];
        }
    }];
}

/// 获取服务器时间和fromDate的时间差
/// @param fromDate 开始时间
- (void)requestTimeInterval:(NSString *)fromDate
{
    __weak __typeof(self)weakSelf = self;
    [HttpRequest requestWithURLType:UrlTypeQueryServerTime parameters:[NSDictionary dictionaryWithObject:fromDate forKey:@"clientTime"] type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code==200) {
            strongSelf.systemTimeInterval = responseObject[@"data"][@"differTime"];         //相差时间，毫秒
            if (strongSelf.delegate) {
                [strongSelf.delegate requestTimeIntervalFinish:nil];
            }
        }
        else {
            NSString *message = responseObject[@"message"];
            if ([message isEqual:[NSNull null]] && message == nil) {
                message = @"";
            }
            NSError *error = [NSError errorWithDomain:message code:code userInfo:nil];
            if (strongSelf.delegate) {
                [strongSelf.delegate requestTimeIntervalFinish:error];
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.delegate) {
            [strongSelf.delegate requestTimeIntervalFinish:error];
        }
    }];
}

@end
