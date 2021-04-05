//
//  BaseViewController.h
//  DragonLive
//
//  Created by 11号 on 2020/11/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController<UINavigationControllerDelegate>

/**
 显示Toast
 
 @param message 提示文本内容
 */
-(void)showToast:(NSString *)message;

-(void)close;

@end

NS_ASSUME_NONNULL_END
