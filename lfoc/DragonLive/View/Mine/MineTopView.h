//
//  MineTopView.h
//  DragonLive
//
//  Created by LoaA on 2020/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class UserModel;

typedef void(^LoginBtnOnClickBlock)(void);

@interface MineTopView : UIView

/// 用户模型
@property (nonatomic, strong) UserModel *model;

/// 登录按钮执行的block
@property (nonatomic, copy) LoginBtnOnClickBlock loginBtnOnClickBlock;

/// 显示登录
-(void)showLogin;

@end

NS_ASSUME_NONNULL_END
