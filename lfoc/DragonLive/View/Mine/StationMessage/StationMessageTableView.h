//
//  StationMessageTableView.h
//  DragonLive
//
//  Created by LoaA on 2020/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StationMessageTableView : UITableView<UITableViewDelegate,UITableViewDataSource>
/// 总数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

/// 页码
@property (nonatomic, assign) NSInteger page;

@end

NS_ASSUME_NONNULL_END
