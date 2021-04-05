//
//  DREmitterLayer.h
//  DragonLive
//
//  Created by 11号 on 2021/2/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DREmitterLayer : NSObject


/// 烟花粒子特效
/// @param rect 渲染rect
+ (CAEmitterLayer *)fireworkdEmitterLayer:(CGRect)rect;

/// 下雪粒子特效
/// @param rect 渲染rect
+ (CAEmitterLayer *)snowEmitterLayer:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
