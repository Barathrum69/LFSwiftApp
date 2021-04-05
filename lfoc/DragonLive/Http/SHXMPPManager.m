//
//  SHXMPPManager.m
//  DragonLive
//
//  Created by 11号 on 2020/12/1.
//

#import "SHXMPPManager.h"

#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

//本地服务器端口名
#define kxmppServer  @"47.241.16.100"

#define kDomain  @"conference.izt4nhwkjw59e9rlelmoprz"

@interface SHXMPPManager (){

    NSString *_userName;    //用户名
    NSString *_password;    //密码
    NSString *_roomId;      //房间id
}
@property(nonatomic,copy)NSString *userName;        //用户名
@property(nonatomic,copy)NSString *password;        //密码
@property(nonatomic,copy)NSString *roomId;          //房间id
@property (nonatomic,assign)BOOL isDisconnect;

@end

@implementation SHXMPPManager

//创建一个单例模式来管理xmpp的连接和操作
+(SHXMPPManager *)xmppManager{

    static SHXMPPManager *manager =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SHXMPPManager alloc]init];
        [manager setupStream];
    });
    
    return manager;
}

#pragma mark ----- 登录注册部分 -------

-(void)loginWithUserName:(NSString *)userName password:(NSString *)password roomId:(NSString *)roomId loginSuccess:(OperationSuccessBlock)loginSuceess loginFailed:(OperationfailedBlock)loginFailed{
    
    self.roomId = roomId;
    [self initWithUserName:userName password:password loginSuccess:loginSuceess loginFailed:loginFailed];
}

-(void)registerWithUserName:(NSString *)userName password:(NSString *)password registerSuccess:(OperationSuccessBlock)registerSuccess registerFailed:(OperationfailedBlock)registerFailed{

    self.isRegisterUser =YES;
    [self initWithUserName:userName password:password loginSuccess:registerSuccess loginFailed:registerFailed];
}

-(void)initWithUserName:(NSString *)userName password:(NSString *)password loginSuccess:(OperationSuccessBlock)suceess loginFailed:(OperationfailedBlock)failed{

    self.successBlock = suceess;
    self.failedBlock = failed;
    self.userName = userName;
    self.password = password;
    
    [self currentStateIsConnected];
    [self connect];
}

#pragma mark  ------- 建立连接相关代理 -----

//登录操作，也就是连接xmpp服务器,该方法会首先被调用。
-(void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket{
    NSLog(@"%@ %@",sender,socket);
}

//连接成功时调用，然后开始授权密码验证
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    
    if (self.isRegisterUser) {
        //用户注册，发送注册请求
        [self.xmppStream registerWithPassword:_password error:nil];
    } else {
        //用户登录，发送身份验证请求
        [self.xmppStream authenticateWithPassword:_password error:nil];
    }
}

//断开连接时调用.此方法在stream连接断开的时候调用，注意这些代理方法都是异步的.
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    NSLog(@"断开连接! %@",sender);
    self.isDisconnect = YES;
}

#pragma mark --------  授权部分 ----------
//授权成功,开始发送信息
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{

    __weak SHXMPPManager *weakSelf =self;
    dispatch_main_sync_safe(^{
        if (weakSelf.successBlock) {
            weakSelf.successBlock();
        }
    });
    //通知服务器用户上线
    [self goOnline];
}

//授权失败,该方法会被调用
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    
    //授权失败重新注册一次
    [self.xmppStream registerWithPassword:_password error:nil];
    
   __weak SHXMPPManager *weakSelf =self;
    //根据是否是主线程再决定是否使用GCD。
    dispatch_main_sync_safe(^{
      if (self.failedBlock) {
          weakSelf.failedBlock(error.description);
        }
    });
}

#pragma mark ------- 注册相关代理 ----------
-(void)xmppStreamDidRegister:(XMPPStream *)sender{

    self.isRegisterUser =NO;
    __weak SHXMPPManager *weakSelf =self;
    dispatch_main_sync_safe(^{
        if (weakSelf.successBlock) {
            weakSelf.successBlock();
        }
    });
}

-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    
    __weak SHXMPPManager *weakSelf =self;
    dispatch_main_sync_safe(^{
        if (self.failedBlock) {
            weakSelf.failedBlock(error.description);
        }
    });
}

//连接服务端
-(void)connect{
    
    // 如果XMPPStream当前已经连接，直接返回
    if ([_xmppStream isConnected]) {
        return;
    }
    
    // 设置XMPPStream的JID和主机.完整的Jid包括 Username@Domain/resource. Username：用户名，Domain登陆的XMPP服务器域名。Resource：资源/来源，用于区别客户端来源，xmpp协议设计为可多客户端同时登陆，resource就是用于区分同一用户不同端登陆。
    XMPPJID *myJID = [XMPPJID jidWithString:[self getBareJidStr]];
    [_xmppStream setMyJID: myJID];
    [_xmppStream setHostName:[UserInstance shareInstance].xmppServerAddress];
    [_xmppStream setHostPort:5222];
    
    // 开始连接提示：如果没有指定JID和hostName，才会出错，其他都不出错。
    NSError *error = nil;
    NSLog(@"%d", [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]);
    if (error) {
        NSLog(@"连接请求发送出错 %@",error.localizedDescription);
    }else{
        NSLog(@"连接请求发送成功！");
    }
}

//与服务器断开连接
-(void)disconnect{
    
    //通知服务器下线
    [self goOffLine];
    //XMPPStream断开连接
    [_xmppStream disconnect];
}

//如果已经存在连接，先断开连接
-(void)currentStateIsConnected{
    
    if ([self.xmppStream isConnected]){
        [self.xmppStream disconnect];
    }
}

//初始化 XMPPStream并设置代理:
-(void)setupStream{
    
    _xmppStream = [[XMPPStream alloc] init];
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

//XMPPStream 上线
-(void)goOnline{

    // 实例化一个”展现“，上线的报告，默认类型为：available
    XMPPPresence *presence = [XMPPPresence presence];
    // 发送Presence给服务器,服务器知道“我”上线后，只需要通知我的好友，而无需通知我，因此，此方法没有回调
    [_xmppStream sendElement:presence];
}

//XMPPStream 离线
-(void)goOffLine{

    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:presence];
}

- (NSString *)getBareJidStr{
    
    //注册进入不用拼接房间号
    if (self.isRegisterUser) {
        return [NSString stringWithFormat:@"%@@%@",_userName,kDomain];
    }
    return [NSString stringWithFormat:@"%@@%@",_userName,kDomain];
}

-(void)dealloc{

    _xmppStream = nil;
    [_xmppStream removeDelegate:self];
}

@end
