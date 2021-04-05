//
//  SHXMPPManager.h
//  DragonLive
//
//  Created by 11号 on 2020/12/1.
//

#import <Foundation/Foundation.h>
#import <XMPPFramework/XMPP.h>

NS_ASSUME_NONNULL_BEGIN

//block 用户登录，注册部分
typedef void (^OperationSuccessBlock)(void);
typedef void (^OperationfailedBlock)(NSString *error);

@interface SHXMPPManager : NSObject<XMPPStreamDelegate>

@property(nonatomic,strong,readonly)XMPPStream *xmppStream;
@property (nonatomic,assign)BOOL isRegisterUser;                    //是否需要注册标示
@property(nonatomic,copy)OperationSuccessBlock successBlock;        //成功回掉
@property(nonatomic,copy)OperationfailedBlock failedBlock;          //失败回掉

+(SHXMPPManager *)xmppManager;

////初始化XMPPStream
//-(void)setupStream;

//与服务器断开连接
-(void)disconnect;

//登录
-(void)loginWithUserName:(NSString *)userName password:(NSString *)password roomId:(NSString *)roomId loginSuccess:(OperationSuccessBlock)loginSuceess loginFailed:(OperationfailedBlock)loginFailed;

//注册
- (void)registerWithUserName:(NSString *)userName  password:(NSString *)password registerSuccess:(OperationSuccessBlock)registerSuccess registerFailed:(OperationfailedBlock)registerFailed;

@end

NS_ASSUME_NONNULL_END
