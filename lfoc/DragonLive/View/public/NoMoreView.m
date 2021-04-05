//
//  NoMoreView.m
//  DragonLive
//
//  Created by LoaA on 2021/1/20.
//

#import "NoMoreView.h"
#import "NomoreDataIcon.h"
@implementation NoMoreView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        NomoreDataIcon *icon = [[NomoreDataIcon alloc]initWithFrame:CGRectMake(0, 0, kWidth(128), kWidth(132))];
        icon.center = self.center;
        [self addSubview:icon];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
