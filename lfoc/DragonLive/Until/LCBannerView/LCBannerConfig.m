//
//  LCBannerConfig.m
//  cecece
//
//  Created by 刘璇 on 2020/8/20.
//  Copyright © 2020 ChangSong. All rights reserved.
//

#import "LCBannerConfig.h"

@implementation LCBannerConfig

///// 背景色
//@property (nonatomic,strong)UIColor *backGroundColor;
/////左侧边距
//@property (nonatomic,assign)CGFloat leftSpace;
/////右侧边距
//@property (nonatomic,assign)CGFloat rightSpace;
/////上方边距
//@property (nonatomic,assign)CGFloat topSpace;
/////下方边距
//@property (nonatomic,assign)CGFloat bottomSpace;
//
/////是否 显示pagecontroller
//@property (nonatomic,assign)BOOL showPageController;


-(instancetype)init{
    self = [super init];
    if (self) {
        self.backGroundColor = [UIColor clearColor];
        self.scrollViewEdges = UIEdgeInsetsMake(0, 0, 0, 0);
        
        self.showPageController = NO;
        self.autoScroll = YES;
        self.animationTime = 2.0f;
        self.singleScroll = NO;
        
        self.imageViewContentMode = UIViewContentModeScaleToFill;
        self.scrollViewRadius = 0;
        
        self.showPageController = YES;
        self.pageControlSelectColor = [UIColor whiteColor];
        self.pageControlNormalColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
        self.pageControlBottomDistance = 4;
        self.pageControlBackGroundColor = [UIColor clearColor];
        self.pageControllerShowType = PageControlShowTypeFit;
        self.showPageControllerInSingle = NO;
        
    }
    return self;
}


@end
