//
//  UIControl+Interval.h
//  DragonLive
//
//  Created by 11号 on 2021/1/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIControl (Interval)
 
 
@property (nonatomic, assign) NSTimeInterval cjr_acceptEventInterval;// 可以用这个给重复点击加间隔
 
 
 
@end


NS_ASSUME_NONNULL_END
