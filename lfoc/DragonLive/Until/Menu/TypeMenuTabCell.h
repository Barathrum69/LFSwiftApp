//
//  TypeMenuTabCell.h
//  Alerts
//
//  Created by 王明 on 2019/10/29.
//  Copyright © 2019 王明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TypeMenuTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *img;
+ (instancetype)msGetInstance;
@end

NS_ASSUME_NONNULL_END
