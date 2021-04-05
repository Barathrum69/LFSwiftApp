//
//  RecommendVideoTableView.h
//  DragonLive
//
//  Created by LoaA on 2020/12/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class VideoItemModel;
typedef void(^TableViewItemDidSelected)(VideoItemModel *model);

@interface RecommendVideoTableView : UITableView<UITableViewDelegate,UITableViewDataSource>
/// 总数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

/// cell点击
@property (nonatomic, copy) TableViewItemDidSelected itemDidSelected;
/// 页码
//@property (nonatomic, assign) NSInteger page;

@end

NS_ASSUME_NONNULL_END
