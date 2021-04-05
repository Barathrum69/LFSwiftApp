//
//  DRLivePlayer.m
//  DragonLive
//
//  Created by 11号 on 2020/12/9.
//

#import "DRLivePlayer.h"
#import "TXLivePlayer.h"
#import "TXVodPlayer.h"
#import "OCBarrage.h"
#import "OCBarrageGradientBackgroundColorCell.h"
#import "RoomInfo.h"
#import "TypeMenu.h"
#import "EasyTextView.h"
#import <UIImageView+WebCache.h>
#import "UIView+drag.h"
#import "UserTaskInstance.h"
#import "MineProxy.h"
#import "LiveLoadingView.h"
#import "DRVodProgressView.h"
#import "HostModel.h"

#define screenW  [UIScreen mainScreen].bounds.size.width
#define screenH  [UIScreen mainScreen].bounds.size.height

@interface DRLivePlayer ()<TXLivePlayListener,TXVodPlayListener,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *contentView;                  //底层view(弹幕)
@property (nonatomic, strong) UIImageView *coverImgView;            //直播封面图
@property (nonatomic, strong) UIView *topView;                      //顶部工具栏
@property (nonatomic, strong) UIView *bottomView;                   //底部工具栏
@property (nonatomic, strong) UIView *chatView;                     //聊天输入框
@property (nonatomic, strong) UIButton *backBut;                    //返回按钮
@property (nonatomic, strong) UILabel *roomNameLab;                 //直播间名称
@property (nonatomic, strong) UILabel *contentLab;                  //热度和房间号
@property (nonatomic, strong) UIButton *playBut;                    //播放/暂停
@property (nonatomic, strong) UIButton *barrageBut;                 //弹幕
@property (nonatomic, strong) UIButton *giftBut;                    //礼物按钮
@property (nonatomic, strong) UIButton *fullBut;                    //全屏
@property (nonatomic, strong) UIButton *openScreenBut;              //打开画面按钮
@property (nonatomic, strong) UIButton *resetPlayBut;               //重播按钮
@property (nonatomic, strong) UILabel *countdownLab;                //赛事开始倒计时提醒

@property (nonatomic, strong) TypeMenu *typeMenu;                   //右上角菜单
@property (nonatomic, strong) LiveLoadingView *loadingView;         //加载动画
@property (nonatomic, strong) DRVodProgressView *vodProgressView;   //播放进度条view
@property (nonatomic, strong) OCBarrageManager *barrageManager;     //弹幕管理
@property (nonatomic, strong) HostModel *hostModel;                 //赛事数据模型
@property (nonatomic, copy) NSString *videoPullUrl;                 //视频拉流地址

@property (nonatomic, assign) BOOL isShowToolbar;                   //是否显示上下的工具栏
@property (nonatomic, assign) BOOL isOrientationLandscape;          //是否全屏
@property (nonatomic, assign) BOOL isAudio;                         //是否音频播放
@property (nonatomic, assign) BOOL isVodPlayer;                     //是否录播播放

@end

@implementation DRLivePlayer

- (id)initWithFrame:(CGRect)frame coverImageUrl:(NSString *)imgUrlStr livePlayer:(TXLivePlayer *)player vodPlayer:(TXVodPlayer *)vodPlayer hostModel:(HostModel *)hostModel
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        self.isShowToolbar = YES;
        self.hostModel = hostModel;
        
        _vodPlayer = vodPlayer;
        _player = player;
        
//        if (isVodPlayer) {
//            //点播播放器
//            self.isVodPlayer = YES;
//            if (vodPlayer) {
//                _vodPlayer = vodPlayer;
//            }else {
//                _vodPlayer = [TXVodPlayer new];
//                [_vodPlayer setIsAutoPlay:YES];
//                _vodPlayer.vodDelegate = self;
//            }
//        }else {
//            //直播播放器
//            if (player) {
//                _player = player;
//            }else {
//                _player = [[TXLivePlayer alloc] init];
//                TXLivePlayConfig* config = _player.config;
//                config.bAutoAdjustCacheTime = YES;
//                config.minAutoAdjustCacheTime = 1.0;
//                config.maxAutoAdjustCacheTime = 5.0;
//                config.enableMessage = YES;
//                [_player setConfig:config];
//            }
//        }
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
        
        [self setupUI:imgUrlStr];
        
        [self creatTopView];
        
        [self creatBottomView];
    }
    return self;
}

