//
//  DREmitterLayer.m
//  DragonLive
//
//  Created by 11号 on 2021/2/2.
//

#import "DREmitterLayer.h"

@implementation DREmitterLayer

+ (CAEmitterLayer *)fireworkdEmitterLayer:(CGRect)rect
{
    //cell产生在底部,向上移动
    CAEmitterLayer *fireworkdEmitter =[CAEmitterLayer layer];
    CGRect viewBounds = rect;
    
    fireworkdEmitter.emitterPosition =CGPointMake(viewBounds.size.width/2, viewBounds.size.height - 100);
    // 发射源尺寸大小
    fireworkdEmitter.emitterSize = CGSizeMake(viewBounds.size.width/2.0, 0.0);
    fireworkdEmitter.emitterMode = kCAEmitterLayerOutline;
    fireworkdEmitter.emitterShape = kCAEmitterLayerLine;
    fireworkdEmitter.renderMode = kCAEmitterLayerAdditive;
    fireworkdEmitter.seed = (arc4random()%100)+1;
    
    //创建火箭cell
    CAEmitterCell *rocket = [CAEmitterCell emitterCell];
    rocket.birthRate = 1;
    rocket.emissionRange = 0.25 *M_PI;
    rocket.velocity = 300;
    rocket.velocityRange = 75;
    rocket.lifetime =1.02;
    
    rocket.contents = (id)[UIImage imageNamed:@"DazFire"].CGImage;
    rocket.scale = 0.5;
    rocket.scaleRange =0.5;
    rocket.color = [UIColor redColor].CGColor;
    rocket.greenRange = 1.0;
    rocket.redRange = 1.0;
    rocket.blueRange = 1.0;
    rocket.spinRange =M_PI;
    
    //破裂对象不能被看到,但会产生火花
    //这里我们改变颜色,因为火花继承它的值
    CAEmitterCell *fireCell =[CAEmitterCell emitterCell];
    
    fireCell.birthRate          = 1;
    fireCell.velocity           = 0;
    fireCell.scale              = 1;
    fireCell.redSpeed           =- 1.5;
    fireCell.blueSpeed          =+ 1.5;
    fireCell.greenSpeed         =+ 1.5;        // shifting
    fireCell.lifetime           = 0.34;
    
    
    // and finally, the sparks
    CAEmitterCell* spark = [CAEmitterCell emitterCell];
    
    spark.birthRate            = 400;       //炸开后产生400个小烟花
    spark.velocity             = 125;       //速度
    spark.emissionRange        = 2* M_PI;   // 360 度
    spark.yAcceleration        = 40;         // 重力
    spark.lifetime             = 3;
    
    spark.contents          = (id) [[UIImage imageNamed:@"DazFireSnow"] CGImage];
    spark.scaleSpeed        =- 0.2;
    
    spark.greenSpeed        =- 0.1;
    spark.redSpeed          =+ 0.1;
    spark.blueSpeed         =- 0.1;
    
    spark.alphaSpeed        =- 0.25;
    
    spark.spin              = 2* M_PI;
    spark.spinRange         = 2* M_PI;
    
    fireworkdEmitter.emitterCells        = [NSArray arrayWithObject:rocket];
    rocket.emitterCells                  = [NSArray arrayWithObject:fireCell];
    fireCell.emitterCells                = [NSArray arrayWithObject:spark];
    
    return fireworkdEmitter;
}

+ (CAEmitterLayer *)snowEmitterLayer:(CGRect)rect
{
    CAEmitterLayer *snowEmitter = [CAEmitterLayer layer];
    snowEmitter.emitterPosition = CGPointMake(rect.size.width / 2.0, -30);
    snowEmitter.emitterSize = CGSizeMake(rect.size.width * 2.0, 30.0);;
   
    // Spawn points for the flakes are within on the outline of the line
    snowEmitter.emitterMode = kCAEmitterLayerOutline;
    snowEmitter.emitterShape = kCAEmitterLayerLine;
   
    // Configure the snowflake emitter cell
    CAEmitterCell *snowflake = [CAEmitterCell emitterCell];
   
    snowflake.birthRate = 3; //控制数量
    snowflake.lifetime = 120.0;
    snowflake.alphaRange = 0.02;
    snowflake.scaleSpeed = -0.02;
    snowflake.velocity = 35; // 速度-每个释放对象的初始平均速度
    snowflake.velocityRange = 200.0;
    snowflake.yAcceleration = 4;//加速度-加速度矢量用于释放对象
    snowflake.emissionRange = 0.5 * M_PI; // some variation in angle
    snowflake.spinRange = 0.25 * M_PI; // slow spin
   
    snowflake.contents = (id) [[UIImage imageNamed:@"snowflake"] CGImage];
//    snowflake.color = [[UIColor colorWithRed:0.600 green:0.658 blue:0.743 alpha:1.000] CGColor];
   
    // Make the flakes seem inset in the background
    snowEmitter.shadowOpacity = 1.0;//影子不透明
    snowEmitter.shadowRadius  = 0.0;//影子半径
    snowEmitter.shadowOffset  = CGSizeMake(0.0, 1.0);
    snowEmitter.shadowColor  = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
   
    // Add everything to our backing layer below the UIContol defined in the storyboard
    snowEmitter.emitterCells = [NSArray arrayWithObject:snowflake];
    
    return snowEmitter;
}

@end
