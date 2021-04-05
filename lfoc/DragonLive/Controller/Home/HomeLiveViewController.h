//
//  HomeLiveViewController.h
//  DragonLive
//
//  Created by 11号 on 2020/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeLiveViewController : BaseViewController

@property (nonatomic) NSInteger selectIndex;                                        //当前选中的大分类索引

- (void)selectedLiveType:(NSInteger)selectIndex;

@end

NS_ASSUME_NONNULL_END
