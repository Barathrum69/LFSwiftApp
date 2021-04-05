//
//  LiveRoomViewController.m
//  DragonLive
//
//  Created by 11号 on 2020/11/28.
//

#import "LiveRoomViewController.h"
#import "WalletController.h"
#import "JHRotatoUtil.h"
#import "SHXMPPManager.h"
#import "RoomClass.h"
#import "RoomInfo.h"
#import "LiveItem.h"
#import "EasyShowView.h"
#import "MineProxy.h"
#import "DKSKeyboardView.h"
#import "LiveChatCell.h"
#import "LiveChatSystemCell.h"
#import "RoomChat.h"
#import "LiveStreamerView.h"
#import "DRLivePlayer.h"
#import "ReportRoomViewController.h"
#import "LiveRoomViewModel.h"
#import "ZGAlertView.h"
#import "DRGiftChooseView.h"
#import "DRGiftAnimationView.h"
#import "DRSVGAnimationView.h"
#import "DRSmallDragView.h"
#import "UserTaskInstance.h"
#import "AFNetworkReachabilityManager.h"
#import "XMNShareView.h"
#import "ZXCTimer.h"
#import "DREmitterLayer.h"
#import "HostModel.h"

@interface LiveRoomViewController ()<DKSKeyboardDelegate,ChatRoomDelegate,LiveRoomViewModelDelegate,UIGestureRecognizerDelegate>
{
    dispatch_source_t _timer;
}
@property (nonatomic, weak) IBOutlet UIView *centerSuperView;               //中间superview
@property (nonatomic, weak) IBOutlet UITableView *chatTableView;            //聊天table
@property (nonatomic, weak) IBOutlet UIButton *hostBut;                     //主播but
@property (nonatomic, weak) IBOutlet UIView *followView;                    //关注view
@property (nonatomic, weak) IBOutlet UILabel *followTitleLab;               //关注标题
@property (nonatomic, weak) IBOutlet UILabel *followNumLab;                 //关注数量lab
@property (nonatomic, weak) IBOutlet UIView *sliderView;                    //滑块view
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *centerTop;         //centerSuperView距离顶部边距
@property (nonatomic, strong) UIButton *scrollBottomBut;                    //底部有新消息按钮

@property (nonatomic, strong) LiveStreamerView *streamerView;               //主播view
@property (nonatomic, strong) DRGiftChooseView *giftChooseView;             //礼物选择view
@property (atomic, strong) DRLivePlayer *drLivePlayer;                      //直播播放器
@property (nonatomic, strong) DKSKeyboardView *keyboardView;                //聊天输入

@property (nonatomic, strong) NSMutableArray *chatArr;                      //聊天消息集合
@property (nonatomic, strong) NSDictionary *emojiDic;                       //表情字典
@property (nonatomic, assign) NSInteger sliderStage;                        //0:聊天 1:主播
@property (nonatomic, assign) CGFloat livePlayerHeight;                     //播放器高度
@property (nonatomic, copy) NSString *disableSpeakId;                       //被禁言用户id
@property (nonatomic, assign) long long milliSecond;                        //赛事倒计时
@property (nonatomic, assign) BOOL isRecognizedChange;                      //用户手动滑动了聊天则停止系统的自动滑动
@property (nonatomic, assign) BOOL currentIsInBottom;                       //列表是滑动到最底部

@property (nonatomic, strong) LiveRoomViewModel *roomViewModel;             //直播间view model
@property (nonatomic, strong) RoomClass *roomClass;                         //xmpp 加入房间server
@property (nonatomic, strong) RoomGift *giftRewardModel;                    //记录打赏的某个礼物

@property (nonatomic, strong) XMNShareView *shareView;                      //分享View


@end

