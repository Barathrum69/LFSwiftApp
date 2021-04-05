//
//  LiveRoomViewController.h
//  DragonLive
//
//  Created by 11号 on 2020/11/28.
//

#import <UIKit/UIKit.h>
#import "TXLivePlayer.h"
#import "TXVodPlayer.h"

@class LiveItem;
@class HostModel;

/// 直播间
@interface LiveRoomViewController : BaseViewController

@property (nonatomic, strong) TXLivePlayer *livePlayer;     //小窗口进入传递
@property (nonatomic, strong) TXVodPlayer *vodPlayer;       //小窗口进入传递
@property (nonatomic, strong) LiveItem *liveItem;           //直播列表model
@property (nonatomic, strong) HostModel *matchItem;         //赛事模型
@end

