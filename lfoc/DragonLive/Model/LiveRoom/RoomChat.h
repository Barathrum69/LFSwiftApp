//
//  RoomChat.h
//  DragonLive
//
//  Created by 11号 on 2020/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 聊天室消息模型
@interface RoomChat : NSObject

/// 用户id
@property (nonatomic, copy) NSString *userId;

/// 用户名
@property (nonatomic, copy) NSString *userName;

/// 用户等级
@property (nonatomic, copy) NSString *userLevel;

/// 用户在直播间的角色类型 ：1 - 主播或者房管,2 - 普通用户
@property (nonatomic, copy) NSString *userRole;

/// 消息体
@property (nonatomic, copy) NSString *userChat;

/// 雷速聊天标识：2
@property (nonatomic, copy) NSString *leisu;

/// 聊天消息高度
@property (nonatomic, assign) CGFloat contentHeight;

/// 聊天消息体富文本拼接
@property (nonatomic, copy) NSMutableAttributedString *contentAtt;

- (NSMutableAttributedString *)getContentAttri;

@end

NS_ASSUME_NONNULL_END
