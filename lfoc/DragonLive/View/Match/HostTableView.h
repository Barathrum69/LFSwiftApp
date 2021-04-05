//
//  HostTableView.h
//  DragonLive
//
//  Created by LoaA on 2021/1/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HostModel;

typedef void(^TableViewDidSelected)(HostModel *model);

@interface HostTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

/// 数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

/// 点击事件
@property (nonatomic, copy) TableViewDidSelected tableViewDidSelected;

@end

NS_ASSUME_NONNULL_END