@implementation LiveRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"直播详情";
    
    _chatArr = [NSMutableArray array];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //seconds  设置响应时间
    lpgr.delegate = self;
    [_chatTableView addGestureRecognizer:lpgr]; //启用长按事件

    [UserInstance shareInstance].userModel.userRoomRole = @"2";
    [UserInstance shareInstance].userModel.isLeisuJinyan = NO;
    
    [self setupUI];
    
    [self joinXmppRoom];
    
    [self afnReachability];

    self.roomViewModel = [[LiveRoomViewModel alloc] initWithDelegate:self roomId:_liveItem.roomId];
    //赛事进入需要获取最新的时间差
    if (_matchItem) {
        [self.roomViewModel requestTimeInterval:_matchItem.startTime];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];   //监听键盘出现、消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
    name:UIApplicationWillResignActiveNotification object:nil]; //监听是否触发home键挂起程序，（把程序放在后台执行其他操作）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
    name:UIApplicationDidBecomeActiveNotification object:nil]; //监听是否重新进入程序程序.（回到程序)
    
    if (_timer) {
        dispatch_resume(_timer);
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (_timer) {
        dispatch_suspend(_timer);
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
//    //判断当前controller是否被pop
    NSUInteger isPop = [[self.navigationController viewControllers] indexOfObject:self];
    if (isPop == 0) {
        if ([UserInstance shareInstance].isSetSmallWindow && [_drLivePlayer isRenderFirstFrame]) {
            if (_matchItem) {
                [[DRSmallDragView smallDragViewManager] showWindowWithPlayer:_drLivePlayer.player hostModel:_matchItem];
            }
            else if (![_roomViewModel.roomInfoModel.living boolValue] && _roomViewModel.roomInfoModel.recordedUrl.length) {
                [[DRSmallDragView smallDragViewManager] showWindowWithVodPlayer:_drLivePlayer.vodPlayer liveItem:_liveItem];
            }
            else {
                [[DRSmallDragView smallDragViewManager] showWindowWithPlayer:_drLivePlayer.player liveItem:_liveItem];
            }
        }else {
            [self.drLivePlayer stopPlay];
        }
        [self.roomClass leaveRoom];
        [[SHXMPPManager xmppManager] disconnect];
        
        //保存直播观看超过5分钟任务上报
        if ([UserTaskInstance shareInstance].livePlayStatus == 1) {
            //调用完成任务接口
            if ([UserTaskInstance shareInstance].livePlayTime >= 300) {
                [MineProxy completeTaskWithTaskId:@"2" success:^(BOOL success) {
                    [UserTaskInstance shareInstance].livePlayStatus = 2;
                    [[NSUserDefaults standardUserDefaults] setInteger:[UserTaskInstance shareInstance].livePlayStatus forKey:kkLivePlayStatus];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                } failure:^(NSError * _Nonnull error) {
                }];
            }
            [[NSUserDefaults standardUserDefaults] setInteger:[UserTaskInstance shareInstance].livePlayTime forKey:kkLivePlayTimes];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    
    if (self.shareView) {
        [self.shareView dismissUseAnimated:NO];
        self.shareView = nil;
    }
    
    if ([JHRotatoUtil isOrientationLandscape]) {
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

//iOS8旋转动作的具体执行
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator: coordinator];
    // 监察者将执行： 1.旋转前的动作  2.旋转后的动作（completion）
    [coordinator animateAlongsideTransition: ^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         if ([JHRotatoUtil isOrientationLandscape]) {
             [self p_prepareFullScreen];
         }
         else {
             [self p_prepareSmallScreen];
         }
     } completion: ^(id<UIViewControllerTransitionCoordinatorContext> context) {
         
     }];
    
}

#pragma mark ====== Private方法 ======
/// 直播view布局及聊天输入框
- (void)setupUI
{
    CGFloat ratio = 16/9.0;         //封面图宽高比
    CGFloat liveViewHeight = kkScreenWidth / ratio;
    _livePlayerHeight = liveViewHeight;
    _centerTop.constant = kStatusBarHeight + liveViewHeight;
    
    //赛事直播间不显示主播板块和关注view
    if (self.matchItem) {
        self.hostBut.hidden = YES;
        self.followView.hidden = YES;
    }
    
    _drLivePlayer = [[DRLivePlayer alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kkScreenWidth, liveViewHeight) coverImageUrl:_liveItem.coverImg livePlayer:_livePlayer vodPlayer:_vodPlayer hostModel:self.matchItem];
    [self.view addSubview:_drLivePlayer];
    
    [_drLivePlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(kStatusBarHeight);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(liveViewHeight);
    }];
//    [_drLivePlayer layoutIfNeeded];
    __weak __typeof(self)weakSelf = self;
    _drLivePlayer.goBackBlock = ^{  //返回
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([JHRotatoUtil isOrientationLandscape]) {
            [JHRotatoUtil forceOrientation: UIInterfaceOrientationPortrait];
        }
        else {
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    _drLivePlayer.reportBlock = ^{  //举报房间
        //未登录跳转登录页
        if (![UserInstance shareInstance].isLogin) {
            [UntilTools pushLoginPage];
            return;;
        }
        
        if ([JHRotatoUtil isOrientationLandscape]) {
            [JHRotatoUtil forceOrientation: UIInterfaceOrientationPortrait];
        }
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        ReportRoomViewController *reportContro = [[ReportRoomViewController alloc] init];
        reportContro.streamerId = strongSelf.roomViewModel.roomInfoModel.hostId;
        [strongSelf.navigationController pushViewController:reportContro animated:YES];
    };
    void (^extractedExpr)(void) = ^{   //分享
        if ( weakSelf.shareView) {
            weakSelf.shareView = nil;
        }
        
        NSLog(@"%f",[UIScreen mainScreen].bounds.size.width);
        weakSelf.shareView = [[XMNShareView alloc]init];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [UntilTools pushSharePageSysparamCode:@"SHARE_LIVE_ROOM_URL" itemId:strongSelf.liveItem.roomId isTask:YES shareView:weakSelf.shareView success:^{
            
        }];
    };
    _drLivePlayer.shareBlock = extractedExpr;
    _drLivePlayer.chatBlock = ^{    //聊天
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.keyboardView.hidden = NO;
        [strongSelf.keyboardView.textView becomeFirstResponder];
    };
    _drLivePlayer.giftBlock = ^{    //礼物
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf showChooseView];
    };
    _drLivePlayer.fullBlock = ^{    //退出全屏
        if([JHRotatoUtil isOrientationLandscape]) {
            [JHRotatoUtil forceOrientation: UIInterfaceOrientationPortrait];
        }
        else {
            [JHRotatoUtil forceOrientation: UIInterfaceOrientationLandscapeRight];
        }
    };

    [self.view addSubview:self.keyboardView];
}

// 聊天室加入房间
- (void)joinXmppRoom
{
    UserModel *userModel = [UserInstance shareInstance].userModel;
    NSString *account = userModel.userName;
    NSString *nickName = userModel.nickname;
    NSString *psw = @"123456";                      //默认登录密码
    NSString *roomId;
    if (self.matchItem) {
        roomId = _matchItem.jumpUrl;
    }else {
        roomId = _liveItem.roomId;
    }
    
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

// 切换成全屏的准备工作
- (void)p_prepareFullScreen {
    
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [_drLivePlayer mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(kTopBarSafeHeight);
        make.right.equalTo(self.view).with.offset(-kTopBarSafeHeight);
    }];
    [self.view layoutIfNeeded];

    _centerSuperView.hidden = YES;
    _keyboardView.hidden = YES;

    [self hidenKeyboardAction];
    
    if (self.giftChooseView ) {
        [self.giftChooseView hiddenGiftView];
    }
}

// 切换成小屏的准备工作
- (void)p_prepareSmallScreen {
    
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    CGFloat playerbottom = kkScreenHeight - _livePlayerHeight - kStatusBarHeight;
    
    [_drLivePlayer mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(kStatusBarHeight);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(-playerbottom);
    }];
    [self.view layoutIfNeeded];
    
    _centerSuperView.hidden = NO;
    _keyboardView.hidden = NO;
    
    [self hidenKeyboardAction];
    
    if (self.giftChooseView ) {
        [self.giftChooseView hiddenGiftView];
    }
}

// 刷新关注状态
- (void)reloadFollowStatus
{
    NSInteger hostFollow = [_roomViewModel.roomInfoModel.hostFollow integerValue];              //是否已关注
//    NSInteger hostFansNum = [_roomViewModel.roomInfoModel.hostFansNum integerValue];            //关注数量
    
    CGFloat colorAlpha = hostFollow == 1 ? 0.5 : 1.0;
    self.followTitleLab.text = hostFollow == 1 ? @"已关注" : @"+关注";
    self.followView.backgroundColor = [[UIColor colorWithRed:246/255.0 green:124/255.0 blue:55/255.0 alpha:1.0] colorWithAlphaComponent:colorAlpha];
    self.followTitleLab.textColor = [[UIColor whiteColor] colorWithAlphaComponent:colorAlpha];
    self.followNumLab.textColor = [[UIColor whiteColor] colorWithAlphaComponent:colorAlpha];
    self.followNumLab.text = _roomViewModel.roomInfoModel.hostFansNum;
//    //数量超过1万显示单位：万
//    if (hostFansNum > 10000) {
//        if (hostFansNum % 10000 == 0) {
//            self.followNumLab.text = [NSString stringWithFormat:@"%ld万",hostFansNum / 10000];
//        }else {
//            self.followNumLab.text = [NSString stringWithFormat:@"%0.1f万",hostFansNum / 10000.0];
//        }
//
//    }else {
//        self.followNumLab.text = [NSString stringWithFormat:@"%ld",hostFansNum];
//    }
}

//让聊天室信息自动滚动到底部
- (void)setScrollPositionBottom
{
    if (!self.isRecognizedChange) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.chatArr.count-1 inSection:0];
        [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }else {
        if (_chatArr.count > 10 && _sliderStage == 0) {      //超过一屏才出现
            self.scrollBottomBut.hidden = NO;
        }
    }
}

