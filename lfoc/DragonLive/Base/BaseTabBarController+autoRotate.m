//
//  UITabBarController+autoRotate.m
//  DragonLive
//
//  Created by LoaA on 2020/12/8.
//


#import "BaseTabBarController+autoRotate.h"
 
@implementation BaseTabBarController (autoRotate)
 
- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}
- (NSUInteger)supportedInterfaceOrientations {
    return [self.selectedViewController supportedInterfaceOrientations];
}

@end
