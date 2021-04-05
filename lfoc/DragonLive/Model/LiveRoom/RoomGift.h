//
//  RoomGift.h
//  DragonLive
//
//  Created by 11号 on 2020/12/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 直播礼物
@interface RoomGift : NSObject

/// 礼物id
@property (nonatomic, copy) NSString *propId;

/// 道具名称
@property (nonatomic, copy) NSString *propName;

/// 序号
@property (nonatomic, copy) NSString *sequence;

/// 价格
@property (nonatomic, copy) NSString *price;

/// 图标地址
@property (nonatomic, copy) NSString *giftIcon;

/// 特效文件地址（gif和svga两种）
@property (nonatomic, copy) NSString *giftCgi;

/// 动画类型
@property (nonatomic, copy) NSString *cartoonType;

/// 动画时长
@property (nonatomic, copy) NSString *duration;

///  0 为 普通 1为全屏
@property (nonatomic, copy) NSString *showType;

/// 横幅
@property (nonatomic, copy) NSString *banner;

/// 礼物数量
@property (nonatomic, copy) NSString *giftNum;

@property (nonatomic, assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
