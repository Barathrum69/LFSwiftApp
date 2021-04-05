//
//  LiveHosts.h
//  DragonLive
//
//  Created by 11号 on 2020/12/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveHosts : NSObject

/// 主播ID
@property (nonatomic, copy) NSString *hostId;

/// 主播昵称
@property (nonatomic, copy) NSString *nickname;

/// 主播头像
@property (nonatomic, copy) NSString *headicon;

/// 房间id
@property (nonatomic, copy) NSString *roomid;

/// 直播状态
@property (nonatomic, copy) NSString *livestatus;

/// 主播状态
@property (nonatomic, copy) NSString *userstatus;

/// 粉丝数
@property (nonatomic, copy) NSString *fansnum;

@end

NS_ASSUME_NONNULL_END
