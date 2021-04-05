//
//  LiveBannerHeaderView.m
//  DragonLive
//
//  Created by 11号 on 2021/1/4.
//

#import "LiveBannerHeaderView.h"
#import "LCBannerView.h"
#import "MarqueeView.h"

@interface LiveBannerHeaderView ()<LCBannerViewDelegate,LCBannerViewDataSource>

@property (nonatomic, strong) LCBannerView *bannerView;
@property (nonatomic, strong) MarqueeView *marqueeView;

@end

@implementation LiveBannerHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    if (self.bannerView) {
        self.bannerView.delegate = nil;
        self.bannerView.dataSource = nil;
        [self.bannerView removeFromSuperview];
        self.bannerView = nil;
    }
    LCBannerView *bannerView = [[LCBannerView alloc] initWithFrame:CGRectMake(5, 6, self.size.width - 10, self.size.height - 32)];
    [self addSubview:bannerView];
    bannerView.delegate = self;
    bannerView.dataSource = self;
    bannerView.config.showPageController = YES;
    bannerView.config.scrollViewRadius = 6;
    self.bannerView = bannerView;
    
    [self.bannerView reloadData];
}

- (void)setMarqueeArray:(NSArray *)marqueeArray
{
    _marqueeArray = marqueeArray;
    
    [self addSubview:self.marqueeView];
}

-(void)bannerView:(LCBannerView *)view didSelect:(NSInteger)index{
    NSLog(@"%ld",index);
    if (self.selectedItemHelper) {
        self.selectedItemHelper(index);
    }
}

-(NSInteger)numberOfCount{
    return self.dataArray.count;
}

//返回类型为 NSString，NSUrl ， UIImage
-(id)bannerView:(LCBannerView *)bannerView imageForIndex:(NSInteger)index{
    
    if (self.dataArray.count) {
        return self.dataArray[index];
    }
    return nil;
}

#pragma Lazy Methods
- (MarqueeView *)marqueeView{

    if (_marqueeView) {
        [_marqueeView removeFromSuperview];
        _marqueeView = nil;
    }
    CGFloat top = self.size.height - 20;
    if (!self.dataArray.count || self.dataArray.count == 0) {
        top = 6;
    }
    MarqueeView *marqueeView = [[MarqueeView alloc] initWithFrame:CGRectMake(5, self.size.height - 20, self.size.width - 10, 20) withTitle:_marqueeArray];
    marqueeView.titleColor = [UIColor colorWithHexString:@"#777777"];
    marqueeView.titleFont = [UIFont systemFontOfSize:10];
    marqueeView.backgroundColor = [UIColor whiteColor];
//    __weak MarqueeView *marquee = marqueeView;
    marqueeView.handlerTitleClickCallBack = ^(NSInteger index){
        
        if (self.selectedMarquee) {
            self.selectedMarquee();
        }
    };
    _marqueeView = marqueeView;
    
    return _marqueeView;
}

@end
