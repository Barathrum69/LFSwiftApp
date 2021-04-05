//
//  DRChatRoomView.m
//  DragonLive
//
//  Created by 11号 on 2021/2/15.
//

#import "DRChatRoomView.h"
#import "LiveChatCell.h"
#import "LiveChatSystemCell.h"
#import "LiveStreamerView.h"
#import "DRGiftChooseView.h"
#import "DRGiftAnimationView.h"
#import "DRSVGAnimationView.h"
#import "DKSKeyboardView.h"
#import "EasyTextView.h"
#import "RoomClass.h"
#import "RoomChat.h"
#import "RoomGift.h"
#import "SHXMPPManager.h"
#import "ZXCTimer.h"
#import "DREmitterLayer.h"
#import "UserTaskInstance.h"
#import "JHRotatoUtil.h"
#import "MineProxy.h"
#import "LiveRoomViewModel.h"
#import "RoomInfo.h"

typedef enum : NSUInteger {
    SLChatType,                     //聊天
    SLHostType,                     //主播
} SliderType;

@interface DRChatRoomView ()<UITableViewDelegate,UITableViewDataSource,ChatRoomDelegate,DKSKeyboardDelegate>

@property (nonatomic,strong) UILabel *attentionLab;             //关注标题
@property (nonatomic,strong) UILabel *fansLab;                  //粉丝数
@property (nonatomic,strong) UIView *sliderView;                //滑块
@property (nonatomic,strong) UITableView *chatTableView;        //聊天table
@property (nonatomic, strong) UIButton *scrollBottomBut;        //底部有新消息按钮

@property (nonatomic, strong) LiveStreamerView *streamerView;               //主播view
@property (nonatomic, strong) DRGiftChooseView *giftChooseView;             //礼物选择view
@property (nonatomic, strong) DKSKeyboardView *keyboardView;                //聊天输入

@property (nonatomic, strong) RoomClass *roomClass;                         //xmpp 加入房间server
@property (nonatomic, strong) RoomGift *giftRewardModel;                    //记录打赏的某个礼物
@property (nonatomic, strong) NSMutableArray *chatArr;                      //聊天消息集合
@property (nonatomic, strong) NSDictionary *emojiDic;                       //表情字典
@property (nonatomic, assign) CGFloat livePlayerHeight;                     //播放器高度
@property (nonatomic, copy) NSString *disableSpeakId;                       //被禁言用户id
@property (nonatomic, assign) BOOL isRecognizedChange;                      //用户手动滑动了聊天则停止系统的自动滑动
@property (nonatomic, assign) SliderType sliderType;

@end

@implementation DRChatRoomView

- (id)initWithFrame:(CGRect)frame roomId:(NSString *)roomId
{
    self = [super initWithFrame:frame];
    if (self) {
        [self joinXmppRoom:roomId];
        [self setTopView];
        [self setChatView];
    }
    return self;
}

#pragma mark -private method
// 聊天室加入房间
- (void)joinXmppRoom:(NSString *)roomId
{
    UserModel *userModel = [UserInstance shareInstance].userModel;
    
    NSString *account = userModel.userName;
    NSString *nickName = userModel.nickname;
    NSString *psw = @"123456";                      //默认登录密码
    
    XMPPStream *xmppStream = [SHXMPPManager xmppManager].xmppStream;
    
    __weak __typeof(self)weakSelf = self;
    [[SHXMPPManager xmppManager] loginWithUserName:account password:psw roomId:roomId loginSuccess:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSLog(@"xmpp登录成功");
        [UserInstance shareInstance].isXmppLogin = YES;
        //加入房间
        strongSelf.roomClass = [[RoomClass alloc] initWithXMPPStream:xmppStream roomId:roomId account:account nickName:nickName];
        strongSelf.roomClass.roomDelegate = strongSelf;
        
    } loginFailed:^(NSString * _Nonnull error) {
        NSLog(@"xmpp登录失败");
    }];
}

