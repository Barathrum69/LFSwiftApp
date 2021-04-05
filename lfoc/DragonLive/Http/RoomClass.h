//
//  RoomClass.h
//  DragonLive
//
//  Created by 11号 on 2020/12/1.
//

#import <Foundation/Foundation.h>
#import "XMPPRoom.h"
#import <XMPPFramework/XMPPRoomCoreDataStorage.h>
//#import "CoreDataManager.h"
//#import "CentreControl.h"
//#import "TFTimer.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ChatRoomDelegate <NSObject>

@optional //非必实现的方法

//加入聊天室成功
- (void)xmppChatRoomDidJoin:(XMPPRoom *)sender;

//接收到新消息事件
- (void)xmppChatRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID;

//新人加入群聊
- (void)xmppChatRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence;

//有人退出群聊
- (void)xmppChatRoom:(XMPPRoom *)sender occupantDidLeave:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence;

@end

@interface RoomClass : NSObject<XMPPRoomDelegate>
{
    NSTimer *RoomTimer;
    XMPPStream  *stream;
}

typedef void(^handler)(BOOL result,id obj) ;

@property (nonatomic,assign) id <ChatRoomDelegate> roomDelegate;
@property (nonatomic,strong) XMPPRoomCoreDataStorage *xmppRoomData;
@property (nonatomic,strong) XMPPRoom *m_xmppRoom;
@property (nonatomic,copy) NSString *Jid;
@property (nonatomic,assign) BOOL    isCame;
@property (nonatomic,assign) BOOL    isLoadHistory;

/// 进入房间
/// @param xmppstream 已登录的stream服务
/// @param roomId 房间id
/// @param account 用户账号
/// @param nickName 用户名
- (id)initWithXMPPStream:(XMPPStream *)xmppstream roomId:(NSString *)roomId account:(NSString *)account nickName:(NSString *)nickName;


/// 离开房间
-(void)leaveRoom;

@end

NS_ASSUME_NONNULL_END
