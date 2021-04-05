//
//  CommentNoMoreView.m
//  DragonLive
//
//  Created by LoaA on 2021/1/20.
//

#import "CommentNoMoreView.h"
#import "CommentNoral.h"
@implementation CommentNoMoreView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        CommentNoral *icon = [[CommentNoral alloc]initWithFrame:CGRectMake(0, 0, kWidth(156), kWidth(148))];
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
