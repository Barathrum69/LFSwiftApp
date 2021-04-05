//
//  MatchTableViewCell.m
//  DragonLive
//
//  Created by LoaA on 2020/12/4.
//

#import "MatchTableViewCell.h"
#import "MatchItemModel.h"
#import "LeftLabel.h"
#import "HostModel.h"
@implementation MatchTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self frameForUI];

    // Initialization code
}//awakeFromNib

-(void)frameForUI
{
    
    _timeLabel.frame = CGRectMake(kWidth(25), kWidth(26), kWidth(50), kWidth(12));
    _timeLabel.font = [UIFont boldSystemFontOfSize:kWidth(15)];
    
    _descriptionLabel.frame = CGRectMake(_timeLabel.left, _timeLabel.bottom+kWidth(6), _timeLabel.width, kWidth(25));
    _descriptionLabel.textColor = [UIColor colorFromHexString:@"999999"];
    _descriptionLabel.textAlignment = NSTextAlignmentCenter;
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.font = [UIFont systemFontOfSize:kWidth(9)];
    
    CGFloat top = (self.height-kWidth(18*2+7))/2;
    _homeImg.frame = CGRectMake(kWidth(102), top, kWidth(18), kWidth(18));
    _awayImg.frame = CGRectMake(_homeImg.left, _homeImg.bottom+kWidth(7), _homeImg.width, _homeImg.height);
    
    [_homeImg setCornerWithType:UIRectCornerAllCorners Radius:_homeImg.width/2 ];
    [_awayImg setCornerWithType:UIRectCornerAllCorners Radius:_awayImg.width/2];
    
    _homeName.frame = CGRectMake(_homeImg.right+kWidth(10), _homeImg.top, kWidth(100), _homeImg.height);
    _homeName.textColor = [UIColor colorFromHexString:@"222222"];
    _homeName.font = [UIFont systemFontOfSize:kWidth(15)];
    
    _awayName.frame = CGRectMake(_homeName.left, _awayImg.top, _homeName.width, _homeName.height);
    _awayName.textColor = [UIColor colorFromHexString:@"222222"];
    _awayName.font = [UIFont systemFontOfSize:kWidth(15)];
    
    _hostImg.frame = CGRectMake(kScreenWidth-kWidth(40+40+35), (self.height-kWidth(40))/2, kWidth(40), kWidth(40));
    _hostImg2.frame = CGRectMake(_hostImg.right-kWidth(20), (self.height-kWidth(40))/2, kWidth(40), kWidth(40));
    _hostImg2.backgroundColor = [UIColor redColor];
    
    _hostImg3.frame = CGRectMake(_hostImg2.right-kWidth(20), (self.height-kWidth(40))/2, kWidth(40), kWidth(40));
    _hostImg3.backgroundColor = [UIColor blackColor];
    
    [_hostImg setCornerWithType:UIRectCornerAllCorners Radius:_hostImg.width/2];
    [_hostImg2 setCornerWithType:UIRectCornerAllCorners Radius:_hostImg.width/2];
    [_hostImg3 setCornerWithType:UIRectCornerAllCorners Radius:_hostImg.width/2];

    _videoLiveIcon.frame = CGRectMake(_hostImg.left, _hostImg.bottom+kWidth(3), kWidth(12), kWidth(12));
    _liveLab.frame = CGRectMake(_videoLiveIcon.right+kWidth(3), _videoLiveIcon.top, kWidth(50), kWidth(12));
    _liveLab.textColor = [UIColor colorFromHexString:@"222222"];
    _liveLab.font = [UIFont systemFontOfSize:kWidth(10)];
    _liveLab.text = @"视频直播";
//    _watchBtn.backgroundColor = [UIColor colorFromHexString:@"4EBCFF"];
//    _watchBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(15)];
//    [_watchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}//frameUI


-(void)setModel:(MatchItemModel *)model{
    _model = model;
    _timeLabel.text = _model.time;
    _descriptionLabel.text = _model.title;
//    _descriptionLabel.text = @"乌拉乌拉乌拉乌拉乌拉";
    [_homeImg sd_setImageWithURL:[NSURL URLWithString:_model.teamALogo]placeholderImage:[UIImage imageNamed:@"headNomorl"]];
    [_awayImg sd_setImageWithURL:[NSURL URLWithString:_model.teamBLogo]placeholderImage:[UIImage imageNamed:@"headNomorl"]];
    _homeName.text = _model.teamA;
    _awayName.text = _model.teamB;
//    if (_model.hostAvatarUrl.length != 0) {
//        _hostImg.hidden = NO;
//        [_hostImg sd_setImageWithURL:[NSURL URLWithString:_model.hostAvatarUrl]placeholderImage:[UIImage imageNamed:@"headNomorl"]];
//    }else{
//        _hostImg.hidden = YES;
//    }

//    if ([_model.forward isEqualToString:@"0"]) {
        
        if (_model.liveHosts.count >= 3) {
            _hostImg3.hidden = _hostImg2.hidden = _hostImg.hidden = NO;
            
            HostModel *model0 = _model.liveHosts[0];
            HostModel *model1 = _model.liveHosts[1];
            HostModel *model2 = _model.liveHosts[2];
        
            [_hostImg sd_setImageWithURL:[NSURL URLWithString:model0.avatar] placeholderImage:[UIImage imageNamed:@"headNomorl"]];
            [_hostImg2 sd_setImageWithURL:[NSURL URLWithString:model1.avatar] placeholderImage:[UIImage imageNamed:@"headNomorl"]];
            [_hostImg3 sd_setImageWithURL:[NSURL URLWithString:model2.avatar] placeholderImage:[UIImage imageNamed:@"headNomorl"]];

        }else if(_model.liveHosts.count == 2){
            _hostImg.hidden = _hostImg2.hidden = NO;
            _hostImg3.hidden = YES;
            HostModel *model0 = _model.liveHosts[0];
            HostModel *model1 = _model.liveHosts[1];
//            HostModel *model2 = _model.refHosts[2];

            [_hostImg sd_setImageWithURL:[NSURL URLWithString:model0.avatar] placeholderImage:[UIImage imageNamed:@"headNomorl"]];
            [_hostImg2 sd_setImageWithURL:[NSURL URLWithString:model1.avatar] placeholderImage:[UIImage imageNamed:@"headNomorl"]];
//            [_hostImg3 sd_setImageWithURL:[NSURL URLWithString:model2.avatar] placeholderImage:[UIImage imageNamed:@"headNomorl"]];
            
            
        }else if(_model.liveHosts.count == 1){
            _hostImg.hidden = NO;
            _hostImg3.hidden = _hostImg2.hidden =YES;
            HostModel *model0 = _model.liveHosts[0];
//            HostModel *model1 = _model.refHosts[1];
//            HostModel *model2 = _model.refHosts[2];

            [_hostImg sd_setImageWithURL:[NSURL URLWithString:model0.avatar] placeholderImage:[UIImage imageNamed:@"headNomorl"]];
//            [_hostImg2 sd_setImageWithURL:[NSURL URLWithString:model1.avatar] placeholderImage:[UIImage imageNamed:@"headNomorl"]];
//            [_hostImg3 sd_setImageWithURL:[NSURL URLWithString:model2.avatar] placeholderImage:[UIImage imageNamed:@"headNomorl"]];

        }else{
            _hostImg3.hidden = _hostImg2.hidden = _hostImg.hidden = YES;
        }
    
    if (_model.url.length == 0) {
        _videoLiveIcon.hidden = YES;
        _liveLab.hidden = YES;
    }else{
        _videoLiveIcon.hidden = NO;
        _liveLab.hidden = NO;
        HostModel *model0 = [_model.refHosts lastObject];
        if (model0.statusOfLive) {
            [_videoLiveIcon setImage:[UIImage imageNamed:@"guanfanglive"]];
        }else{
            [_videoLiveIcon setImage:[UIImage imageNamed:@"unguanfanglive"]];

        }

    }
    
    
//    }else{
//        _hostImg3.hidden = _hostImg2.hidden = _hostImg.hidden = YES;
//    }

}

@end
