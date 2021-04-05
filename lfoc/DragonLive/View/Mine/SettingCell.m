//
//  SettingCell.h
//  BallSaintSport
//
//  Created by LoaA on 2020/11/6.
//

#import "SettingCell.h"
#import "SettingItemModel.h"
@interface SettingCell()<UITextFieldDelegate>

/// 左边名字
@property (strong, nonatomic) UILabel *funcNameLabel;

/// 左边图片
@property (nonatomic,strong) UIImageView *imgView;

/// 右边小角标
@property (nonatomic,strong) UIImageView *indicator;

/// 选择框
@property (nonatomic,strong) UISwitch *aswitch;

/// 详情label
@property (nonatomic,strong) UILabel *detailLabel;

/// 详情图像
@property (nonatomic,strong) UIImageView *detailImageView;

/// 输入框
@property (nonatomic,strong) UITextField *detailField;

@property (nonatomic, assign) BOOL isStop;

@end
@implementation SettingCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //        self.userInteractionEnabled = NO;
    }
    return self;
}


- (void)setItem:(SettingItemModel *)item
{
    _item = item;
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self updateUI];
}

- (void)updateUI
{
    
    if (_isStop == YES) {
        if (self.item.accessoryType !=  SettingAccessoryTypeTextFeild) {
            if (self.item.detailText) {
                
                
                self.detailLabel.text = self.item.detailText;
                self.detailLabel.size = [self sizeForTitle:self.item.detailText withFont:self.detailLabel.font];
                switch (self.item.accessoryType) {
                    case SettingAccessoryTypeNone:
                        self.detailLabel.x = kScreenWidth - self.detailLabel.width - DetailViewToIndicatorGap - 2;
                        break;
                    case SettingAccessoryTypeDisclosureIndicator:
                        self.detailLabel.x = self.indicator.x - self.detailLabel.width - DetailViewToIndicatorGap;
                        break;
                    case SettingAccessoryTypeSwitch:
                        self.detailLabel.x = self.aswitch.x - self.detailLabel.width - DetailViewToIndicatorGap;
                        break;
                    case SettingAccessoryTypeTextFeild:
                        //            self.detailLabel.backgroundColor = [UIColor greenColor];`
                        self.detailLabel.text = [NSString stringWithFormat:@"%lu/%ld",(unsigned long)self.detailField.text.length,(long)self.item.count];
                        self.detailLabel.size = CGSizeMake(kWidth(40), kWidth(20));
                        
                        self.detailLabel.x = self.detailField.right+2;
                        
                        break;
                    default:
                        break;
                }
                self.detailLabel.centerY = self.contentView.centerY;
            }
        }
        
        if (self.item.detailImage) {
            self.detailImageView.image = self.item.detailImage;
        }
        
        return;
    }
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //如果有图片
    if (self.item.img) {
        [self setupImgView];
    }
    //功能名称
    if (self.item.funcName) {
        [self setupFuncLabel];
    }
    
    //accessoryType
    if (self.item.accessoryType) {
        [self setupAccessoryType];
    }
    //detailView
    if (self.item.detailText) {
        //        if (self.item.accessoryType != SettingAccessoryTypeTextFeild) {
        [self setupDetailText];
        //        }
    }
    
    if (self.item.placeholderText) {
        [self setupDetailText];
    }
    
    if (self.item.detailImage) {
        [self setupDetailImage];
    }
    
    if (self.item.titleColor) {
        self.funcNameLabel.textColor = self.item.titleColor;
    }
    
    if (self.item.detailColor) {
        self.detailLabel.textColor = self.item.detailColor;
    }
    
    if (self.item.accessoryType == SettingAccessoryTypeSwitch) {
        self.aswitch.on = _item.isOn;
    }
    
    //bottomLine
    //    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(kWidth(10), self.height - 1, kScreenWidth-kWidth(20), 1)];
    //    line.backgroundColor = [UIColor colorFromHexString:@"#F5F5F5"];
    //    [self.contentView addSubview:line];
    _isStop = YES;
}

-(void)setupDetailImage
{
    self.detailImageView = [[UIImageView alloc]initWithImage:self.item.detailImage];
    self.detailImageView.size = CGSizeMake(kWidth(35), kWidth(35));
    [self.detailImageView setCornerWithType:UIRectCornerAllCorners Radius:self.detailImageView.width/2];
    switch (self.item.accessoryType) {
        case SettingAccessoryTypeNone:
            self.detailImageView.x = kScreenWidth-kWidth(10) - self.detailImageView.width - DetailViewToIndicatorGap - 2;
            break;
        case SettingAccessoryTypeDisclosureIndicator:
            self.detailImageView.x = self.indicator.x - self.detailImageView.width - DetailViewToIndicatorGap;
            break;
        case SettingAccessoryTypeSwitch:
            self.detailImageView.x = self.aswitch.x - self.detailImageView.width - DetailViewToIndicatorGap;
            break;
        default:
            break;
    }
    self.detailImageView.center = CGPointMake(self.detailImageView.centerX, self.height/2);
    
    [self.contentView addSubview:self.detailImageView];
}

