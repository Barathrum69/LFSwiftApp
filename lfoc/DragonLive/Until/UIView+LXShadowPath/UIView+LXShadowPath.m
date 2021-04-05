//
//  UIView+LXShadowPath.m
//  LXViewShadowPath
//
//  Created by chenergou on 2017/11/23.
//  Copyright © 2017年 漫漫. All rights reserved.
//

#import "UIView+LXShadowPath.h"

@implementation UIView (LXShadowPath)
/*
 * shadowColor 阴影颜色
 *
 * shadowOpacity 阴影透明度，默认0
 *
 * shadowRadius  阴影半径，默认3
 *
 * shadowPathSide 设置哪一侧的阴影，
 
 * shadowPathWidth 阴影的宽度，
 
 */

-(void)LX_SetShadowPathWith:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowSide:(LXShadowPathSide)shadowPathSide shadowPathWidth:(CGFloat)shadowPathWidth{
    
    
    self.layer.masksToBounds = NO;
    
    self.layer.shadowColor = shadowColor.CGColor;
    
    self.layer.shadowOpacity = shadowOpacity;
    
    self.layer.shadowRadius =  shadowRadius;
    
    self.layer.shadowOffset = CGSizeZero;
    CGRect shadowRect;
    
    CGFloat originX = 0;
    
    CGFloat originY = 0;
    
    CGFloat originW = self.bounds.size.width;
    
    CGFloat originH = self.bounds.size.height;
    
    
    switch (shadowPathSide) {
        case LXShadowPathTop:
            shadowRect  = CGRectMake(originX, originY - shadowPathWidth/2, originW,  shadowPathWidth);
            break;
        case LXShadowPathBottom:
            shadowRect  = CGRectMake(originX, originH -shadowPathWidth/2, originW, shadowPathWidth);
            break;
            
        case LXShadowPathLeft:
            shadowRect  = CGRectMake(originX - shadowPathWidth/2, originY, shadowPathWidth, originH);
            break;
            
        case LXShadowPathRight:
            shadowRect  = CGRectMake(originW - shadowPathWidth/2, originY, shadowPathWidth, originH);
            break;
        case LXShadowPathNoTop:
            shadowRect  = CGRectMake(originX -shadowPathWidth/2, originY +1, originW +shadowPathWidth,originH + shadowPathWidth/2 );
            break;
        case LXShadowPathAllSide:
            shadowRect  = CGRectMake(originX - shadowPathWidth/2, originY - shadowPathWidth/2, originW +  shadowPathWidth, originH + shadowPathWidth);
            break;
       
          }
    
    UIBezierPath *path =[UIBezierPath bezierPathWithRect:shadowRect];
    
    self.layer.shadowPath = path.CGPath;
    
}

/// 贝塞尔曲线切圆觉
/// @param type 圆角类型
/// @param radius 角度
- (void)setCornerWithType:(UIRectCorner)type
                   Radius:(CGFloat)radius {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:type cornerRadii:CGSizeMake(radius,radius)];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = self.bounds;
    layer.path = path.CGPath;
    self.layer.mask = layer;
 
}
//
///** 画图片边的圈 */
//- (UIImage *)drawCircleImageInCircleColor:(UIColor *)color withMargin:(CGFloat)margin {
//    CGFloat side = MIN(self.size.width, self.size.height);
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(side, side), false, [UIScreen mainScreen].scale);
//    //设置圆形
//    CGContextAddPath(UIGraphicsGetCurrentContext(),[UIBezierPath bezierPathWithArcCenter:CGPointMake(side*0.5, side*0.5) radius:side*0.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES].CGPath);
//
//    CGContextClip(UIGraphicsGetCurrentContext());
//    CGFloat marginX = -(self.size.width - side) / 2.f;
//    CGFloat marginY = -(self.size.height - side) / 2.f;
//    [self drawInRect:CGRectMake(marginX, marginY, self.size.width, self.size.height)];
//    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
//    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    //
//    CGFloat margSide = side*0.5 + margin;
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(margSide*2, margSide*2), false, [UIScreen mainScreen].scale);
//    CGContextRef ref = UIGraphicsGetCurrentContext();
//    CGContextAddArc(ref, margSide, margSide, margSide, 0, M_PI*2, YES);
//    CGContextClip(ref);
//    CGContextSetFillColorWithColor(ref, color.CGColor);
//    CGContextFillRect(ref, CGRectMake(0, 0, margSide*2, margSide*2));
//
//    CGContextDrawImage(ref,CGRectMake(margin, margin, side, side), output.CGImage);
//
//    CGContextStrokePath(ref);
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
////    CGContextRelease(ref);
//
//
//    return image;
//}
//- (UIImage *)drawCircleImageInCircle {
//    CGFloat side = MIN(self.size.width, self.size.height);
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(side, side), false, [UIScreen mainScreen].scale);
//    //设置圆形
//        CGContextAddPath(UIGraphicsGetCurrentContext(),[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, side, side)].CGPath);
//
//    CGContextClip(UIGraphicsGetCurrentContext());
//    CGFloat marginX = -(self.size.width - side) / 2.f;
//    CGFloat marginY = -(self.size.height - side) / 2.f;
//    [self drawInRect:CGRectMake(marginX, marginY, self.size.width, self.size.height)];
//    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
//    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return output;
//}



@end
