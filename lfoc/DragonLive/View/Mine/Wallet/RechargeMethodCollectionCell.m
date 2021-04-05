//
//  RechargeMethodCollectionCell.m
//  DragonLive
//
//  Created by LoaA on 2020/12/30.
//

#import "RechargeMethodCollectionCell.h"
#import "RechargeMethodModel.h"
NSString *const RechargeMethodCollectionCellID = @"RechargeMethodCollectionCellID";

@interface RechargeMethodCollectionCell ()

/// 头像
@property (nonatomic, strong) UIImageView *iconImg;

/// 描述Lab
@property (nonatomic, strong) UILabel     *messageLab;


@end

@implementation RechargeMethodCollectionCell

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


-(void)setupViews
{
    /// 头像
    _iconImg = ({
        UIImageView *iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(8), (self.height-kWidth(34))/2, kWidth(45), kWidth(34))];
        [iconImg setImage:[UIImage imageNamed:@"icon_yinlian"]];
        [self addSubview:iconImg];
        iconImg;
    });
    
    /// 描述Lab
    _messageLab = ({
//        kWidth(100)
        UILabel *messageLab = [[UILabel alloc]initWithFrame:CGRectMake(self.width-kWidth(115), (self.height-kWidth(15))/2, kWidth(100), kWidth(15))];
        messageLab.textColor = [UIColor colorWithHexString:@"#777777"];
        messageLab.font = [UIFont systemFontOfSize:kWidth(15)];
        messageLab.textAlignment = NSTextAlignmentRight;
        messageLab.text = @"微信支付";
        [self addSubview:messageLab];
        messageLab;
    });
    
}


-(void)configureCellWithModel:(RechargeMethodModel *)model
{
    if (model.isSelected == YES) {
        self.layer.borderColor = SelectedBtnColor.CGColor;
        _messageLab.textColor = [UIColor colorWithHexString:@"F67C37"];
    }else{
        self.layer.borderColor = [UIColor colorFromHexString:@"DCDCDC"].CGColor;
        _messageLab.textColor = [UIColor colorWithHexString:@"777777"];
    }
    
    _messageLab.text = model.channelName;
    [_iconImg setImageURL:[NSURL URLWithString:model.channelImg]];
    
}

@end
