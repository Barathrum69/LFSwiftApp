//
//  HostTableViewCell.m
//  DragonLive
//
//  Created by LoaA on 2021/1/26.
//

#import "HostTableViewCell.h"
#import <SDWebImage/UIImage+GIF.h>
#import "HostModel.h"
@interface HostTableViewCell()

@property (nonatomic, strong) UIImage *image;

@end

@implementation HostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _headImg.frame = CGRectMake(kWidth(20), (self.height-kWidth(46))/2, kWidth(46), kWidth(46));
    [_headImg setCornerWithType:UIRectCornerAllCorners Radius:_headImg.width/2];
    
    
    _nameLab.frame = CGRectMake(_headImg.right+kWidth(11), _headImg.top-kWidth(4), kWidth(190), kWidth(35));
    _nameLab.numberOfLines = 0;
//    _nameLab.backgroundColor = [UIColor redColor];
    _nameLab.textColor = [UIColor colorFromHexString:@"222222"];
    _nameLab.font = [UIFont systemFontOfSize:kWidth(14)];
    
    
    _fansLab.frame = CGRectMake(_nameLab.left, _nameLab.bottom+kWidth(3), _nameLab.width, kWidth(13));
    _fansLab.textColor = [UIColor colorFromHexString:@"999999"];
    _fansLab.font = [UIFont systemFontOfSize:kWidth(9)];
    
    _hasLiveImage.frame = CGRectMake(_nameLab.right+kWidth(15), (self.height-kWidth(19))/2, kWidth(19), kWidth(19));
    
    _liveMessageLab.frame = CGRectMake(_hasLiveImage.right+kWidth(2), (self.height-kWidth(13))/2, kWidth(40), kWidth(13));
    _liveMessageLab.font = [UIFont systemFontOfSize:kWidth(12)];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"hasLive" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    _image = [UIImage sd_imageWithGIFData:data];
    // Initialization code
}

-(void)prepareForReuse{
    [super prepareForReuse];
    _hasLiveImage.image = nil;
}


-(void)setModel:(HostModel *)model
{
    _model = model;
    [_headImg sd_setImageWithURL:[NSURL URLWithString:_model.avatar] placeholderImage:[UIImage imageNamed:@"headNomorl"]];
    _nameLab.text = _model.name;
    _fansLab.attributedText = _model.hotAtt;
    if (_model.statusOfLive) {
        //如果是直播.
        _hasLiveImage.image = _image;
        _hasLiveImage.hidden = NO;
        _liveMessageLab.text = @"直播中";
        _liveMessageLab.textColor = SelectedBtnColor;
    }else{
        _hasLiveImage.hidden = YES;
        _liveMessageLab.text = @"未直播";
        _liveMessageLab.textColor = [UIColor colorFromHexString:@"787878"];
    }
    
    if ([model.hostType isEqualToString:@"2"]) {
        _fansLab.hidden = YES;
    }else{
        _fansLab.hidden = NO;
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