//聊天输入内容中表情字符替换
- (NSString *)filterChatEmoji:(NSString *)chatStr
{
    NSString *pattern = @"\\[[\u4e00-\u9fa5]+\\]";
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *resultArray = [regular matchesInString:chatStr options:0 range:NSMakeRange(0, chatStr.length)];

    if (resultArray.count) {
        NSTextCheckingResult *result = [resultArray firstObject];
        NSRange range = result.range;

        NSString *emojiName = [chatStr substringWithRange:range];
        NSString *emojiKey = [self.emojiDic objectForKey:emojiName];
        chatStr = [chatStr stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"[face%@]",emojiKey]];
        
        return [self filterChatEmoji:chatStr];
    }
    
    return chatStr;
}

//接收到礼物消息的处理
- (void)receiveGiftMessage:(XMPPMessage *)message
{
    NSString *giftId = [[message elementForName:@"giftid"] stringValue];
    NSString *fromUserName = [[message elementForName:@"name"] stringValue];
    NSString *giftNum = [[message elementForName:@"num"] stringValue];
    
    //快速查找出接收的某个礼物
    NSPredicate *modelPredicate = [NSPredicate predicateWithFormat:@"SELF.propId = %@", giftId];
    NSArray *result = [_roomViewModel.giftArray filteredArrayUsingPredicate:modelPredicate];
    if (result.count) {
        RoomGift *giftModel = result.firstObject;
        giftModel.giftNum = giftNum;
        if ([giftModel.showType integerValue] == 0) {
            [DRGiftAnimationView showGiftAnimationInWindow:giftModel fromName:fromUserName];
        }else {
            [DRSVGAnimationView showSVGAnimationInWindow:giftModel fromName:fromUserName];
        }
    }
}

//让聊天室信息自动滚动到底部
- (void)setScrollPositionBottom
{
    if (!self.isRecognizedChange) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.chatArr.count-1 inSection:0];
        [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }else {
        if (_chatArr.count > 10 && _sliderType == SLChatType) {      //超过一屏才出现
            self.scrollBottomBut.hidden = NO;
        }
    }
}

//系统公告、加入房间、新消息等
- (void)insertChatMessage:(NSDictionary *)dic
{
    RoomChat *chatModel = [RoomChat modelWithDictionary:dic];
    
    //首次光临直播间的提示语5s后自动移除
    if ([chatModel.userChat isEqualToString:@"光临直播间"]) {
        __weak __typeof(self)weakSelf = self;
        [[ZXCTimer shareInstance] addTimerTask:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            [strongSelf.chatArr removeObject:chatModel];
            [strongSelf.chatTableView reloadData];
            
        } after:5 threadMode:ZXCMainThread];
        
    }else {
        chatModel.userName = [NSString stringWithFormat:@"%@:",chatModel.userName?:@""];
    }
    
    chatModel.contentAtt = [chatModel getContentAttri];
    
    [self.chatArr addObject:chatModel];
    [self.chatTableView reloadData];
    
    //接收聊天室消息并自动滚动到最底部
    [self setScrollPositionBottom];
    
    if ([chatModel.userChat isEqualToString:@"#下雪了"] && [UserTaskInstance shareInstance].snowCount<2) {
        [UserTaskInstance shareInstance].snowCount++;
        CAEmitterLayer *snowLayer = [DREmitterLayer snowEmitterLayer:self.bounds];
        [self.layer addSublayer:snowLayer];
        [[ZXCTimer shareInstance] addTimerTask:^{
            [snowLayer removeFromSuperlayer];
            
        } after:10 threadMode:ZXCMainThread];
        
    }else if ([chatModel.userChat isEqualToString:@"#新年快乐"] && [UserTaskInstance shareInstance].fireCount<2) {
        [UserTaskInstance shareInstance].fireCount++;
        CAEmitterLayer *snowLayer = [DREmitterLayer fireworkdEmitterLayer:self.bounds];
        [self.layer addSublayer:snowLayer];
        [[ZXCTimer shareInstance] addTimerTask:^{
            [snowLayer removeFromSuperlayer];
            
        } after:10 threadMode:ZXCMainThread];
    }
}

//隐藏键盘
- (void)hidenKeyboardAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"keyboardHide" object:nil];
    
    if([JHRotatoUtil isOrientationLandscape]) {
        self.keyboardView.y = kkScreenHeight;
    }
}

