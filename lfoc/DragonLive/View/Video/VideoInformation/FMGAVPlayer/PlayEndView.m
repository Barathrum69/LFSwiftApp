//
//  PlayEndView.m
//  DragonLive
//
//  Created by LoaA on 2021/1/15.
//

#import "PlayEndView.h"

@implementation PlayEndView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self initView];
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)initView
{
    UIButton *btn = [[UIButton alloc]init];
    btn.size = CGSizeMake(kWidth(67), kWidth(30));
    [btn setImage:[UIImage imageNamed:@"PlayEndView"] forState:UIControlStateNormal];
    btn.center = CGPointMake(self.centerX, self.height/2-20);
    [self addSubview:btn];
    [btn addTarget:self action:@selector(btnOnClick) forControlEvents:UIControlEventTouchUpInside];
}


-(void)tap{
    if (self.tapShow) {
        self.tapShow();
    }
}


-(void)btnOnClick
{
    
    if (self.replayBtnBlock) {
        self.replayBtnBlock();
    }
    
    NSLog(@"1112121212");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
