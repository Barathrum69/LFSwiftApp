//
//  DRSearchAllViewController.h
//  DragonLive
//
//  Created by 11号 on 2020/12/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MoreActionBlock)(NSInteger index);

@interface DRSearchAllViewController : UIViewController

@property (nonatomic, copy) MoreActionBlock tapActionBlock;
@property (nonatomic, copy) NSString *searchKey;

//全部数据加载完成后刷新
- (void)reloadData:(NSMutableArray *)allArray;

//清除搜索历史
- (void)clearSearchHistory;

@end

NS_ASSUME_NONNULL_END
