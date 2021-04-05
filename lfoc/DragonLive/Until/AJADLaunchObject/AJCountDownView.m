//
//  AJCountDownView.m
//  AJADLaunchObject
//
//  Created by Jame on 19/6/16.
//  Copyright © 2019年 Jame. All rights reserved.
//


#import "AJCountDownView.h"

@implementation AJCountDownView{
    NSTimer *_countTimer;
    NSInteger _time;
    UILabel *title;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self createUI];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    [self createUI];
}

-(void)createUI{
    self.backgroundColor = [UIColor clearColor];
    title = [[UILabel alloc] initWithFrame:self.bounds];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:10];
    title.textColor = [UIColor lightGrayColor];
    title.backgroundColor = [UIColor clearColor];
//    title.backgroundColor = [UIColor redColor];
    [self addSubview:title];
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}

-(void)drawAction:(NSInteger)drawTime{
    CAShapeLayer *layer = [CAShapeLayer layer];
//    layer.backgroundColor = [UIColor clearColor].CGColor;
    // 填充颜色
    layer.fillColor = [UIColor clearColor].CGColor;
    // 绘制颜色
    layer.strokeColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1].CGColor;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    layer.lineWidth = 4;
    layer.frame = self.bounds;
    layer.path = [self circlePath].CGPath;
    [self.layer addSublayer:layer];
    
    CAShapeLayer *_shapeLayer = [CAShapeLayer layer];
    // 填充颜色
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    // 绘制颜色
    _shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    _shapeLayer.lineCap = kCALineCapRound;
    _shapeLayer.lineJoin = kCALineJoinRound;
    _shapeLayer.lineWidth = 4;
    _shapeLayer.frame = self.bounds;
    _shapeLayer.path =  [self arcPath].CGPath;
    [self.layer addSublayer:_shapeLayer];

    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basic.duration = drawTime;
    basic.fromValue = @(0);
    basic.toValue =@(1);
    basic.removedOnCompletion = NO;
    basic.fillMode = kCAFillModeForwards;
    [_shapeLayer addAnimation:basic forKey:@"basic"];
    
    
}
//圆
- (UIBezierPath *)circlePath
{
    return [UIBezierPath bezierPathWithOvalInRect:self.bounds];
}
//圆弧
- (UIBezierPath *)arcPath
{
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:self.frame.size.width/2 startAngle:M_PI*2-90 endAngle:M_PI*4-90 clockwise:YES];
}

-(void)showWithTime:(NSInteger)time{
    _time = time;
    
    title.text = [NSString stringWithFormat:@"%lds跳过",(long)time];

    [self drawAction:time];
//    [self createUI];
    
    if(_countTimer){
        [_countTimer invalidate];
    }
    _countTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countAction) userInfo:nil repeats:YES];
}
-(void)countAction{
    _time -= 1;
    title.text = [NSString stringWithFormat:@"%lds跳过",(long)_time];
    if(_time<1){
        [self countFinishedAction];
    }
}

-(void)end{
    if(_countTimer){
        [_countTimer invalidate];
    }
}
-(void)countFinishedAction{
    
    [_countTimer invalidate];
    if(self.countFinished){
        self.countFinished();
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self countFinishedAction];
}

@end
