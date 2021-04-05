//
//  AnchorCenterView.h
//  DragonLive
//
//  Created by LoaA on 2020/12/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^GobackBlock)(void);
@class AnchorModel;
@interface AnchorCenterTopView : UIView

/// 返回按钮block
@property (nonatomic, copy) GobackBlock gobackBlock;

/// 数据模型
@property (nonatomic, strong) AnchorModel *model;

@end

NS_ASSUME_NONNULL_END
