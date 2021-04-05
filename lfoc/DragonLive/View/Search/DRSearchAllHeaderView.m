//
//  DRSearchAllHeaderView.m
//  DragonLive
//
//  Created by 11号 on 2020/12/19.
//

#import "DRSearchAllHeaderView.h"

@interface DRSearchAllHeaderView ()

@property (nonatomic, weak) IBOutlet UILabel *titleLab;

@end

@implementation DRSearchAllHeaderView

- (void)setTitleStr:(NSString *)titleStr
{
    self.titleLab.text = titleStr;
}

- (IBAction)moreAction:(id)sender
{
    if (self.moreBlock) {
        self.moreBlock();
    }
}

@end