//礼物选择view
- (void)showChooseView
{
    __weak __typeof(self)weakSelf = self;
    self.giftChooseView = [DRGiftChooseView showGiftViewInWindow:self.roomViewModel.giftArray changeItem:^(RoomGift * _Nonnull giftModel) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([UserInstance shareInstance].isLogin) {
            strongSelf.giftRewardModel = giftModel;
            NSString *liveId = @"";
            if (strongSelf.liveItem) {
                liveId = strongSelf.roomViewModel.roomInfoModel.liveId;
            }
            [strongSelf.roomViewModel requestGiftReward:giftModel.propId giftNum:giftModel.giftNum liveId:liveId];
        }else {
            [UntilTools pushLoginPage];
        }
    }];
    self.giftChooseView.loadMoneyBlock = ^{
        if ([[UserInstance shareInstance] isLogin]) {
            if ([JHRotatoUtil isOrientationLandscape]) {
                [JHRotatoUtil forceOrientation:UIInterfaceOrientationPortrait];
            }
            WalletController *vc = [WalletController new];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else {
            [UntilTools pushLoginPage];
        }
        
    };
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

//关注/取关
- (void)followUserEvent
{
    if ([UserInstance shareInstance].isLogin) {
        
        if ([self.roomViewModel.roomInfoModel.hostFollow integerValue] == 1) {
            ZGAlertView *alertView = [[ZGAlertView alloc] initWithTitle:@"确定取消关注？"
                                                   message:nil
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"确定", nil];
            [alertView show];
            
            __weak __typeof(self)weakSelf = self;
            alertView.dismissBlock = ^(NSInteger clickIndex) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                
                if (clickIndex == 1) {
                    [strongSelf.roomViewModel requestAttentionUser];
                }
            };
        }else {
            [self.roomViewModel requestAttentionUser];
        }
    }else {
        [UntilTools pushLoginPageSuccess:^{
            [self.roomViewModel requestRoomInfo:self.liveItem.roomId];
        }];
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
        CAEmitterLayer *snowLayer = [DREmitterLayer snowEmitterLayer:self.view.bounds];
        [self.view.layer addSublayer:snowLayer];
        [[ZXCTimer shareInstance] addTimerTask:^{
            [snowLayer removeFromSuperlayer];
            
        } after:10 threadMode:ZXCMainThread];
        
    }else if ([chatModel.userChat isEqualToString:@"#新年快乐"] && [UserTaskInstance shareInstance].fireCount<2) {
        [UserTaskInstance shareInstance].fireCount++;
        CAEmitterLayer *snowLayer = [DREmitterLayer fireworkdEmitterLayer:self.view.bounds];
        [self.view.layer addSublayer:snowLayer];
        [[ZXCTimer shareInstance] addTimerTask:^{
            [snowLayer removeFromSuperlayer];
            
        } after:10 threadMode:ZXCMainThread];
    }
}

