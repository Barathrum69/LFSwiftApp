//
//  BaseTabBarController+autoRotate.h
//  DragonLive
//
//  Created by LoaA on 2020/12/8.
//

#import <UIKit/UIKit.h>
#import "BaseTabBarController.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseTabBarController (autoRotate)
 
-(BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;
 
@end


NS_ASSUME_NONNULL_END
