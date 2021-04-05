//
//  LCBannerView.m
//  cecece
//
//  Created by 刘璇 on 2020/8/20.
//  Copyright © 2020 ChangSong. All rights reserved.
//

#import "LCBannerView.h"
#import <UIImageView+WebCache.h>
#import "CyclePageControl.h"

@interface LCBannerView()<UIScrollViewDelegate,UITableViewDelegate>
@property (nonatomic,strong)UIScrollView *scrollView;
//三个视图的集合
@property (nonatomic,strong)NSMutableArray<UIImageView *> *viewArray;
//定时器
@property (nonatomic,strong)NSTimer *timer;

//配置信息类
@property (nonatomic,strong,readwrite)LCBannerConfig *config;

//滚动视图的宽度  根据自身视图的宽度减去左右两边的间距
@property (nonatomic,assign)CGFloat scrollViewW;

//滚动视图的高度  根据自身视图的高度减去上下两边的间距
@property (nonatomic,assign)CGFloat scrollViewH;

//小圆点
@property (nonatomic,strong)CyclePageControl *pageControl;

@end
@implementation LCBannerView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.config = [[LCBannerConfig alloc]init];
    }
    return self;
}


/// 设置scrollview的frame
-(void)createSubViewFrame{
    self.scrollViewW = self.frame.size.width - self.config.scrollViewEdges.left - self.config.scrollViewEdges.right;
    
    self.scrollViewH = self.frame.size.height - self.config.scrollViewEdges.top - self.config.scrollViewEdges.bottom;
    
    self.backgroundColor = self.config.backGroundColor;
    
    if (self.config.singleScroll == NO && [self.dataSource numberOfCount] == 1) {
        self.scrollView.scrollEnabled = NO;
    }else{
        self.scrollView.scrollEnabled = YES;
    }
    
}

-(void)reloadData{
    [self createSubViewFrame];
    NSInteger num = [self.dataSource numberOfCount];
    //如果没有数据则不加载后续内容
    if (num == 0) {
        return;
    }
    self.viewArray = [NSMutableArray arrayWithCapacity:3];
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i<3; i++) {
        UIImageView * imageView = [UIImageView new];
        [self.scrollView addSubview:imageView];
        imageView.contentMode = self.config.imageViewContentMode;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchAction:)]];
        imageView.frame = CGRectMake(i * self.scrollViewW, 0, self.scrollViewW, self.scrollViewH);
//        imageView.layer.cornerRadius = self.config.scrollViewRadius;
//        imageView.layer.masksToBounds = YES;
//        imageView.clipsToBounds = YES;
        
        if (i == 0) {
            imageView.tag = MAX(num-1, 0);
        }else if (i == 2){
            imageView.tag = MIN(1, num-1);
        }else{
            imageView.tag = 0;
        }

        [self.viewArray addObject:imageView];
        
        [self getImagePathWithImageView:imageView];
    }
    
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollViewW, 0) animated:NO];
    //开启定时器
    [self startTimer];
    //添加小圆点
    [self initPageControl];
}

#pragma mark ----------------------------
#pragma mark 设置图片内容
-(void)getImagePathWithImageView:(UIImageView *)imageView{
    BannerModel *bannerModel = [self.dataSource bannerView:self imageForIndex:imageView.tag];
    if (bannerModel) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:bannerModel.contentUrl] placeholderImage:[UIImage imageNamed:@"video_img_bg"]];
    }
    
//    [imageView sd_setImageWithURL:[NSURL URLWithString:bannerModel.contentUrl] placeholderImage:[UIImage imageNamed:@"video_img_bg"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        if (image) {
//            NSLog(@"广告图片加载完成");
//        }else {
//            NSLog(@"广告图片加载失败");
//        }
//    }];
}

