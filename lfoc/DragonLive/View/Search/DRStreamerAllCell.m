//
//  DRStreamerAllCell.m
//  DragonLive
//
//  Created by 11号 on 2020/12/18.
//

#import "DRStreamerAllCell.h"
#import <UIImageView+WebCache.h>
#import "LiveHosts.h"

@interface DRStreamerAllCell ()

@property (nonatomic, weak) IBOutlet UIImageView *headerImgView;
@property (nonatomic, weak) IBOutlet UIImageView *statusImgView;
@property (nonatomic, weak) IBOutlet UILabel *nameLab;

@end

@implementation DRStreamerAllCell

- (void)setLiveHosts:(LiveHosts *)hostsModel
{
    [self setLiveHosts:hostsModel searchKey:@""];
}

- (void)setLiveHosts:(LiveHosts *)hostsModel searchKey:(NSString *)searchKey
{
    NSRange range = [hostsModel.nickname rangeOfString:searchKey];
    if (range.length) {
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:hostsModel.nickname];
        [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"#F67C37"] range:range];
        self.nameLab.attributedText = attri;
    }else {
        self.nameLab.text = hostsModel.nickname;
    }
    
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:hostsModel.headicon] placeholderImage:[UIImage imageNamed:@"headNomorl"]];
    //正在直播
    if ([hostsModel.livestatus integerValue] == 1) {
        NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"live_status.gif" ofType:@""]];
        UIImage *gifImg = [UIImage sd_imageWithGIFData:gifData];
        self.statusImgView.image = gifImg;
    }else {
        self.statusImgView.image = nil;
    }
}

@end
