//
//  UINavigationController+autoRotate.m
//  DragonLive
//
//  Created by LoaA on 2020/12/8.
//

#import "NaviControllrer+autoRotate.h"


@implementation NaviControllrer (autoRotate)
 
- (BOOL)shouldAutorotate {
    return [self.visibleViewController shouldAutorotate];
}
 
- (NSUInteger)supportedInterfaceOrientations {
    return [self.visibleViewController supportedInterfaceOrientations];
}
 
@end
