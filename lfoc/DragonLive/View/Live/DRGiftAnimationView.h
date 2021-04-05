//
//  DRGiftAnimationView.h
//  DragonLive
//
//  Created by 11号 on 2020/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RoomGift;

/// 普通礼物动画展示view
@interface DRGiftAnimationView : UIView

+ (void)showGiftAnimationInWindow:(RoomGift *)giftModel fromName:(NSString *)fromName;

@end

NS_ASSUME_NONNULL_END