- (void)setupUI:(NSString *)imgUrl
{
    //创建封面
    UIImageView *coverImgView = [[UIImageView alloc] init];
    UIImage *coverImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:imgUrl];
    if (coverImage) {
        //高斯模糊背景
        coverImage = [coverImage sd_blurredImageWithRadius:30];        //默认模糊度为10，最低0，最高100。
        coverImgView.image = coverImage;
    }else {
        [coverImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                UIImage *newImage = [coverImage sd_blurredImageWithRadius:30];
                coverImgView.image = newImage;
            }
        }];
    }
    [self addSubview:coverImgView];
    self.coverImgView = coverImgView;
    [coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //底部弹幕contentView
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    self.contentView = contentView;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(0);
        make.left.equalTo(self).with.offset(0);
        make.bottom.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(0);
    }];
    
    //loading 动画
    LiveLoadingView * spotView = [LiveLoadingView lvLoadingInstance];
    [self addSubview:spotView];
    [spotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [spotView setLoadingType:LRAnimationLoadingType];
    self.loadingView = spotView;
    
    if (_player || _vodPlayer) {
        self.loadingView.hidden = YES;
    }
    
//
//    if (self.isVodPlayer) {
//        //重播按钮
//        UIButton *resetPlayBut = [[UIButton alloc] init];
//        [resetPlayBut setBackgroundImage:[UIImage imageNamed:@"PlayEndView"] forState:UIControlStateNormal];
//        [resetPlayBut addTarget:self action:@selector(resetPlayAction) forControlEvents:UIControlEventTouchUpInside];
//        resetPlayBut.hidden = YES;
//        self.resetPlayBut = resetPlayBut;
//        [self addSubview:resetPlayBut];
//        [resetPlayBut mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(0);
//            make.centerY.mas_equalTo(0);
//            make.width.mas_equalTo(64);
//            make.height.mas_equalTo(30);
//        }];
//    }else {
        //打开画面按钮
        UIButton *openBut = [[UIButton alloc] init];
        openBut.backgroundColor = [[UIColor colorWithHexString:@"#151515"] colorWithAlphaComponent:0.8];
        openBut.layer.cornerRadius = 18.0;
        openBut.layer.masksToBounds = YES;
        openBut.borderWidth = 1.0;
        openBut.borderColor = [UIColor whiteColor];
        [openBut setTitle:@"打开画面" forState:UIControlStateNormal];
        openBut.titleLabel.font = [UIFont systemFontOfSize:13];
        [openBut addTarget:self action:@selector(openScreenAction) forControlEvents:UIControlEventTouchUpInside];
        openBut.hidden = YES;
        self.openScreenBut = openBut;
        [self addSubview:openBut];
        [openBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(103);
            make.height.mas_equalTo(36);
        }];
//    }
}

- (OCBarrageManager *)barrageManager
{
    if (!_barrageManager) {
        //弹幕
        self.barrageManager = [[OCBarrageManager alloc] init];
        //弹幕在封面图下面
        [self.contentView addSubview:self.barrageManager.renderView];
        
        CGFloat barrageTop = 0;
        CGFloat barrageH = kkScreenWidth;
        if ([UserInstance shareInstance].barrageFontPosition == 0) {
            barrageH = barrageH * 0.5;
            barrageTop = 0;
        }else if ([UserInstance shareInstance].barrageFontPosition == 1) {
            barrageTop = 0;
        }else if ([UserInstance shareInstance].barrageFontPosition == 2) {
            barrageH = barrageH * 0.5;
            barrageTop = barrageH;
        }
        
        [self.barrageManager.renderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(barrageTop);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(barrageH);
        }];
    }
    
    return _barrageManager;
}

- (TypeMenu *)typeMenu{
    
    if (!_typeMenu) {
        NSArray *dataArray = [[NSArray alloc]initWithObjects:
           [NSDictionary dictionaryWithObjectsAndKeys:@"仅音频播放",@"title",@"player_audio",@"img", nil],
           [NSDictionary dictionaryWithObjectsAndKeys:@"举报此房间",@"title",@"player_report",@"img", nil],nil];
        CGFloat topSapce = self.isOrientationLandscape ? 45 : (35+kStatusBarHeight);                                       //全屏时顶部间距
        CGFloat trailing = (self.isOrientationLandscape && kIs_iPhoneX) ? kTopBarSafeHeight : 0;        //iphonex全屏右边安全区域
        CGRect menuRect = CGRectMake(kkScreenWidth - 85 - 10 - trailing, topSapce, 85, 70);
        _typeMenu = [TypeMenu createMenuWithFrame:menuRect dataArray:dataArray];
        
        __weak __typeof(self)weakSelf = self;
        _typeMenu.selectRowBlcok = ^(NSString * _Nonnull title, NSInteger index) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (index == 0) {
                strongSelf.isAudio = !strongSelf.isAudio;
                if (strongSelf.isAudio) {
                    strongSelf.openScreenBut.hidden = NO;
                    strongSelf.coverImgView.hidden = NO;
                    strongSelf.coverImgView.image = [UIImage imageNamed:@"player_audioBg"];
                }else {
                    strongSelf.openScreenBut.hidden = YES;
                    strongSelf.coverImgView.hidden = YES;
                }
            }
            else if (index == 1) {
                if (strongSelf.reportBlock) {
                    strongSelf.reportBlock();
                }
            }
        };
    }
    return _typeMenu;
}

