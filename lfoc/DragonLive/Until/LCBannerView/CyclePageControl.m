//
//  CyclePageControl.m
//  SimpleBanner
//
//  Created by 11号 on 2021/1/2.
//

#import "CyclePageControl.h"

@implementation CyclePageControl

- (id)initWithFrame:(CGRect)frame withCount:(NSInteger)count
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

- (void)setupUI:(NSInteger)count
{
    for (NSInteger i=0; i<count; i++) {
        UIView  *dotView = [[UIView alloc] initWithFrame:CGRectMake(i*(dotW+margin), marginTopDown, dotW, dotW)];
        dotView.tag = 100 + i;
        if (i == _currentPage) {
            dotView.backgroundColor = self.pageControlSelectColor;
        }else {
            dotView.backgroundColor = self.pageControlNormalColor;
        }
        dotView.layer.mask = [self getCornersShapeLayer:dotView];
        [self addSubview:dotView];
    }
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    [self setupUI:numberOfPages];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    
    [self reloadCurrentPageView];
}

- (void)reloadCurrentPageView
{
    for (NSInteger i=0; i<self.subviews.count; i++) {
        UIView *dotView = [self.subviews objectAtIndex:i];
        if (i == _currentPage) {
            dotView.backgroundColor = self.pageControlSelectColor;
        }else {
            dotView.backgroundColor = self.pageControlNormalColor;
        }
    }
}

- (CAShapeLayer *)getCornersShapeLayer:(UIView *)contentView
{
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:contentView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(contentView.bounds.size.width * 0.5, contentView.bounds.size.height * 0.5)];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    return shape;
}

@end
