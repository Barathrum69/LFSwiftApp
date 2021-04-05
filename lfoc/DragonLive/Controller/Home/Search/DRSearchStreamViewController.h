//
//  DRSearchStreamViewController.h
//  DragonLive
//
//  Created by 11号 on 2020/12/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^FooterLoadMoreBlock)(void);

@interface DRSearchStreamViewController : UIViewController

@property (nonatomic, copy) FooterLoadMoreBlock footerLoadBlock;

- (void)reloadHostData:(NSArray *)dataArray;

@end

NS_ASSUME_NONNULL_END
