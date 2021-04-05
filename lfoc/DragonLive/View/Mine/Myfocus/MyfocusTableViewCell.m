//
//  MyfocusTableViewCell.m
//  DragonLive
//
//  Created by LoaA on 2020/12/9.
//

#import "MyfocusTableViewCell.h"
#import "MyFocusModel.h"
#import <SDWebImage/UIImage+GIF.h>

@interface MyfocusTableViewCell ()
@property (nonatomic, strong) UIImage *image;
@end

@implementation MyfocusTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = The_MainColor;
    
 
//    [_headImg setImage:[UIImage imageNamed:@"timg.jpeg"]];
    
    _nameLab.textColor = [UIColor colorFromHexString:@"222222"];
    _nameLab.font = [UIFont boldSystemFontOfSize:kWidth(14)];
//    _nameLab.text = @"一条小团团";
    
    _fansLab.textColor = [UIColor colorFromHexString:@"222222"];
    _fansLab.font = [UIFont systemFontOfSize:kWidth(11)];
//    _fansLab.text = @"粉丝数 : 1241";
    
    _focusBtn.backgroundColor = SelectedBtnColor;
    _focusBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(12)];
    [_focusBtn setTitle:@"已关注" forState:UIControlStateNormal];
    [_focusBtn addTarget:self action:@selector(focusBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"live_status" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    _image = [UIImage sd_imageWithGIFData:data];
    
    
}//awakeFromNib


-(void)focusBtnOnClick
{
    if (self.focusBtnClickBlock) {
        self.focusBtnClickBlock(_model);
    }
}


-(void)setFrame:(CGRect)frame
{
    _headImg.frame = CGRectMake(kWidth(17), (self.height-kWidth(46))/2, kWidth(46), kWidth(46));
    [_headImg setCornerWithType:UIRectCornerAllCorners Radius:_headImg.width/2];
    _nameLab.frame = CGRectMake(_headImg.right+kWidth(10), _headImg.top+kWidth(7), kWidth(200), kWidth(14));
    _fansLab.frame = CGRectMake(_nameLab.left, _nameLab.bottom+kWidth(10), _nameLab.width, kWidth(11));
    
    _focusBtn.frame = CGRectMake(self.width-kWidth(82), (self.height-kWidth(30))/2, kWidth(60), kWidth(30));
    [_focusBtn setCornerWithType:UIRectCornerAllCorners Radius:_focusBtn.width/2];
    _hasLive.frame  = CGRectMake(_headImg.right-kWidth(20), _headImg.bottom-kWidth(20), kWidth(20), kWidth(20));
    
    [super setFrame:frame];
    
}//setFrame

-(void)prepareForReuse{
    [super prepareForReuse];
    _hasLive.image = nil;
}

-(void)setModel:(MyFocusModel *)model
{
    _model = model;
    [_headImg sd_setImageWithURL:[NSURL URLWithString:_model.headIcon] placeholderImage:[UIImage imageNamed:@"headNomorl"]];
    _nameLab.text = _model.nickName;
    _fansLab.text = _model.fansNum;
    
    if ([model.hasLive isEqualToString:@"0"]) {
        _hasLive.hidden = YES;
    }else{
        _hasLive.hidden = NO;
    }
    _hasLive.image = _image;
}


@end
