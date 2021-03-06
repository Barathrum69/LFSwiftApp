//
//  UIView+LXShadowPath.h
//  LXViewShadowPath
//
//  Created by chenergou on 2017/11/23.
//  Copyright © 2017年 漫漫. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum :NSInteger{
    
    LXShadowPathLeft,
    
    LXShadowPathRight,
    
    LXShadowPathTop,

    LXShadowPathBottom,

    LXShadowPathNoTop,
    
    LXShadowPathAllSide

} LXShadowPathSide;
@interface UIView (LXShadowPath)

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

-(void)LX_SetShadowPathWith:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowSide:(LXShadowPathSide)shadowPathSide shadowPathWidth:(CGFloat)shadowPathWidth;

/// 贝塞尔曲线切圆觉
/// @param type 圆角类型
/// @param radius 角度
- (void)setCornerWithType:(UIRectCorner)type
                   Radius:(CGFloat)radius;

/** 画图片边的圈 */
- (UIImage *)drawCircleImageInCircleColor:(UIColor *)color withMargin:(CGFloat)margin;
@end