//礼物选择view
- (void)showChooseView
{
    __weak __typeof(self)weakSelf = self;
    self.giftChooseView = [DRGiftChooseView showGiftViewInWindow:_roomViewModel.giftArray changeItem:^(RoomGift * _Nonnull giftModel) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([UserInstance shareInstance].isLogin) {
            strongSelf.giftRewardModel = giftModel;
            [strongSelf.roomViewModel requestGiftReward:giftModel.propId giftNum:giftModel.giftNum liveId:strongSelf.roomViewModel.roomInfoModel.liveId];
        }else {
            [UntilTools pushLoginPage];
        }
    }];
    self.giftChooseView.loadMoneyBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.delegate) {
            [strongSelf.delegate giftViewWithRechargeEvent];
        }
//        if ([[UserInstance shareInstance] isLogin]) {
//            if ([JHRotatoUtil isOrientationLandscape]) {
//                [JHRotatoUtil forceOrientation:UIInterfaceOrientationPortrait];
//            }
//            WalletController *vc = [WalletController new];
//            [weakSelf.navigationController pushViewController:vc animated:YES];
//        }else {
//            [UntilTools pushLoginPage];
//        }
        
    };
}

#pragma mark ====== 外部调用方法 ======

#pragma mark ====== 点击事件 ======
/// 聊天
- (void)chatAction
{
    self.sliderType = SLChatType;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.sliderView.center = CGPointMake(30, self.sliderView.center.y);
    }];
    
    self.streamerView.hidden = YES;
    self.keyboardView.hidden = NO;
}

/// 主播
- (void)hostAction
{
    self.sliderType = SLHostType;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.sliderView.center = CGPointMake(84, self.sliderView.center.y);
    }];
    
    self.scrollBottomBut.hidden = YES;
    self.streamerView.hidden = NO;
    self.keyboardView.hidden = YES;
}

/// 底部有新消息
- (void)scrollBottomAction
{
    
}

/// 关注/取关
/// @param sender 手势
- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    
}

#pragma mark ====== UITableView代理事件 ======
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.chatArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RoomChat *chatModel = [self.chatArr objectAtIndex:indexPath.row];
    
    if (chatModel.userName.length && [chatModel.userName rangeOfString:@"系统消息"].location != NSNotFound) {
        static NSString *cellSystemIdentifier = @"LiveChatSystemCell";
        LiveChatSystemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellSystemIdentifier];
        if (!cell) {
            cell =  [[NSBundle mainBundle] loadNibNamed:@"LiveChatSystemCell" owner:self options:nil].firstObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setRoomChat:chatModel];
        
        return cell;
    }
    
    static NSString *cellIdentifier = @"LiveChatCell";
    LiveChatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell =  [[NSBundle mainBundle]loadNibNamed:@"LiveChatCell" owner:self options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setRoomChat:chatModel];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoomChat *chatModel = [self.chatArr objectAtIndex:indexPath.row];
    return chatModel.contentHeight + 2.0;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat height = scrollView.frame.size.height;
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat bottomOffset = scrollView.contentSize.height - contentOffsetY;
    if (bottomOffset <= height + 10) {
        //滑动到最底部隐藏按钮
        self.scrollBottomBut.hidden = YES;
    }else {
        if (scrollView.panGestureRecognizer.state != UIGestureRecognizerStateChanged) return;
        CGPoint point =  [scrollView.panGestureRecognizer translationInView:self];
        NSIndexPath *indexPath = [self.chatTableView indexPathForRowAtPoint:point];
        NSLog(@"滑动到%ld行",(long)indexPath.row);
        if (point.y != 0 ) {
            self.isRecognizedChange = YES;
        }
    }
}

#pragma mark ====== 聊天室代理 ======

//加入聊天室成功
- (void)xmppChatRoomDidJoin:(XMPPRoom *)sender
{
    XMPPMessage *message = [XMPPMessage message];
    NSXMLElement *body = [NSXMLElement elementWithName:@"body" stringValue:@"光临直播间"];
    [message addChild:body];
    NSXMLElement *name = [NSXMLElement elementWithName:@"name" stringValue:[UserInstance shareInstance].userModel.nickname];
    [message addChild:name];
    NSXMLElement *level = [NSXMLElement elementWithName:@"enter" stringValue:@"enter"];
    [message addChild:level];
    
    [self.roomClass.m_xmppRoom sendMessage:message];
}

