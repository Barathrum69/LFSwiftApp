//
//  DKSKeyboardView.m
//  DKSChatKeyboard
//
//  Created by aDu on 2017/9/6.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import "DKSKeyboardView.h"
#import "DKSMoreView.h"
#import "DKSEmojiView.h"
#import "UIView+FrameTool.h"

//状态栏和导航栏的总高度
#define StatusNav_Height (isIphoneX ? 88 : 64)
/*状态栏高度*/
#define k_StatusBarHeight (CGFloat)(kIs_iPhoneX?(44.0):(20.0))
/*顶部安全区域高度*/
#define k_TopBarSafeHeight (CGFloat)(kIs_iPhoneX?(44.0):(0))
 /*底部安全区域高度*/
#define k_BottomSafeHeight (CGFloat)(kIs_iPhoneX?(34.0):(0))
//判断是否是iPhoneX
#define isIphoneX (K_Width == 375.f && K_Height == 812.f ? YES : NO)
#define K_Width [UIScreen mainScreen].bounds.size.width
#define K_Height [UIScreen mainScreen].bounds.size.height

static float viewMargin = 8.0f;             //输入框上边距和左边距
static float viewBottomHeight = 41.0f;      //输入框下面切换按钮和退格删除视图高度
static float viewHeight = 36.0f;            //输入框视图默认高度
static float bottomHeight = 250.0f;         //表情视图高度
static float bottomFullHeight = 124.0f;     //横屏时表情视图高度

@interface DKSKeyboardView ()<UITextViewDelegate,DREmojiViewDelegate>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) UIButton *emojiBtn;
@property (nonatomic, strong) UIButton *giftBtn;
@property (nonatomic, strong) UIButton *deleteBtn;                  //退格删除按钮
@property (nonatomic, strong) DKSMoreView *moreView;
@property (nonatomic, strong) DKSEmojiView *emojiView;

@property (nonatomic, assign) float keyboardHeight;                 //键盘高度
@property (nonatomic, assign) BOOL emojiClick;                      //点击表情按钮
@property (nonatomic, assign) BOOL giftClick;                       //点击礼物按钮
@property (nonatomic, assign) BOOL showKeyboard;                    //是否显示键盘
@property (nonatomic, assign) BOOL isOrientationLandscape;          //是否全屏

@end

@implementation DKSKeyboardView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        //监听键盘出现、消失
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        //此通知主要是为了获取点击空白处回收键盘的处理
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:@"keyboardHide" object:nil];
        
        //创建视图
        [self creatView];
    }
    return self;
}

- (void)creatView {
    
    [self addSubview:self.bgBtn];
    
    self.backView.frame = CGRectMake(0, 0, self.width, self.height);
    
    //输入视图
    self.textView.frame = CGRectMake(viewMargin, viewMargin, K_Width - 3 * viewMargin - viewHeight, viewHeight);
    
    //表情按钮
    self.emojiBtn.frame = CGRectMake(viewMargin, CGRectGetMaxY(self.textView.frame) + viewMargin, viewBottomHeight, viewBottomHeight);
    
    //礼物按钮
    self.giftBtn.frame = CGRectMake(CGRectGetMaxX(self.textView.frame) + viewMargin, viewMargin, viewHeight, viewHeight);
    
    //退格删除按钮
    self.deleteBtn.frame = CGRectMake(K_Width - 44, 60, 34, 22);
}

- (BOOL)isOrientationLandscape
{
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return YES;
    }
    return NO;
}

//退格删除功能，表情需要整个表情字符串清除
- (void)deleteBackward:(NSString *)text
{
    if (!text.length) {
        return ;
    }
    NSRange selRange = NSMakeRange(self.textView.selectedRange.location - 1, 1);             //退格光标
    NSString *backward = [text substringWithRange:selRange];    //退格字符
    if ([backward isEqualToString:@"]"]) {  //检测完整表情符并退格删除
        NSString *pattern = @"\\[[\u4e00-\u9fa5]+\\]";
        NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray *resultArray = [regular matchesInString:text options:0 range:NSMakeRange(0, text.length)];
        if (resultArray.count) {
            NSTextCheckingResult *result = [resultArray lastObject];
            NSRange range = result.range;
            text = [text stringByReplacingCharactersInRange:range withString:@""];
            self.textView.text = text;
            self.textView.selectedRange = NSMakeRange(range.location, 0);
        }else { //如果没有完整表情符做普通退格删除
            text = [text stringByReplacingCharactersInRange:selRange withString:@""];
            self.textView.text = text;
            self.textView.selectedRange = NSMakeRange(selRange.location, 0);
        }
    } else {
        text = [text stringByReplacingCharactersInRange:selRange withString:@""];
        self.textView.text = text;
        self.textView.selectedRange = NSMakeRange(selRange.location, 0);
    }
}