- (BOOL)isOrientationLandscape
{
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return YES;
    }
    return NO;
}

//横屏时显示聊天输入框、弹幕、礼物按钮，竖屏则隐藏
- (void)layoutSubviews
{
    self.chatView.hidden = !self.isOrientationLandscape;
    self.barrageBut.hidden = !self.isOrientationLandscape;
    self.giftBut.hidden = !self.isOrientationLandscape;
    self.vodProgressView.hidden = self.isOrientationLandscape;
    
    //横屏时iphoneX底部bottomView增加14像素高度
    CGFloat bottomAddH = self.isOrientationLandscape ? (kIs_iPhoneX ? 14.0 : 0) : 0;
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44 + bottomAddH);
    }];
    
    if (_typeMenu) {
        [_typeMenu hiddenMenu];
        _typeMenu = nil;
    }
    
    //横屏且弹幕开关打开时才显示弹幕
    if (self.isOrientationLandscape && [UserInstance shareInstance].isSetBarrageOpen) {
        [self.barrageManager start];
    }else {
        [self.barrageManager stop];
    }
}

/// 顶部工具栏
- (void)creatTopView
{
    UIView *topView = [[UIView alloc] init];
    [self addSubview:topView];
    self.topView = topView;
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(0);
        make.left.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(0);
        make.height.mas_equalTo(44);
        
    }];
    
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.image = [UIImage imageNamed:@"player_topBg"];
    [topView addSubview:bgImgView];
    [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 下、右不需要写负号，insets方法中已经为我们做了取反的操作了。
        make.edges.equalTo(topView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UIButton *backBut = [[UIButton alloc] init];
    [backBut setImage:[UIImage imageNamed:@"back_full"] forState:UIControlStateNormal];
    [backBut addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBut];
    [backBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView).with.offset(0);
        make.left.equalTo(topView).with.offset(0);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(44);
    }];
    
    UILabel *roomNameLabel = [[UILabel alloc] init];
    roomNameLabel.font = [UIFont boldSystemFontOfSize:15.0];
    roomNameLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    [topView addSubview:roomNameLabel];
    self.roomNameLab = roomNameLabel;
    
    //赛事直播间直接显示赛事信息
    if (self.hostModel) {
        roomNameLabel.text = [NSString stringWithFormat:@"%@ vs %@",self.hostModel.teamA,self.hostModel.teamB];
        [roomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView).with.offset(13);
            make.left.equalTo(topView).with.offset(36);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(18);
        }];
        
        //开赛倒计时
        UILabel *countdownLab = [[UILabel alloc] init];
        countdownLab.backgroundColor = [UIColor redColor];
        countdownLab.font = [UIFont boldSystemFontOfSize:14.0];
        countdownLab.textColor = [UIColor whiteColor];
        countdownLab.textAlignment = NSTextAlignmentCenter;
        countdownLab.hidden = YES;
        [self addSubview:countdownLab];
        self.countdownLab = countdownLab;
        [countdownLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(36);
            make.centerY.mas_equalTo(0);
        }];
    }else {
        
        [roomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView).with.offset(5);
            make.left.equalTo(topView).with.offset(36);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(18);
        }];
        
        UIImageView *hotImgView = [[UIImageView alloc] init];
        hotImgView.image = [UIImage imageNamed:@"player_hot"];
        [topView addSubview:hotImgView];
        [hotImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView).with.offset(29);
            make.left.equalTo(topView).with.offset(34);
            make.width.mas_equalTo(11);
            make.height.mas_equalTo(11);
        }];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = [UIFont boldSystemFontOfSize:10.0];
        contentLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        [topView addSubview:contentLabel];
        self.contentLab = contentLabel;
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView).with.offset(29);
            make.left.equalTo(topView).with.offset(46);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(11);
        }];
        
        //音频和举报房间菜单按钮
        UIButton *moreBut = [[UIButton alloc] init];
        [moreBut setImage:[UIImage imageNamed:@"player_more"] forState:UIControlStateNormal];
        [moreBut addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:moreBut];
        [moreBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView).with.offset(11);
            make.right.equalTo(topView).with.offset(-41);
            make.width.mas_equalTo(22);
            make.height.mas_equalTo(22);
        }];
    }
    
    //分享按钮
    UIButton *shareBut = [[UIButton alloc] init];
    [shareBut setImage:[UIImage imageNamed:@"player_share"] forState:UIControlStateNormal];
    [shareBut addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:shareBut];
    [shareBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView).with.offset(11);
        make.right.equalTo(topView).with.offset(-11);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(22);
    }];
}

