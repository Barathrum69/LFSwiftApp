//
//  DRSearchBar.m
//  DragonLive
//
//  Created by 11号 on 2020/12/16.
//

#import "DRSearchBar.h"

@interface DRSearchBar ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation DRSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.contentView];
        [self addSubview:self.cancelButton];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(NSString *)text
{
    return _textField.text;
}

-(void)setText:(NSString *)text
{
    _textField.text = text?:@"";
}

/**
 * 设置字体大小
 */
-(void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    [_textField setFont:_textFont];
}

/**
 * 设置边框样式
 */
-(void)setTextBorderStyle:(UITextBorderStyle)textBorderStyle{
    _textBorderStyle = textBorderStyle;
    _textField.borderStyle = textBorderStyle;
}

/**
 * 设置textColor
 */
-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    [_textField setTextColor:_textColor];
}

/**
 * 设置iconImage
 */
-(void)setIconImage:(UIImage *)iconImage{
    _iconImage = iconImage;
    ((UIImageView*)_textField.leftView).image = _iconImage;
}

/**
 * 设置placeholder
 */
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    _textField.placeholder = placeholder;
}

/**
 * 设置背景图片
 */
-(void)setBackgroundImage:(UIImage *)backgroundImage{
    _backgroundImage = backgroundImage;
    
}

/**
 * 设置TextFiled的键盘样式
 */
-(void)setKeyboardType:(UIKeyboardType)keyboardType{
    _keyboardType = keyboardType;
    _textField.keyboardType = _keyboardType;
}

/**
 * 设置TextFiled的inputView
 */
-(void)setInputView:(UIView *)inputView{
    _inputView = inputView;
    _textField.inputView = _inputView;
}

/**
 * 设置TextFiled的inputAccessoryView
 */
-(void)setInputAccessoryView:(UIView *)inputAccessoryView{
    _inputAccessoryView = inputAccessoryView;
    _textField.inputAccessoryView = _inputAccessoryView;
}

/**
 * 设置placeholderColor
 */
-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    NSAssert(_placeholder, @"Please set placeholder before setting placeholdercolor");
    
    if ([[[UIDevice currentDevice] systemVersion] integerValue] < 6)
    {
        [_textField setValue:_placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    else
    {
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:placeholderColor}];
    }
}

- (BOOL)becomeFirstResponder
{
    return [_textField becomeFirstResponder];
}

/**
 * 响应事件
 */
-(BOOL)resignFirstResponder
{
    return [_textField resignFirstResponder];
}

/**
 * 取消按钮
 */
-(void)cancelButtonTouched
{
    _textField.text = @"";
    [_textField resignFirstResponder];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)])
    {
        [self.delegate searchBarCancelButtonClicked:self];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
        [self.delegate searchBar:self textDidChange:@""];
    }
}

/**
 * 样式
 */
-(void)setAutoCapitalizationMode:(UITextAutocapitalizationType)type
{
    _textField.autocapitalizationType = type;
}

//开始输入动画
- (void)textFieldBeginAnimation
{
    [UIView animateWithDuration:0.1 animations:^{
        self.cancelButton.hidden = NO;
        self.contentView.frame = CGRectMake(20, 0, self.frame.size.width - 20 - 60, self.frame.size.height);
    }];
}

//结束输入动画
- (void)textFieldEndAnimation
{
    [UIView animateWithDuration:0.1 animations:^{
        self.cancelButton.hidden = YES;
        self.contentView.frame = CGRectMake(20, 0, self.frame.size.width - 20*2, self.frame.size.height);
    }];
}

#pragma --mark textfield delegate
/**
 * textField应该输入时调用
 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    [self textFieldBeginAnimation];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)])
    {
        return [self.delegate searchBarShouldBeginEditing:self];
    }
    return YES;
}

/**
 * textField开始输入时调用
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarTextDidBeginEditing:)])
    {
        [self.delegate searchBarTextDidBeginEditing:self];
    }
}

/**
 * textField应该结束时输入时调用
 */
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{

    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)])
    {
        return [self.delegate searchBarShouldEndEditing:self];
    }
    return YES;
}

/**
 * textField结束输入时调用
 */
- (void)textFieldDidEndEditing:(UITextField *)textField
{

//    [self textFieldEndAnimation];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarTextDidEndEditing:)])
    {
        [self.delegate searchBarTextDidEndEditing:self];
    }
}

/**
 * 监听textField值的变化
 */
-(void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 20) {
        textField.text = [textField.text substringToIndex:20];
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:textDidChange:)])
    {
        [self.delegate searchBar:self textDidChange:textField.text];
    }
}

/**
 * 改变值
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:shouldChangeTextInRange:replacementText:)])
    {
        return [self.delegate searchBar:self shouldChangeTextInRange:range replacementText:string];
    }
    return YES;
}

/**
 * 清空textField的值
 */
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:textDidChange:)])
    {
        [self.delegate searchBar:self textDidChange:@""];
    }
    return YES;
}

/**
 * 应该返回textField的值
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_textField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarSearchButtonClicked:)])
    {
        [self.delegate searchBarSearchButtonClicked:self];
    }
    return YES;
}

#pragma Mark - 懒加载
- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _cancelButton.frame = CGRectMake(self.frame.size.width-60, 0, 55, self.frame.size.height);
        [_cancelButton addTarget:self
                          action:@selector(cancelButtonTouched)
                forControlEvents:UIControlEventTouchUpInside];
//        _cancelButton.backgroundColor = [UIColor greenColor];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:UIControlStateNormal];
        _cancelButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    }
    return _cancelButton;
}

- (UIView *)contentView
{
    if (!_contentView) {
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width - 20 - 60, self.frame.size.height)];
        contentView.layer.cornerRadius = 5.0f;
        contentView.layer.masksToBounds = YES;
        contentView.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
        _contentView = contentView;
        
        UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_search"]];
        iconView.frame = CGRectMake(9, 5, 20, 20);
        [contentView addSubview:iconView];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(39, 0, CGRectGetWidth(contentView.frame) - 39, CGRectGetHeight(contentView.frame))];
        textField.delegate = self;
        textField.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
//        _textField.borderStyle = UITextBorderStyleNone;
//        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.returnKeyType = UIReturnKeySearch;
//        _textField.enablesReturnKeyAutomatically = YES;
        textField.font = [UIFont systemFontOfSize:13.0f];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [textField addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
        [contentView addSubview:textField];
        _textField = textField;
//        _textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        //for dspa
//        _textField.layer.cornerRadius = 5.0f;
//        _textField.layer.masksToBounds = YES;
//        _textField.layer.borderColor = [[UIColor colorWithWhite:0.783 alpha:1.000] CGColor];
//        _textField.layer.borderWidth = 0.5f;
//        _textField.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
//        UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_search"]];
//        iconView.contentMode = UIViewContentModeScaleAspectFit;
//        _textField.leftView = iconView;
//        _textField.leftViewMode =  UITextFieldViewModeAlways;
    }
    
    return _contentView;
}
@end
