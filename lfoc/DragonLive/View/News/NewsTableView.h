//
//  NewsTableView.h
//  DragonLive
//
//  Created by LoaA on 2021/2/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class NewsItemModel;
typedef void(^ItemDidSelectBlock) (NewsItemModel *model);
@interface NewsTableView : UITableView<UITableViewDelegate,UITableViewDataSource>
/// 总数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

/// 页码
@property (nonatomic, assign) NSInteger page;

/// 点击
@property (nonatomic, copy) ItemDidSelectBlock itemDidSelectBlock;

@end

NS_ASSUME_NONNULL_END