/// 底部部工具栏
- (void)creatBottomView
{
    UIView *bottomView = [[UIView alloc] init];
    [self addSubview:bottomView];
    self.bottomView = bottomView;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(0);
        make.left.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(0);
        make.height.mas_equalTo(44);
    }];
    
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.image = [UIImage imageNamed:@"player_bottomBg"];
    [bottomView addSubview:bgImgView];
    [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 下、右不需要写负号，insets方法中已经为我们做了取反的操作了。
        make.edges.equalTo(bottomView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //聊天输入框
    UIView *chatBgView = [[UIView alloc] init];
    chatBgView.backgroundColor = [UIColor clearColor];
    chatBgView.layer.cornerRadius = 3;
    chatBgView.layer.borderWidth = 0.5;
    chatBgView.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5].CGColor;
    [bottomView addSubview:chatBgView];
    self.chatView = chatBgView;
    [chatBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).with.offset(7);
        make.centerX.equalTo(bottomView).with.offset(0);
//        make.right.equalTo(bottomView).with.offset(-170);
        make.width.mas_equalTo(260);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *noticeLab = [[UILabel alloc] init];
    noticeLab.text = @"请输入聊天内容~";
    noticeLab.font = [UIFont systemFontOfSize:13];
    noticeLab.textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    [chatBgView addSubview:noticeLab];
    [noticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(chatBgView).with.offset(0);
        make.left.equalTo(chatBgView).with.offset(9);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(30);
    }];
    
    UIButton *chatBut = [[UIButton alloc] init];
    [chatBut addTarget:self action:@selector(chatAction) forControlEvents:UIControlEventTouchUpInside];
    [chatBgView addSubview:chatBut];
    [chatBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(chatBgView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UIButton *playBut = [[UIButton alloc] init];
    [playBut setImage:[UIImage imageNamed:@"player_stop"] forState:UIControlStateNormal];
    [playBut addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:playBut];
    self.playBut = playBut;
    [playBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).with.offset(8);
        make.left.equalTo(bottomView).with.offset(9);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    UIButton *barrageBut = [[UIButton alloc] init];
    if ([UserInstance shareInstance].isSetBarrageOpen) {
        [barrageBut setImage:[UIImage imageNamed:@"player_dm"] forState:UIControlStateNormal];
        barrageBut.tag = 0;
    }else {
        [barrageBut setImage:[UIImage imageNamed:@"player_dmClose"] forState:UIControlStateNormal];
        barrageBut.tag = 1;
    }
    [barrageBut addTarget:self action:@selector(barrageAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:barrageBut];
    self.barrageBut = barrageBut;
    [barrageBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).with.offset(7);
        make.centerX.equalTo(bottomView).with.offset(155);
//        make.right.equalTo(bottomView).with.offset(-120);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    UIButton *giftBut = [[UIButton alloc] init];
    [giftBut setImage:[UIImage imageNamed:@"icon_lwtb"] forState:UIControlStateNormal];
    [giftBut addTarget:self action:@selector(giftAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:giftBut];
    self.giftBut = giftBut;
    [giftBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).with.offset(8);
        make.right.equalTo(bottomView).with.offset(-49);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    UIButton *fullBut = [[UIButton alloc] init];
    [fullBut setImage:[UIImage imageNamed:@"player_fullscreen"] forState:UIControlStateNormal];
    [fullBut addTarget:self action:@selector(fullAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:fullBut];
    self.fullBut = fullBut;
    [fullBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).with.offset(8);
        make.right.equalTo(bottomView).with.offset(-9);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
}

/// 启动从指定的 pullUrl 播放音视频流
/// @param pullUrl 拉流地址
/// @param isLiving 是否是直播，或是录播
- (BOOL)startPlay:(NSString *)pullUrl isLiving:(BOOL)isLiving
{
    self.videoPullUrl = pullUrl;
    self.isVodPlayer = !isLiving;
    self.countdownLab.hidden = YES;
    
    if (self.isVodPlayer) {
        //点播播放器
        self.isVodPlayer = YES;
        if (!_vodPlayer) {
            _vodPlayer = [TXVodPlayer new];
            [_vodPlayer setIsAutoPlay:YES];
            _vodPlayer.vodDelegate = self;
        }
        [_vodPlayer setupVideoWidget:self insertIndex:0];
        [_vodPlayer startPlay:pullUrl];
        
        //点播播放进度条
        DRVodProgressView *vodProgressView = [[DRVodProgressView alloc] initWithFrame:CGRectMake(49, 13, self.size.width - 49 - 49 , 20) vodPlayer:self.vodPlayer];
        __weak __typeof(self)weakSelf = self;
        vodProgressView.vodPlayEnd = ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.loadingView.hidden = YES;
            strongSelf.resetPlayBut.hidden = NO;
            [strongSelf stopPlay];
        };
        [self.bottomView addSubview:vodProgressView];
        self.vodProgressView = vodProgressView;
        
    }else {
        //直播播放器
        if (!_player) {
            _player = [[TXLivePlayer alloc] init];
            TXLivePlayConfig* config = _player.config;
            config.bAutoAdjustCacheTime = YES;
            config.minAutoAdjustCacheTime = 1.0;
            config.maxAutoAdjustCacheTime = 5.0;
            config.enableMessage = YES;
            [_player setConfig:config];
            _player.enableHWAcceleration = YES;
            [_player setDelegate:self];
            // 播放参数初始化
            [_player showVideoDebugLog:NO];
            [_player setRenderRotation:HOME_ORIENTATION_DOWN];
            [_player setRenderMode:RENDER_MODE_FILL_SCREEN];
        }
        
        [_player setupVideoWidget:CGRectZero containView:self insertIndex:0];
        
        TX_Enum_PlayType playType = PLAY_TYPE_LIVE_FLV;
        if ([pullUrl hasPrefix:@"rtmp:"]) {
            playType = PLAY_TYPE_LIVE_RTMP;
        } else if (([pullUrl hasPrefix:@"https:"] || [pullUrl hasPrefix:@"http:"]) && [pullUrl rangeOfString:@".m3u8"].length > 0) {
            playType = PLAY_TYPE_VOD_HLS;
        }
//        pullUrl = @"https://c7d13e8e0a1f203ae9d8d5f47cd627ef.v.smtcdns.net/txycdn.video.qq.com/1CCD6ED396A832FB82CFC134DD980FE72A6D2B7AECE1A36A0BBFE6A8187103C7161B2FC4DDBE4C46B99BD70BFC583B29AAA2179C2C9D58D8DF2ED6311D42E10B389960A3F19D09405EE5B99AD27872F52A312297F7E45B8BA139483B9E6953988A29855B28B241927B5ADFB8A9F4D637/1661372401.m3u8?from=player&cdncode=%2f18907E7BE0798990%2f&time=1614827386&cdn=tcloud&sdtfrom=v32430212&platform=40201&butype=30&scheduleflag=0&HLSP2P=1&buname=qqlive&vkey=1CCD6ED396A832FB82CFC134DD980FE72A6D2B7AECE1A36A0BBFE6A8187103C7161B2FC4DDBE4C46B99BD70BFC583B29AAA2179C2C9D58D8DF2ED6311D42E10B389960A3F19D09405EE5B99AD27872F52A312297F7E45B8BA139483B9E6953988A29855B28B241927B5ADFB8A9F4D637";
        int ret = [_player startPlay:pullUrl type:playType];
        if (ret != 0) {
            NSLog(@"播放器启动失败");
            return NO;
        }
    }
    
    return YES;
}

- (void)stopPlay
{
    if (self.isVodPlayer) {
        if (_vodPlayer) {
            [_vodPlayer setVodDelegate:nil];
            [_vodPlayer removeVideoWidget];
            [_vodPlayer stopPlay];
        }
    }else {
        if (_player) {
            [_player setDelegate:nil];
            [_player removeVideoWidget];
            [_player stopPlay];
        }
    }
}

- (void)pause
{
    if (self.isVodPlayer) {
        [_vodPlayer pause];
    }else {
        [_player pause];
    }
}

- (void)resume
{
    if (self.isVodPlayer) {
        [_vodPlayer resume];
    }else {
        [_player resume];
    }
}

//显示/隐藏工具栏
- (void)showHiddenToolBar
{
    [UIView animateWithDuration:0.3 animations:^{
        if (self.isShowToolbar) {
            self.topView.alpha = 0;
            self.bottomView.alpha = 0;
        }else {
            self.topView.alpha = 1;
            self.bottomView.alpha = 1;
        }
    }];
    self.isShowToolbar = !self.isShowToolbar;
}

//添加等速弹幕
- (void)addBarrageWithChat:(NSString *)chatStr leisu:(NSString *)leisu
{
    CGFloat textAlpha = 1 - [UserInstance shareInstance].barrageFontAlpha;          //弹幕透明度
    if (textAlpha <= 0) {
        return;
    }
    CGFloat fontSize = [UserInstance shareInstance].barrageFontSize;
    OCBarrageGradientBackgroundColorDescriptor *gradientBackgroundDescriptor = [[OCBarrageGradientBackgroundColorDescriptor alloc] init];
    gradientBackgroundDescriptor.text = chatStr;
    gradientBackgroundDescriptor.positionPriority = OCBarragePositionLow;
    gradientBackgroundDescriptor.textFont = [UIFont boldSystemFontOfSize:fontSize];
    gradientBackgroundDescriptor.strokeColor = [[UIColor blackColor] colorWithAlphaComponent:textAlpha];
    gradientBackgroundDescriptor.strokeWidth = -1;
    gradientBackgroundDescriptor.fixedSpeed = 15;//用fixedSpeed属性设定速度
    gradientBackgroundDescriptor.barrageCellClass = [OCBarrageGradientBackgroundColorCell class];
    gradientBackgroundDescriptor.gradientColor = [UIColor blackColor];
    
    //快龙+雷速聊天同时开启的时候，主播或房管看见的雷速消息是黑色，快龙消息是红色
    if ([[UserInstance shareInstance].userModel.userRoomRole integerValue] == 1 && ![UserInstance shareInstance].userModel.isLeisuJinyan) {
        if (leisu && [leisu integerValue] == 2) {
            gradientBackgroundDescriptor.textColor = [[UIColor whiteColor] colorWithAlphaComponent:textAlpha];
        }else{
            gradientBackgroundDescriptor.textColor = [[UIColor colorFromHexString:@"#FF0000"] colorWithAlphaComponent:textAlpha];
        }
    }else {
        gradientBackgroundDescriptor.textColor = [[UIColor whiteColor] colorWithAlphaComponent:textAlpha];
    }
    
    [self.barrageManager renderBarrageDescriptor:gradientBackgroundDescriptor];
}

- (void)setRoomInfo:(RoomInfo *)roomInfo
{
    self.roomNameLab.text = roomInfo.hostNickName;
    
    //数量超过1万显示单位：万
    self.contentLab.text = [NSString stringWithFormat:@"%@  房间号: %@",roomInfo.hot,roomInfo.roomId];
    
    if (![roomInfo.living boolValue] && !roomInfo.recordedUrl) {
        self.loadingView.hidden = NO;
        [self.loadingView setLoadingType:LRHostLivingLostType];
    }
    else if (![roomInfo.forbid boolValue]) {
        self.loadingView.hidden = NO;
        [self.loadingView setLoadingType:LRHostLivingForbidType];
    }
}

/// 显示赛事倒计时
/// @param systemInterval 距离开赛相差时间（毫秒）
- (void)setCountDownTimer:(NSString *)systemInterval
{
    self.countdownLab.hidden = NO;
    self.countdownLab.text = systemInterval;
}

- (void)networkConnectCheck
{
    self.loadingView.hidden = NO;
    [self.loadingView setLoadingType:LRAnimationLoadingType];
}

- (void)networkDisconnect
{
    self.loadingView.hidden = NO;
    [self.loadingView setLoadingType:LRNetworkDisconnectType];
}

/// 主播不在
- (void)hostLivingLost
{
    self.loadingView.hidden = NO;
    [self.loadingView setLoadingType:LRHostLivingLostType];
}

#pragma mark ====== IBAction事件 ======
//返回/退出全屏
- (void)goBackAction
{
    if (self.goBackBlock) {
        self.goBackBlock();
    }
}

//音频和举报房间菜单按钮
- (void)moreAction
{
    NSString *firstTitle = @"仅音频播放";
    if (self.isAudio) {
        firstTitle = @"打开画面";
    }
    NSArray *dataArray = [[NSArray alloc]initWithObjects:
       [NSDictionary dictionaryWithObjectsAndKeys:firstTitle,@"title",@"player_audio",@"img", nil],
       [NSDictionary dictionaryWithObjectsAndKeys:@"举报此房间",@"title",@"player_report",@"img", nil],nil];
    [self.typeMenu setDataArray:dataArray];
    [self.typeMenu showMenu];
}

//分享
- (void)shareAction
{
    if (self.shareBlock) {
        self.shareBlock();
    }
}

//播放/暂停
- (void)playAction
{
    if (_playBut.tag == 0) {
        [self pause];
        
        [_playBut setImage:[UIImage imageNamed:@"player_start"] forState:UIControlStateNormal];
        _playBut.tag = 1;

    } else {
        [self resume];
        
        [_playBut setImage:[UIImage imageNamed:@"player_stop"] forState:UIControlStateNormal];
        _playBut.tag = 0;
    }
}

//聊天
- (void)chatAction
{
    NSLog(@"聊天");
    if (self.chatBlock) {
        self.chatBlock();
    }

    //缩小视频
//    CGFloat width = self.size.width;
//    CGFloat height = self.size.height;
//    [UIView animateWithDuration:0.4 animations:^{
//        self.transform = CGAffineTransformScale(self.transform, 0.5, 0.5);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.4 animations:^{
//            self.transform = CGAffineTransformTranslate(self.transform, -width * 0.5, -height * 0.5);
//                }];
//    }];
    
}

//弹幕
- (void)barrageAction
{
    BOOL isOpenBarrage;
    if (_barrageBut.tag == 0) {
        
        [self.barrageManager stop];
        
        isOpenBarrage = NO;
        [_barrageBut setImage:[UIImage imageNamed:@"player_dmClose"] forState:UIControlStateNormal];
        _barrageBut.tag = 1;
        
    } else {
        [self.barrageManager start];
        
        isOpenBarrage = YES;
        [_barrageBut setImage:[UIImage imageNamed:@"player_dm"] forState:UIControlStateNormal];
        _barrageBut.tag = 0;
    }
    
    [UserInstance shareInstance].isSetBarrageOpen = isOpenBarrage;
    [[NSUserDefaults standardUserDefaults] setBool:isOpenBarrage forKey:kkBarrageOpenManager];
    
    
                    
}

//礼物
- (void)giftAction
{
    if (self.giftBlock) {
        self.giftBlock();
    }
}

//全屏
- (void)fullAction
{
    if (self.fullBlock) {
        self.fullBlock();
    }
}

//点播视频重播
- (void)resetPlayAction
{
    [_playBut setImage:[UIImage imageNamed:@"player_stop"] forState:UIControlStateNormal];
    _playBut.tag = 0;
    _resetPlayBut.hidden = YES;
    _loadingView.hidden = YES;
    [self.vodPlayer startPlay:self.videoPullUrl];
}

//打开画面
- (void)openScreenAction
{
    self.isAudio = NO;
    self.openScreenBut.hidden = YES;
    self.coverImgView.hidden = YES;
}

#pragma mark ====== TXLivePlayListener事件 ======
- (void)onPlayEvent:(int)EvtID withParam:(NSDictionary *)param {
    NSDictionary *dict = param;
//    NSLog(@"播放器事件:%d",EvtID);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (EvtID == PLAY_EVT_PLAY_BEGIN) {
            NSLog(@"直播播放开始");
            self.coverImgView.hidden = YES;
            self.loadingView.hidden = YES;
            self.countdownLab.hidden = YES;
        } else if (EvtID == EVT_RENDER_FIRST_I_FRAME) {
            NSLog(@"直播渲染首个数据包");
            self.isRenderFirstFrame = YES;
            self.coverImgView.hidden = YES;
            self.loadingView.hidden = YES;
            self.countdownLab.hidden = YES;
        } else if (EvtID == PLAY_EVT_PLAY_LOADING){
            self.loadingView.hidden = NO;
        }
        else if (EvtID == EVT_VIDEO_PLAY_PROGRESS) {
            NSString *msg = (NSString*)[dict valueForKey:EVT_PLAY_PROGRESS];      //播放进度，时间单位秒
            
            if ([UserTaskInstance shareInstance].livePlayStatus == 1 && [msg integerValue] > 0) {
                NSInteger sumTime = [UserTaskInstance shareInstance].livePlayTime + [msg integerValue];
                [UserTaskInstance shareInstance].livePlayTime = sumTime;
            }
        }
        else if (EvtID == PLAY_ERR_NET_DISCONNECT || EvtID == PLAY_EVT_PLAY_END) {
            // 断开连接时，模拟点击一次关闭播放
            
            NSLog(@"直播网络断开连接");
            if (EvtID == PLAY_ERR_NET_DISCONNECT) {
                NSString *msg = (NSString*)[dict valueForKey:EVT_MSG];
//                [EasyTextView showText:msg config:nil];
            }
            
        } else if (EvtID == EVT_VOD_PLAY_LOADING_END){
            NSLog(@"直播loading结束");
        } else if (EvtID == PLAY_EVT_CONNECT_SUCC) {
            NSLog(@"直播网络连接成功");
        }
        else if (EvtID == EVT_VIDEO_PLAY_END) {
        }
        else if (EvtID == EVT_ROOM_NEED_REENTER) {
            NSLog(@"直播网络变化");
        }
        /*
         7.2 新增
        else if (EvtID == PLAY_EVT_GET_FLVSESSIONKEY) {
            //NSString *Msg = (NSString*)[dict valueForKey:EVT_MSG];
            //[self toastTip:[NSString stringWithFormat:@"event PLAY_EVT_GET_FLVSESSIONKEY: %@", Msg]];
        }
         */
    });
}

