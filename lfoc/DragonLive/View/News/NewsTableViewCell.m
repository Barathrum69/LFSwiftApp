//
//  NewsTableViewCell.m
//  DragonLive
//
//  Created by LoaA on 2021/2/17.
//

#import "NewsTableViewCell.h"
#import "LeftLabel.h"
#import "NewsItemModel.h"
@implementation NewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self frameForUI];

}


-(void)frameForUI{
    _iconImage.frame = CGRectMake(kScreenWidth-kWidth(126+15), (self.height-kWidth(76))/2, kWidth(126), kWidth(76));
    _iconImage.contentMode = UIViewContentModeScaleAspectFill;

    _titleLab.frame  = CGRectMake(kWidth(13), _iconImage.top, kScreenWidth-kWidth(126+15+13+32), kWidth(40));
    _titleLab.font = [UIFont systemFontOfSize:kWidth(13)];
    _titleLab.textColor = [UIColor colorFromHexString:@"333333"];
    _titleLab.numberOfLines = 0;
//    _titleLab.text = @"易卜拉欣莫維奇的MLS處子秀，勞埃德世界杯決賽英雄，貝克漢姆的救贖：我見過的最佳個人表現";
    
    _timeLab.frame   = CGRectMake(kWidth(13), _titleLab.bottom+kWidth(22), _titleLab.width, kWidth(14));
    _timeLab.font = [UIFont systemFontOfSize:kWidth(10)];
    _timeLab.textColor = [UIColor colorFromHexString:@"888888"];
//    _timeLab.text = @"19分钟前";
    
    [_iconImage setImage:[UIImage imageNamed:@"aaaa.jpeg"]];
}


-(void)prepareForReuse{
    [super prepareForReuse];
}

-(void)setModel:(NewsItemModel *)model{
    _model = model;
    _titleLab.text = _model.articleTitle;
    _timeLab.text = _model.mobileIssueTime;
    if (_model.contentUrl.length != 0) {
        [_iconImage sd_setImageWithURL:[NSURL URLWithString:_model.coverUrl] placeholderImage:nil];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
