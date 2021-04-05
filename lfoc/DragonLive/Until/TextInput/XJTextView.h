//
//  XJTextView.h
//  XJ_WeChat
//
//  Created by mac on 2019/5/9.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XJInputUtil.h"

@interface XJTextView : UITextView

/// 占位颜色与文字（可换行）
@property (nonatomic,strong) UIColor *placeholderColor;
@property (nonatomic,  copy) NSString *placeholderText;

/// 最大可输入数量，默认250
@property (nonatomic,assign) NSInteger maxLength;
/// 是否展现数字统计，默认不展现
@property (nonatomic,assign) BOOL showTipLb;
@property (nonatomic,strong) UIFont *tipsFont;
@property (nonatomic,strong) UIColor *tipsNormalColor;
@property (nonatomic,strong) UIColor *tipsAttriColor;
/// 统计类型（普通统计、特殊统计）
@property (nonatomic,assign) XJStatisticsType statisticsType;

@end
