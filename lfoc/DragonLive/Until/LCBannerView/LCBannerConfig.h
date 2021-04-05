//
//  LCBannerConfig.h
//  cecece
//
//  Created by 刘璇 on 2020/8/20.
//  Copyright © 2020 ChangSong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSInteger {
    //充满屏幕
    PageControlShowTypeFill,
    
    //充满图片
    PageControlShowTypeFit
} PageControlShowType;


@interface LCBannerConfig : NSObject


/// 背景色
@property (nonatomic,strong)UIColor *backGroundColor;
//scrollView 相对于父视图的内边距
@property (nonatomic,assign)UIEdgeInsets scrollViewEdges;
///默认 UIViewContentModeScaleAspectFill
@property (nonatomic)UIViewContentMode imageViewContentMode;
//图片圆角 
@property (nonatomic,assign)CGFloat scrollViewRadius;

#pragma mark ----------------------------
#pragma mark 滚动相关设置
///是否 自动滚动  默认yes
@property (nonatomic,assign)BOOL autoScroll;
//滚动周期设置  默认2秒
@property (nonatomic,assign)CGFloat animationTime;
//单个视图是否滚动  默认为NO 即单个图片时不滚动
@property (nonatomic,assign)BOOL singleScroll;


#pragma mark ----------------------------
#pragma mark pageControl相关设置
///是否 显示pagecontroller 默认YES
@property (nonatomic,assign)BOOL showPageController;
//小圆点选中颜色
@property (nonatomic,strong)UIColor *pageControlSelectColor;
//小圆点默认颜色
@property (nonatomic,strong)UIColor *pageControlNormalColor;
//小圆点底部距离 默认与scrollViewEdges的bottom相同
@property (nonatomic,assign)CGFloat pageControlBottomDistance;
//小圆点背景色
@property (nonatomic,strong)UIColor *pageControlBackGroundColor;
//小圆点的显示方式 -- 当图片有左右边距，pagecontroller有背景色的时候，设置不同样式
//如果没有左右边距，两者没啥区别
@property (nonatomic,assign)PageControlShowType pageControllerShowType;
//单个图片时是否显示  默认为NO
@property (nonatomic,assign)BOOL showPageControllerInSingle;

@end

NS_ASSUME_NONNULL_END
