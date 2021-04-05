//
//  DREmptyView.h
//  DragonLive
//
//  Created by 11号 on 2021/1/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    DREmptyDataType,                //空数据
    DRNetworkErrorType,             //无网络
} DREmptyType;

/// 空数据view
@interface DREmptyView : UIView

+ (DREmptyView *)showEmptyInView:(UIView *)superview emptyType:(DREmptyType)type refresh:(nullable void (^)(void))refresh;

+ (DREmptyView *)showEmptyInView:(UIView *)superview emptyType:(DREmptyType)type;

+ (void)hiddenEmptyInView:(UIView *)superView;

@end

NS_ASSUME_NONNULL_END
