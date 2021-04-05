//
//  DRSVGAnimationView.m
//  DragonLive
//
//  Created by 11号 on 2020/12/29.
//

#import "DRSVGAnimationView.h"
#import "RoomGift.h"
#import "SVGA.h"

@interface DRSVGAnimationView ()<SVGAPlayerDelegate>

@end

@implementation DRSVGAnimationView

+ (void)showSVGAnimationInWindow:(RoomGift *)giftModel fromName:(NSString *)fromName
{
    DRSVGAnimationView *animationView = [[DRSVGAnimationView alloc] initWithFrame:CGRectMake(0, 0, kkScreenWidth, kkScreenHeight)];
    animationView.backgroundColor = [UIColor clearColor];
    animationView.userInteractionEnabled = NO;
    
    [[UntilTools topViewController].view addSubview:animationView];
    
    if (![animationView isOrientationLandscape]) {
        [animationView setSVGView:giftModel];
    }
//    [animationView setSVGView:giftModel];
    [animationView setTopView:giftModel fromName:fromName];
}

- (void)setTopView:(RoomGift *)giftModel fromName:(NSString *)fromName
{
//    CGFloat topWidth = kkScreenWidth;
//    if ([self isOrientationLandscape]) {
//        topWidth = kkScreenWidth * 0.6;
//    }
//
    //最多显示6个
//    if (fromName.length > 6) {
//        fromName = [fromName substringToIndex:6];
//    }
    
    int random = arc4random() % 4;
    CGFloat topSpace = kStatusBarHeight + 40 + random * 50;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(kkScreenWidth, topSpace, kkScreenWidth, 50)];
    [self addSubview:topView];
    
    UIImageView *giftIconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, -15, 80, 80)];
    [giftIconImgView sd_setImageWithURL:[NSURL URLWithString:giftModel.banner]];
    [topView addSubview:giftIconImgView];
    
    UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake(90, (topView.frame.size.height - 24) * 0.5, topView.frame.size.width - 90, 24)];
    [topView addSubview:contentLab];
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 赠送给 主播 %@个%@",fromName,giftModel.giftNum,giftModel.propName]];
    
    //用户名
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(0, fromName.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, fromName.length)];
    
    //赠送给
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(fromName.length+1, 3)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FCE04E"] range:NSMakeRange(fromName.length+1, 3)];
    
    //主播
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(fromName.length+5, 2)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(fromName.length+5, 2)];
    
    //几个礼物
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(fromName.length+8, giftModel.giftNum.length+1+giftModel.propName.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FCE04E"] range:NSMakeRange(fromName.length+8, giftModel.giftNum.length+1+giftModel.propName.length)];
    contentLab.attributedText = attributedStr;
        
    CGSize size = [attributedStr boundingRectWithSize:CGSizeMake(1000, 24) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    contentLab.frame = CGRectMake(contentLab.x, contentLab.y, size.width + 30, contentLab.height);
    topView.frame = CGRectMake(kkScreenWidth, topSpace, contentLab.width+90, topView.height);
    [self setTopGradientLayer:topView];
    
    CGFloat animationDura = [self isOrientationLandscape] ? 9.0 : 6.0;
    CGFloat originX = topView.width > kkScreenWidth ? topView.width : kkScreenWidth;
    [UIView animateWithDuration:animationDura animations:^{
//        CGFloat leading = 0;
//        if ([self isOrientationLandscape] && kIs_iPhoneX) {     //有刘海的全屏左边留出安全区域
//            leading = kTopBarSafeHeight;
//        }
        [topView setOrigin:CGPointMake(-originX, topView.y)];
    } completion:^(BOOL finished) {
        //如果横屏只有横幅显示时，在动画结束后移除self
        if ([self isOrientationLandscape]) {
            [self removeFromSuperview];
        }
    }];
    
    
}

- (void)setSVGView:(RoomGift *)giftModel
{
    CGRect svgRect = CGRectMake(0, 0, kkScreenWidth, kkScreenHeight);
    
    if ([self isOrientationLandscape]) {  //横屏时缩小svg显示范围
        svgRect = CGRectMake((kkScreenWidth - 300) * 0.5, 0, 300, 300);
    }
    SVGAPlayer *aPlayer = [[SVGAPlayer alloc] initWithFrame:svgRect];
    [self addSubview:aPlayer];
    aPlayer.loops = 1;
    aPlayer.delegate = self;
    aPlayer.clearsAfterStop = YES;
    aPlayer.userInteractionEnabled = NO;
    SVGAParser *parser = [[SVGAParser alloc] init];
    parser.enabledMemoryCache = YES;
    [parser parseWithURL:[NSURL URLWithString:giftModel.giftCgi] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        if (videoItem != nil) {
            aPlayer.videoItem = videoItem;
            [aPlayer startAnimation];
        }else {
            [self removeFromSuperview];
        }
    } failureBlock:^(NSError * _Nullable error) {
        [self removeFromSuperview];
    }];
    
//    [NSTimer scheduledTimerWithTimeInterval:[giftModel.duration doubleValue] block:^(NSTimer * _Nonnull timer) {
//        [self removeFromSuperview];
//    } repeats:NO];
}

#pragma - mark SVGAPlayer Delegate
- (void)svgaPlayerDidAnimatedToPercentage:(CGFloat)percentage {
    
}

- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player {
    [self removeFromSuperview];
}

- (BOOL)isOrientationLandscape
{
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return YES;
    }
    return NO;
}

- (void)setTopGradientLayer:(UIView *)topView
{
    //横幅背景三种颜色随机取
    NSArray *array0 = @[(__bridge id)[[UIColor colorWithHexString:@"#9D7DFD"] colorWithAlphaComponent:1.0].CGColor, (__bridge id)[[UIColor colorWithHexString:@"#CCB4FF"] colorWithAlphaComponent:0.7].CGColor];
    NSArray *array1 = @[(__bridge id)[[UIColor colorWithHexString:@"#FF8EB7"] colorWithAlphaComponent:1.0].CGColor, (__bridge id)[[UIColor colorWithHexString:@"#FFC1DC"] colorWithAlphaComponent:0.7].CGColor];
    NSArray *array2 = @[(__bridge id)[[UIColor colorWithHexString:@"#4ECFFF"] colorWithAlphaComponent:1.0].CGColor, (__bridge id)[[UIColor colorWithHexString:@"#86E9FF"] colorWithAlphaComponent:0.7].CGColor];
    NSArray *colorArr = @[array0,array1,array2];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = colorArr[(arc4random()%3)];
    gradientLayer.locations = @[@0.3, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(46.0, (topView.frame.size.height - 24) * 0.5, topView.frame.size.width - 50, 24);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:gradientLayer.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:gradientLayer.bounds.size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = gradientLayer.bounds;
    maskLayer.path = maskPath.CGPath;
    gradientLayer.mask = maskLayer;
    [topView.layer insertSublayer:gradientLayer atIndex:0];
}

@end
