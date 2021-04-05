//
//  RecommendHeader.m
//  DragonLive
//
//  Created by LoaA on 2020/12/8.
//

#import "RecommendHeader.h"
#import "VideoDetailModel.h"
#import "LEECoolButton.h"
@interface RecommendHeader()

/// 头像
@property (nonatomic, strong) UIImageView *headImg;

/// 名字
@property (nonatomic, strong) UILabel       *nameLab;

/// 粉丝数
@property (nonatomic, strong) UILabel       *fansNumLab;

/// 简介
@property (nonatomic, strong) UILabel       *contentLab;

/// 点赞
@property (nonatomic, strong) LEECoolButton      *likeBtn;

/// 评论
@property (nonatomic, strong) UIButton      *commentBtn;

//分享
@property (nonatomic, strong) UIButton      *shareBtn;

/// 那条线
@property (nonatomic, strong) UIView        *line;

/// sectionLab
@property (nonatomic, strong) UILabel       *sectionLab;

@end


@implementation RecommendHeader

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

-(void)updateFrame
{
    _headImg.frame = CGRectMake(kWidth(15), kWidth(14), kWidth(36), kWidth(36));
    _nameLab.frame = CGRectMake(_headImg.right+kWidth(8), _headImg.top+kWidth(3), kWidth(150), kWidth(14));
    _nameLab.center = CGPointMake(_nameLab.centerX, _headImg.centerY);
    _fansNumLab.frame = CGRectMake(_nameLab.left, _headImg.bottom-kWidth(12), _nameLab.width, kWidth(12));
    
    _contentLab.frame = CGRectMake(kWidth(17), _headImg.bottom+kWidth(14), kScreenWidth-kWidth(34), self.height-kWidth(152));
    _likeBtn.frame = CGRectMake(0, _contentLab.bottom, kScreenWidth/3, kWidth(40));
    _commentBtn.frame = CGRectMake(_likeBtn.right, _contentLab.bottom, _likeBtn.width, _likeBtn.height);
    _shareBtn.frame = CGRectMake(_commentBtn.right, _contentLab.bottom, _commentBtn.width, _commentBtn.height);
    _line.frame = CGRectMake(0, _likeBtn.bottom, kScreenWidth, kWidth(10));
    _sectionLab.frame = CGRectMake(kWidth(17), _line.bottom+kWidth(16), 200, kWidth(16));

}//更新frame

-(void)setModel:(VideoDetailModel *)model{
    _model = model;
    [_headImg sd_setImageWithURL:[NSURL URLWithString:model.hostAvatar] placeholderImage:[UIImage imageNamed:@"headNomorl"]];
    _nameLab.text = _model.hostNickName;
    _fansNumLab.text = [NSString stringWithFormat:@"粉丝数:%@万粉丝",model.fansNumberOfCurUser];
    _contentLab.text = _model.title;
    [_likeBtn setTitle:_model.likeNumberOfCurVideo forState:UIControlStateNormal];
    [_commentBtn setTitle:_model.commentNumberOfCurVideo forState:UIControlStateNormal];
//    [_shareBtn setTitle:_model.shareNumberOfCurVideo forState:UIControlStateNormal];
    
}

