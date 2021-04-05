//
//  LeftTextRightImageBtn.m
//  DragonLive
//
//  Created by LoaA on 2020/12/14.
//

#import "LeftTextRightImageBtn.h"

@implementation LeftTextRightImageBtn

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect titleF = self.titleLabel.frame;
    CGRect imageF = self.imageView.frame;
    titleF.origin.x = (self.width - (titleF.size.width+kWidth(5)+imageF.size.width))/2;
    self.titleLabel.frame = titleF;
    imageF.origin.x = CGRectGetMaxX(titleF)+kWidth(5);
    self.imageView.frame = imageF;
}//这么常用的。你苹果系统就不能自己封装出来一个属性么？

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
