//
//  VideoCommentTableViewCell.m
//  DragonLive
//
//  Created by LoaA on 2020/12/8.
//

#import "VideoCommentTableViewCell.h"
#import "LEECoolButton.h"
#import "VideoCommentModel.h"
@implementation VideoCommentTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    _headImg.frame = CGRectMake(kWidth(14), kWidth(13), kWidth(30), kWidth(30));
    [_headImg setImage:[UIImage imageNamed:@"timg.jpeg"]];
    [_headImg setCornerWithType:UIRectCornerAllCorners Radius:_headImg.width/2];
    
    _nameLab.font = [UIFont systemFontOfSize:kWidth(13)];
    _nameLab.textColor = [UIColor colorFromHexString:@"666666"];
    _nameLab.text = @"Faker大魔王";
    
    _messageLab.font = [UIFont systemFontOfSize:kWidth(15)];
    _messageLab.textColor = [UIColor colorFromHexString:@"222222"];
//    _messageLab.text = @"我是评论内容";
    _messageLab.numberOfLines = 0;
    
    
    _timeLab.font = [UIFont systemFontOfSize:kWidth(11)];
    _timeLab.textColor = [UIColor colorFromHexString:@"B8B8B8"];
//    _timeLab.text = @"11-16 18:01";
    
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(12)];
    [_deleteBtn setTitleColor:[UIColor colorFromHexString:@"222222"] forState:UIControlStateNormal];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deleteBtnOnClickAction) forControlEvents:UIControlEventTouchUpInside];
    _commentNum.font = [UIFont systemFontOfSize:kWidth(11)];
    _commentNum.textColor = [UIColor colorFromHexString:@"B8B8B8"];
//    _commentNum.text = @"1242";
    [_commentNum sizeToFit];
    
    _likeBtn = [LEECoolButton coolButtonWithImage:[UIImage imageNamed:@"icon_likeBtn"] ImageFrame:CGRectMake(kWidth(10), kWidth(10), kWidth(20), kWidth(20))];

//    [_greatBtn setImage:[UIImage imageNamed:@"icon_likeBtn"] forState:UIControlStateNormal];
    _likeBtn.imageColorOn = [UIColor colorFromHexString:@"F67C37"];
    _likeBtn.circleColor = [UIColor colorFromHexString:@"ffcece"];
    _likeBtn.lineColor = [UIColor colorFromHexString:@"ffcece"];
    
    [_likeBtn addTarget:self action:@selector(likeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_likeBtn];
    
}//awakeFromNib 设置他的颜色 font

-(void)updateFrame
{
    
//    kScreenWidth - kWidth(68);
    _headImg.frame = CGRectMake(kWidth(14), kWidth(13), kWidth(30), kWidth(30));
    _nameLab.frame = CGRectMake(_headImg.right+kWidth(11), _headImg.top, kWidth(200), kWidth(13));
    _messageLab.frame = CGRectMake(_nameLab.left, _nameLab.bottom+kWidth(13), kScreenWidth-_nameLab.left-kWidth(13), _model.messageHeight);
    _timeLab.frame = CGRectMake(_messageLab.left, self.height-kWidth(26), kWidth(150), kWidth(9));
    _deleteBtn.frame = CGRectMake(kScreenWidth-kWidth(10+40), 0, kWidth(40), kWidth(20));
    _deleteBtn.center = CGPointMake(_deleteBtn.centerX, _nameLab.centerY);
    
    
    _commentNum.frame = CGRectMake(kScreenWidth-kWidth(10)-_commentNum.width, _timeLab.top, _commentNum.width, _commentNum.height);
    
    
    _likeBtn.frame = CGRectMake(kScreenWidth-kWidth(3)-_commentNum.width-kWidth(40), 0, kWidth(40), kWidth(40));
    _likeBtn.center = CGPointMake(_likeBtn.centerX, _timeLab.centerY);

    

    
}//更新UI位置


-(void)deleteBtnOnClickAction
{
    if (self.deleteBtnOnClick) {
        self.deleteBtnOnClick(_model);
    }
}//删除



-(void)layoutSubviews
{
    [super layoutSubviews];
    [self updateFrame];
}//layoutSubviews

- (void)likeButtonAction:(LEECoolButton *)sender
{
    if (![[UserInstance shareInstance]isLogin]) {
        [UntilTools pushLoginPageSuccess:^{
            if (self.likeBtnOnClick) {
                self.likeBtnOnClick(self->_model);
            }
            NSInteger like = [self->_model.likeNum integerValue];
            if (sender.selected) {
                [sender deselect];
                self->_commentNum.text = [NSString stringWithFormat:@"%ld",like-1];
                self->_commentNum.textColor = [UIColor colorFromHexString:@"B8B8B8"];
            } else {
                [sender select];
                self->_commentNum.text = [NSString stringWithFormat:@"%ld",like+1];
                self->_commentNum.textColor = [UIColor colorFromHexString:@"F67C37"];
            }
            self->_model.likeNum = self->_commentNum.text;
        }];
    }else{
        if (self.likeBtnOnClick) {
            self.likeBtnOnClick(_model);
        }
        NSInteger like = [_model.likeNum integerValue];
        if (sender.selected) {
            [sender deselect];
            _commentNum.text = [NSString stringWithFormat:@"%ld",like-1];
            _commentNum.textColor = [UIColor colorFromHexString:@"B8B8B8"];
        } else {
            [sender select];
            _commentNum.text = [NSString stringWithFormat:@"%ld",like+1];
            _commentNum.textColor = [UIColor colorFromHexString:@"F67C37"];
        }
        _model.likeNum = _commentNum.text;
    }
}//点赞按钮

-(void)setModel:(VideoCommentModel *)model{
    _model = model;
    [_headImg sd_setImageWithURL:[NSURL URLWithString:_model.userHeadPicUrl] placeholderImage:nil];
    _nameLab.text = _model.nickname;
    _messageLab.text = _model.content;
    _timeLab.text = _model.commentTime;
    _commentNum.text = _model.likeNum;
    if ([_model.likeStatus isEqualToString:@"2"]) {
        _likeBtn.selected = NO;
        _commentNum.textColor = [UIColor colorFromHexString:@"B8B8B8"];

    }else{
        _likeBtn.selected = YES;
        _commentNum.textColor = [UIColor colorFromHexString:@"F67C37"];
    }
    
    if ([_model.userId isEqualToString:[UserInstance shareInstance].userId]) {
        _deleteBtn.hidden = NO;
    }else{
        _deleteBtn.hidden = YES;
    }
    
//    [self updateFrame];
}


@end
