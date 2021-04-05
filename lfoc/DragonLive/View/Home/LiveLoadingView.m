//
//  LiveLoadingView.m
//  DragonLive
//
//  Created by 11号 on 2021/1/12.
//

#import "LiveLoadingView.h"

@interface LiveLoadingView ()

@property (nonatomic, weak) IBOutlet UIView *centerView;
@property (nonatomic, weak) IBOutlet UILabel *noticeLab;
@property (nonatomic, strong) UIView *animationView;
@property (nonatomic, copy) RetryOnClickBlock retryOnClickBlock;


@end

@implementation LiveLoadingView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}
- (IBAction)retryOnClick:(id)sender {
    
    if (self.retryOnClickBlock) {
        self.retryOnClickBlock();
    }
    
}

+ (instancetype)lvLoadingInstance
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

- (void)layoutSubviews
{
    
}

- (UIView *)animationView
{
    if (!_animationView) {
        UIView *aniView = [[UIView alloc] initWithFrame:CGRectMake((self.size.width - 48)*0.5+4, (self.size.height - 11)*0.5, 48, 11)];
        [self addSubview:aniView];
        [aniView.layer addSublayer:[self replicatorLayer_Wave]];
        [aniView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(48);
            make.height.mas_equalTo(11);
        }];
        [aniView layoutIfNeeded];
        
        self.animationView = aniView;
    }
    return _animationView;
}

- (IBAction)retryConnectNetworkAction:(id)sender
{
    
}

-(void)setLoadingType:(LRLoadingType)loadingType block:(RetryOnClickBlock)retryOnClickBlock
{
    _retryOnClickBlock = retryOnClickBlock;
    
    switch (loadingType) {
        case LRAnimationLoadingType:
            self.backgroundColor = [UIColor clearColor];
            self.animationView.hidden = NO;
            self.centerView.hidden = YES;
            self.noticeLab.hidden = YES;
        
            break;
            
        case LRNetworkDisconnectType:
            self.backgroundColor = [UIColor blackColor];
            self.animationView.hidden = YES;
            self.centerView.hidden = NO;
            self.noticeLab.hidden = YES;
        
            break;
            
        case LRHostLivingLostType:
            self.backgroundColor = [UIColor blackColor];
            self.animationView.hidden = YES;
            self.centerView.hidden = YES;
            self.noticeLab.hidden = NO;
            self.noticeLab.text = @"主播暂时不在播";
        
            break;
            
        case LRHostLivingForbidType:
            self.backgroundColor = [UIColor blackColor];
            self.animationView.hidden = YES;
            self.centerView.hidden = YES;
            self.noticeLab.hidden = NO;
            self.noticeLab.text = @"该主播账号被禁播";
        
            break;
            
        default:
            break;
    }
}


- (void)setLoadingType:(LRLoadingType)loadingType
{
    switch (loadingType) {
        case LRAnimationLoadingType:
            self.backgroundColor = [UIColor clearColor];
            self.animationView.hidden = NO;
            self.centerView.hidden = YES;
            self.noticeLab.hidden = YES;
        
            break;
            
        case LRNetworkDisconnectType:
            self.backgroundColor = [UIColor blackColor];
            self.animationView.hidden = YES;
            self.centerView.hidden = NO;
            self.noticeLab.hidden = YES;
        
            break;
            
        case LRHostLivingLostType:
            self.backgroundColor = [UIColor blackColor];
            self.animationView.hidden = YES;
            self.centerView.hidden = YES;
            self.noticeLab.hidden = NO;
            self.noticeLab.text = @"主播暂时不在播";
        
            break;
            
        case LRHostLivingForbidType:
            self.backgroundColor = [UIColor blackColor];
            self.animationView.hidden = YES;
            self.centerView.hidden = YES;
            self.noticeLab.hidden = NO;
            self.noticeLab.text = @"该主播账号被禁播";
        
            break;
            
        default:
            break;
    }
}

// 波动动画
- (CALayer *)replicatorLayer_Wave{
    CGFloat between = 18.0;      //间距
    CGFloat radius = 11;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(0, 0, radius, radius);
    shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)].CGPath;
    shapeLayer.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8].CGColor;
    [shapeLayer addAnimation:[self scaleAnimation] forKey:@"scaleAnimation"];
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
//    replicatorLayer.frame = CGRectMake(0, 0, 30, 100);
    replicatorLayer.instanceDelay = 0.1;
    replicatorLayer.instanceCount = 3;
    replicatorLayer.instanceTransform = CATransform3DMakeTranslation(between,0,0);
    [replicatorLayer addSublayer:shapeLayer];
    
    return replicatorLayer;
}

- (CABasicAnimation *)scaleAnimation{
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    scale.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.3, 0.3, 0)];
    scale.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1, 1, 0)];
    scale.removedOnCompletion = NO;          //离开控制器了在返回继续保持动画状态
    scale.autoreverses = YES;
    scale.repeatCount = HUGE;
    scale.duration = 0.3;
    return scale;
}

@end