- (void)setupDetailText
{
    self.detailLabel = [[UILabel alloc]init];
    self.detailLabel.text = self.item.detailText;
    self.detailLabel.textColor = MakeColorWithRGB(142, 142, 142, 1);
    self.detailLabel.font = [UIFont systemFontOfSize:DetailLabelFont];
    self.detailLabel.size = [self sizeForTitle:self.item.detailText withFont:self.detailLabel.font];
    
    switch (self.item.accessoryType) {
        case SettingAccessoryTypeNone:
            self.detailLabel.x = kScreenWidth - self.detailLabel.width - DetailViewToIndicatorGap - 2;
            break;
        case SettingAccessoryTypeDisclosureIndicator:
            self.detailLabel.x = self.indicator.x - self.detailLabel.width - DetailViewToIndicatorGap;
            break;
        case SettingAccessoryTypeSwitch:
            self.detailLabel.x = self.aswitch.x - self.detailLabel.width - DetailViewToIndicatorGap;
            break;
        case SettingAccessoryTypeTextFeild:
            //            self.detailLabel.backgroundColor = [UIColor greenColor];`
            self.detailLabel.text = [NSString stringWithFormat:@"%lu/%ld",(unsigned long)self.detailField.text.length,(long)self.item.count];
            self.detailLabel.size = CGSizeMake(kWidth(40), kWidth(20));
            
            self.detailLabel.x = self.detailField.right+2;
            
            break;
        default:
            break;
    }
    self.detailLabel.centerY = self.contentView.centerY;
    [self.contentView addSubview:self.detailLabel];
}

- (void)setupDetailTextFeild
{
    self.detailField = [[UITextField alloc]init];
    self.detailField.placeholder = self.item.placeholderText;
    //    self.
    self.detailField.textColor = self.item.detailColor;
    self.detailField.delegate = self;
    self.detailField.returnKeyType = UIReturnKeyDone;
    self.detailField.font = [UIFont systemFontOfSize:DetailLabelFont];
    self.detailField.size = CGSizeMake(kWidth(200), kWidth(40));
    //    [ self.detailField addTarget:self action:@selector(textFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
    self.detailField.textAlignment = NSTextAlignmentRight;
    switch (self.item.accessoryType) {
        case SettingAccessoryTypeNone:
            //            self.detailLabel.x = kScreenWidth - self.detailLabel.width - DetailViewToIndicatorGap - 2;
            break;
        case SettingAccessoryTypeDisclosureIndicator:
            //            self.detailLabel.x = self.indicator.x - self.detailLabel.width - DetailViewToIndicatorGap;
            break;
        case SettingAccessoryTypeSwitch:
            //            self.detailLabel.x = self.aswitch.x - self.detailLabel.width - DetailViewToIndicatorGap;
            break;
        case SettingAccessoryTypeTextFeild:
            self.detailField.x = kScreenWidth - self.detailField.width - DetailViewToIndicatorGap - 35;
            //            self.detailField.backgroundColor = [UIColor redColor];
            break;
        default:
            break;
    }
    self.detailField.centerY = self.contentView.centerY+1;
    [self.contentView addSubview:self.detailField];
}


//-(void)textFiledEditChanged:(NSNotification *)obj{//这里obj类型根据第一步确定
//    UITextField *textField = (UITextField *)obj.object;
//
//    NSString *toBeString = textField.text;
//    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
//    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
//        UITextRange *selectedRange = [textField markedTextRange];
//        //获取高亮部分
//        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制 kMaxLength是想要限制的长度值
//        if (!position) {
//            if (toBeString.length > _item.count) {
//                textField.text = [toBeString substringToIndex:_item.count];
//            }
//        }
//        // 有高亮选择的字符串，则暂不对文字进行统计和限制
//        else{
//
//        }
//    }
//    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
//    else{
//        if (toBeString.length > _item.count) {
//            textField.text = [toBeString substringToIndex:_item.count];
//        }
//    }
//}
//- (void)textfe:(UITextField *)textField{
//    NSLog( @"text changed: %@", textField.text);
//    self.item.detailText = textField.text;
//}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //变化后的字符串
    NSString * new_text_str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField.text.length > _item.count) {
        UITextRange *markedRange = [textField markedTextRange];
        if (markedRange) {
            return NO;
        }
        //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
        //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
        NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:_item.count];
        textField.text = [textField.text substringToIndex:range.location];
    }
    
    if (new_text_str.length > _item.count) {
        [[NSNotificationCenter defaultCenter]postNotificationName:TextChangeNotification object: self.item.detailText];
        return NO;
    }
    self.item.detailText = new_text_str;
    self.detailLabel.text = [NSString stringWithFormat:@"%lu/%ld",(unsigned long)new_text_str.length,(long)self.item.count];
    [[NSNotificationCenter defaultCenter]postNotificationName:TextChangeNotification object:  self.item.detailText];
    
    return YES;
}