-(void)initView
{
    
    _headImg = [[UIImageView alloc]init];
//    [_headImg setImage:[UIImage imageNamed:@"timg.jpeg"]];
    [self addSubview:_headImg];
    
    _nameLab = [[UILabel alloc]init];
    _nameLab.textColor = [UIColor colorFromHexString:@"222222"];
    _nameLab.font = [UIFont boldSystemFontOfSize:kWidth(14)];
//    _nameLab.text = @"阿斗归来了";
    [self addSubview:_nameLab];
    
    _fansNumLab = [[UILabel alloc]init];
//    _fansNumLab.text = @"粉丝数:459.2万粉丝";
    _fansNumLab.textColor = [UIColor colorFromHexString:@"999999"];
    _fansNumLab.font = [UIFont systemFontOfSize:kWidth(12)];
    _fansNumLab.hidden = YES;
    [self addSubview:_fansNumLab];

    _contentLab = [[UILabel alloc]init];
//    _contentLab.text = @"男子车祸后换成动物器官，一看到美女就控制不住自己《人面兽心》";
    _contentLab.numberOfLines = 0;
    _contentLab.textColor = [UIColor colorFromHexString:@"222222"];
    _contentLab.font = [UIFont systemFontOfSize:kWidth(16)];
    [self addSubview:_contentLab];

    _likeBtn = [LEECoolButton coolButtonWithImage:[UIImage imageNamed:@"icon_likeBtn"] ImageFrame:CGRectMake((kScreenWidth/3-20)/2, (kWidth(40)-20)/2, 20, 20)];
    
    [_likeBtn addTarget:self action:@selector(likeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _likeBtn.backgroundColor = [UIColor whiteColor];
    [self addSubview:_likeBtn];
    
    _commentBtn = [[UIButton alloc]init];
    _commentBtn.backgroundColor = [UIColor whiteColor];
    [self addSubview:_commentBtn];
    
    _shareBtn = [[UIButton alloc]init];
        _shareBtn.backgroundColor = [UIColor whiteColor];
    [self addSubview:_shareBtn];
    
    _likeBtn.titleLabel.font = _commentBtn.titleLabel.font = _shareBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(12)];
    [_likeBtn setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateNormal];
    [_commentBtn setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateNormal];
    [_shareBtn setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateNormal];
    
//    [_likeBtn setTitle:@"124" forState:UIControlStateNormal];
//    [_commentBtn setTitle:@"125" forState:UIControlStateNormal];
    [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    
//    [_likeBtn setImage:[UIImage imageNamed:@"icon_likeBtn"] forState:UIControlStateNormal];
    
    [_commentBtn setImage:[UIImage imageNamed:@"icon_commentBtn"] forState:UIControlStateNormal];
    [_shareBtn setImage:[UIImage imageNamed:@"icon_shareBtn"] forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(sharBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [_commentBtn addTarget:self action:@selector(commentBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    _line = [[UIView alloc]init];
    _line.backgroundColor = [UIColor colorFromHexString:@"FAFAFA"];
    [self addSubview:_line];

    _sectionLab = [[UILabel alloc]init];
    _sectionLab.font = [UIFont boldSystemFontOfSize:kWidth(16)];
    _sectionLab.textColor = [UIColor colorFromHexString:@"222222"];
    _sectionLab.text = @"推荐视频";
    [self addSubview:_sectionLab];
    
    [self updateFrame];
    [_headImg setCornerWithType:UIRectCornerAllCorners Radius:_headImg.width/2];

}//加载View

-(void)commentBtnOnClick
{
    if (self.reCommentBtnClickBlock) {
        self.reCommentBtnClickBlock();
    }
}//评论按钮点击


- (void)likeButtonAction:(LEECoolButton *)sender
{
    if (![[UserInstance shareInstance]isLogin]) {
        [UntilTools pushLoginPageSuccess:^{
            if (self.likeBtnClickBlock) {
                self.likeBtnClickBlock(_model);
            }
        //    NSInteger like = [_model.likeNum integerValue];
            if (sender.selected) {
                [sender deselect];
        //        _commentNum.text = [NSString stringWithFormat:@"%ld",like-1];
        //        _commentNum.textColor = [UIColor colorFromHexString:@"B8B8B8"];
            } else {
                [sender select];
        //        _commentNum.text = [NSString stringWithFormat:@"%ld",like+1];
        //        _commentNum.textColor = SelectedBtnColor;
            }
        }];
    }else{
        if (self.likeBtnClickBlock) {
            self.likeBtnClickBlock(_model);
        }
    //    NSInteger like = [_model.likeNum integerValue];
        if (sender.selected) {
            [sender deselect];
    //        _commentNum.text = [NSString stringWithFormat:@"%ld",like-1];
    //        _commentNum.textColor = [UIColor colorFromHexString:@"B8B8B8"];
        } else {
            [sender select];
    //        _commentNum.text = [NSString stringWithFormat:@"%ld",like+1];
    //        _commentNum.textColor = SelectedBtnColor;
        }
    }
    
   
//    _model.likeNum = _commentNum.text;
}//点赞按钮



-(void)sharBtnOnClick
{
    if (self.shareBtnBlock) {
        self.shareBtnBlock();
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