//新人加入房间
- (void)xmppChatRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence
{
//    NSString *joinUserName = [[presence from] resource];
//
//    //加入房间
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"光临直播间",@"userChat",joinUserName,@"userName", nil];
//    [self insertChatMessage:dic];
//
//    NSLog(@"%@加入房间",joinUserName);
}

//有人退出房间
- (void)xmppChatRoom:(XMPPRoom *)sender occupantDidLeave:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence
{
//    NSString *leaveUserName = [[presence from] resource];
//
//    //主播和房管可看见离开的用户
//    if ([[UserInstance shareInstance].userModel.userRoomRole integerValue] == 1) {
//
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"离开了直播间",@"userChat",leaveUserName,@"userName", nil];
//        [self insertChatMessage:dic];
//    }
//    NSLog(@"%@离开房间",leaveUserName);
}

//接收消息
- (void)xmppChatRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID
{
    //判断用户是否被禁言
    NSString *userId = [[message elementForName:@"jinyan"] stringValue];
    if (userId && userId.length) {
        if ([userId isEqualToString:[UserInstance shareInstance].userModel.userId]) {
            [UserInstance shareInstance].disableUserMessage = YES;
        }
        return;
    }
    
    //礼物
    if ([[message elementForName:@"giftid"] stringValue]) {
        [self receiveGiftMessage:message];
        return;
    }
    
    //开播/关播
    NSString *startStatus = [[message elementForName:@"start"] stringValue];
    if (startStatus) {
        if ([startStatus integerValue] == 1) {
            //开播
        }else {
            //关播
//            [self.drLivePlayer hostLivingLost];
            if (self.delegate) {
                [self.delegate hostLivingTurnOff];
            }
        }
    }
    
    //普通消息
    NSString *body = message.body;
    NSString *uId = [[message elementForName:@"id"] stringValue];
    NSString *name = [[message elementForName:@"name"] stringValue];
    NSString *level = [[message elementForName:@"level"] stringValue];
    NSString *role = [[message elementForName:@"role"] stringValue];
    NSString *leisu = [[message elementForName:@"leisu"] stringValue];
    
    //过滤换行符和空格
    body = [body stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    body = [body stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    body = [body stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:body,@"userChat",name,@"userName",level,@"userLevel",uId,@"userId",role,@"userRole",leisu,@"leisu", nil];
    [self insertChatMessage:dic];
    
    //弹幕开关打开且全屏才可以显示弹幕
    if ([UserInstance shareInstance].isSetBarrageOpen && [JHRotatoUtil isOrientationLandscape]) {
//        [_drLivePlayer addBarrageWithChat:body];
        if (self.delegate) {
            [self.delegate addBarrageWithMessage:body];
        }
    }
    
    //用户发送了2次聊天则上报任务
//    NSLog(@"用户id：%@ 弹幕状态：%ld",[UserInstance shareInstance].userModel.userId,(long)[UserTaskInstance shareInstance].barrageStatus);
    if ([uId isEqualToString:[UserInstance shareInstance].userModel.userId] && [UserTaskInstance shareInstance].barrageStatus == 1) {
        [UserTaskInstance shareInstance].barrageCount = [UserTaskInstance shareInstance].barrageCount + 1;
        //调用完成任务接口
        if ([UserTaskInstance shareInstance].barrageCount >= 2) {
            [MineProxy completeTaskWithTaskId:@"3" success:^(BOOL success) {
                [UserTaskInstance shareInstance].barrageStatus = 2;
                [[NSUserDefaults standardUserDefaults] setInteger:[UserTaskInstance shareInstance].barrageStatus forKey:kkBarrageSendStatus];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } failure:^(NSError * _Nonnull error) {
            }];
        }
        [[NSUserDefaults standardUserDefaults] setInteger:[UserTaskInstance shareInstance].barrageCount forKey:kkBarrageSendCount];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark ====== DKSKeyboardDelegate ======
//发送的文案
- (void)textViewContentText:(NSString *)textStr {

    //收起键盘
    [self hidenKeyboardAction];
    
    //未登录跳转登录页
    if (![UserInstance shareInstance].isLogin) {
        
        [UntilTools pushLoginPage];
        return;;
    }
    
    //输入全空格过滤
    NSString *bodyStr = [textStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (bodyStr.length == 0) {
        return;
    }
    //未被禁言的则可以聊天
    if (![UserInstance shareInstance].disableUserMessage) {
        UserModel *userModel = [UserInstance shareInstance].userModel;
        XMPPMessage *message = [XMPPMessage message];
        NSXMLElement *body = [NSXMLElement elementWithName:@"body" stringValue:[self filterChatEmoji:textStr]];
        [message addChild:body];
        NSXMLElement *name = [NSXMLElement elementWithName:@"name" stringValue:userModel.nickname];
        [message addChild:name];
        NSXMLElement *level = [NSXMLElement elementWithName:@"level" stringValue:userModel.currentGradle];
        [message addChild:level];
        NSXMLElement *userId = [NSXMLElement elementWithName:@"id" stringValue:userModel.userId];
        [message addChild:userId];
        NSXMLElement *userRole = [NSXMLElement elementWithName:@"role" stringValue:userModel.userRoomRole];
        [message addChild:userRole];
        
        [self.roomClass.m_xmppRoom sendMessage:message];
    }else {
        [EasyTextView showText:@"您已被禁言"];
    }
}

- (void)keyboardChangeFrameWithMinY:(CGFloat)minY {
}

- (void)keyboardWillShow:(NSNotification *)notification {
}

- (void)inputMaxLimitNums
{
    [EasyTextView showText:@"发言不能超过30个字符" config:^EasyTextConfig *{

        //方法三
        EasyTextConfig *config = [EasyTextConfig shared];
        config.statusType = TextStatusTypeTop ;
        return config ;
    }];
//    [EasyTextView showText:@"发言不能超过30个字符"];
}

- (void)giftChange
{
    [self hidenKeyboardAction];
    [self showChooseView];
}

#pragma mark ====== UI初始化 ======
/// 聊天/主播切换view
- (void)setTopView
{
    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topView];
    
    UIButton *chatBut = [UIButton new];
    [chatBut setTitle:@"聊天" forState:UIControlStateNormal];
    [chatBut setTitleColor:[UIColor colorFromHexString:@"#222222"] forState:UIControlStateNormal];
    chatBut.titleLabel.font = [UIFont systemFontOfSize:15];
    [chatBut addTarget:self action:@selector(chatAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:chatBut];
    
    UIButton *hostBut = [UIButton new];
    [hostBut setTitle:@"主播" forState:UIControlStateNormal];
    [hostBut setTitleColor:[UIColor colorFromHexString:@"#222222"] forState:UIControlStateNormal];
    hostBut.titleLabel.font = [UIFont systemFontOfSize:15];
    [hostBut addTarget:self action:@selector(hostAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:hostBut];
    
    //关注view
    UIView *attentionView = [UIView new];
    [UntilTools addCAGradientLayer:attentionView fromColor:[UIColor colorFromHexString:@"#FF7835"] toColor:[UIColor colorFromHexString:@"#F09246"]];
    [topView addSubview:attentionView];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [attentionView addGestureRecognizer:tapGesture];
    
    //关注标题
    UILabel *attentionLab = [UILabel new];
    attentionLab.textAlignment = NSTextAlignmentCenter;
    attentionLab.font = [UIFont boldSystemFontOfSize:16];
    attentionLab.text = @"+关注";
    [attentionView addSubview:attentionLab];
    self.attentionLab = attentionLab;
    
    //粉丝数
    UILabel *fansLab = [UILabel new];
    fansLab.textAlignment = NSTextAlignmentCenter;
    fansLab.font = [UIFont boldSystemFontOfSize:12];
    [attentionView addSubview:fansLab];
    self.fansLab =fansLab;
    
    //滑块
    UIView *sliderView = [UIView new];
    [UntilTools addCAGradientLayer:sliderView fromColor:[UIColor colorFromHexString:@"#FF7835"] toColor:[UIColor colorFromHexString:@"#F09246"]];
    sliderView.layer.cornerRadius = 2;
    sliderView.layer.masksToBounds = YES;
    [topView addSubview:sliderView];
    self.sliderView = sliderView;
    
    //分割线
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorFromHexString:@"#EEEEEE"];
    [topView addSubview:lineView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(47);
    }];
    [chatBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(3);
        make.width.mas_equalTo(54);
        make.height.mas_equalTo(47);
    }];
    [hostBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(54);
        make.width.mas_equalTo(54);
        make.height.mas_equalTo(47);
    }];
    [attentionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(47);
    }];
    [attentionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(9);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(18);
    }];
    [fansLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(28);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(12);
    }];
    [sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(36);
        make.left.mas_equalTo(27);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(4);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.64);
    }];
}