//- (void)textFieldDidChange:(UITextField *)textField
//{
//    if (textField == self.detailField) {
//        if (textField.text.length > _item.count) {
//　　　　　　　　UITextRange *markedRange = [textField markedTextRange];
//        　　　if (markedRange) {
//           　　 return;
//       　　　 }
//            //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
//        //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
//        NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:_item.count];
//            textField.text = [textField.text substringToIndex:range.location];
//        }
//    }
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    NSLog(@"%@",textField.text);
    
    self.item.detailText = textField.text;
    
    return YES;
}

- (void)setupAccessoryType
{
    switch (self.item.accessoryType) {
        case SettingAccessoryTypeNone:
            break;
        case SettingAccessoryTypeDisclosureIndicator:
            [self setupIndicator];
            break;
        case SettingAccessoryTypeSwitch:
            [self setupSwitch];
            break;
        case SettingAccessoryTypeTextFeild:
            [self setupDetailTextFeild];
            break;
        default:
            break;
    }
}

- (void)setupSwitch
{
    [self.contentView addSubview:self.aswitch];
}

- (void)setupIndicator
{
    [self.contentView addSubview:self.indicator];
    
}



- (void)setupImgView
{
    self.imgView = [[UIImageView alloc]initWithImage:self.item.img];
    self.imgView.size = CGSizeMake(kWidth(25), kWidth(25));
    self.imgView.x = FuncImgToLeftGap;
    self.imgView.centerY = self.contentView.centerY;
    self.imgView.centerY = self.contentView.centerY;
    [self.contentView addSubview:self.imgView];
}

- (void)setupFuncLabel
{
    self.funcNameLabel = [[UILabel alloc]init];
    self.funcNameLabel.text = self.item.funcName;
    self.funcNameLabel.textColor = [UIColor colorFromHexString:@"262626"];
    self.funcNameLabel.font = [UIFont systemFontOfSize:kWidth(12)];
    self.funcNameLabel.textAlignment = NSTextAlignmentLeft;
    self.funcNameLabel.size = [self sizeForTitle:self.item.funcName withFont:self.funcNameLabel.font];
    self.funcNameLabel.centerY = self.contentView.centerY;
    self.funcNameLabel.x = CGRectGetMaxX(self.imgView.frame) + FuncLabelToFuncImgGap;
    if (CGRectGetMaxX(self.imgView.frame) == 0) {
        self.funcNameLabel.x = 19;
    }
    [self.contentView addSubview:self.funcNameLabel];
    
    if (_item.accessoryType == SettingAccessoryTypeLogout) {
        
        self.funcNameLabel.font = [UIFont boldSystemFontOfSize:kWidth(14)];
        self.funcNameLabel.size = [self sizeForTitle:self.item.funcName withFont:self.funcNameLabel.font];
        self.funcNameLabel.center = self.contentView.center;
        self.funcNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    
}

- (CGSize)sizeForTitle:(NSString *)title withFont:(UIFont *)font
{
    CGRect titleRect = [title boundingRectWithSize:CGSizeMake(FLT_MAX, FLT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : font}
                                           context:nil];
    
    return CGSizeMake(titleRect.size.width,
                      titleRect.size.height);
}

- (UIImageView *)indicator
{
    if (!_indicator) {
        _indicator = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-arrow1"]];
        _indicator.centerY = self.contentView.centerY;
        _indicator.x = self.width- _indicator.width - IndicatorToRightGap;
    }
    return _indicator;
}

- (UISwitch *)aswitch
{
    if (!_aswitch) {
        _aswitch = [[UISwitch alloc]init];
        _aswitch.centerY = self.contentView.centerY;
        //        _aswitch.isOn =
        [_aswitch setOnTintColor:SelectedBtnColor];
        _aswitch.x = kScreenWidth - _aswitch.width - IndicatorToRightGap;
        [_aswitch addTarget:self action:@selector(switchTouched:) forControlEvents:UIControlEventValueChanged];
    }
    return _aswitch;
}



- (void)switchTouched:(UISwitch *)sw
{
    self.item.isOn = sw.isOn;
    self.item.switchValueChanged(sw.isOn);
}

@end
