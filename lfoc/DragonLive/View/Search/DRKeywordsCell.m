//
//  DRKeywordsCell.m
//  DragonLive
//
//  Created by 11号 on 2020/12/17.
//

#import "DRKeywordsCell.h"

@interface DRKeywordsCell ()

@property (nonatomic, weak) IBOutlet UILabel *kwordsLab;

@end

@implementation DRKeywordsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setKeywords:(NSString *)keyword searchKey:(NSString *)searchKey
{
    NSRange range = [keyword rangeOfString:searchKey];
    if (range.length) {
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:keyword];
        [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"#F67C37"] range:range];
        self.kwordsLab.attributedText = attri;
    }else {
        self.kwordsLab.text = keyword;
    }
}

@end
