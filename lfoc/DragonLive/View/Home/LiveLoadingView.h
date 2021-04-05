//
//  LiveLoadingView.h
//  DragonLive
//
//  Created by 11号 on 2021/1/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//重试按钮点击
typedef void(^RetryOnClickBlock)(void);

typedef enum : NSUInteger {
    LRAnimationLoadingType,             //loading动画
    LRNetworkDisconnectType,            //无网络
    LRHostLivingLostType,               //主播不在
    LRHostLivingForbidType,             //主播禁播
} LRLoadingType;

    /// 直播间loading、无网络、主播不在、主播禁播view
@interface LiveLoadingView : UIView


+ (instancetype)lvLoadingInstance;
- (void)setLoadingType:(LRLoadingType)loadingType;

- (void)setLoadingType:(LRLoadingType)loadingType block:(RetryOnClickBlock)retryOnClickBlock;


@end

NS_ASSUME_NONNULL_END
