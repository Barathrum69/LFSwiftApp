//
//  TaskTableView.h
//  DragonLive
//
//  Created by LoaA on 2020/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TaskModel;

typedef void(^CellBlock)(TaskModel *model);
@interface TaskTableView : UITableView<UITableViewDelegate,UITableViewDataSource>
/// 总数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

/// 页码
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, copy) CellBlock cellBlock;

@end

NS_ASSUME_NONNULL_END
