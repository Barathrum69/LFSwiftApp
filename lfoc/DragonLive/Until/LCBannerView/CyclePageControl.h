//
//  CyclePageControl.h
//  SimpleBanner
//
//  Created by 11号 on 2021/1/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define dotW 6
#define marginTopDown 5
#define margin 5

@interface CyclePageControl : UIView

//小圆点选中颜色
@property (nonatomic,strong)UIColor *pageControlSelectColor;
//小圆点默认颜色
@property (nonatomic,strong)UIColor *pageControlNormalColor;

@property (nonatomic,assign)NSInteger numberOfPages;

@property (nonatomic,assign)NSInteger currentPage;

- (id)initWithFrame:(CGRect)frame withCount:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
