//
//  LeftRightTextField.h
//  DragonLive
//
//  Created by LoaA on 2020/12/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TextFieldDidChange)(NSString *text);

@interface LeftRightTextField : UITextField

/// 当文字发生改变
@property (nonatomic,copy) TextFieldDidChange textFieldDidChange;

@end

NS_ASSUME_NONNULL_END