#pragma mark ====== 按钮事件 ======
- (void)emojiBtn:(UIButton *)btn {
    
    if (self.emojiClick == NO) {
        self.showKeyboard = NO;
        self.emojiClick = YES;
        [self.emojiView removeFromSuperview];
        self.emojiView = nil;
        self.deleteBtn.hidden = NO;
        [self.emojiBtn setImage:[UIImage imageNamed:@"live_keyboard"] forState:UIControlStateNormal];
        [self.textView resignFirstResponder];
        [self addSubview:self.emojiView];
        
        CGFloat emojiViewH = self.isOrientationLandscape?bottomFullHeight:bottomHeight;
        self.keyboardHeight = emojiViewH;     //切换成表情后把高度设置为表情视图高度
        [UIView animateWithDuration:0.25 animations:^{
            self.emojiView.y = self.height - emojiViewH;
            self.backView.y = self.height - emojiViewH - self.backView.height;
//            self.emojiView.frame = CGRectMake(0, self.backView.height, K_Width, bottomHeight);
//            self.frame = CGRectMake(0, K_Height - k_BottomSafeHeight - self.backView.height - bottomHeight, K_Width, self.backView.height + bottomHeight);
//            self.frame = CGRectMake(0, 0, K_Width, K_Height);
        }];
    } else {
        self.emojiClick = NO;
        self.giftClick = NO;
        self.deleteBtn.hidden = YES;
        [self.emojiBtn setImage:[UIImage imageNamed:@"live_emoji"] forState:UIControlStateNormal];
        [self.textView becomeFirstResponder];
    }
}

- (void)giftBtnAction:(UIButton *)btn {
    self.giftClick = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(giftChange)]) {
        [self.delegate giftChange];
    }
}

- (void)deleteBtnAction:(UIButton *)btn {
    [self deleteBackward:self.textView.text];
    [self emojiChangeFrame];
}

- (void)hidenKeyboardAction {
    [self keyboardHide];
}

#pragma mark ====== 改变输入框大小 ======
- (void)changeFrame:(CGFloat)height {

    CGFloat iphonexH = 0;
    self.frame = CGRectMake(0, 0, K_Width, K_Height - k_BottomSafeHeight);
    self.bgBtn.frame = CGRectMake(0, 0, K_Width, K_Height - k_BottomSafeHeight);
    if (self.isOrientationLandscape) {
        self.textView.frame = CGRectMake((self.width - 300) * 0.5, viewMargin, 300, height); //改变输入框的frame
        self.giftBtn.frame = CGRectMake(CGRectGetMaxX(self.textView.frame) + 10, viewMargin, viewHeight, viewHeight);
        self.emojiBtn.frame = CGRectMake(CGRectGetMinX(self.textView.frame) - viewBottomHeight - 5, 5, viewBottomHeight, viewBottomHeight);
        self.deleteBtn.frame = CGRectMake(self.width - 34 - 10, CGRectGetMinY(self.textView.frame) + 7, 34, 22);
        CGFloat backViewH = self.textView.height + 2 * viewMargin;
        if (self.emojiClick && !self.showKeyboard) {
            self.backView.frame = CGRectMake(0, self.height - backViewH - bottomFullHeight, K_Width, backViewH);
            self.emojiView.frame = CGRectMake(0, CGRectGetMaxY(self.backView.frame), K_Width, bottomFullHeight);
        }else {
            iphonexH = kIs_iPhoneX ? 30 : 0;    //iPhonex横屏键盘间隙
            self.backView.frame = CGRectMake(0, self.height - backViewH - self.keyboardHeight + iphonexH, K_Width, backViewH+iphonexH);
        }
    }else {
        self.textView.frame = CGRectMake(viewMargin, viewMargin, self.textView.width, height);
        self.giftBtn.frame = CGRectMake(CGRectGetMaxX(self.textView.frame) + 10, viewMargin, viewHeight, viewHeight);
        self.emojiBtn.frame = CGRectMake(viewMargin, CGRectGetMaxY(self.textView.frame) + 5, viewBottomHeight, viewBottomHeight);
        self.deleteBtn.frame = CGRectMake(K_Width - 44, CGRectGetMaxY(self.textView.frame) + 12, 34, 22);
        CGFloat backViewH = self.textView.height + 2 * viewMargin + viewBottomHeight;
        if (self.emojiClick && !self.showKeyboard) {
            self.backView.frame = CGRectMake(0, self.height - backViewH - bottomHeight, K_Width, backViewH);
            self.emojiView.frame = CGRectMake(0, CGRectGetMaxY(self.backView.frame), K_Width, bottomHeight);
        }else {
            
            iphonexH = kIs_iPhoneX ? 10 : 0;    //iPhonex竖屏键盘间隙
            self.backView.frame = CGRectMake(0, self.height - backViewH - self.keyboardHeight - iphonexH, K_Width, backViewH);
        }
    }
}

