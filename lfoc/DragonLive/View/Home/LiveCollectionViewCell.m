//
//  LiveCollectionViewCell.m
//  DragonLive
//
//  Created by 11号 on 2020/11/26.
//

#import "LiveCollectionViewCell.h"
#import "LiveItem.h"
#import <UIImageView+WebCache.h>
#import "LiveStatusGifView.h"

@interface LiveCollectionViewCell ()


/// 直播封面图
@property (nonatomic, weak) IBOutlet UIImageView *coverImgView;

/// 主播名称
@property (nonatomic, weak) IBOutlet UILabel *hostNameLab;

/// 直播标题
@property (nonatomic, weak) IBOutlet UILabel *liveTitleLab;

/// 直播热度
@property (nonatomic, weak) IBOutlet UILabel *liveHotLab;

/// 热度icon
@property (nonatomic, weak) IBOutlet UIImageView *hotImgView;

@property (nonatomic, weak) IBOutlet LiveStatusGifView *gifView;

@end

@implementation LiveCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellItem:(LiveItem *)item
{
    [self setCellItem:item searchKey:@""];
}

- (void)setCellItem:(LiveItem *)item searchKey:(NSString *)searchKey
{
    NSRange range = [item.liveTitle rangeOfString:searchKey];
    if (searchKey.length && range.length) {
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:item.liveTitle];
        [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"#F67C37"] range:range];
        self.liveTitleLab.attributedText = attri;
    }else {
        self.liveTitleLab.text = item.liveTitle;
    }
    
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:item.coverImg] placeholderImage:[UIImage imageNamed:@"video_img_bg"]];
    self.hostNameLab.text = item.belongHostName;
    
    if ([item.liveStatus integerValue] == 1) {
        self.gifView.hidden = NO;
    }else {
        self.gifView.hidden = YES;
    }
    
//    if ([item.hot integerValue] > 0) {
//        self.hotImgView.hidden = NO;
//    }else {
//        self.hotImgView.hidden = YES;
//    }
    
    //热度超过1万显示单位：万
    self.liveHotLab.text = item.hot;
//    if ([item.hot integerValue] >= 10000) {
//        if ([item.hot integerValue] % 10000 == 0) {
//            self.liveHotLab.text = [NSString stringWithFormat:@"%ld万",[item.hot integerValue] / 10000];
//        }else {
//            //浮点数四舍五入
//            self.liveHotLab.text = [NSString stringWithFormat:@"%0.1f万",[item.hot floatValue] / 10000];
//        }
//        
//    }else {
//        
//    }
}

@end
