//
//  LiveBannerHeaderView.h
//  DragonLive
//
//  Created by 11号 on 2021/1/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 首页广告banner
@interface LiveBannerHeaderView : UICollectionReusableView

@property (nonatomic, strong) NSArray *marqueeArray;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) void (^selectedItemHelper)(NSUInteger index);
@property (nonatomic, copy) void (^selectedMarquee)(void);

//- (void)clearBanner;

@end

NS_ASSUME_NONNULL_END
