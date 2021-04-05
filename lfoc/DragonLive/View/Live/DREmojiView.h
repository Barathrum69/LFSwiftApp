//
//  DREmojiView.h
//  DragonLive
//
//  Created by 11号 on 2021/1/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DREmojiViewDelegate <NSObject>

@optional //非必实现的方法

/// 切换键盘事件
- (void)keywordChange;

/// 退格删除事件
- (void)deleteEmoji;

/// 表情分类切换事件
- (void)typeEmoji;

/// 选择表情
/// @param emojiStr 表情字符串，例如：[1]
- (void)selectEmoji:(NSString *)emojiStr;

/// 发送表情
- (void)sendEmoji;

@end

/// 表情包view
@interface DREmojiView : UIView

@property (nonatomic, weak) id<DREmojiViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