//获取用户在直播间的角色
- (void)getUserRoleWithRoom
{
    [UserInstance shareInstance].userModel.userRoomRole = @"2";
    if (_roomViewModel.roomInfoModel.manageList.count) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF == %ld",(long)[[UserInstance shareInstance].userModel.userId integerValue]];
        NSArray *roleArr = [_roomViewModel.roomInfoModel.manageList filteredArrayUsingPredicate:pred];
        if (roleArr && roleArr.count) {
            [UserInstance shareInstance].userModel.userRoomRole = @"1";
        }
    }
}

//房间实时热度获取
-(void)startTimer:(NSString *)liveId{

    if (!liveId || liveId.length == 0) {
        return;
    }
    NSTimeInterval period = 1.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        __weak __typeof(self)weakSelf = self;
        [HttpRequest requestWithURLType:UrlTypeLiveHotQuery parameters:[NSDictionary dictionaryWithObject:liveId forKey:@"liveId"] type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf.roomViewModel.roomInfoModel) {
                strongSelf.roomViewModel.roomInfoModel.hot = [responseObject[@"data"] stringValue];
                [strongSelf.drLivePlayer setRoomInfo:strongSelf.roomViewModel.roomInfoModel];
            }
        } failure:^(NSError * _Nonnull error) {
        }];
        
    });

    dispatch_resume(_timer);
}

