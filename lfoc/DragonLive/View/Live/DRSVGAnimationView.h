//
//  DRSVGAnimationView.h
//  DragonLive
//
//  Created by 11号 on 2020/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RoomGift;

/// SVG全屏礼物动画展示view
@interface DRSVGAnimationView : UIView

+ (void)showSVGAnimationInWindow:(RoomGift *)giftModel fromName:(NSString *)fromName;

@end

NS_ASSUME_NONNULL_END
