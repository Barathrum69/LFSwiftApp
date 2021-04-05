//
//  TaskTableViewCell.m
//  DragonLive
//
//  Created by LoaA on 2020/12/9.
//

#import "TaskTableViewCell.h"
#import "TaskModel.h"
@implementation TaskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    _img.image = [UIImage imageNamed:@"mine_information"];

    _titleLab.textColor = [UIColor colorFromHexString:@"222222"];
    _titleLab.text = @"分享房间";
    _titleLab.font = [UIFont boldSystemFontOfSize:kWidth(12)];
    
    _contentLab.text = @"累积赠送任意礼物1个";
    _contentLab.textColor = [UIColor colorFromHexString:@"ADADAD"];
    _contentLab.font = [UIFont boldSystemFontOfSize:kWidth(10)];
    
    _receiveBtn.backgroundColor = SelectedBtnColor;
    _receiveBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(12)];
    [_receiveBtn setTitle:@"领取" forState:UIControlStateNormal];
    [_receiveBtn addTarget:self action:@selector(receiveBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    _rewardLab.textAlignment = NSTextAlignmentCenter;
    _rewardLab.textColor = [UIColor colorFromHexString:@"777777"];
    _rewardLab.text = @"奖励EXP800";
    _rewardLab.font = [UIFont systemFontOfSize:kWidth(9)];
}


-(void)receiveBtnOnClick
{
    if (self.receiveBtnBlock) {
        self.receiveBtnBlock(_model);
    }
}//领取按钮点击


-(void)setModel:(TaskModel *)model
{
    _model = model;
    _titleLab.text = _model.taskName;
    _contentLab.text = _model.remark;
    _rewardLab.text = _model.experience;
    [_img sd_setImageWithURL:[NSURL URLWithString:_model.taskIcon]];
    
    if ([_model.currentType isEqualToString:@"1"]) {
        _receiveBtn.backgroundColor = [UIColor colorFromHexString:@"F5F5F5"];
        [_receiveBtn setTitle:@"去完成" forState:UIControlStateNormal];
        _receiveBtn.userInteractionEnabled = NO;
        [_receiveBtn setTitleColor:[UIColor colorFromHexString:@"858585"] forState:UIControlStateNormal];
    }else if ([_model.currentType isEqualToString:@"2"]){
        _receiveBtn.backgroundColor = SelectedBtnColor;
        [_receiveBtn setTitle:@"领取" forState:UIControlStateNormal];
        _receiveBtn.userInteractionEnabled = YES;
        [_receiveBtn setTitleColor:[UIColor colorFromHexString:@"FFFFFF"] forState:UIControlStateNormal];
    }else if ([_model.currentType isEqualToString:@"3"]){
        _receiveBtn.backgroundColor = [UIColor colorFromHexString:@"F5F5F5"];
        [_receiveBtn setTitle:@"已领取" forState:UIControlStateNormal];
        _receiveBtn.userInteractionEnabled = NO;
        [_receiveBtn setTitleColor:[UIColor colorFromHexString:@"858585"] forState:UIControlStateNormal];

    }
    
}




-(void)setFrame:(CGRect)frame
{
    frame.origin.x = kWidth(15);//这里间距为15，可以根据自己的情况调整
    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 2 * (frame.origin.x-kWidth(12));
    [super setFrame:frame];
    [self setCornerWithType:UIRectCornerAllCorners Radius:kWidth(3)];
    [self updateUI];
}//setFrame

-(void)updateUI
{
    _img.frame = CGRectMake(kWidth(17), (self.height-kWidth(20))/2, kWidth(20), kWidth(20));
//    _img.backgroundColor = [UIColor redColor];
    _titleLab.frame = CGRectMake(_img.right+kWidth(14), _img.top-kWidth(3), kWidth(150), kWidth(12));
    _contentLab.frame = CGRectMake(_titleLab.left, _titleLab.bottom+kWidth(10), kWidth(200), kWidth(10));
    
    _receiveBtn.frame = CGRectMake(self.width-kWidth(24+60), self.height-kWidth(30)-kWidth(5), kWidth(60), kWidth(30));
    [_receiveBtn setCornerWithType:UIRectCornerAllCorners Radius:_receiveBtn.width/2];
   
    _rewardLab.frame  = CGRectMake(_receiveBtn.left, _receiveBtn.top-kWidth(9+8), _receiveBtn.width, kWidth(9));

}//更新UI



@end
