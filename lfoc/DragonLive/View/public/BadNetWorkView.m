//
//  BadNetWorkView.m
//  DragonLive
//
//  Created by LoaA on 2021/1/20.
//

#import "BadNetWorkView.h"

@implementation BadNetWorkView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = The_MainColor;
        [self initView];
    }
    return self;
}

-(void)initView
{
    UIImageView *image_bg = [[UIImageView alloc]initWithFrame:CGRectMake((self.width-kWidth(102))/2, kWidth(309), kWidth(102), kWidth(95))];
    [image_bg setImage:[UIImage imageNamed:@"badNetWork"]];
    [self addSubview:image_bg];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, image_bg.bottom+kWidth(13), self.width, 11)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor colorFromHexString:@"333333"];
    lab.text = @"无网络连接,请检查您的网络设置";
    lab.font = [UIFont systemFontOfSize:kWidth(10)];
    [self addSubview:lab];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((self.width-kWidth(57))/2, lab.bottom+kWidth(13), kWidth(57), kWidth(25))];
    btn.backgroundColor = SelectedBtnColor;
    btn.titleLabel.font = [UIFont systemFontOfSize:kWidth(10)];
    [btn setTitle:@"去检查" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

-(void)btnOnClick
{
    if (self.refreshBlock) {
        self.refreshBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
