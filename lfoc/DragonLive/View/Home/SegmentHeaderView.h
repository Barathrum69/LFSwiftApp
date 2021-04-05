//
//  SegmentHeaderView.h
//  PersonalCenter
//
//  Created by Arch on 2018/8/20.
//  Copyright © 2018年 mint_bin. All rights reserved.
//

#import <UIKit/UIKit.h>
UIKIT_EXTERN CGFloat const SegmentHeaderViewHeight;

@interface SegmentHeaderViewCollectionViewCell : UICollectionViewCell
@property (nonatomic, readonly, strong) UILabel *titleLabel;
@end;

/// 直播首页二级分类view
@interface SegmentHeaderView : UIView
@property (nonatomic, assign) NSUInteger defaultSelectedIndex;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, copy) void (^selectedItemHelper)(NSUInteger index);

- (void)setTitleArray:(NSArray *)titleArray;
- (void)changeItemWithTargetIndex:(NSUInteger)targetIndex;
- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray;
@end
