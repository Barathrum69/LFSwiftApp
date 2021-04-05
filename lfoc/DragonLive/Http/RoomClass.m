//
//  RoomClass.m
//  DragonLive
//
//  Created by 11号 on 2020/12/1.
//

#import "RoomClass.h"
//#import <XMPP.h>

@implementation RoomClass
{
   XMPPStream * m_stream;
   NSMutableArray * members;
   NSString *Roomjid;
   NSDate *dateIn;
}

//
//NSString *const kXMPPmyJID = @"kXMPPmyJID";
//NSString *const kXMPPmyPassword = @"kXMPPmyPassword";
#define kDomain  @"conference.izt4nhwkjw59e9rlelmoprz"

- (id)initWithXMPPStream:(XMPPStream *)xmppstream roomId:(NSString *)roomId account:(NSString *)account nickName:(NSString *)nickName
{
//   _RoomBlock = finished;
   m_stream = xmppstream;
    
   self = [super init];
   if (self) {
        // Custom initialization

       //完整的Jid拼接，包括 roomId@Domain/nickName.
       NSString *jidStr = [NSString stringWithFormat:@"%@@%@/%@",roomId,kDomain,nickName];
       
        _xmppRoomData = [[XMPPRoomCoreDataStorage alloc] initWithInMemoryStore];
       _m_xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:_xmppRoomData jid:[XMPPJID jidWithString:jidStr] dispatchQueue:dispatch_get_main_queue()];
        [_m_xmppRoom activate:xmppstream];
       
//       NSXMLElement *xml = [[NSXMLElement alloc] initWithXMLString:@"<history maxstanzas='0'/>"error:nil];
        //            NSLog(@"room xml == {%@}",xml.XMLString);
       //在聊天中显示的昵称
       [_m_xmppRoom joinRoomUsingNickname:nickName history:nil];
       
       //房间默认配置
       [_m_xmppRoom fetchConfigurationForm];
       
        [_m_xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
//       NSLog(@"init roomJID%@",RoomJID);

    }
    return self;
}

-(void)leaveRoom{
   if (!_isCame) {
//        [RoomTimer pauseTimer];
    }
    
    [_m_xmppRoom leaveRoom];
    [_m_xmppRoom deactivate];
//
    
    [_m_xmppRoom removeDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}

#pragma mark 配置房间为永久房间
-(void)sendDefaultRoomConfig
{
    
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:@"jabber:x:data"];
    
    NSXMLElement *field = [NSXMLElement elementWithName:@"field"];
    NSXMLElement *value = [NSXMLElement elementWithName:@"value"];
        
    [field addAttributeWithName:@"var" stringValue:@"muc#roomconfig_persistentroom"];  // 永久属性
    [field addAttributeWithName:@"type" stringValue:@"boolean"];
    [value setStringValue:@"1"];
    
    [x addChild:field];
    [field addChild:value];
   
    [_m_xmppRoom configureRoomUsingOptions:x];

}
 
//创建聊天室成功
- (void)xmppRoomDidCreate:(XMPPRoom *)sender{
    NSLog(@"创建聊天室成功~");
    [self sendDefaultRoomConfig];
}
- (void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(NSXMLElement *)configForm{
//    NSLog(@"%s~~~",__FUNCTION__);
}

- (void)xmppRoom:(XMPPRoom *)sender willSendConfiguration:(XMPPIQ *)roomConfigForm{
//    NSLog(@"%s~~~",__FUNCTION__);
}

- (void)xmppRoom:(XMPPRoom *)sender didConfigure:(XMPPIQ *)iqResult{
//    NSLog(@"%s~~~",__FUNCTION__);
}
- (void)xmppRoom:(XMPPRoom *)sender didNotConfigure:(XMPPIQ *)iqResult{
//    NSLog(@"%s~~~",__FUNCTION__);
}

//加入聊天室成功
- (void)xmppRoomDidJoin:(XMPPRoom *)sender{
    NSLog(@"获取聊天室信息~");
   _isCame = YES;
    _isLoadHistory =NO;
    if (self.roomDelegate) {
        [self.roomDelegate xmppChatRoomDidJoin:sender];
    }
//    [sender fetchConfigurationForm];
//    [sender fetchBanList];
//    [sender fetchMembersList];
//    [sender fetchModeratorsList];
}

//离开聊天室
- (void)xmppRoomDidLeave:(XMPPRoom *)sender{
    [_m_xmppRoom leaveRoom];
    [_m_xmppRoom deactivate];
    _xmppRoomData  =nil;
    [_m_xmppRoom removeDelegate:self delegateQueue:dispatch_get_main_queue()];

}

- (void)xmppRoomDidDestroy:(XMPPRoom *)sender{
//    NSLog(@"%s~~~",__FUNCTION__);
}

- (void)xmppRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence{
    
    if (self.roomDelegate) {
        [self.roomDelegate xmppChatRoom:sender occupantDidJoin:occupantJID withPresence:presence];
    }
}
- (void)xmppRoom:(XMPPRoom *)sender occupantDidLeave:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence{
    
    if (self.roomDelegate) {
        [self.roomDelegate xmppChatRoom:sender occupantDidLeave:occupantJID withPresence:presence];
    }
}
- (void)xmppRoom:(XMPPRoom *)sender occupantDidUpdate:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence{
//    NSLog(@"%s~~~",__FUNCTION__);
}

/**
 * Invoked when a message is received.
 * The occupant parameter may be nil if the message came directly from the room, or from a non-occupant.
 **/
- (void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID{
    
    if (self.roomDelegate) {
        [self.roomDelegate xmppChatRoom:sender didReceiveMessage:message fromOccupant:occupantJID];
    }
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchBanList:(NSArray *)items{
    NSLog(@"%s~~~",__FUNCTION__);
}
- (void)xmppRoom:(XMPPRoom *)sender didNotFetchBanList:(XMPPIQ *)iqError{
    NSLog(@"%s~~~",__FUNCTION__);
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchMembersList:(NSArray *)items{
    NSLog(@"%s~~~",__FUNCTION__);
}
- (void)xmppRoom:(XMPPRoom *)sender didNotFetchMembersList:(XMPPIQ *)iqError{
    NSLog(@"%s~~~",__FUNCTION__);
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchModeratorsList:(NSArray *)items{
//    NSLog(@"%s~~~",__FUNCTION__);
}
- (void)xmppRoom:(XMPPRoom *)sender didNotFetchModeratorsList:(XMPPIQ *)iqError{
//    NSLog(@"%s~~~%@",__FUNCTION__,sender.roomJID.bare);
}

- (void)xmppRoom:(XMPPRoom *)sender didEditPrivileges:(XMPPIQ *)iqResult{
//    NSLog(@"%s~~~",__FUNCTION__);
}
- (void)xmppRoom:(XMPPRoom *)sender didNotEditPrivileges:(XMPPIQ *)iqError{
//    NSLog(@"%s~~~",__FUNCTION__);
}

@end
