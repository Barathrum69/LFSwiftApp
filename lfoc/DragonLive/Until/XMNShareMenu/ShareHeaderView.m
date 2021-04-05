//
//  ShareHeaderView.m
//  DragonLive
//
//  Created by LoaA on 2021/1/16.
//

#import "ShareHeaderView.h"

@implementation ShareHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 19, kScreenWidth, 15)];
    _label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    _label.backgroundColor = [UIColor clearColor];
    _label.font = [UIFont systemFontOfSize:13];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"分享至";
    [self addSubview:_label];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _label.frame = CGRectMake(0, 19, self.width, 15);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
