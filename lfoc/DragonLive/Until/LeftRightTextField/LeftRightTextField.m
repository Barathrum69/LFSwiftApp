//
//  LeftRightTextField.m
//  DragonLive
//
//  Created by LoaA on 2020/12/14.
//

#import "LeftRightTextField.h"

@interface LeftRightTextField ()<UITextFieldDelegate>

@end

@implementation LeftRightTextField




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.delegate = self;
    self.textContentType = UITextContentTypeOneTimeCode;

    }
    return self;
}


-(instancetype)init{
    self = [super init];
    if (self) {
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.delegate = self;
    self.textContentType = UITextContentTypeOneTimeCode;

    }
    return self;
}


-(void)textFieldDidChange :(UITextField *)theTextField{
    if (self.textFieldDidChange) {
        self.textFieldDidChange(theTextField.text);
    }
}


- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    UIView *leftView = self.leftView;
    if (leftView) {
        return CGRectMake(0, leftView.top, leftView.width, leftView.height);
    } else {
        return CGRectZero;
    }
}

-(CGRect)rightViewRectForBounds:(CGRect)bounds{
    UIView *rightView = self.rightView;
    if (rightView) {
        return CGRectMake(self.width-rightView.frame.size.width, rightView.top, rightView.width, rightView.height);
    }else{
        return CGRectZero;
    }
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

@end
