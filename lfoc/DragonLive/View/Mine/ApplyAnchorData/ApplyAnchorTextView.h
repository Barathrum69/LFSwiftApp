//
//  ApplyAnchorTextView.h
//  DragonLive
//
//  Created by LoaA on 2020/12/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LeftRightTextField;
@interface ApplyAnchorTextView : UIView

/// 输入框
@property (nonatomic, strong) LeftRightTextField *textField;

/// 初始化
/// @param frame frame
/// @param title title
/// @param placeholder placeholder
-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title placeholder:(NSString *)placeholder;

@end

NS_ASSUME_NONNULL_END
