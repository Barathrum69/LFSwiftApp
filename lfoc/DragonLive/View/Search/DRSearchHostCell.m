//
//  DRSearchHostCell.m
//  DragonLive
//
//  Created by 11号 on 2020/12/19.
//

#import "DRSearchHostCell.h"
#import "LiveHosts.h"

@interface DRSearchHostCell ()

@property (nonatomic, weak) IBOutlet UIImageView *headerImgView;
@property (nonatomic, weak) IBOutlet UIImageView *statusImgView;
@property (nonatomic, weak) IBOutlet UILabel *nameLab;
@property (nonatomic, weak) IBOutlet UILabel *followLab;

@end

@implementation DRSearchHostCell

- (void)setHostModel:(LiveHosts *)hostModel
{
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:hostModel.headicon] placeholderImage:[UIImage imageNamed:@"headNomorl"]];
    self.nameLab.text = hostModel.nickname;
    self.followLab.text = [NSString stringWithFormat:@"%@人关注",hostModel.fansnum];
    //正在直播
    if ([hostModel.livestatus integerValue] == 1) {
        NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"live_status.gif" ofType:@""]];
        UIImage *gifImg = [UIImage sd_imageWithGIFData:gifData];
        self.statusImgView.image = gifImg;
    }else {
        self.statusImgView.image = nil;
    }
}

@end