/// 聊天列表view
- (void)setChatView
{
    //聊天table
    UITableView *tableView = [UITableView new];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:tableView];
    self.chatTableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(47);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    //底部有新消息but
    UIButton *scrollBottomBut = [[UIButton alloc] init];
    [scrollBottomBut setTitleColor:[UIColor colorWithHexString:@"#F67C37"] forState:UIControlStateNormal];
    [scrollBottomBut setBackgroundColor:[UIColor whiteColor]];
    scrollBottomBut.titleLabel.font = [UIFont systemFontOfSize:12];
    [scrollBottomBut addTarget:self action:@selector(scrollBottomAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollBottomBut setTitle:@"底部有新消息" forState:UIControlStateNormal];
    [self addSubview:scrollBottomBut];
    [scrollBottomBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(113);
        make.height.mas_equalTo(33);
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(-5);
    }];
    [scrollBottomBut layoutIfNeeded];
    self.scrollBottomBut = scrollBottomBut;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_scrollBottomBut.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = scrollBottomBut.bounds;
    maskLayer.path = maskPath.CGPath;
    maskLayer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.14].CGColor;
    maskLayer.shadowOpacity = 1.0;
    maskLayer.shadowOffset = CGSizeMake(0, 0);
    maskLayer.shadowPath = maskPath.CGPath;
    maskLayer.fillColor = [UIColor whiteColor].CGColor;
    [scrollBottomBut.layer insertSublayer:maskLayer atIndex:0];

    [self addSubview:self.keyboardView];
    [self addSubview:self.streamerView];
}

