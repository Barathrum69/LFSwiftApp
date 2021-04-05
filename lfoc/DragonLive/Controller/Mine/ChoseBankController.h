//
//  ChoseBankController.h
//  DragonLive
//
//  Created by LoaA on 2021/1/6.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^ReturnBankNameBlock) (NSString *name);

@interface ChoseBankController : BaseViewController


/// 选择银行。
@property (nonatomic, copy) ReturnBankNameBlock returnBankNameBlock;
@end

NS_ASSUME_NONNULL_END
