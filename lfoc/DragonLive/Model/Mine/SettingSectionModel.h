//
//  SettingSectionModel.h
//  BallSaintSport
//
//  Created by LoaA on 2020/11/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SettingSectionModel : NSObject


/// 传空表示分组无名称
@property (nonatomic,copy) NSString  *sectionHeaderName;

/// 分组header高度
@property (nonatomic,assign) CGFloat  sectionHeaderHeight;

///item模型数组
@property (nonatomic,strong) NSArray  *itemArray;

/// 背景色
@property (nonatomic,strong) UIColor  *sectionHeaderBgColor;

@end
