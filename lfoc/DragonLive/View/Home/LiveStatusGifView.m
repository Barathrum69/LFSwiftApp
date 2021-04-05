//
//  LiveStatusGifView.m
//  YUAnimation
//
//  Created by 11号 on 2021/1/7.
//  Copyright © 2021 animation.com. All rights reserved.
//

#import "LiveStatusGifView.h"

@implementation LiveStatusGifView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup {
    self.layer.cornerRadius = 3.0;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:93/255.0 blue:35/255.0 alpha:0.8];
    [self.layer addSublayer:[self replicatorLayer_Shake]];
    
    UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.frame.size.width-15, self.frame.size.height)];
    contentLab.font = [UIFont systemFontOfSize:8];
    contentLab.textColor = [UIColor whiteColor];
    contentLab.text = @"直播中";
    [self addSubview:contentLab];
}

- (CALayer *)replicatorLayer_Shake{
    
    CALayer *layer = [[CALayer alloc]init];
    layer.frame = CGRectMake(4, 6, 1.5, 6);
    layer.cornerRadius = layer.bounds.size.width/2.0;
    layer.masksToBounds = YES;
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    layer.anchorPoint = CGPointMake(0.5, 1);
    // 添加一个基本动画
    [layer addAnimation:[self scaleYAnimation] forKey:@"scaleAnimation"];
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
//    replicatorLayer.frame = CGRectMake(0, 0, 44, 12);
    replicatorLayer.backgroundColor = [UIColor whiteColor].CGColor;
    replicatorLayer.instanceCount = 3;
    replicatorLayer.instanceTransform =  CATransform3DMakeTranslation(3, 0, 0);
    replicatorLayer.instanceDelay = 0.2;
//    replicatorLayer.instanceGreenOffset = -0.3;
    [replicatorLayer addSublayer:layer];
    
    return replicatorLayer;
}

- (CABasicAnimation *)scaleYAnimation{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    anim.toValue = @0.1;
    anim.duration = 0.4;
    anim.removedOnCompletion = NO;          //离开控制器了在返回继续保持动画状态
    anim.autoreverses = YES;//往返都有动画
    anim.repeatCount = MAXFLOAT;//执行次数
    
    return anim;
}

@end
