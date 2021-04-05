//
//  LCBannerView.h
//  cecece
//
//  Created by 刘璇 on 2020/8/20.
//  Copyright © 2020 ChangSong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCBannerConfig.h"
#import "BannerModel.h"


NS_ASSUME_NONNULL_BEGIN
@class LCBannerView;

#pragma mark ----------------------------
#pragma mark Delegate
@protocol LCBannerViewDelegate <NSObject>

-(void)bannerView:(LCBannerView *)view didSelect:(NSInteger)index;

@end


#pragma mark ----------------------------
#pragma mark DataSource
@protocol LCBannerViewDataSource <NSObject>
@required
-(NSInteger)numberOfCount;
//返回类型为 NSString，NSUrl ， UIImage
-(id)bannerView:(LCBannerView *)bannerView imageForIndex:(NSInteger)index;
@end




#pragma mark ----------------------------
#pragma mark 类的具体信息
@interface LCBannerView : UIView
@property (nonatomic,weak)id<LCBannerViewDelegate> delegate;
@property (nonatomic,weak)id<LCBannerViewDataSource> dataSource;
///类的一些基础信息配置
@property (nonatomic,strong,readonly)LCBannerConfig *config;
///重新加载数据
-(void)reloadData;

@end

NS_ASSUME_NONNULL_END
