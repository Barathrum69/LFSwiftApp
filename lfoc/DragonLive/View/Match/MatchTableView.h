//
//  MatchTableView.h
//  DragonLive
//
//  Created by LoaA on 2020/12/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MatchItemModel;

typedef void(^TableViewDidSelected)(MatchItemModel *model);

@interface MatchTableView : UITableView<UITableViewDelegate,UITableViewDataSource>
/// 总数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

/// 页码
@property (nonatomic, assign) NSInteger page;

/// 原始数据
@property (nonatomic, strong) NSMutableArray *resArray;

/// 点击block
@property (nonatomic, copy) TableViewDidSelected tableViewDidSelected;

@end

NS_ASSUME_NONNULL_END