/// 主播view
- (LiveStreamerView *)streamerView
{
    if (!_streamerView) {
        __weak __typeof(self)weakSelf = self;
        _streamerView = [[LiveStreamerView alloc] initWithFrame:CGRectMake(0, 47, kkScreenWidth, self.height - 47)];
        _streamerView.followBlock = ^{
//            __strong __typeof(weakSelf)strongSelf = weakSelf;
//            [strongSelf followUserEvent];
        };
        _streamerView.hidden = YES;
        [self addSubview:_streamerView];
    }
    return _streamerView;
}

- (NSDictionary *)emojiDic
{
    if (!_emojiDic) {
        _emojiDic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"[老实微笑]",@"2",@"[害羞]",@"3",@"[真香]",@"4",@"[脑壳痛]",@"5",@"[么么哒]",@"6",@"[哼哼]",@"7",@"[呵呵]",@"8",@"[喔耶]",@"9",@"[嘿嘿嘿]",@"10",@"[哭哭]",@"11",@"[心塞]",@"12",@"[好困]",@"13",@"[思考]",@"14",@"[我去]",@"15",@"[无语]",@"16",@"[开心]",@"17",@"[嘻嘻]",@"18",@"[得瑟]",@"19",@"[哈罗]",@"20",@"[生气]",@"21",@"[无聊]",@"22",@"[找事]",@"23",@"[惊呆了]",@"24",@"[暴怒]",@"25",@"[好冷]",@"26",@"[暴打]", nil];
    }
    return _emojiDic;
}

- (DKSKeyboardView *)keyboardView
{
    if (!_keyboardView) {
        //添加输入框
        self.keyboardView = [[DKSKeyboardView alloc] initWithFrame:CGRectMake(0, self.height - 52, self.width, 52)];
        //设置代理方法
        self.keyboardView.delegate = self;
    }

    return _keyboardView;
}

@end
