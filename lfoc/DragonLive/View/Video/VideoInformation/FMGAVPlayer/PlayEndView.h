//
//  PlayEndView.h
//  DragonLive
//
//  Created by LoaA on 2021/1/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//点击手势
typedef void(^TapShow)(void);
//重播按钮
typedef void(^ReplayBtnBlock)(void);

@interface PlayEndView : UIView
//点击手势
@property (nonatomic, copy) TapShow tapShow;

/// 重播blcok
@property (nonatomic, copy) ReplayBtnBlock replayBtnBlock;
@end

NS_ASSUME_NONNULL_END
