//
//  BadNetWorkView.h
//  DragonLive
//
//  Created by LoaA on 2021/1/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^RefreshBlock)(void);
@interface BadNetWorkView : UIView

/// 点击刷新的block
@property (nonatomic,copy) RefreshBlock refreshBlock;

@end

NS_ASSUME_NONNULL_END
