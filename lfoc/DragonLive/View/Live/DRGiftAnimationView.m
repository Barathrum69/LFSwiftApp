//
//  DRGiftAnimationView.m
//  DragonLive
//
//  Created by 11号 on 2020/12/29.
//

#import "DRGiftAnimationView.h"
#import "RoomGift.h"
#import <UIImageView+WebCache.h>
#import <WebKit/WKWebView.h>

@interface DRGiftAnimationView ()

//@property (nonatomic, strong) UIView *contentView;
//@property (nonatomic, strong) UILabel *fromNameLab;             //送礼人昵称
//@property (nonatomic, strong) UIImageView *gifImgView;          //gif图片

@end

@implementation DRGiftAnimationView

+ (void)showGiftAnimationInWindow:(RoomGift *)giftModel fromName:(NSString *)fromName
{
    DRGiftAnimationView *animationView = [[DRGiftAnimationView alloc] initWithFrame:CGRectMake(0, 0, kkScreenWidth, 51)];
    animationView.backgroundColor = [UIColor clearColor];
    [animationView setUIWith:giftModel fromName:fromName];
}

- (void)setUIWith:(RoomGift *)giftModel fromName:(NSString *)fromName
{
    CGFloat animationH = 51.0;
    CGFloat animationTop;
    if ([self isOrientationLandscape]) {
        NSInteger count = kkScreenHeight / animationH - 1;
        int random = arc4random() % count;
        animationTop = 20 + random * animationH;
    }else {
        //竖屏在聊天室区域随机出现
        CGFloat topH = 270;
        CGFloat downH = 50;
        NSInteger count = (kkScreenHeight - topH - downH) / animationH - 1;
        int random = arc4random() % count;
        animationTop = kStatusBarHeight + topH + random * animationH;
    }
    self.frame = CGRectMake(0, animationTop, kkScreenWidth, 51);
    
    [[UntilTools topViewController].view addSubview:self];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(-245, 0, 245, self.size.height)];
    [self addSubview:contentView];
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 11, 245, 29)];
    bgImgView.image = [UIImage imageNamed:@"livegif_bg"];
    [contentView addSubview:bgImgView];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 83, 47)];
    nameLab.textAlignment = NSTextAlignmentRight;
    nameLab.font = [UIFont boldSystemFontOfSize:13];
    nameLab.textColor = [UIColor whiteColor];
    nameLab.text = fromName;
//    nameLab.numberOfLines = 0; // 最关键的一句
    [contentView addSubview:nameLab];
    
//    CGFloat hei = [fromName boundingRectWithSize:CGSizeMake(75, 100) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:13]} context:nil].size.height;
//    if (hei > 40) { //超过一行时缩小字体显示
//        nameLab.font = [UIFont boldSystemFontOfSize:8];
//    }
    
    UILabel *songLab = [[UILabel alloc] initWithFrame:CGRectMake(93, 0, 12, 51)];
    songLab.font = [UIFont boldSystemFontOfSize:10];
    songLab.textColor = [UIColor colorWithHexString:@"#FBFF87"];
    songLab.text = @"送";
    [contentView addSubview:songLab];
    
    UIImageView *numImgView = [[UIImageView alloc] initWithFrame:CGRectMake(170, 12, 48, 27)];
    numImgView.image = [self getGiftNumImage:giftModel.giftNum];
    [contentView addSubview:numImgView];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(112, 0, 48, 48)];
    webView.backgroundColor = [UIColor clearColor];
    [contentView addSubview:webView];
//    webView.scalesPageToFit = YES;
    NSURL *url = [NSURL URLWithString:giftModel.giftCgi];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];

//    UIImageView *gifImgView = [[UIImageView alloc] initWithFrame:CGRectMake(112, 0, 51, 51)];
//    [contentView addSubview:gifImgView];
//    [gifImgView sd_internalSetImageWithURL:[NSURL URLWithString:giftModel.giftCgi] placeholderImage:nil options:SDWebImageRetryFailed context:nil setImageBlock:nil progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
//        gifImgView.image = [UIImage sd_imageWithGIFData:data];
//    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat leading = 0;
        if ([self isOrientationLandscape] && kIs_iPhoneX) {     //有刘海的全屏左边留出安全区域
            leading = kTopBarSafeHeight;
        }
        contentView.frame = CGRectMake(leading, 0, 245, 51);
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:[giftModel.duration doubleValue] block:^(NSTimer * _Nonnull timer) {
        [self removeFromSuperview];
    } repeats:NO];
}

- (UIImage *)getGiftNumImage:(NSString *)giftNum
{
    NSString *imgName = [NSString stringWithFormat:@"gift_Num_%ld",(long)[giftNum integerValue]];
    UIImage *img = [UIImage imageNamed:imgName];
    
    return img;
}

- (BOOL)isOrientationLandscape
{
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return YES;
    }
    return NO;
}

@end