- (void)onNetStatus:(NSDictionary *)param {
//    NSLog(@"网络状态：%@",param);
}

- (void) onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary*)param
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (EvtID == PLAY_EVT_PLAY_END) {
            [self.playBut setImage:[UIImage imageNamed:@"player_start"] forState:UIControlStateNormal];
            [self.vodPlayer pause];
        }
        else if (EvtID == PLAY_EVT_PLAY_BEGIN) {
            self.coverImgView.hidden = YES;
            self.loadingView.hidden = YES;
        }
        else if (EvtID == PLAY_EVT_RCV_FIRST_I_FRAME) {
            self.isRenderFirstFrame = YES;
            self.coverImgView.hidden = YES;
            self.loadingView.hidden = YES;
        }
        else if (EvtID == PLAY_EVT_PLAY_LOADING){
            self.loadingView.hidden = NO;
        }
    });
}

- (void) onNetStatus:(TXVodPlayer *)player withParam:(NSDictionary*)param
{
}

#pragma mark ====== 点击UIView手势事件 ======
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    CGPoint point = [gestureRecognizer locationInView:self];
    NSLog(@"touch类名：%@",NSStringFromClass([touch.view class]));
    
    if([NSStringFromClass([touch.view class]) isEqualToString:@"OCBarrageRenderView"]) {
        UIView *brView = touch.view;
        NSLog(@"brView高度：%f",brView.frame.size.height);
    }
    //若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