//赛事倒计时
-(void)startMatchTimer{

    NSTimeInterval period = 1.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if (self.milliSecond <= 0) {
            dispatch_source_cancel(self->_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.drLivePlayer startPlay:self.matchItem.url isLiving:YES];
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.milliSecond--;
                [self.drLivePlayer setCountDownTimer:[self countDownTimerStr]];
            });
        }
    });

    dispatch_resume(_timer);
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

//赛事倒计时时间
- (NSString *)countDownTimerStr
{
    NSString *countDownStr = @"";
    long long miseconds = self.milliSecond;
    long long minute = miseconds/60;
    long long hours = miseconds/3600;
    long long day = miseconds/3600/24;
    countDownStr = [NSString stringWithFormat:@"距离赛事开始还有%lld天%lld小时%lld分%lld秒",day,hours%24,minute%60,miseconds%60];
    
    return countDownStr;
}

#pragma mark ====== IBAction ======
//聊天
- (IBAction)chatRoomAction:(id)sender
{
    self.sliderStage = 0;
    
    UIButton *but = (UIButton *)sender;
    [UIView animateWithDuration:0.2 animations:^{
        self.sliderView.center = CGPointMake(but.center.x, self.sliderView.center.y);
    }];
    
    self.streamerView.hidden = YES;
    self.keyboardView.hidden = NO;
}

//主播
- (IBAction)streamerAction:(id)sender
{
    self.sliderStage = 1;
    
    UIButton *but = (UIButton *)sender;
    [UIView animateWithDuration:0.2 animations:^{
        self.sliderView.center = CGPointMake(but.center.x, self.sliderView.center.y);
    }];
    
    self.scrollBottomBut.hidden = YES;
    self.streamerView.hidden = NO;
    self.keyboardView.hidden = YES;
}

//底部有新消息按钮
- (void)scrollBottomAction
{
    self.isRecognizedChange = NO;
    self.scrollBottomBut.hidden = YES;
    [self setScrollPositionBottom];
}

//隐藏键盘
- (void)hidenKeyboardAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"keyboardHide" object:nil];
    
    if([JHRotatoUtil isOrientationLandscape]) {
        self.keyboardView.y = kkScreenHeight;
    }
}

//关注数量
- (IBAction)followAction:(id)sender
{
    [self followUserEvent];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer  //长按响应函数
{
    //避免响应多次
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    //主播或房管禁言操作
    if ([[UserInstance shareInstance].userModel.userRoomRole integerValue] == 1 && self.liveItem) {
        
        CGPoint p = [gestureRecognizer locationInView:self.chatTableView];
        NSIndexPath *indexPath = [self.chatTableView indexPathForRowAtPoint:p];
        RoomChat *chatModel = [self.chatArr objectAtIndex:indexPath.row];
        
        //不能禁言自己，不能禁言主播或者房管
        if ([chatModel.userId integerValue] == [[UserInstance shareInstance].userModel.userId integerValue] || [chatModel.userRole integerValue] == 1) {
            return;
        }
        
        ZGAlertView *alertView = [[ZGAlertView alloc] initWithTitle:@"屏蔽用户发言？"
                                               message:nil
                                     cancelButtonTitle:@"取消"
                                     otherButtonTitles:@"屏蔽", nil];
        [alertView show];
        
        __weak __typeof(self)weakSelf = self;
        alertView.dismissBlock = ^(NSInteger clickIndex) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            if (clickIndex == 1) {
                if (indexPath.row < strongSelf.chatArr.count) {
                    RoomChat *chatModel = [strongSelf.chatArr objectAtIndex:indexPath.row];
                    strongSelf.disableSpeakId = chatModel.userId;
                    [strongSelf.roomViewModel requestUserDisableSpeak:chatModel.userId];
                }
            }
        };
        
    }
}

