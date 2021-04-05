//
//  TypeMenuTabCell.m
//  Alerts
//
//  Created by 王明 on 2019/10/29.
//  Copyright © 2019 王明. All rights reserved.
//

#import "TypeMenuTabCell.h"

@implementation TypeMenuTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+ (instancetype)msGetInstance{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
