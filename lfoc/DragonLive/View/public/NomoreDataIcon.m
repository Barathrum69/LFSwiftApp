//
//  NomoreDataIcon.m
//  DragonLive
//
//  Created by LoaA on 2021/1/20.
//

#import "NomoreDataIcon.h"

@implementation NomoreDataIcon

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView];
    }
    return self;
}


-(void)initView
{
    UIImageView *image_bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.width, kWidth(108))];
    [image_bg setImage:[UIImage imageNamed:@"NomoreDataIcon"]];
    [self addSubview:image_bg];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, image_bg.bottom+kWidth(13), self.width, 11)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor colorFromHexString:@"333333"];
    lab.text = @"暂无数据";
    lab.font = [UIFont systemFontOfSize:kWidth(10)];
    [self addSubview:lab];
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