#pragma mark ====== LiveRoomViewModel网络请求代理事件 ======
- (void)requestRoomInfoFinish:(nullable NSError *)error
{
    if (!error) {
        
        [UserInstance shareInstance].userModel.isLeisuJinyan = [_roomViewModel.roomInfoModel.chatHideStatus boolValue];
        
        [self startTimer:_roomViewModel.roomInfoModel.liveId];
        
        [_drLivePlayer setRoomInfo:_roomViewModel.roomInfoModel];
        
        BOOL isLiving = YES;
//        _roomViewModel.roomInfoModel.living = @"0";
//        _roomViewModel.roomInfoModel.recordedUrl = @"https://liveuploadtest1.oss-cn-shenzhen.aliyuncs.com/c6d9de92-2b72-4e5c-bd86-699b6fddf642.mp4";
        if (![_roomViewModel.roomInfoModel.living boolValue] && _roomViewModel.roomInfoModel.recordedUrl.length) {
            isLiving = NO;
        }
        if (isLiving) {
            [_drLivePlayer startPlay:_roomViewModel.roomInfoModel.pullUrl isLiving:isLiving];
        }else {
            [_drLivePlayer startPlay:_roomViewModel.roomInfoModel.recordedUrl isLiving:isLiving];
        }

        [self.streamerView setRoomInfo:_roomViewModel.roomInfoModel];
        
        [self reloadFollowStatus];
        
        [self getUserRoleWithRoom];
    }
}

- (void)requestSystemNoticeFinish:(nullable NSError *)error
{
    if (_roomViewModel.systemNotice && _roomViewModel.systemNotice.length) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_roomViewModel.systemNotice,@"userChat",@"系统消息",@"userName", nil];
        [self insertChatMessage:dic] ;
    }
}

- (void)requestLiveGiftFinish:(nullable NSError *)error
{
}

- (void)requestLiveGiftRewardFinish:(nullable NSError *)error
{
    if (!error) {
        
        //打赏礼物接口回掉成功则广播礼物消息体
        XMPPMessage *message = [XMPPMessage message];
        NSXMLElement *userId = [NSXMLElement elementWithName:@"id" stringValue:[UserInstance shareInstance].userModel.userId];
        [message addChild:userId];
        NSXMLElement *giftid = [NSXMLElement elementWithName:@"giftid" stringValue:_giftRewardModel.propId];
        [message addChild:giftid];
        NSXMLElement *userName = [NSXMLElement elementWithName:@"name" stringValue:[UserInstance shareInstance].userModel.nickname];
        [message addChild:userName];
        NSXMLElement *giftNum = [NSXMLElement elementWithName:@"num" stringValue:_giftRewardModel.giftNum];
        [message addChild:giftNum];
        NSXMLElement *body = [NSXMLElement elementWithName:@"body" stringValue:@"gift"];
        [message addChild:body];
        
        [self.roomClass.m_xmppRoom sendMessage:message];
        
        //打赏礼物成功则更新用户龙币
        [MineProxy getAccountCoinsSuccess:^(BOOL isSuccess) {
        } failure:^(NSError * _Nonnull error) {
        }];
        
//        //打赏礼物成功任务上报
//        if ([UserTaskInstance shareInstance].giftStatus == 1) {
//            [MineProxy completeTaskWithTaskId:@"4" success:^(BOOL success) {
//                [UserTaskInstance shareInstance].giftStatus = 2;
//            } failure:^(NSError * _Nonnull error) {
//            }];
//        }
        
    }else if (error.code == 9101){
        [EasyTextView showText:@"龙币余额不足,请充值"];
    }else if (error.code == 9214){
        [EasyTextView showText:@"账号被冻结，请联系客服"];
    }else if (error.code == 2004){
        [EasyTextView showText:@"账号被禁用，请联系客服"];
    }
    else {
        [EasyTextView showText:@"打赏失败"];
    }
}

- (void)requestForbiduserStatusFinish:(nullable NSError *)error
{

}

- (void)requestAttentionUserFinish:(nullable NSError *)error
{
    if (error) {
        if ([_roomViewModel.roomInfoModel.hostFollow integerValue] == 1) {
            [EasyTextView showText:@"取消关注失败"];
        }else {
            if ([error.domain isEqualToString:@"can't follow/take off oneself"]) {
                [EasyTextView showText:@"主播不能关注自己"];
            }else {
                [EasyTextView showText:@"关注主播失败"];
            }
        }
    }else {
        if ([_roomViewModel.roomInfoModel.hostFollow integerValue] == 1) {
            [EasyTextView showText:@"已关注该主播"];
        }else {
            [EasyTextView showText:@"已取消关注"];
        }
        
        [self.streamerView setRoomInfo:_roomViewModel.roomInfoModel];
        
        [self reloadFollowStatus];
    }
}

- (void)requestUserDisableSpeakFinish:(nullable NSError *)error
{
    if (!error) {
        [EasyTextView showText:@"屏蔽成功"];
        
        XMPPMessage *message = [XMPPMessage message];
        NSXMLElement *jinyan = [NSXMLElement elementWithName:@"jinyan" stringValue:_disableSpeakId];
        [message addChild:jinyan];
        NSXMLElement *body = [NSXMLElement elementWithName:@"body" stringValue:@"禁言用户"];
        [message addChild:body];
        
        [self.roomClass.m_xmppRoom sendMessage:message];
    }else {
        [EasyTextView showText:@"屏蔽失败"];
    }
}

