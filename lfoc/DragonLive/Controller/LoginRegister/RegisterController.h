//
//  RegisterController.h
//  DragonLive
//
//  Created by LoaA on 2020/12/18.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RegisterSuccess)(NSString *phone,NSString *pwd,NSString *countryCode,NSString *salt);

@interface RegisterController : BaseViewController

/// 注册成功的block
@property (nonatomic, copy) RegisterSuccess registerSuccess;

@end

NS_ASSUME_NONNULL_END
