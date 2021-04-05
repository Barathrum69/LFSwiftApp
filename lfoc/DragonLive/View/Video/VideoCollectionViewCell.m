//
//  VideoCollectionViewCell.m
//  DragonLive
//
//  Created by LoaA on 2020/12/3.
//

#import "VideoCollectionViewCell.h"
#import "VideoItemModel.h"

NSString *const VideoCollectionViewCellID = @"VideoCollectionViewCellID";

@interface VideoCollectionViewCell()
/**
 视频图.
 */
@property (nonatomic, strong) UIImageView   *videoImg;

/**
 标题label
 */
@property (nonatomic, strong) UILabel       *titleLabel;

/**
 时间label
 */
@property (nonatomic, strong) UILabel       *timeLabel;

/**
 多少观看 多少人评论, 用一个富文本显示的
 */
@property (nonatomic, strong) UILabel       *watchLabel;

@end

@implementation VideoCollectionViewCell
- (void)prepareForReuse
{
    [super prepareForReuse];
}//滑出的时候要清空一些数据

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupViews];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}//初始化


-(void)setupViews
{
    _videoImg = ({
        UIImageView *videoImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, kWidth(102))];
        videoImg.contentMode = UIViewContentModeScaleToFill;
        [videoImg setCornerWithType:UIRectCornerAllCorners Radius:kWidth(6)];
//        [videoImg setImage:[UIImage imageNamed:@"aaaa.jpeg"]];
        [self addSubview:videoImg];
        videoImg;
    });
    
    _watchLabel = ({
//        kWidth(100)
        UILabel *watchLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth(8), _videoImg.height-kWidth(18), kWidth(100), kWidth(11))];
//        watchLabel.backgroundColor = [UIColor redColor];
//        watchLabel.attributedText = [self aaa];
        watchLabel.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        watchLabel.font = [UIFont systemFontOfSize:kWidth(8)];
        [_videoImg addSubview:watchLabel];
        watchLabel;
    });
    
    
    _timeLabel = ({
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width-kWidth(88), _videoImg.height-kWidth(14), kWidth(80), kWidth(7))];
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.font = [UIFont systemFontOfSize:kWidth(8)];
//        timeLabel.text = @"24:24:24";
        [_videoImg addSubview:timeLabel];
        timeLabel;
        
    });
    
    
    _titleLabel = ({
        CGFloat scan = (self.height-_videoImg.height-kWidth(14))/2;
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth(8), _videoImg.bottom + scan, self.width-kWidth(16), kWidth(14))];
//        titleLabel.text = @"苹果秋季新品发布会";
        titleLabel.font = [UIFont systemFontOfSize:kWidth(13)];
        titleLabel.textColor = [UIColor colorWithHexString:@"222222"];
        [self addSubview:titleLabel];
        titleLabel;
    });
    
}//加载View


-(void)configureCellWithModel:(VideoItemModel *)model
{
    [self configureCellWithModel:model searchKey:@""];
}//赋值

-(void)configureCellWithModel:(VideoItemModel *)model searchKey:(NSString *)searchKey
{
    NSRange range = [model.title rangeOfString:searchKey];
    if (range.length && searchKey.length) {
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:model.title];
        [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"#F67C37"] range:range];
        _titleLabel.attributedText = attri;
    }else {
        _titleLabel.text = model.title;
    }
    
    _watchLabel.attributedText = model.watchAndCommentAtt;
    _timeLabel.text = model.videoDuration;
    [_videoImg sd_setImageWithURL:[NSURL URLWithString:model.coverImg] placeholderImage:[UIImage imageNamed:@"video_img_bg"]];
}

@end