- (void)requestTimeIntervalFinish:(nullable NSError *)error
{
    //已开赛的直接去拉流
    if ([_matchItem.status integerValue] == 1) {
        [_drLivePlayer startPlay:self.matchItem.url isLiving:YES];
        return;
    }
    if (!error) {
        self.milliSecond = - ([self.roomViewModel.systemTimeInterval longLongValue]/1000);      //秒
        if (self.milliSecond > 0) {
            [self startMatchTimer];
        }
    }
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
            cell =  [[NSBundle mainBundle]loadNibNamed:@"LiveChatSystemCell" owner:self options:nil].firstObject;
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
        CGPoint point =  [scrollView.panGestureRecognizer translationInView:self.view];
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
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"光临直播间",@"userChat",[UserInstance shareInstance].userModel.nickname,@"userName", nil];
//    [self insertChatMessage:dic];
    
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
    if (userId) {
        NSString *nickName = [[message elementForName:@"name"] stringValue];
        //收到jinyan消息’thirdmsg‘，表示禁止雷速聊天内容显示
        if ([userId isEqualToString:@"thirdmsg"]) {
            [UserInstance shareInstance].userModel.isLeisuJinyan = YES;
        }
        //userid禁言
        else if ([userId isEqualToString:[UserInstance shareInstance].userModel.userId]) {
            [UserInstance shareInstance].disableUserMessage = YES;
        }
        //nickname禁言
        else if ([nickName isEqualToString:[UserInstance shareInstance].userModel.nickname]) {
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
            [self.drLivePlayer hostLivingLost];
        }
    }
    
    //普通消息
    NSString *body = message.body;
    NSString *uId = [[message elementForName:@"id"] stringValue];
    NSString *name = [[message elementForName:@"name"] stringValue];
    NSString *level = [[message elementForName:@"level"] stringValue];
    NSString *role = [[message elementForName:@"role"] stringValue];
    NSString *leisu = [[message elementForName:@"leisu"] stringValue];
    
    //主播或房管禁用雷速聊天消息后则不显示
    if ([leisu integerValue] == 2 && [UserInstance shareInstance].userModel.isLeisuJinyan && [[UserInstance shareInstance].userModel.userRoomRole integerValue] == 1) {
        return;
    }
    
    //过滤换行符和空格
    body = [body stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    body = [body stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    body = [body stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:body,@"userChat",name,@"userName",level,@"userLevel",uId,@"userId",role,@"userRole",leisu,@"leisu", nil];
    [self insertChatMessage:dic];
    
    //弹幕开关打开且全屏才可以显示弹幕
    if ([UserInstance shareInstance].isSetBarrageOpen && [JHRotatoUtil isOrientationLandscape] && ![body isEqualToString:@"光临直播间"]) {
        [_drLivePlayer addBarrageWithChat:body leisu:leisu];
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

//keyboard的frame改变
- (void)keyboardChangeFrameWithMinY:(CGFloat)minY {
//    NSLog(@"minY:%f",minY);
}

#pragma mark ====== 键盘将要出现 ======
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

#pragma mark ====== 懒加载 ======
- (LiveStreamerView *)streamerView
{
    if (!_streamerView) {
        __weak __typeof(self)weakSelf = self;
        _streamerView = [[LiveStreamerView alloc] initWithFrame:CGRectMake(0, 47, kkScreenWidth, CGRectGetHeight(_centerSuperView.frame) - 47)];
        _streamerView.followBlock = ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf followUserEvent];
        };
        _streamerView.hidden = YES;
        [_centerSuperView addSubview:_streamerView];
    }
    return _streamerView;
}

- (DKSKeyboardView *)keyboardView
{
    if (!_keyboardView) {
        //添加输入框
        self.keyboardView = [[DKSKeyboardView alloc] initWithFrame:CGRectMake(0, kkScreenHeight - kBottomSafeHeight - 52, kkScreenWidth, 52)];
        //设置代理方法
        self.keyboardView.delegate = self;
    }

    return _keyboardView;
}

- (UIButton *)scrollBottomBut
{
    if (!_scrollBottomBut) {
        _scrollBottomBut = [[UIButton alloc] init];
        [_scrollBottomBut setTitleColor:[UIColor colorWithHexString:@"#F67C37"] forState:UIControlStateNormal];
        [_scrollBottomBut setBackgroundColor:[UIColor whiteColor]];
        _scrollBottomBut.titleLabel.font = [UIFont systemFontOfSize:12];
        [_scrollBottomBut addTarget:self action:@selector(scrollBottomAction) forControlEvents:UIControlEventTouchUpInside];
        [_scrollBottomBut setTitle:@"底部有新消息" forState:UIControlStateNormal];
        [self.centerSuperView addSubview:_scrollBottomBut];
        [_scrollBottomBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(113);
            make.height.mas_equalTo(33);
            make.centerX.mas_equalTo(self.centerSuperView);
            make.bottom.mas_equalTo(-57);
        }];
        [self.centerSuperView layoutIfNeeded];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_scrollBottomBut.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(4, 4)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = _scrollBottomBut.bounds;
        maskLayer.path = maskPath.CGPath;
        maskLayer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.14].CGColor;
        maskLayer.shadowOpacity = 1.0;
        maskLayer.shadowOffset = CGSizeMake(0, 0);
        maskLayer.shadowPath = maskPath.CGPath;
        maskLayer.fillColor = [UIColor whiteColor].CGColor;
        [_scrollBottomBut.layer insertSublayer:maskLayer atIndex:0];
    }
    
    return _scrollBottomBut;
}