- (void)emojiChangeFrame
{
    /**
     *  根据最大的行数计算textView的最大高度
     *  计算最大高度 = (每行高度 * 总行数 + 文字上下间距)
     */
    CGFloat maxTextH = ceil(self.textView.font.lineHeight * 2 + self.textView.textContainerInset.top + self.textView.textContainerInset.bottom);
    CGFloat textH = ceilf([self.textView sizeThatFits:CGSizeMake(self.textView.frame.size.width, MAXFLOAT)].height);
    if (textH < viewHeight) {
        textH = viewHeight;
    }
    if (textH > maxTextH) {
        textH = maxTextH;
    }
    
    [self changeFrame:textH];
}

#pragma mark ====== 点击空白处，键盘收起时，移动self至底部 ======
- (void)keyboardHide {
    //收起键盘
    [self removeBottomViewFromSupview];
    [UIView animateWithDuration:0.25 animations:^{
        if (self.isOrientationLandscape) {
            self.y = self.height;
        }else {
            self.backView.y = 0;
            self.textView.frame = CGRectMake(viewMargin, viewMargin, self.textView.width, self.textView.height);
            self.giftBtn.frame = CGRectMake(CGRectGetMaxX(self.textView.frame) + 10, viewMargin, viewHeight, viewHeight);
//            self.emojiBtn.frame = CGRectMake(viewMargin, CGRectGetMaxY(self.textView.frame) + 12, 30, 30);
            self.frame = CGRectMake(0, K_Height - k_BottomSafeHeight - self.textView.height - 2 * viewMargin, K_Width, self.textView.height + 2 * viewMargin);
        }
    }];
}

#pragma mark ====== 键盘将要出现 ======
- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //获取键盘的高度
    self.keyboardHeight = endFrame.size.height;
    
    if (!self.isOrientationLandscape) {
        self.emojiBtn.hidden = NO;
    }
    self.showKeyboard = YES;
    self.emojiClick = NO;
    self.giftClick = NO;
    self.deleteBtn.hidden = YES;
    [self.emojiBtn setImage:[UIImage imageNamed:@"live_emoji"] forState:UIControlStateNormal];
    
    [self changeFrame:self.textView.height];
//    NSLog(@"键盘宽度：%f，高度：%f",endFrame.size.width,endFrame.size.height);
    //键盘的动画时长
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration delay:0 options:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] animations:^{
        self.frame = CGRectMake(0,0, self.width, self.height);
        
    } completion:nil];
}

#pragma mark ====== 键盘将要消失 ======
- (void)keyboardWillHide:(NSNotification *)notification {
    //点击表情切换或者空白区域都会触发键盘消失事件，所以要过滤
    if (self.emojiClick || self.giftClick) {
        return;
    }
    [self keyboardHide];
}

#pragma mark ====== 改变tableView的frame ======
- (void)changeTableViewFrame {
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardChangeFrameWithMinY:)]) {
        [self.delegate keyboardChangeFrameWithMinY:self.y];
    }
}

#pragma mark ====== 移除底部视图 ======
- (void)removeBottomViewFromSupview {
    
    self.showKeyboard = NO;
    self.emojiBtn.hidden = YES;
    [self.emojiBtn setImage:[UIImage imageNamed:@"live_emoji"] forState:UIControlStateNormal];
    self.deleteBtn.hidden = YES;
    [self.textView resignFirstResponder];
    
    [self.emojiView removeFromSuperview];
    self.emojiView = nil;
    self.emojiClick = NO;
}

