//
//  ApplyAnchorIdCardView.m
//  DragonLive
//
//  Created by LoaA on 2020/12/29.
//

#import "ApplyAnchorIdCardView.h"
@interface ApplyAnchorIdCardView()
/// titleLabel
@property (nonatomic, strong) UILabel *titleLabel;

/// title
@property (nonatomic,copy) NSString *title;

/// placeholder
@property (nonatomic,copy) NSString *imageNamed;

@end
@implementation ApplyAnchorIdCardView
/// 初始化
/// @param frame frame
/// @param title title
/// @param imageNamed 图片名
-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title imageNamed:(NSString *)imageNamed
{
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        _imageNamed = imageNamed;
        [self initView];
    }
    return self;
}

-(void)initView
{
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth(37), 0, kWidth(200), kWidth(13))];
    _titleLabel.text = _title;
    _titleLabel.textColor = [UIColor colorFromHexString:@"999999"];
    _titleLabel.font = [UIFont systemFontOfSize:kWidth(13)];
    [self addSubview:_titleLabel];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-kWidth(240))/2, _titleLabel.bottom+kWidth(8), kWidth(240), kWidth(136))];
    [_imageView setImage:[UIImage imageNamed:_imageNamed]];
    _imageView.userInteractionEnabled = YES;
    [self addSubview:_imageView];
    
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(_imageView.width-kWidth(32), kWidth(10), kWidth(22), kWidth(22))];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"cancelBtnBg"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cleanTheImage) forControlEvents:UIControlEventTouchUpInside];
    [_imageView addSubview:cancelBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [_imageView addGestureRecognizer:tap];
    
}


-(void)tap
{
    NSLog(@"111");
    if (self.selectedThumbBlock) {
        self.selectedThumbBlock(self);
    }
}


-(void)cleanTheImage
{
    _isSelected = NO;
    [_imageView setImage:[UIImage imageNamed:_imageNamed]];
    _imageUrl = @"";
    NSLog(@"2222");
    
    if (self.cancelBlock) {
        self.cancelBlock();
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
