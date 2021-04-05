//
//  AnchorCenterView.m
//  DragonLive
//
//  Created by LoaA on 2020/12/10.
//

#import "AnchorCenterTopView.h"
#import "AnchorHeadView.h"
#import "AnchorModel.h"
@interface AnchorCenterTopView ()

/// 主播登记等等。。
@property (nonatomic, strong) AnchorHeadView *anchorHeadView;

@end


@implementation AnchorCenterTopView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}//init


-(void)initView{
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(171))];
    img.contentMode = UIViewContentModeScaleToFill;
    [img setImage:[UIImage imageNamed:@"mine_top_view_bg"]];
    [self addSubview:img];
    
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, 44)];
    topView.backgroundColor = [UIColor clearColor];
    [self addSubview:topView];
    
    UIButton *goback = [[UIButton alloc]initWithFrame:CGRectMake(15, topView.height-kWidth(29), 40, 40)];
    [goback setBackgroundImage:[UIImage imageNamed:@"left-arrow_white"] forState:UIControlStateNormal];
    [topView addSubview:goback];
    goback.center = CGPointMake(goback.centerX, topView.height/2);
    [goback  addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
    title.textColor = [UIColor colorFromHexString:@"FFFFFF"];
    title.text = @"主播中心";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:20];
    [topView addSubview:title];
    title.center = CGPointMake(topView.centerX, topView.height/2);
    
    //主播等级
    _anchorHeadView = [[AnchorHeadView alloc]initWithFrame:CGRectMake(kWidth(27), self.height-kWidth(102), kScreenWidth-kWidth(27*2), kWidth(102))];

    [self addSubview:_anchorHeadView];
    
}//加载View

-(void)setModel:(AnchorModel *)model
{
    _model = model;
    _anchorHeadView.model = model;
}

-(void)goback
{
    if (self.gobackBlock) {
        self.gobackBlock();
    }
}//返回


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
