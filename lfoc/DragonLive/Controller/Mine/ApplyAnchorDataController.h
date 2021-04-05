//
//  ApplyAnchorDataController.h
//  DragonLive
//
//  Created by LoaA on 2020/12/28.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ApplyAnchorDataController : BaseViewController

/// 手机号
@property (nonatomic, strong) NSString *phoneText;

/// 验证码
@property (nonatomic, strong) NSString *codeText;

@end

NS_ASSUME_NONNULL_END
