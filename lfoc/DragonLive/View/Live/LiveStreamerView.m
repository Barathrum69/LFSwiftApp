//
//  LiveStreamerView.m
//  DragonLive
//
//  Created by 11号 on 2020/12/9.
//

#import "LiveStreamerView.h"
#import "RoomInfo.h"

@interface LiveStreamerView ()

@property (nonatomic, strong) UIImageView *hostImgView;
@property (nonatomic, strong) UILabel *nickNameLab;
@property (nonatomic, strong) UILabel *hostFansLab;
@property (nonatomic, strong) UIImageView *levelImgView;
@property (nonatomic, strong) UIButton *followBut;
@property (nonatomic, strong) UILabel *noticeLab;

@end

@implementation LiveStreamerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = The_MainColor;
        
        CGFloat space = 10.0;           //左右边距
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(space, space, frame.size.width - 2 * space, 58.0)];
        topView.backgroundColor = [UIColor whiteColor];
        topView.layer.cornerRadius = 3;
        [self addSubview:topView];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 8, 42, 42)];
        imgView.layer.cornerRadius = 21;
        imgView.layer.masksToBounds = YES;
        [topView addSubview:imgView];
        self.hostImgView = imgView;
   
        UILabel *nickNameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame) + 13, space, 60, 15)];
        nickNameLab.font = [UIFont boldSystemFontOfSize:13.0];
        nickNameLab.textColor = [UIColor colorWithRGB:333333];
        [topView addSubview:nickNameLab];
        self.nickNameLab = nickNameLab;
        
        UILabel *fansLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nickNameLab.frame), CGRectGetMaxY(nickNameLab.frame) + 9, 100, 15)];
        fansLab.font = [UIFont systemFontOfSize:13.0];
        fansLab.textColor = [UIColor colorWithHexString:@"#333333"];
        [topView addSubview:fansLab];
        self.hostFansLab = fansLab;
    
        UIImageView *levelImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nickNameLab.frame) + 8, space, 28, 11)];
        [topView addSubview:levelImgView];
        self.levelImgView = levelImgView;
        
        UIButton *followBut = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(topView.frame) - 53 - 14, 11, 53, 37)];
        [followBut addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
        followBut.titleLabel.font = [UIFont systemFontOfSize:13];
        followBut.layer.cornerRadius = 3;
        [topView addSubview:followBut];
        self.followBut = followBut;
        
        UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(space, CGRectGetMaxY(topView.frame) + 14, CGRectGetWidth(topView.frame), 160)];
        centerView.backgroundColor = [UIColor whiteColor];
        centerView.layer.cornerRadius = 3;
        [self addSubview:centerView];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, CGRectGetWidth(centerView.frame), 18)];
        titleLab.text = @"主播公告";
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = [UIFont boldSystemFontOfSize:16.0];
        titleLab.textColor = [UIColor colorWithHexString:@"#222222"];
        [centerView addSubview:titleLab];
        
        UILabel *noticeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 42, CGRectGetWidth(centerView.frame), 15)];
        noticeLab.numberOfLines = 0;
        noticeLab.font = [UIFont systemFontOfSize:13.0];
        noticeLab.textColor = [UIColor colorWithHexString:@"#333333"];
        [centerView addSubview:noticeLab];
        self.noticeLab = noticeLab;
                
    }
    
    return self;
}

- (void)setRoomInfo:(RoomInfo *)roomInfo
{
    [self.hostImgView setImageURL:[NSURL URLWithString:roomInfo.hostHeadPicUrl]];
    self.hostImgView.layer.cornerRadius = 21;
    self.hostImgView.layer.masksToBounds = YES;
    
    CGFloat maxW = self.size.width - 140;        //最大宽
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0]};
    CGSize nickNameSize = [roomInfo.hostNickName boundingRectWithSize:CGSizeMake(maxW, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    self.nickNameLab.frame = CGRectMake(CGRectGetMaxX(_hostImgView.frame) + 13, 10, nickNameSize.width + 2, 15);
    self.nickNameLab.text = roomInfo.hostNickName;
    
    self.levelImgView.frame = CGRectMake(CGRectGetMaxX(self.nickNameLab.frame) + 8, 12, 28, 11);
    [self.levelImgView sd_setImageWithURL:[NSURL URLWithString:roomInfo.hostGradleImg]];
    
    if (!roomInfo.notice || !roomInfo.notice.length) {
        self.noticeLab.text = @"暂无公告";
        self.noticeLab.frame = CGRectMake(10, 42, self.size.width - 20 - 20,15);
    }else {
        self.noticeLab.text = roomInfo.notice;
        NSDictionary *noticeAttrs = @{NSFontAttributeName:[UIFont systemFontOfSize:13.0]};
        CGSize noticeSize = [roomInfo.notice boundingRectWithSize:CGSizeMake(self.size.width - 20 - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:noticeAttrs context:nil].size;
        self.noticeLab.frame = CGRectMake(10, 42, noticeSize.width, noticeSize.height);
    }
    
    self.hostFansLab.text = [NSString stringWithFormat:@"粉丝数：%@",roomInfo.hostFansNum];
//    //数量超过1万显示单位：万
//    if ([roomInfo.hostFansNum integerValue] > 10000) {
//        if ([roomInfo.hostFansNum integerValue] % 10000 == 0) {
//            self.hostFansLab.text = [NSString stringWithFormat:@"粉丝数：%ld万",[roomInfo.hostFansNum integerValue] / 10000];
//        }else {
//            self.hostFansLab.text = [NSString stringWithFormat:@"粉丝数：%0.1f万",[roomInfo.hostFansNum floatValue] / 10000];
//        }
//        
//    }else {
//        self.hostFansLab.text = [NSString stringWithFormat:@"粉丝数：%@",roomInfo.hostFansNum];
//    }
    
    NSInteger hostFollow = [roomInfo.hostFollow integerValue];
    CGFloat colorAlpha = hostFollow == 1 ? 0.5 : 1.0;
    [self.followBut setBackgroundColor:[[UIColor colorWithRed:246/255.0 green:124/255.0 blue:55/255.0 alpha:1.0] colorWithAlphaComponent:colorAlpha]];
    [self.followBut setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:colorAlpha] forState:UIControlStateNormal];
    [self.followBut setTitle:(hostFollow == 1 ? @"已关注" : @"+关注") forState:UIControlStateNormal];
}

- (void)followAction:(UIButton *)but
{
    if (self.followBlock) {
        self.followBlock();
    }
}

@end
