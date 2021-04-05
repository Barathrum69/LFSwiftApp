//
//  LoginController.h
//  DragonLive
//
//  Created by LoaA on 2020/12/11.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
//登录成功失败的block
typedef void(^LoginSuccessBlock)(void);
@interface LoginController : BaseViewController
//登录成功失败的block
@property (nonatomic, copy) LoginSuccessBlock loginBlock;

@end

NS_ASSUME_NONNULL_END