#pragma mark ====== UITextViewDelegate ======
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //判断输入的字是否是回车，即按下return
    if ([text isEqualToString:@"\n"]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(textViewContentText:)]) {
            [self changeFrame:viewHeight];      //发送完充值输入框高度
            [self.delegate textViewContentText:textView.text];
        }
        if ([UserInstance shareInstance].isLogin) {
            textView.text = @"";
        }
        
        /*这里返回NO，就代表return键值失效，即页面上按下return，
         不会出现换行，如果为yes，则输入页面会换行*/
        return NO;
    }
    
    //如果是退格删除，则调用自定义方法
    if ([text isEqualToString:@""]) {
        [self deleteBackward:textView.text];
        [self emojiChangeFrame];
        return NO;
    }
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = 30 - comcatstr.length;
    NSLog(@"还能输入%ld个字符",caninputlen);
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputMaxLimitNums)]) {
            [self.delegate inputMaxLimitNums];
        }
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    return YES;
}

#pragma mark ====== DREmojiViewDelegate ======
/// 表情分类切换事件
- (void)typeEmoji {
    
}

/// 选择表情
/// @param emojiStr 表情字符串，例如：[1]
- (void)selectEmoji:(NSString *)emojiStr {
    
    NSString *comcatstr = [_textView.text stringByAppendingString:emojiStr];
    NSInteger caninputlen = 30 - comcatstr.length;
    if (caninputlen >= 0)
    {
        self.textView.text = [_textView.text stringByAppendingString:emojiStr];
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputMaxLimitNums)]) {
            [self.delegate inputMaxLimitNums];
        }
        self.textView.text = [comcatstr substringToIndex:30];
    }
    
    [self emojiChangeFrame];
}

/// 发送表情
- (void)sendEmoji {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewContentText:)]) {
        [self.delegate textViewContentText:self.textView.text];
    }
    if ([UserInstance shareInstance].isLogin) {
        self.textView.text = @"";
    }
}

#pragma mark ====== init ======
- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor whiteColor];
        UIView *lineView = [[UIView alloc] init];
        [_backView addSubview:lineView];
        lineView.frame = CGRectMake(0, 0, 320, 0.5);
        lineView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
        lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self addSubview:_backView];
    }
    return _backView;
}

- (DKSTextView *)textView {
    if (!_textView) {
        _textView = [[DKSTextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:16];
        [_textView textValueDidChanged:^(CGFloat textHeight) {
            [self changeFrame:textHeight];
        }];
        _textView.maxNumberOfLines = 5;
        _textView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.00];
        _textView.layer.cornerRadius = 4;
        _textView.layer.borderWidth = 0.5;
        _textView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.00].CGColor;
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeySend;
        [self.backView addSubview:_textView];
    }
    return _textView;
}

//表情按钮
- (UIButton *)emojiBtn {
    if (!_emojiBtn) {
        _emojiBtn = [[UIButton alloc] init];
        _emojiBtn.frame = CGRectMake(viewMargin, viewMargin, viewHeight, viewHeight);
        [_emojiBtn setImage:[UIImage imageNamed:@"live_emoji"] forState:UIControlStateNormal];
        [_emojiBtn addTarget:self action:@selector(emojiBtn:) forControlEvents:UIControlEventTouchUpInside];
        _emojiBtn.hidden = YES;
        [self.backView addSubview:_emojiBtn];
    }
    return _emojiBtn;
}

//礼物按钮
- (UIButton *)giftBtn {
    if (!_giftBtn) {
        _giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_giftBtn setBackgroundImage:[UIImage imageNamed:@"icon_lwtb"] forState:UIControlStateNormal];
        [_giftBtn addTarget:self action:@selector(giftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:_giftBtn];
    }
    return _giftBtn;
}

//退格删除按钮
- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.hidden = YES;
        [_deleteBtn setImage:[UIImage imageNamed:@"live_backDelete"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:_deleteBtn];
    }
    return _deleteBtn;
}

//遮挡按钮
- (UIButton *)bgBtn
{
    if (!_bgBtn) {
        _bgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, K_Width, K_Height)];
        [_bgBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0]];
        [_bgBtn addTarget:self action:@selector(hidenKeyboardAction) forControlEvents:UIControlEventTouchUpInside];
    }

    return _bgBtn;
}


//表情视图
- (DKSEmojiView *)emojiView {
    if (!_emojiView) {
        _emojiView = [[DKSEmojiView alloc] initWithFrame:CGRectMake(0, K_Height, K_Width, self.isOrientationLandscape?bottomFullHeight:bottomHeight)];
        _emojiView.delegate = self;
    }
    return _emojiView;
}

#pragma mark ====== 移除监听 ======
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
