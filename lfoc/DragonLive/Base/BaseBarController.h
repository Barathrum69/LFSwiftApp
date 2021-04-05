//
//  BaseViewController.h
//  MaJingGallery
//
//  Created by T34 on 2019/7/13.
//  Copyright © 2019 T34. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface BaseBarController : UIViewController<UINavigationControllerDelegate>{
    UINavigationController *navController;
    
}


/// 去黑线
/// @param view <#view description#>
- (UIImageView *)findLineImageViewUnder:(UIView *)view;
/**
 显示Toast
 
 @param message 提示文本内容
 */
-(void)showToast:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
