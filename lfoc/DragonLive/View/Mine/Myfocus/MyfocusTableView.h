//
//  MyfocusTableView.h
//  DragonLive
//
//  Created by LoaA on 2020/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MyFocusModel;

//点击cell
typedef void(^CellItemSelectedBlock)(MyFocusModel *model);

// 点击取消按钮的block
typedef void(^FocusTableViewItemBlock)(MyFocusModel *model);
@interface MyfocusTableView : UITableView<UITableViewDelegate,UITableViewDataSource>
/// 总数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

/// 页码
@property (nonatomic, assign) NSInteger page;

/// 点击取消按钮的block
@property (nonatomic, copy) FocusTableViewItemBlock ItemBlock;

/// 点击cell
@property (nonatomic, copy) CellItemSelectedBlock cellItemSelectedBlock;

@end

NS_ASSUME_NONNULL_END
