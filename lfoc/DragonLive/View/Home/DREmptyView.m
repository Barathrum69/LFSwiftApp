//
//  DREmptyView.m
//  DragonLive
//
//  Created by 11号 on 2021/1/12.
//

#import "DREmptyView.h"

@interface DREmptyView ()

@property (nonatomic,assign) DREmptyType emptyType;
@property (nonatomic, copy) void (^refreshBlock)(void);

@end

@implementation DREmptyView

- (id)initWithFrame:(CGRect)frame type:(DREmptyType)emptyType
{
    self = [super initWithFrame:frame];
    if (self) {
        if (emptyType == DREmptyDataType) {
            [self setupEmptyUI];
        }else {
            [self setupErrorUI];
        }
    }
    
    return self;
}

- (void)setupEmptyUI
{
    UIImageView *emptyImgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 123) * 0.5, (self.frame.size.height - 104) * 0.5 - 30, 123, 104)];
    emptyImgView.image = [UIImage imageNamed:@"icon_kongshuju"];
    [self addSubview:emptyImgView];
    
    UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(emptyImgView.frame)+10, self.frame.size.width, 14) ];
    noticeLabel.font = [UIFont systemFontOfSize:12];
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    noticeLabel.text = @"暂无数据";
    [self addSubview:noticeLabel];
    
}

- (void)setupErrorUI
{
    UIImageView *errorImgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 98) * 0.5, (self.frame.size.height - 91) * 0.5 - 50, 98, 91)];
    errorImgView.image = [UIImage imageNamed:@"network_error"];
    [self addSubview:errorImgView];
    
    UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(errorImgView.frame)+10, self.frame.size.width, 14) ];
    noticeLabel.font = [UIFont systemFontOfSize:12];
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    noticeLabel.text = @"当前网络信号较差，请稍后刷新试试";
    [self addSubview:noticeLabel];
    
    UIButton *refreshBut = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - 58) * 0.5, CGRectGetMaxY(errorImgView.frame)+34, 58, 24)];
    refreshBut.titleLabel.font = [UIFont systemFontOfSize:10];
    [refreshBut setTitle:@"点击刷新" forState:UIControlStateNormal];
    [refreshBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [refreshBut setBackgroundColor:[UIColor colorWithHexString:@"#F67C37"]];
    [refreshBut addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    refreshBut.layer.cornerRadius = 3;
    refreshBut.layer.masksToBounds = YES;
    [self addSubview:refreshBut];
}

- (void)refreshAction
{
    if (self.refreshBlock) {
        self.refreshBlock();
    }
}

+ (DREmptyView *)showEmptyInView:(UIView *)superview emptyType:(DREmptyType)type refresh:(nullable void (^)(void))refresh
{
    [DREmptyView hiddenEmptyInView:superview];
    
    DREmptyView *emptyView = [[DREmptyView alloc] initWithFrame:CGRectMake(0, (superview.frame.size.height - 200) * 0.5, superview.frame.size.width, 200) type:type];
    [superview addSubview:emptyView];
//    emptyView.userInteractionEnabled = NO;
    [emptyView showView];
    if (refresh) {
        emptyView.refreshBlock = refresh;
    }
    
    return emptyView;
}

+ (DREmptyView *)showEmptyInView:(UIView *)superview emptyType:(DREmptyType)type
{
    return [self showEmptyInView:superview emptyType:type refresh:nil];
}

- (void)showView
{
    self.alpha = 0.2 ;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1 ;
    }] ;
}

+ (void)hiddenEmptyInView:(UIView *)superView
{
    
    NSAssert([NSThread isMainThread], @"needs to be accessed on the main thread.");
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
        });
    }
    
    NSEnumerator *subviewsEnum = [superView.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            DREmptyView *emptyView = (DREmptyView *)subview ;
            [UIView animateWithDuration:.3 animations:^{
                emptyView.alpha = 0.2 ;
            } completion:^(BOOL finished) {
                [emptyView removeFromSuperview];
            }] ;
        }
    }
}

@end
