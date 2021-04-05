//
//  RecommendVideoTableViewCell.m
//  DragonLive
//
//  Created by LoaA on 2020/12/7.
//

#import "RecommendVideoTableViewCell.h"
#import "LeftLabel.h"
#import "VideoItemModel.h"
@implementation RecommendVideoTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    [self frameUI];
}


-(void)frameUI
{
    //图
    _video_img.frame = CGRectMake(kWidth(17), kWidth(8), kWidth(150), kWidth(85));
    _video_img.contentMode = UIViewContentModeScaleToFill;
//    [_video_img setImage:[UIImage imageNamed:@"aaaa.jpeg"]];
    
    //视频时长
    _duration_lab.frame = CGRectMake(_video_img.right-kWidth(43), _video_img.bottom-kWidth(19), kWidth(40), kWidth(16));
    [_duration_lab setCornerWithType:UIRectCornerAllCorners Radius:kWidth(2)];
    _duration_lab.backgroundColor = [UIColor colorFromHexString:@"000000" withAlph:0.7];
    _duration_lab.font = [UIFont systemFontOfSize:kWidth(8)];
    
    //title
    _title_lab.frame = CGRectMake(_video_img.right+kWidth(7), _video_img.top+kWidth(6),kScreenWidth-_video_img.right-kWidth(35), kWidth(35));
    _title_lab.numberOfLines = 0;
    _title_lab.font = [UIFont systemFontOfSize:kWidth(14)];
    
    
    _watch_lab.frame = CGRectMake(_title_lab.left, _title_lab.bottom+kWidth(9), _title_lab.width, kWidth(10));
    _watch_lab.font = [UIFont systemFontOfSize:kWidth(8)];
//    _watch_lab.backgroundColor = [UIColor redColor];
//    _watch_lab.attributedText = [self aaa];

    
    _name_lab.frame = CGRectMake(_watch_lab.left, _watch_lab.bottom+kWidth(9), _watch_lab.width, kWidth(11));
    _name_lab.font = [UIFont systemFontOfSize:kWidth(11)];
    
}//更新UI


-(void)setModel:(VideoItemModel *)model
{
    _model = model;
    
    [_video_img sd_setImageWithURL:[NSURL URLWithString:_model.coverImg] placeholderImage:[UIImage imageNamed:@"video_img_bg"]];
    _duration_lab.text = _model.videoDuration;
    _title_lab.text = _model.title;
    _watch_lab.attributedText = _model.recommedwatchCommentAtt;
    _name_lab.text = _model.hostNickName;
    
}


//-(NSMutableAttributedString *)aaa
//{
//    NSMutableAttributedString *attri =  [[NSMutableAttributedString alloc] initWithString:@" 5.1万  "];
//    // 2.添加表情图片
//        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
//        // 表情图片
//        attch.image = [UIImage imageNamed:@"icon_video_comment_gary"];
//
////        attch.image = [UIImage imageNamed:@"football.gif"];
//        // 设置图片大小
//        attch.bounds = CGRectMake(0, kWidth(-1), kWidth(8), kWidth(8));
//
//        // 创建带有图片的富文本
//        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
//        [attri insertAttributedString:string atIndex:0];// 插入某个位置
//
//
//    NSMutableAttributedString *att =  [[NSMutableAttributedString alloc] initWithString:@" 234"];
//    NSTextAttachment *attch2 = [[NSTextAttachment alloc] init];
//    attch2.image = [UIImage imageNamed:@"icon_video_play_gary"];
//    attch2.bounds = CGRectMake(0, kWidth(-1), kWidth(8), kWidth(8));
//    NSAttributedString *string2 = [NSAttributedString attributedStringWithAttachment:attch2];
//    [att insertAttributedString:string2 atIndex:0];// 插入某个位置
//    [attri appendAttributedString:att];
//
//    return attri;
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
