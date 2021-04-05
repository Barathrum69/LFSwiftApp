//
//  AnchorHeadView.m
//  DragonLive
//
//  Created by LoaA on 2020/12/10.
//

#import "AnchorHeadView.h"
#import "ZYLineProgressView.h"
#import "AnchorModel.h"
#import "GradleModel.h"
#import "GradleSettingsModel.h"
@interface AnchorHeadView()

/// 头像图像
@property (nonatomic, strong) UIImageView *headImg;

/// 等级图像
@property (nonatomic, strong) UIImageView *levelImg;

/// 名字
@property (nonatomic, strong) UILabel *nameLab;

/// 房间号
@property (nonatomic, strong) UILabel *houseLab;

/// 那条竖线
@property (nonatomic, strong) UILabel *lineLab;

/// 粉丝数
@property (nonatomic, strong) UILabel *fansLab;

/// 进度条
@property (nonatomic, strong) ZYLineProgressView *progressView;

/// 经验label
@property (nonatomic, strong) UILabel *expLab;

///当前等级
@property (nonatomic, strong) UILabel *currentLevLab;

/// 下一个等级
@property (nonatomic, strong) UILabel *nextLevLab;

@end


@implementation AnchorHeadView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setCornerWithType:UIRectCornerAllCorners Radius:kWidth(3)];
        [self initView];
    }
    return self;
}//init


-(void)initView
{
    
    _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(29), kWidth(11), kWidth(57), kWidth(57))];
    [_headImg setCornerWithType:UIRectCornerAllCorners Radius:_headImg.width/2];
//    [_headImg setImage:[UIImage imageNamed:@"timg.jpeg"]];
    [self addSubview:_headImg];
    
    
    _levelImg = [[UIImageView alloc]initWithFrame:CGRectMake(_headImg.right-kWidth(27)+kWidth(6), _headImg.bottom-kWidth(11), kWidth(27), kWidth(11))];
//    [_levelImg setImage:[UIImage imageNamed:@"mine_lev_1"]];
    [self addSubview:_levelImg];
    
    
    
    _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(_headImg.right+kWidth(16), _headImg.top+kWidth(8),kWidth(200), kWidth(19))];
    _nameLab.textColor = [UIColor colorFromHexString:@"333333"];
    _nameLab.font = [UIFont systemFontOfSize:kWidth(19)];
//    _nameLab.text = @"可可西里";
    [self addSubview:_nameLab];

    _houseLab = [[UILabel alloc]initWithFrame:CGRectMake(_nameLab.left, _nameLab.bottom +kWidth(15), 100, kWidth(12))];
    _houseLab.font = [UIFont systemFontOfSize:kWidth(12)];
    _houseLab.textColor = [UIColor colorFromHexString:@"333333"];
//    _houseLab.text = @"房间号:11223344";
    [_houseLab sizeToFit];
    [self addSubview:_houseLab];
    
    _lineLab = [[UILabel alloc]initWithFrame:CGRectMake(_houseLab.right+kWidth(10), _houseLab.top+1, 1, _houseLab.height)];
    _lineLab.backgroundColor = [UIColor colorFromHexString:@"CCCCCC"];
    [self addSubview:_lineLab];
    
    _fansLab = [[UILabel alloc]initWithFrame:CGRectMake(_lineLab.right+kWidth(10), _houseLab.top, 100, _houseLab.height)];
    _fansLab.font = [UIFont systemFontOfSize:kWidth(12)];
    _fansLab.textColor = [UIColor colorFromHexString:@"333333"];
//    _fansLab.text = @"粉丝:1144";
    [_fansLab sizeToFit];
    [self addSubview:_fansLab];
    
    
    _progressView = [[ZYLineProgressView alloc]initWithFrame:CGRectMake((self.width-kWidth(180))/2, _headImg.bottom+kWidth(12), kWidth(180), kWidth(13))];
    [_progressView updateConfig:^(ZYLineProgressViewConfig *config) {
        config.isShowDot = NO;
        config.backLineColor = [UIColor colorFromHexString:@"AEAEAE"];
        config.progressLineColor = [UIColor colorFromHexString:@"379EF6"];
    }];
    [self addSubview:_progressView];
//    _progressView.progress = 0.5;
    
    _expLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _progressView.width, _progressView.height)];
    _expLab.font = [UIFont systemFontOfSize:kWidth(13)];
    _expLab.textColor = [UIColor whiteColor];
    _expLab.textAlignment = NSTextAlignmentCenter;
//    _expLab.text = @"150/300";
    [_progressView addSubview:_expLab];
    
    _currentLevLab = [[UILabel alloc]initWithFrame:CGRectMake(_progressView.left-kWidth(67), _progressView.top, kWidth(60), kWidth(13))];
    _currentLevLab.font = [UIFont systemFontOfSize:kWidth(13)];
    _currentLevLab.textColor = [UIColor colorFromHexString:@"363636"];
    _currentLevLab.textAlignment = NSTextAlignmentRight;
//    _currentLevLab.text = @"Lv103";
    [self addSubview:_currentLevLab];

    _nextLevLab = [[UILabel alloc]initWithFrame:CGRectMake(_progressView.right+kWidth(7), _progressView.top, kWidth(60), kWidth(13))];
    _nextLevLab.font = [UIFont systemFontOfSize:kWidth(13)];
    _nextLevLab.textColor = [UIColor colorFromHexString:@"363636"];
//    _nextLevLab.text = @"Lv104";
    [self addSubview:_nextLevLab];
    
    
}//initView

-(void)setModel:(AnchorModel *)model
{
    _model = model;
    _fansLab.text = [NSString stringWithFormat:@"粉丝:%@",_model.fansNumber];
    _nameLab.text = _model.nickname;
    _houseLab.text = [NSString stringWithFormat:@"房间号:%@",_model.liveBoardcastRoomNum];
    [_houseLab sizeToFit];

    _lineLab.frame = CGRectMake(_houseLab.right+kWidth(10), _houseLab.top+1, 1, _houseLab.height);
    _fansLab.frame = CGRectMake(_lineLab.right+kWidth(10), _houseLab.top, 100, _houseLab.height);
    
    [_headImg sd_setImageWithURL:[NSURL URLWithString:[UserInstance shareInstance].userModel.headicon] placeholderImage:[UIImage imageNamed:@"headNomorl"]];
    [_levelImg sd_setImageWithURL:[NSURL URLWithString:_model.gradleModel.image] placeholderImage:nil];
    //当前等级
    _currentLevLab.text = [NSString stringWithFormat:@"Lv%@",_model.gradleModel.gradle];
    //目标等级
    _nextLevLab.text = [NSString stringWithFormat:@"Lv%@",_model.gradleModel.gradleSettingsModel.targetGradle];
    //经验值
    _expLab.text = [NSString stringWithFormat:@"%@/%@",_model.gradleModel.experience,_model.gradleModel.gradleSettingsModel.experienceLimit];
    //当前等级
    float experience = [_model.gradleModel.experience floatValue];
    //等级总经验
    float experienceLimit = [_model.gradleModel.gradleSettingsModel.experienceLimit floatValue];
    
    _progressView.progress = experience/experienceLimit;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
