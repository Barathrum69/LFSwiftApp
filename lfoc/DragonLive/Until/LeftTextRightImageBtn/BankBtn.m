//
//  BankBtn.m
//  DragonLive
//
//  Created by LoaA on 2021/1/6.
//

#import "BankBtn.h"

@implementation BankBtn


-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect titleF = self.titleLabel.frame;
    CGRect imageF = self.imageView.frame;
    titleF.origin.x = 20;
    self.titleLabel.frame = titleF;
    imageF.origin.x = self.width-imageF.size.width-10;
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
