//
//  CALayer+ZZYXibBorderColor.m
//  BallSaintSport
//
//  Created by 11号 on 2020/11/7.
//

#import "CALayer+ZZYXibBorderColor.h"
#import <UIKit/UIKit.h>

@implementation CALayer (ZZYXibBorderColor)

- (void)setBorderColorWithUIColor:(UIColor *)color
{

    self.borderColor = color.CGColor;
}

@end
