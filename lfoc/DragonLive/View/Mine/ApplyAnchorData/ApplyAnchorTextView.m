//
//  ApplyAnchorTextView.m
//  DragonLive
//
//  Created by LoaA on 2020/12/28.
//

#import "ApplyAnchorTextView.h"
#import "LeftRightTextField.h"
@interface ApplyAnchorTextView ()

/// titleLabel
@property (nonatomic, strong) UILabel *titleLabel;

/// title
@property (nonatomic,copy) NSString *title;

/// placeholder
@property (nonatomic,copy) NSString *placeholder;

@end

@implementation ApplyAnchorTextView
-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title placeholder:(NSString *)placeholder
{
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        _placeholder = placeholder;
        [self initView];
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

-(void)initView
{
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth(37), kWidth(20), kWidth(200), kWidth(13))];
    _titleLabel.text = _title;
    _titleLabel.textColor = [UIColor colorFromHexString:@"999999"];
    _titleLabel.font = [UIFont systemFontOfSize:kWidth(13)];
    
    [self addSubview:_titleLabel];
    
    _textField = [[LeftRightTextField alloc]initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom+kWidth(11), kScreenWidth-kWidth(37*2), kWidth(44))];
    _textField.placeholder = _placeholder;
    _textField.font = [UIFont systemFontOfSize:kWidth(13)];
    UIView *left = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth(15), 20)];
    _textField.leftView = left;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    
    _textField.layer.borderColor = [UIColor colorFromHexString:@"ECECEC"].CGColor;
    _textField.layer.borderWidth = 1;
    [self addSubview:_textField];
    
   
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
