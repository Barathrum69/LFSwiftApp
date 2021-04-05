//
//  DRSearchHistoryView.h
//  DragonLive
//
//  Created by 11号 on 2020/12/15.
//

#import <UIKit/UIKit.h>

#define KHistorySearchPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"PYSearchhistories.plist"]

#define kDRScreenWidth   [UIScreen mainScreen].bounds.size.width
#define KDRScreenHeight  [UIScreen mainScreen].bounds.size.height

NS_ASSUME_NONNULL_BEGIN

typedef void(^TapActionBlock)(NSString *str);

@interface DRSearchHistoryView : UIView

@property (nonatomic, copy) TapActionBlock tapAction;

- (instancetype)initWithFrame:(CGRect)frame hotArray:(NSMutableArray *)hotArr historyArray:(NSMutableArray *)historyArr;

//刷新搜索历史
- (void)reloadHistoryView;

@end

NS_ASSUME_NONNULL_END
