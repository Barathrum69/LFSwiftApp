//
//  VideoInformationController.h
//  DragonLive
//
//  Created by LoaA on 2020/12/3.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class VideoItemModel;
@interface VideoInformationController : BaseViewController

/// 上一层传过来的model
@property (nonatomic,strong) VideoItemModel *itemModel;

@end

NS_ASSUME_NONNULL_END