- (NSDictionary *)emojiDic
{
    if (!_emojiDic) {
        _emojiDic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"[老实微笑]",@"2",@"[害羞]",@"3",@"[真香]",@"4",@"[脑壳痛]",@"5",@"[么么哒]",@"6",@"[哼哼]",@"7",@"[呵呵]",@"8",@"[喔耶]",@"9",@"[嘿嘿嘿]",@"10",@"[哭哭]",@"11",@"[心塞]",@"12",@"[好困]",@"13",@"[思考]",@"14",@"[我去]",@"15",@"[无语]",@"16",@"[开心]",@"17",@"[嘻嘻]",@"18",@"[得瑟]",@"19",@"[哈罗]",@"20",@"[生气]",@"21",@"[无聊]",@"22",@"[找事]",@"23",@"[惊呆了]",@"24",@"[暴怒]",@"25",@"[好冷]",@"26",@"[暴打]",@"101",@"[爱你唷]",@"102",@"[开心]",@"103",@"[666]",@"104",@"[宝宝]",@"105",@"[有点慌]",@"106",@"[难受]",@"107",@"[财迷]",@"108",@"[美女]",@"109",@"[吃瓜]",@"110",@"[打]",@"111",@"[真的吗]",@"112",@"[有毒]",@"113",@"[加油]",@"114",@"[鬼脸]",@"115",@"[发狂]",@"116",@"[吃惊]",@"117",@"[足球]",@"118",@"[篮球]",@"119",@"[大哭]",@"120",@"[走起]",@"121",@"[犯规]",@"122",@"[社会人]",@"123",@"[心碎]",@"124",@"[住嘴]",@"125",@"[真香",@"126",@"[疑惑]",@"127",@"[害羞]",@"128",@"[skr]",@"129",@"[阵亡]",@"130",@"[欠揍]",@"131",@"[打扰了]",@"132",@"[潜水]",@"133",@"[垃圾球]",@"134",@"[上车]",@"135",@"[搬砖]", nil];
    }
    return _emojiDic;
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    if (![UserInstance shareInstance].isSetBackgroundPlay) {
        [_drLivePlayer pause];
    }
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    if (![UserInstance shareInstance].isSetBackgroundPlay) {
        [_drLivePlayer resume];
    }
}

- (void)afnReachability{
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                //网络状态变化且xmpp服务断开连接了则重新连接加入房间
                if (![SHXMPPManager xmppManager].xmppStream.isConnected) {
                    if (self.roomClass) {
                        [self.roomClass leaveRoom];
                        self.roomClass = nil;
                    }
                    [self joinXmppRoom];
                }
                [self.drLivePlayer networkConnectCheck];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"移动蜂窝");
                //网络状态变化且xmpp服务断开连接了则重新连接加入房间
                if (![SHXMPPManager xmppManager].xmppStream.isConnected) {
                    if (self.roomClass) {
                        [self.roomClass leaveRoom];
                        self.roomClass = nil;
                    }
                    [self joinXmppRoom];
                }
                [self.drLivePlayer networkConnectCheck];
                break;
            default:
                [self.drLivePlayer networkDisconnect];
                break;
        }
    }];
    [manager startMonitoring];
}

@end
