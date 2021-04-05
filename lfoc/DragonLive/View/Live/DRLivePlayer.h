//
//  DRLivePlayer.h
//  DragonLive
//
//  Created by 11号 on 2020/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RoomInfo;
@class TXLivePlayer;
@class TXVodPlayer;
@class HostModel;

typedef void(^GoBackBlock) (void);          //返回
typedef void(^ReportBlock) (void);          //举报房间
typedef void(^ShareBlock) (void);           //分享
typedef void(^ChatInputBlock) (void);       //聊天输入
typedef void(^GiftBlock) (void);            //礼物
typedef void(^FullBlock) (void);            //全屏

/// 直播播放器
@interface DRLivePlayer : UIView

@property (nonatomic, strong) TXLivePlayer *player;             //腾讯云直播播放器
@property (nonatomic, strong) TXVodPlayer *vodPlayer;           //腾讯云点播播放器

@property (nonatomic, assign) BOOL isRenderFirstFrame;          //直播流是否开始渲染

@property (nonatomic, copy) GoBackBlock goBackBlock;
@property (nonatomic, copy) ReportBlock reportBlock;
@property (nonatomic, copy) ShareBlock shareBlock;
@property (nonatomic, copy) ChatInputBlock chatBlock;           
@property (nonatomic, copy) GiftBlock giftBlock;
@property (nonatomic, copy) FullBlock fullBlock;


/// 初始化播放器
/// @param frame 位置大小
/// @param imgUrlStr 封面图
/// @param player 直播播放器（小窗口进入时携带）
/// @param vodPlayer 点播播放器小窗口进入时携带）
/// @param hostModel 赛事数据模型（从赛事列表进入直播间携带）
- (id)initWithFrame:(CGRect)frame coverImageUrl:(NSString *)imgUrlStr livePlayer:(TXLivePlayer *)player vodPlayer:(TXVodPlayer *)vodPlayer hostModel:(HostModel *)hostModel;

/// 启动从指定的 pullUrl 播放音视频流
/// @param pullUrl 拉流地址
/// @param isLiving 是否是直播，或是录播
- (BOOL)startPlay:(NSString *)pullUrl isLiving:(BOOL)isLiving;


/// 停止播放音视频流（暂停拉流，销毁播放器）
- (void)stopPlay;


/// 暂停播放，适用于点播，直播（此接口会暂停数据拉流，不会销毁播放器，暂停后，播放器会显示最后一帧数据图像）
- (void)pause;


/// 继续播放，适用于点播，直播
- (void)resume;


/// 添加等速弹幕
/// @param chatStr 聊天内容
- (void)addBarrageWithChat:(NSString *)chatStr leisu:(NSString *)leisu;


/// 显示房间信息
/// @param roomInfo 直播间详情model
- (void)setRoomInfo:(RoomInfo *)roomInfo;


/// 显示赛事倒计时
/// @param systemInterval 距离开赛相差时间
- (void)setCountDownTimer:(NSString *)systemInterval;

/// 重连网络
- (void)networkConnectCheck;

/// 网络断开
- (void)networkDisconnect;

/// 主播不在
- (void)hostLivingLost;

@end

NS_ASSUME_NONNULL_END