#pragma mark ----------------------------
#pragma mark 点击后的交互
-(void)touchAction:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(bannerView:didSelect:)]) {
        [self.delegate bannerView:self didSelect:tap.view.tag];
    }
}
#pragma mark ----------------------------
#pragma mark 定时器相关
-(void)startTimer{
    if (self.config.autoScroll == NO) {
        return;
    }
    
    if (self.config.singleScroll == NO && [self.dataSource numberOfCount] == 1) {
        return;
    }
    
    
    if (self.timer) {
        [self stopTimer];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.config.animationTime repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollViewW*2, 0) animated:YES];

    }];
}
-(void)stopTimer{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark ----------------------------
#pragma mark 滚动视图相关
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        [self addSubview:_scrollView];
        [self sendSubviewToBack:_scrollView];
        _scrollView.frame = CGRectMake(self.config.scrollViewEdges.left, self.config.scrollViewEdges.top, self.scrollViewW, self.scrollViewH);
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(3 * self.scrollViewW, 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.layer.cornerRadius = self.config.scrollViewRadius;
        _scrollView.layer.masksToBounds = YES;
    }
    return _scrollView;
}
-(void)resetScrollview:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x / self.scrollViewW;
    
    NSInteger num = [self.dataSource numberOfCount];

    
    UIImageView * view = self.viewArray[page];
    NSInteger tag = view.tag;
    NSInteger lastTag = tag-1 < 0 ? (num-1) : (tag-1);
    NSInteger nextTag = tag+1 == num ? 0 : (tag+1);
        
    self.viewArray[0].tag = lastTag;
    [self getImagePathWithImageView:self.viewArray[0]];

    self.viewArray[1].tag = tag;
    [self getImagePathWithImageView:self.viewArray[1]];
    self.pageControl.currentPage = tag;

    self.viewArray[2].tag = nextTag;
    [self getImagePathWithImageView:self.viewArray[2]];

    [self.scrollView setContentOffset:CGPointMake(self.scrollViewW, 0) animated:NO];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self resetScrollview:scrollView];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self resetScrollview:scrollView];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
}


#pragma mark ----------------------------
#pragma mark 小圆点的初始化
-(void)initPageControl{
    [self.pageControl removeFromSuperview];
    self.pageControl = nil;
    
    CGFloat width = [self.dataSource numberOfCount]*(dotW+margin);
    CGFloat hei = dotW + marginTopDown + marginTopDown;
    self.pageControl = [[CyclePageControl  alloc] initWithFrame:CGRectMake(self.frame.size.width - width - 10, self.frame.size.height - hei - self.config.pageControlBottomDistance , width, hei)];
    [self addSubview:self.pageControl];
    
//    CGFloat height = 30;
//    CGFloat y = self.frame.size.height - height - self.config.pageControlBottomDistance;
//    if (self.config.pageControllerShowType == PageControlShowTypeFit) {
//        CGFloat width = self.frame.size.width - self.config.scrollViewEdges.left - self.config.scrollViewEdges.right;
//        self.pageControl.frame = CGRectMake(self.config.scrollViewEdges.left, y , width, height);
//    }else{
//        self.pageControl.frame = CGRectMake(0, y , self.frame.size.width, height);
//    }
    
    //当有圆角的时候，要设置小圆点的圆角
//    if (self.config.pageControllerShowType == PageControlShowTypeFit && self.config.scrollViewRadius > 0) {
//        UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.pageControl.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(self.config.scrollViewRadius, self.config.scrollViewRadius)];
//        CAShapeLayer* shape = [[CAShapeLayer alloc] init];
//        [shape setPath:rounded.CGPath];
//
//        self.pageControl.layer.mask = shape;
//    }
    
    
    self.pageControl.pageControlSelectColor = self.config.pageControlSelectColor;
    self.pageControl.pageControlNormalColor = self.config.pageControlNormalColor;
    self.pageControl.backgroundColor = self.config.pageControlBackGroundColor;
    
    self.pageControl.numberOfPages = [self.dataSource numberOfCount];
    
    
    self.pageControl.hidden = (self.config.showPageController == NO ||
                               (self.config.showPageControllerInSingle == NO && ([self.dataSource numberOfCount]==1)));
    
    
}

@end
