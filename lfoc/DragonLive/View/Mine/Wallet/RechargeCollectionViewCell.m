//
//  RechargeCollectionViewCell.m
//  DragonLive
//
//  Created by LoaA on 2020/12/11.
//

#import "RechargeCollectionViewCell.h"
#import "RechargeModel.h"
#import "EasyTextView.h"
#import "LeftRightTextField.h"
NSString *const RechargeCollectionViewCellID = @"RechargeCollectionViewCellID";

@interface RechargeCollectionViewCell ()<UITextFieldDelegate>

/**
 人民币abel
 */
@property (nonatomic, strong) UILabel       *rmbLabel;

/**
 虚拟币label
 */
@property (nonatomic, strong) UILabel       *virtualCurrencyLabel;

/// 输入框
@property (nonatomic, strong) LeftRightTextField   *inputTextField;

/// 输入框的遮罩
@property (nonatomic, strong) UIView        *maskView;

@end

@implementation RechargeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = kWidth(4);
        self.layer.borderWidth = kWidth(1.33);
        self.layer.borderColor = [UIColor colorFromHexString:@"DCDCDC"].CGColor;
        [self setupViews];
        
    }
    return self;
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
//    if (!textField.text.length) {
//        return;
//    }
    _inputTextField.textColor = [UIColor colorWithHexString:@"777777"];
    NSInteger inputAmount = [textField.text integerValue];
    if (inputAmount < [_itemModel.minAmount integerValue] || inputAmount > [_itemModel.maxAmount integerValue]) {
        _inputTextField.text = @"";
        _itemModel.amount = 0;
        _inputTextField.hidden = NO;
        _rmbLabel.hidden = YES;
        _virtualCurrencyLabel.hidden = YES;
    }else {
        //获取输入的内容
        _itemModel.amount = [textField.text integerValue];
        _itemModel.coinsNum = [NSString stringWithFormat:@"%ld",_itemModel.amount*10];
        _inputTextField.hidden = YES;
        _rmbLabel.hidden = NO;
        _virtualCurrencyLabel.hidden = NO;
        _rmbLabel.text = [NSString stringWithFormat:@"¥%ld",(long)_itemModel.amount];
        _virtualCurrencyLabel.text = [NSString stringWithFormat:@"%ld龙币",_itemModel.amount*10];
        
        
    }
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[HCToast shareInstance] showToast:[NSString stringWithFormat:@"充值范围%@元-%@元",_itemModel.minAmount,_itemModel.maxAmount]];

}


-(void)setupViews
{
    
    _rmbLabel = ({
//        kWidth(100)
        UILabel *rmbLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth(10), (self.height-kWidth(15))/2, kWidth(100), kWidth(15))];
//        watchLabel.backgroundColor = [UIColor redColor];
//        rmbLabel.attributedText = [self aaa];
        rmbLabel.textColor = [UIColor colorWithHexString:@"#777777"];
        rmbLabel.font = [UIFont systemFontOfSize:kWidth(15)];
        [self addSubview:rmbLabel];
        rmbLabel;
    });
    
    
    _virtualCurrencyLabel = ({
//        kWidth(100)
        UILabel *virtualCurrencyLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width-kWidth(110), (self.height-kWidth(15))/2, kWidth(105), kWidth(15))];
//        watchLabel.backgroundColor = [UIColor redColor];
//        rmbLabel.attributedText = [self aaa];
        virtualCurrencyLabel.textColor = [UIColor colorWithHexString:@"#777777"];
        virtualCurrencyLabel.font = [UIFont systemFontOfSize:kWidth(15)];
        virtualCurrencyLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:virtualCurrencyLabel];
        virtualCurrencyLabel;
    });
    
    
    _inputTextField = ({
        LeftRightTextField *inputTextField = [[LeftRightTextField alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        inputTextField.placeholder = @"其他金额";
        inputTextField.font = [UIFont systemFontOfSize:kWidth(15)];
        inputTextField.textAlignment = NSTextAlignmentCenter;
        inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        inputTextField.delegate = self;
        kWeakSelf(self);
        inputTextField.textFieldDidChange = ^(NSString * _Nonnull text) {
            NSInteger inputAmount = [text integerValue];
            
            if ([weakself.itemModel.maxAmount integerValue] < inputAmount) {
                [[HCToast shareInstance] showToast:[NSString stringWithFormat:@"充值范围%@元-%@元",weakself.itemModel.minAmount,weakself.itemModel.maxAmount]];
            }
        };
        [self addSubview:inputTextField];
        inputTextField;
    });
    
    
}


-(void)configureCellWithModel:(RechargeModel *)model
{
    _itemModel = model;
    if (_itemModel.isSelected == YES) {
        if (_itemModel.rechargeStyleType == RechargeStyleTypeTextField) {
            [_inputTextField becomeFirstResponder];
            _inputTextField.hidden = NO;
            _virtualCurrencyLabel.hidden = YES;
            _rmbLabel.hidden = YES;
        }
        self.layer.borderColor = SelectedBtnColor.CGColor;
        _virtualCurrencyLabel.textColor = [UIColor colorWithHexString:@"F67C37"];
        _rmbLabel.textColor = [UIColor colorWithHexString:@"F67C37"];
        _inputTextField.textColor = [UIColor colorWithHexString:@"F67C37"];

    }else{
        [_inputTextField resignFirstResponder];
        self.layer.borderColor = [UIColor colorFromHexString:@"DCDCDC"].CGColor;
        _virtualCurrencyLabel.textColor = [UIColor colorWithHexString:@"777777"];
        _rmbLabel.textColor = [UIColor colorWithHexString:@"777777"];
        _inputTextField.textColor = [UIColor colorWithHexString:@"777777"];
    }
    
    if (_itemModel.rechargeStyleType == RechargeStyleTypeNormal) {
        //隐藏掉textField
        _inputTextField.hidden = YES;
        _virtualCurrencyLabel.hidden = NO;
        _rmbLabel.hidden = NO;
        _virtualCurrencyLabel.text = [NSString stringWithFormat:@"%@龙币",_itemModel.coinsNum];
        _rmbLabel.text = [NSString stringWithFormat:@"¥%ld",(long)_itemModel.amount];
        
    }else{
        
//        if (_maskView == nil) {
//            _maskView = [[UIView alloc]initWithFrame:_inputTextField.frame];
//            [self addSubview:_maskView];
//        }
        
        if ( _itemModel.amount != 0) {
            _inputTextField.text = [NSString stringWithFormat:@"%ld",(long)_itemModel.amount];
            _virtualCurrencyLabel.text = [NSString stringWithFormat:@"%@龙币",_itemModel.coinsNum];
            _rmbLabel.text = [NSString stringWithFormat:@"¥%ld",(long)_itemModel.amount];
        }
    }
    
}



@end