//    if([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//        return NO;
//    }
//    else if([NSStringFromClass([touch.view class]) isEqualToString:@"UITableView"]) {
//        return NO;
//    }
//    else if([NSStringFromClass([touch.view class]) isEqualToString:@"OCBarrageRenderView"]) {
//
////        [self showHiddenToolBar];
//        return NO;
//    }

    return YES;
}

//最后，响应的方法中，可以获取点击的坐标哦！
-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    
    CGPoint point = [sender locationInView:self];
    CGFloat toolBarH = 44.0;                            //上下工具栏高度
    
    //点击区域在中间范围则可以隐藏工具栏
    if (point.y > toolBarH && point.y < (self.size.height - toolBarH)) {
        [self showHiddenToolBar];
    }
//    NSLog(@"handlePointx:%f,y:%f",point.x,point.y);
}

- (UIButton *)resetPlayBut
{
    if (!_resetPlayBut) {
        //重播按钮
        UIButton *resetPlayBut = [[UIButton alloc] init];
        [resetPlayBut setBackgroundImage:[UIImage imageNamed:@"PlayEndView"] forState:UIControlStateNormal];
        [resetPlayBut addTarget:self action:@selector(resetPlayAction) forControlEvents:UIControlEventTouchUpInside];
        resetPlayBut.hidden = YES;
        [self addSubview:resetPlayBut];
        [resetPlayBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(64);
            make.height.mas_equalTo(30);
        }];
        _resetPlayBut = resetPlayBut;
    }
    return _resetPlayBut;
}

@end
